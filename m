Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbaKLBb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:31:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbaKLBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:31:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.17 228/319] HID: usbhid: fix PIXART optical mouse
Date: Wed, 12 Nov 2014 10:16:06 +0900
Message-Id: <20141112011030.494428819@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 4980f95755e2966b30ac70d1841f4db66d1a8a22 upstream.

This mouse keeps disconnecting in runlevel 3. It needs the ALWAYS_POLL quirk.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -736,6 +736,7 @@
 #define USB_DEVICE_ID_PI_ENGINEERING_VEC_USB_FOOTPEDAL	0xff
 
 #define USB_VENDOR_ID_PIXART				0x093a
+#define USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE		0x2510
 #define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN	0x8001
 #define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1	0x8002
 #define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2	0x8003
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -80,6 +80,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_1610, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_1640, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },


