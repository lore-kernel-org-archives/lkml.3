Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaKYLXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:23:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaKYKmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 140/254] HID: usbhid: add another mouse that needs QUIRK_ALWAYS_POLL
Date: Tue, 25 Nov 2014 10:38:10 +0000
Message-Id: <1416912004-5928-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 5235166fbc332c8b5dcf49e3a498a8b510a77449 upstream.

There is a second mouse sharing the same vendor strings but different IDs.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 889f9115dc4d..cb1f83fe6818 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -732,6 +732,7 @@
 #define USB_DEVICE_ID_PI_ENGINEERING_VEC_USB_FOOTPEDAL	0xff
 
 #define USB_VENDOR_ID_PIXART				0x093a
+#define USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2	0x0137
 #define USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE		0x2510
 #define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN	0x8001
 #define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1	0x8002
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 01377f3b9dd0..b02b4591dab3 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -81,6 +81,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_1610, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_1640, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE, HID_QUIRK_ALWAYS_POLL },
+	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },
-- 
2.1.0

