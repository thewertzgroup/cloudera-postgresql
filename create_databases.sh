sudo yum install -y wget

sudo wget https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/
sudo rpm --import https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/RPM-GPG-KEY-cloudera

sudo yum install -y oracle-j2sdk1.8

sudo yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server

sudo JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera /opt/cloudera/cm-agent/bin/certmanager setup --configure-services

sudo yum install -y postgresql-server

sudo yum install -y epel-release

sudo yum install -y python-pip
sudo pip install psycopg2==2.7.5 --ignore-installed

echo 'LC_ALL="en_US.UTF-8"' >> /etc/locale.conf
sudo su -l postgres -c "postgresql-setup initdb"

exit 1

sudo systemctl enable postgresql
sudo systemctl restart postgresql

sudo -u postgres psql < create_users.sql
sudo -u postgres psql < create_schemas.sql
sudo -u postgres psql < alter_schemas.sql

sudo /opt/cloudera/cm/schema/scm_prepare_database.sh postgresql scm scm scm

sudo systemctl start cloudera-scm-server

sudo tail -n 500 -f /var/log/cloudera-scm-server/cloudera-scm-server.log
