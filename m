Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3GJIc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:32:59 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50612 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3GJIcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:32:54 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/4] iio: hid-sensor-gyro-3d: add module alias for autoload
Date: Wed, 10 Jul 2013 10:31:58 +0200
Message-Id: <1373445120-5407-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1373445120-5407-1-git-send-email-holler@ahsoftware.de>
References: <1373445120-5407-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MODULE_DEVICE_TABLE in order to let hotplug mechanisms automatically
load the driver.

This makes it also possible to use the usual driver name instead of
HID-SENSOR-2000xx which isn't very descriptive in kernel messages.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/iio/gyro/hid-sensor-gyro-3d.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index bc943dd..9cc8aa1 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -30,10 +30,6 @@
 #include <linux/iio/triggered_buffer.h>
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
-/*Format: HID-SENSOR-usage_id_in_hex*/
-/*Usage ID from spec for Gyro-3D: 0x200076*/
-#define DRIVER_NAME "HID-SENSOR-200076"
-
 enum gyro_3d_channel {
 	CHANNEL_SCAN_INDEX_X,
 	CHANNEL_SCAN_INDEX_Y,
@@ -389,9 +385,19 @@ static int hid_gyro_3d_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id hid_gyro_3d_ids[] = {
+	{
+		/* Format: HID-SENSOR-usage_id_in_hex_lowercase */
+		.name = "HID-SENSOR-200076",
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, hid_gyro_3d_ids);
+
 static struct platform_driver hid_gyro_3d_platform_driver = {
+	.id_table = hid_gyro_3d_ids,
 	.driver = {
-		.name	= DRIVER_NAME,
+		.name	= KBUILD_MODNAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_gyro_3d_probe,
-- 
1.8.1.5

