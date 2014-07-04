Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbaGDSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:35:28 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:46982 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbaGDSf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:35:27 -0400
MIME-Version: 1.0
Date: Fri, 4 Jul 2014 20:35:26 +0200
X-Google-Sender-Auth: x8nZzV8b4vycJTyZPJiPSjZwyP4
Message-ID: <CAPhOmC5=zWfJixgxYbscYYNRLvLJYNVQuWtJNk4aSG1cjdMp0g@mail.gmail.com>
Subject: Patch for a buggy Jabra GN9350 (HID)
From: Patrick Plattes <patrick@erdbeere.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all :),

I've the problem, that the buttons of my (USB) mouse stop working when
I activate my USB headset. The headset tells the kernel, that it is a
HID, so I 'blacklisted it with te following patch. Now its working
fine :)

I don't know if it is the right place to do, feedback would be welcome.

Thanks to all kernel devs for the great work over the last years ... decades,
 Patrick

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d00bb9..7de25aa 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -488,6 +488,7 @@
 #define USB_VENDOR_ID_JABRA            0x0b0e
 #define USB_DEVICE_ID_JABRA_SPEAK_410  0x0412
 #define USB_DEVICE_ID_JABRA_SPEAK_510  0x0420
+#define USB_DEVICE_ID_JABRA_GN9350     0x9350

 #define USB_VENDOR_ID_JESS             0x0c45
 #define USB_DEVICE_ID_JESS_YUREX       0x1010
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 59badc1..fdfee8f 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -122,6 +122,8 @@ static const struct hid_blacklist {
        { USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD,
HID_QUIRK_NO_INIT_REPORTS },
        { USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103,
HID_QUIRK_NO_INIT_REPORTS },

+       { USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_GN9350, HID_QUIRK_IGNORE},
+
        { 0, 0 }
 };
