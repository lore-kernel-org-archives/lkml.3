Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3GJIdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:33:06 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50626 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3GJIdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:33:01 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 3/4] iio: hid-sensor-als: add module alias for autoload
Date: Wed, 10 Jul 2013 10:31:59 +0200
Message-Id: <1373445120-5407-4-git-send-email-holler@ahsoftware.de>
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
 drivers/iio/light/hid-sensor-als.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index cdc2cad..9adfef0 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -30,10 +30,6 @@
 #include <linux/iio/triggered_buffer.h>
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
-/*Format: HID-SENSOR-usage_id_in_hex*/
-/*Usage ID from spec for Ambiant-Light: 0x200041*/
-#define DRIVER_NAME "HID-SENSOR-200041"
-
 #define CHANNEL_SCAN_INDEX_ILLUM 0
 
 struct als_state {
@@ -355,9 +351,19 @@ static int hid_als_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id hid_als_ids[] = {
+	{
+		/* Format: HID-SENSOR-usage_id_in_hex_lowercase */
+		.name = "HID-SENSOR-200041",
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, hid_als_ids);
+
 static struct platform_driver hid_als_platform_driver = {
+	.id_table = hid_als_ids,
 	.driver = {
-		.name	= DRIVER_NAME,
+		.name	= KBUILD_MODNAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_als_probe,
-- 
1.8.1.5

