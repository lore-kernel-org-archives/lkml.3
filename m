Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaCaR1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbaCaR1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:27:15 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Reyad Attiyat <reyad.attiyat@gmail.com>, Derya <derya.kiran@yahoo.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Revert "HID: microsoft: Add ID's for Surface Type/Touch Cover 2"
Date: Mon, 31 Mar 2014 13:27:09 -0400
Message-Id: <1396286830-2795-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1396286830-2795-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1396286830-2795-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Derya <derya.kiran@yahoo.de>

This reverts commit 117309c51dca42121f70cacec801511b76acf75c.

The MS Surface Pro 2 has an USB composite device with 3 interfaces
- interface 0 - sensor hub
- interface 1 - wacom digitizer
- interface 2 - the keyboard cover, if one is attached
This USB composite device changes it product id dependent on if and which
keyboard cover is attached. Adding the covers to hid_have_special_driver
prevents loading the right hid drivers for the other two interfaces, all 3
get loaded with hid-microsoft. We don't even need hid-microsoft for the
keyboards. We have to revert this to load the right hid modules for each
interface.

CC: stable@vger.kernel.org # kernel 3.14 only
Signed-off-by: Derya <derya.kiran@yahoo.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c      | 2 --
 drivers/hid/hid-ids.h       | 2 --
 drivers/hid/hid-microsoft.c | 4 ----
 3 files changed, 8 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index cc32a6f..bb5c494 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1780,8 +1780,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 22f28d6..07cd28c 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -624,8 +624,6 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
-#define USB_DEVICE_ID_MS_TOUCH_COVER_2	0x07a7
-#define USB_DEVICE_ID_MS_TYPE_COVER_2	0x07a9
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 404a3a8..c6ef6ee 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -208,10 +208,6 @@ static const struct hid_device_id ms_devices[] = {
 		.driver_data = MS_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
 		.driver_data = MS_DUPLICATE_USAGES },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2),
-		.driver_data = 0 },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2),
-		.driver_data = 0 },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT),
 		.driver_data = MS_PRESENTER },
-- 
1.9.0

