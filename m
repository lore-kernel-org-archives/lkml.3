Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3LLVSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:18:13 -0500
Received: from mout.web.de ([212.227.15.14]:55322 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3LLVSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:18:11 -0500
Message-ID: <52AA2810.2010807@web.de>
Date: Thu, 12 Dec 2013 22:18:08 +0100
From: Emanuel Krenz <emanuelkrenz@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] HID: hid-multitouch: add support for SiS panel in LG 23ET83V
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:TsbtuJcnNtxgQFKwLA8EkhhrLZtU/lH8POl3kQjpQhVUBCZy80B
 UmVoIeH7/j1PYGc6QWTZtsaSEujk/OycwO8IMaoBWYQs83ZJcBMdJOaagmV/lzfh4nqWwNC
 jy/L0hHLcxmanwsMOj6qUhD1LEYc4NYX2yGON7aAIaPJiBvNh+xEn94+pi4beDFQ4kJXmDe
 XeRXRb1Jm+gA5oTUpzr3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12.5-stable patch

--------------------
From: Emanuel Krenz <emanuelkrenz@web.de>

Add support for SiS multitouch panel in the touch monitor LG 23ET83V.

Signed-off-by: Emanuel Krenz <emanuelkrenz@web.de>
Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

I bought an LG 23ET83V multitouch monitor, whose idProduct=1030 wasn't yet included in the hid-multitouch driver (support for SiS panels were just added a few days ago).
So I wrote following patch to include the ID number 1030 and patched the latest stable 3.12.5 kernel. The SiS touchpanel in my monitor works for me now.
This is my first submitted patch by now, hope it's okay.

---
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

