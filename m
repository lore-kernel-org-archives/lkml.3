Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3GIRbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:31:15 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:46354 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3GIRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:31:14 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] rtc: rtc-hid-sensor-time: add module alias to let the module load automatically
Date: Tue,  9 Jul 2013 19:30:03 +0200
Message-Id: <1373391003-20073-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get the module automatically loaded by hotplug mechanisms a
MODULE_DEVICE_TABLE is needed.

Therefor add one.

This makes it also possible to use a module name other than HID-SENSOR-2000a0
which isn't very descriptive in kernel messages.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 7273b01..b5a2874 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -23,10 +23,6 @@
 #include <linux/iio/iio.h>
 #include <linux/rtc.h>
 
-/* Format: HID-SENSOR-usage_id_in_hex */
-/* Usage ID from spec for Time: 0x2000A0 */
-#define DRIVER_NAME "HID-SENSOR-2000a0" /* must be lowercase */
-
 enum hid_time_channel {
 	CHANNEL_SCAN_INDEX_YEAR,
 	CHANNEL_SCAN_INDEX_MONTH,
@@ -300,9 +296,19 @@ static int hid_time_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id hid_time_ids[] = {
+	{
+		/* Format: HID-SENSOR-usage_id_in_hex_lowercase */
+		.name = "HID-SENSOR-2000a0",
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, hid_time_ids);
+
 static struct platform_driver hid_time_platform_driver = {
+	.id_table = hid_time_ids,
 	.driver = {
-		.name	= DRIVER_NAME,
+		.name	= KBUILD_MODNAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_time_probe,
-- 
1.8.1.4

