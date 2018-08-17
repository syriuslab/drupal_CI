FROM php:7.1-apache


# Install Git and wget.
RUN apt-get update
RUN apt-get install wget -y
RUN apt-get install git -y

# Install curl and sudo privileges
RUN apt-get install -y curl
RUN apt-get install -y sudo
RUN apt-get update \
&& rm -rf /var/lib/apt/lists/*

# Install other dependencies
RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libxslt1-dev
RUN docker-php-ext-install gd
RUN docker-php-ext-install mcrypt

# Install Node 7.1.0
RUN curl -LO "https://nodejs.org/dist/v7.1.0/node-v7.1.0-linux-x64.tar.gz" \
&& tar -xzf node-v7.1.0-linux-x64.tar.gz -C /usr/local --strip-components=1 \
&& rm node-v7.1.0-linux-x64.tar.gz


# Install npm 4.2
RUN npm install -g npm@4.2.0

# Install composer
RUN apt-get update && \
    apt-get install -y git zip unzip && \
    php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Install Drush9 via composer
# Set the Drush version.
ENV DRUSH_VERSION 9.0.0
RUN composer global require drush/drush:"9.0.0" --prefer-dist


#Install Drupal console launcher
RUN php -r "readfile('https://drupalconsole.com/installer');" > drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal && \
    /usr/local/bin/drupal check


#Install and configure chromedriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver
