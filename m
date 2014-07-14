Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaGNAte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 20:49:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60446 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaGNAt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 20:49:28 -0400
From: microcai <microcai@fedoraproject.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-usb@vger.kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] add quirks for 0x04d9:0xa096 hid keyborad device
Date: Mon, 14 Jul 2014 08:50:03 +0800
Message-ID: <2622539.lVFtlJePgT@gentoo>
Organization: avplayer.org
User-Agent: KMail/4.13.2 (Linux/3.15.5; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140713174939.GC23425@khazad-dum.debian.net>
References: <1405238642-19507-1-git-send-email-microcai@fedoraproject.org> <1405238642-19507-2-git-send-email-microcai@fedoraproject.org> <20140713174939.GC23425@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using a USB keyboard that give me
"usb_submit_urb(ctrl) failed: -1" error when I plugin it.
and I need to wait for 10s for this device to be ready.

by adding this quirks, the usb keyboard is usable right after plugin
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 34bb220..bda276b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -477,6 +477,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A070    0xa070
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072    0xa072
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081    0xa081
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096 0xa096
 
 #define USB_VENDOR_ID_IMATION          0x0718
 #define USB_DEVICE_ID_DISC_STAKKA      0xd000
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 8e4ddb3..da22a5e 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -120,6 +120,7 @@ static const struct hid_blacklist {
        { USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, 
HID_QUIRK_NO_INIT_REPORTS },
        { USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD, 
HID_QUIRK_NO_INIT_REPORTS },
        { USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103, 
HID_QUIRK_NO_INIT_REPORTS },
+       { USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096, 
HID_QUIRK_NO_INIT_INPUT_REPORTS },
 
        { 0, 0 }
 };
-- 
2.0.0

