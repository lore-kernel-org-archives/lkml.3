Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaFJULo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:11:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaFJTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 152/160] HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
Date: Tue, 10 Jun 2014 12:46:32 -0700
Message-Id: <1402429600-20477-153-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2f433083e854ec72c19dc9b0e1cebcc8e230fd75 upstream.

This touchpad seriously dislikes init reports, not only timeing out, but
also refusing to work after this.

Reported-and-tested-by: Vincent Fortier <th0ma7@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f9304cb..0ef390e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -809,6 +809,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DPAD	0x0013
 #define USB_DEVICE_ID_SYNAPTICS_LTS1	0x0af8
 #define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
+#define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
 
 #define USB_VENDOR_ID_THINGM		0x27b8
 #define USB_DEVICE_ID_BLINK1		0x01ed
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0db9a67..6489dd8 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -115,6 +115,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SIS, USB_DEVICE_ID_SIS_TS, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };
-- 
1.9.1

