Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3KWTDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:03:34 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59687 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab3KWTD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:03:29 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/5] compal-laptop: Replace SENSOR_DEVICE_ATTR with DEVICE_ATTR
Date: Sat, 23 Nov 2013 11:03:18 -0800
Message-Id: <1385233401-21517-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
References: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extra argument to SENSOR_DEVICE_ATTR is not used. It is therefore not
necessary to use SENSOR_DEVICE_ATTR in the first place. Replace it with
DEVICE_ATTR.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/platform/x86/compal-laptop.c |   66 +++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index eaa78ed..8b119a7 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -665,23 +665,23 @@ static DEVICE_ATTR(wake_up_key,
 static DEVICE_ATTR(wake_up_mouse,
 		0644, wake_up_mouse_show,	wake_up_mouse_store);
 
-static SENSOR_DEVICE_ATTR(name,        S_IRUGO, hwmon_name_show,   NULL, 1);
-static SENSOR_DEVICE_ATTR(fan1_input,  S_IRUGO, fan_show,          NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, temp_cpu,          NULL, 1);
-static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, temp_cpu_local,    NULL, 1);
-static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, temp_cpu_DTS,      NULL, 1);
-static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, temp_northbridge,  NULL, 1);
-static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO, temp_vga,          NULL, 1);
-static SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO, temp_SKIN,         NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, label_cpu,         NULL, 1);
-static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, label_cpu_local,   NULL, 1);
-static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, label_cpu_DTS,     NULL, 1);
-static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, label_northbridge, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp5_label, S_IRUGO, label_vga,         NULL, 1);
-static SENSOR_DEVICE_ATTR(temp6_label, S_IRUGO, label_SKIN,        NULL, 1);
-static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, pwm_show, pwm_store, 1);
-static SENSOR_DEVICE_ATTR(pwm1_enable,
-		S_IRUGO | S_IWUSR, pwm_enable_show, pwm_enable_store, 0);
+static DEVICE_ATTR(name,        S_IRUGO, hwmon_name_show,   NULL);
+static DEVICE_ATTR(fan1_input,  S_IRUGO, fan_show,          NULL);
+static DEVICE_ATTR(temp1_input, S_IRUGO, temp_cpu,          NULL);
+static DEVICE_ATTR(temp2_input, S_IRUGO, temp_cpu_local,    NULL);
+static DEVICE_ATTR(temp3_input, S_IRUGO, temp_cpu_DTS,      NULL);
+static DEVICE_ATTR(temp4_input, S_IRUGO, temp_northbridge,  NULL);
+static DEVICE_ATTR(temp5_input, S_IRUGO, temp_vga,          NULL);
+static DEVICE_ATTR(temp6_input, S_IRUGO, temp_SKIN,         NULL);
+static DEVICE_ATTR(temp1_label, S_IRUGO, label_cpu,         NULL);
+static DEVICE_ATTR(temp2_label, S_IRUGO, label_cpu_local,   NULL);
+static DEVICE_ATTR(temp3_label, S_IRUGO, label_cpu_DTS,     NULL);
+static DEVICE_ATTR(temp4_label, S_IRUGO, label_northbridge, NULL);
+static DEVICE_ATTR(temp5_label, S_IRUGO, label_vga,         NULL);
+static DEVICE_ATTR(temp6_label, S_IRUGO, label_SKIN,        NULL);
+static DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, pwm_show, pwm_store);
+static DEVICE_ATTR(pwm1_enable,
+		   S_IRUGO | S_IWUSR, pwm_enable_show, pwm_enable_store);
 
 static struct attribute *compal_attributes[] = {
 	&dev_attr_wake_up_pme.attr,
@@ -692,22 +692,22 @@ static struct attribute *compal_attributes[] = {
 	&dev_attr_wake_up_mouse.attr,
 	/* Maybe put the sensor-stuff in a separate hwmon-driver? That way,
 	 * the hwmon sysfs won't be cluttered with the above files. */
-	&sensor_dev_attr_name.dev_attr.attr,
-	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
-	&sensor_dev_attr_pwm1.dev_attr.attr,
-	&sensor_dev_attr_fan1_input.dev_attr.attr,
-	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_temp2_input.dev_attr.attr,
-	&sensor_dev_attr_temp3_input.dev_attr.attr,
-	&sensor_dev_attr_temp4_input.dev_attr.attr,
-	&sensor_dev_attr_temp5_input.dev_attr.attr,
-	&sensor_dev_attr_temp6_input.dev_attr.attr,
-	&sensor_dev_attr_temp1_label.dev_attr.attr,
-	&sensor_dev_attr_temp2_label.dev_attr.attr,
-	&sensor_dev_attr_temp3_label.dev_attr.attr,
-	&sensor_dev_attr_temp4_label.dev_attr.attr,
-	&sensor_dev_attr_temp5_label.dev_attr.attr,
-	&sensor_dev_attr_temp6_label.dev_attr.attr,
+	&dev_attr_name.attr,
+	&dev_attr_pwm1_enable.attr,
+	&dev_attr_pwm1.attr,
+	&dev_attr_fan1_input.attr,
+	&dev_attr_temp1_input.attr,
+	&dev_attr_temp2_input.attr,
+	&dev_attr_temp3_input.attr,
+	&dev_attr_temp4_input.attr,
+	&dev_attr_temp5_input.attr,
+	&dev_attr_temp6_input.attr,
+	&dev_attr_temp1_label.attr,
+	&dev_attr_temp2_label.attr,
+	&dev_attr_temp3_label.attr,
+	&dev_attr_temp4_label.attr,
+	&dev_attr_temp5_label.attr,
+	&dev_attr_temp6_label.attr,
 	NULL
 };
 
-- 
1.7.9.7

