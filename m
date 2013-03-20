Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3CTPwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:52:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51039 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CTPwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:52:44 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Wed, 20 Mar 2013 10:52:42 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging/iio: iio_hwmon: Use device tree node name for hwmon name attribute
Date: Wed, 20 Mar 2013 08:52:31 -0700
Message-Id: <1363794751-31977-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, all instances of iio_hwmon set their hwmon name attribute
to "iio_hwmon", which is not very descriptive. Set it to the device tree
node name if available, and only revert to iio_hwmon otherwise.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---

Jonathan, can we move this driver out of staging ?
I would like to see it in 3.10 if possible.

 drivers/staging/iio/iio_hwmon.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/iio_hwmon.c b/drivers/staging/iio/iio_hwmon.c
index 93af756..aafa453 100644
--- a/drivers/staging/iio/iio_hwmon.c
+++ b/drivers/staging/iio/iio_hwmon.c
@@ -13,6 +13,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/hwmon.h>
+#include <linux/of.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/iio/consumer.h>
 #include <linux/iio/types.h>
@@ -58,7 +59,12 @@ static ssize_t iio_hwmon_read_val(struct device *dev,
 static ssize_t show_name(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
-	return sprintf(buf, "iio_hwmon\n");
+	const char *name = "iio_hwmon";
+
+	if (dev->of_node && dev->of_node->name)
+		name = dev->of_node->name;
+
+	return sprintf(buf, "%s\n", name);
 }
 
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
-- 
1.7.9.7

