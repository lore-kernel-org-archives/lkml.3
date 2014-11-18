Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaKRP2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:28:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbaKROJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Sung <penmount.touch@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/206] HID: usbhid: quirk for PM1610 and PM1640 Touchscreen.
Date: Tue, 18 Nov 2014 15:06:15 +0100
Message-Id: <1a7ae6c00f200c810b5c77b7dc1add63143650fd.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sung <penmount.touch@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 66e5482752386786c4346f4f4b214b0998639702 upstream.

These device needs to be added to the quirks list with HID_QUIRK_NOGET,
otherwise they will reset upon receiving the get input report requests.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-ids.h           | 2 ++
 drivers/hid/usbhid/hid-quirks.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 10275b63371c..10e01bd3f082 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -692,6 +692,8 @@
 
 #define USB_VENDOR_ID_PENMOUNT		0x14e1
 #define USB_DEVICE_ID_PENMOUNT_PCI	0x3500
+#define USB_DEVICE_ID_PENMOUNT_1610	0x1610
+#define USB_DEVICE_ID_PENMOUNT_1640	0x1640
 
 #define USB_VENDOR_ID_PETALYNX		0x18b1
 #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index ba34d8cbdc5b..175a2bc344e0 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -77,6 +77,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_1610, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_1640, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },
-- 
2.1.3

