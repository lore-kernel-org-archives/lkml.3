Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3LMNjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:39:55 -0500
Received: from mout.web.de ([212.227.17.12]:50712 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3LMNjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:39:54 -0500
MIME-Version: 1.0
Message-ID: <trinity-1ba34dee-30ba-4815-8f91-cbeb762f4b32-1386941992832@3capp-webde-bs44>
From: "Emanuel Krenz" <emanuelkrenz@web.de>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] HID: hid-multitouch: add support for SiS panel in LG
 23ET83V
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Dec 2013 14:39:52 +0100 (CET)
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:uAdyhbekQN7+J7qWlfENc322nFi3xgbtPaskllyln0j
 mMtFIcb9dvd10Qzp9tQpmpX7GbM/UQktDO6QVkf1JjPgA0DXzc
 wCOWYZBxCJ3gYBcpu+bkN1yyyzNFr63X9owotYnsmIsuYsdo6X
 99czWYigRT5GqSJfrWV5zcjSsPKJAjK6vZLWhQFXta351UKpZO
 5xyLlCYDc5ffc4j/dW0Wm2zn7CJAjpRG1LffppaU8pFs0kGL9n
 VIYdeml+SHhWWytiHQcMdGlFutLzV4HPgxHv96aIHzuhYZ+lLk
 QT8wCUEDPS3cI/VlOX/3gf+Wztk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------
From: Emanuel Krenz <emanuelkrenz@web.de>

Add support for SiS multitouch panel in the touch monitor LG 23ET83V.

Signed-off-by: Emanuel Krenz <emanuelkrenz@web.de>

---

I bought an LG 23ET83V multitouch monitor, whose idProduct=1030 wasn't yet included in the hid-multitouch driver.
So I wrote following patch to include the ID number 1030 and patched the latest stable 3.12.5 kernel. The SiS touchpanel in my monitor works for me now.
This is my first submitted patch, hope it's okay now, ...well every beginning is difficult ;-).

------------------ 
 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/hid-multitouch.c    |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 4 files changed, 6 insertions(+)
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1823,6 +1823,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS1030_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -755,6 +755,7 @@
 #define USB_VENDOR_ID_SIS2_TOUCH	0x0457
 #define USB_DEVICE_ID_SIS9200_TOUCH	0x9200
 #define USB_DEVICE_ID_SIS817_TOUCH	0x0817
+#define USB_DEVICE_ID_SIS1030_TOUCH	0x1030
 
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1306,6 +1306,9 @@ static const struct hid_device_id mt_dev
 	{ .driver_data = MT_CLS_DEFAULT,
 		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
 		USB_DEVICE_ID_SIS817_TOUCH) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS1030_TOUCH) },
 
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -86,6 +86,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SIGMATEL, USB_DEVICE_ID_SIGMATEL_STMP3780, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS1030_TOUCH, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_2, HID_QUIRK_NOGET },
