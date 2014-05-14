Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaENAyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 20:54:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58401 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaENAyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 20:54:18 -0400
MIME-Version: 1.0
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 13 May 2014 19:53:57 -0500
Message-ID: <CA+BWVUQEa-X7D=d1eh4do=GQSjJ-TT4pLj-5eKpBp9wnVgQsRg@mail.gmail.com>
Subject: [PATCH] HID: hid-sensor-hub: Add and set report quirk for Microsoft
 Surface Pro 2
To: linux-kernel@vger.kernel.org, linux-input <linux-input@vger.kernel.org>,
        derya.kiran@yahoo.de, linux-iio@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hid/hid-ids.h        | 3 +++
 drivers/hid/hid-sensor-hub.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 34bb220..18e2099 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -633,6 +633,9 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB 0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K 0x0730
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500 0x076c
+#define USB_DEVICE_ID_MS_SURFACE_PRO_2   0x0799
+#define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
+#define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9

 #define USB_VENDOR_ID_MOJO 0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER 0x3201
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index be14b56..f6dc7ea 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -710,6 +710,14 @@ static const struct hid_device_id sensor_hub_devices[] = {
  .driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
  { HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB,
USB_VENDOR_ID_TEXAS_INSTRUMENTS,
  USB_DEVICE_ID_TEXAS_INSTRUMENTS_LENOVO_YOGA),
+ { HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
+ USB_DEVICE_ID_MS_SURFACE_PRO_2),
+ .driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
+ { HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
+ USB_DEVICE_ID_MS_TOUCH_COVER_2),
+ .driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
+ { HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
+ USB_DEVICE_ID_MS_TYPE_COVER_2),
  .driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
  { HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
      HID_ANY_ID) },
-- 
1.9.0
