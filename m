Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3LCI3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:29:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:15183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3LCI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:29:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445878191"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ACPI / fan: remove no need check for device pointer
Date: Tue,  3 Dec 2013 16:28:30 +0800
Message-Id: <1386059312-2990-3-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
References: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device pointer will not be NULL in the PM callback and ACPI driver's
add/remove callback, so checking NULL for them isn't necessary.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/fan.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 9638d28513e8..4a624a35f07d 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -124,9 +124,6 @@ static int acpi_fan_add(struct acpi_device *device)
 	int result = 0;
 	struct thermal_cooling_device *cdev;
 
-	if (!device)
-		return -EINVAL;
-
 	strcpy(acpi_device_name(device), "Fan");
 	strcpy(acpi_device_class(device), ACPI_FAN_CLASS);
 
@@ -170,14 +167,7 @@ end:
 
 static int acpi_fan_remove(struct acpi_device *device)
 {
-	struct thermal_cooling_device *cdev;
-
-	if (!device)
-		return -EINVAL;
-
-	cdev =  acpi_driver_data(device);
-	if (!cdev)
-		return -EINVAL;
+	struct thermal_cooling_device *cdev = acpi_driver_data(device);
 
 	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
 	sysfs_remove_link(&cdev->device.kobj, "device");
@@ -189,9 +179,6 @@ static int acpi_fan_remove(struct acpi_device *device)
 #ifdef CONFIG_PM_SLEEP
 static int acpi_fan_suspend(struct device *dev)
 {
-	if (!dev)
-		return -EINVAL;
-
 	acpi_bus_set_power(to_acpi_device(dev)->handle, ACPI_STATE_D0);
 
 	return AE_OK;
@@ -201,9 +188,6 @@ static int acpi_fan_resume(struct device *dev)
 {
 	int result;
 
-	if (!dev)
-		return -EINVAL;
-
 	result = acpi_bus_update_power(to_acpi_device(dev)->handle, NULL);
 	if (result)
 		printk(KERN_ERR PREFIX "Error updating fan power state\n");
-- 
1.8.3.1

