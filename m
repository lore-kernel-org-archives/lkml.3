Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689AbaE2Fgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:36:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbaE2Ee4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Derya <derya.kiran@yahoo.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.14 027/140] Revert "HID: microsoft: Add IDs for Surface Type/Touch Cover 2"
Date: Wed, 28 May 2014 21:32:46 -0700
Message-Id: <20140529043052.851940220@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derya <derya.kiran@yahoo.de>

commit f3b0cbce01cd5c242b420d986b208d306bdc5083 upstream.

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

Signed-off-by: Derya <derya.kiran@yahoo.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c      |    2 --
 drivers/hid/hid-ids.h       |    2 --
 drivers/hid/hid-microsoft.c |    4 ----
 3 files changed, 8 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1780,8 +1780,6 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
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
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -208,10 +208,6 @@ static const struct hid_device_id ms_dev
 		.driver_data = MS_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
 		.driver_data = MS_DUPLICATE_USAGES },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2),
-		.driver_data = 0 },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2),
-		.driver_data = 0 },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT),
 		.driver_data = MS_PRESENTER },


