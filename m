Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaHVMDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:03:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60224 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHVMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:03:35 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: fan.c: printk replacement
Date: Fri, 22 Aug 2014 17:33:21 +0530
Message-Id: <1408709001-3272-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk replaced with corresponding dev_err and dev_info
fixed one broken user-visible string
multiine comment edited for correct commenting style
asm/uaccess.h replaced with linux/uaccess.h

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/acpi/fan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 8acf53e..7900d55 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/thermal.h>
 #include <linux/acpi.h>
 
@@ -127,8 +127,9 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
 };
 
 /* --------------------------------------------------------------------------
-                                 Driver Interface
-   -------------------------------------------------------------------------- */
+ *                               Driver Interface
+ * --------------------------------------------------------------------------
+*/
 
 static int acpi_fan_add(struct acpi_device *device)
 {
@@ -143,7 +144,7 @@ static int acpi_fan_add(struct acpi_device *device)
 
 	result = acpi_bus_update_power(device->handle, NULL);
 	if (result) {
-		printk(KERN_ERR PREFIX "Setting initial power state\n");
+		dev_err(&device->dev, PREFIX "Setting initial power state\n");
 		goto end;
 	}
 
@@ -168,10 +169,10 @@ static int acpi_fan_add(struct acpi_device *device)
 				   &device->dev.kobj,
 				   "device");
 	if (result)
-		dev_err(&device->dev, "Failed to create sysfs link "
-			"'device'\n");
+		dev_err(&device->dev,
+			"Failed to create sysfs link 'device'\n");
 
-	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
+	dev_info(&device->dev, PREFIX "%s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       !device->power.state ? "on" : "off");
 
@@ -214,10 +215,9 @@ static int acpi_fan_resume(struct device *dev)
 
 	if (!dev)
 		return -EINVAL;
-
 	result = acpi_bus_update_power(to_acpi_device(dev)->handle, NULL);
 	if (result)
-		printk(KERN_ERR PREFIX "Error updating fan power state\n");
+		dev_err(dev, PREFIX "Error updating fan power state\n");
 
 	return result;
 }
-- 
1.8.1.2

