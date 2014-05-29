Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866AbaE2Ntg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:49:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59296 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932738AbaE2Nt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/103] HID: usbhid: quirk for Synaptics HD touchscreen
Date: Thu, 29 May 2014 15:47:50 +0200
Message-Id: <c0ceae2e7e385aa13b823a978b39226850f001ef.1401371258.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d8e2e7581d2521910398c4c80d7a3b78e84da7d5 upstream.

Add Synaptics HD touchscreen(06cb:0ac3) to no init report quirk.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6c63cde6b2af..a1eac61cc744 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -808,6 +808,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DPAD	0x0013
 #define USB_DEVICE_ID_SYNAPTICS_LTS1	0x0af8
 #define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
+#define USB_DEVICE_ID_SYNAPTICS_HD	0x0ac3
 
 #define USB_VENDOR_ID_THINGM		0x27b8
 #define USB_DEVICE_ID_BLINK1		0x01ed
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 37307dc2d1f7..11facfbadead 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -115,6 +115,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };
-- 
1.9.3

