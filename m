Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbaE2OUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:20:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59340 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933192AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/103] HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
Date: Thu, 29 May 2014 15:48:17 +0200
Message-Id: <f0d5a953d2257915fe80ee04f7c9f0e1b021a3ee.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2f433083e854ec72c19dc9b0e1cebcc8e230fd75 upstream.

This touchpad seriously dislikes init reports, not only timeing out, but
also refusing to work after this.

Reported-and-tested-by: Vincent Fortier <th0ma7@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4cc23648c510..ca275f47e860 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -812,6 +812,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
 #define USB_DEVICE_ID_SYNAPTICS_HD	0x0ac3
 #define USB_DEVICE_ID_SYNAPTICS_QUAD_HD	0x1ac3
+#define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
 
 #define USB_VENDOR_ID_THINGM		0x27b8
 #define USB_DEVICE_ID_BLINK1		0x01ed
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index dbd83878ff99..8e4ddb369883 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -119,6 +119,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };
-- 
1.9.3

