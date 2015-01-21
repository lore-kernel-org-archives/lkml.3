Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbbAUIDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:03:34 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64686 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbAUIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:03:25 -0500
Date: Wed, 21 Jan 2015 10:03:22 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: jdelvare@suse.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: abx500: fix format string warnings
Message-ID: <20150121080322.GA26811@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warnings (reported by cppcheck):
[drivers/hwmon/abx500.c:224]: (warning) %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.
[drivers/hwmon/abx500.c:233]: (warning) %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.
[drivers/hwmon/abx500.c:242]: (warning) %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/hwmon/abx500.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/abx500.c b/drivers/hwmon/abx500.c
index 1387596..6cb89c0 100644
--- a/drivers/hwmon/abx500.c
+++ b/drivers/hwmon/abx500.c
@@ -221,7 +221,7 @@ static ssize_t show_min(struct device *dev,
 	struct abx500_temp *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	return sprintf(buf, "%ld\n", data->min[attr->index]);
+	return sprintf(buf, "%lu\n", data->min[attr->index]);
 }
 
 static ssize_t show_max(struct device *dev,
@@ -230,7 +230,7 @@ static ssize_t show_max(struct device *dev,
 	struct abx500_temp *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	return sprintf(buf, "%ld\n", data->max[attr->index]);
+	return sprintf(buf, "%lu\n", data->max[attr->index]);
 }
 
 static ssize_t show_max_hyst(struct device *dev,
@@ -239,7 +239,7 @@ static ssize_t show_max_hyst(struct device *dev,
 	struct abx500_temp *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	return sprintf(buf, "%ld\n", data->max_hyst[attr->index]);
+	return sprintf(buf, "%lu\n", data->max_hyst[attr->index]);
 }
 
 static ssize_t show_min_alarm(struct device *dev,
-- 
1.7.0.4

