Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaAUAmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:42:36 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:59209 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaAUAm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:42:27 -0500
MIME-Version: 1.0
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Mon, 20 Jan 2014 18:42:06 -0600
Message-ID: <CA+BWVUTkaUt8Ys_40r7zFV_wBtY7iWTTmUUL+bHj=e3NwAtgNg@mail.gmail.com>
Subject: [PATCH] Add HID's to hid-microsoft driver of Surface Type/Touch Cover
 2 to fix bug
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a bug 64811
(https://bugzilla.kernel.org/show_bug.cgi?id=64811) of the Microsoft
Surface Type/Touch cover 2 devices being detected as a multitouch
device.
The fix adds the HID of the two devices to hid-microsoft driver. This
ensures that hid-input will eventually be used for the device and not
hid-multitouch.

>From 866c814f3f6740a5a79858fdf8bf5bbcdc3b57f8 Mon Sep 17 00:00:00 2001
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Mon, 20 Jan 2014 16:24:49 -0600
Subject: [PATCH 1/2] Added in ID's for Surface Type/Touch cover 2 to the
 hid-microsoft driver

---
 drivers/hid/hid-ids.h       | 4 +++-
 drivers/hid/hid-microsoft.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f9304cb..b523a8b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -611,7 +611,9 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB    0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K    0x0730
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500    0x076c
-
+#define USB_DEVICE_ID_MS_TOUCH_COVER_2 0x07a7
+#define USB_DEVICE_ID_MS_TYPE_COVER_2  0x07a9
+
 #define USB_VENDOR_ID_MOJO        0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER    0x3201

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 551795b..2599de8 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -207,6 +207,10 @@ static const struct hid_device_id ms_devices[] = {
         .driver_data = MS_NOGET },
     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
         .driver_data = MS_DUPLICATE_USAGES },
+    { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2),
+        .driver_data = 0 },
+    { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2),
+        .driver_data = 0 },

     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_PRESENTER_8K_BT),
         .driver_data = MS_PRESENTER },
-- 
1.8.4.2
