Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaAVTyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:54:21 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:43592 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaAVTyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:54:19 -0500
Message-ID: <52E021E8.8060608@gmail.com>
Date: Wed, 22 Jan 2014 13:54:16 -0600
From: Reyad Attiyat <reyad.attiyat@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] hid-microsoft: Add ID's for Surface Type/Touch Cover 2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bug 64811 (https://bugzilla.kernel.org/show_bug.cgi?id=64811)
The Microsoft Surface Type/Touch cover 2 devices have the flag HID_DG_CONTACTID in their reports.This causes the device to bind to the hid-multitouch driver, which doesn't handle generic keyboard/mouse input events.
The patch adds the hardware id's of the device to hid-microsoft and to the HID special driver array, which makes the device get handled by hid-generic/hid-input properly.

Singed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
Reviewed-by: Benjamin Tissoires<benjamin.tissoires@redhat.com>

---
  drivers/hid/hid-core.c      | 2 ++
  drivers/hid/hid-ids.h       | 2 ++
  drivers/hid/hid-microsoft.c | 4 ++++
  3 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 253fe23..b10f6d0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1778,6 +1778,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f9304cb..bb77d22 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -611,6 +611,8 @@
  #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
  #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
  #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
+#define USB_DEVICE_ID_MS_TOUCH_COVER_2 0x07a7
+#define USB_DEVICE_ID_MS_TYPE_COVER_2  0x07a9
  
  #define USB_VENDOR_ID_MOJO		0x8282
  #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 551795b..277e545 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -207,6 +207,10 @@ static const struct hid_device_id ms_devices[] = {
  		.driver_data = MS_NOGET },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
  		.driver_data = MS_DUPLICATE_USAGES },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2),
+		.driver_data = 0 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2),
+		.driver_data = 0 },
  
  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT),
  		.driver_data = MS_PRESENTER },
-- 
1.8.4.2

