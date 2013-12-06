Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162471Ab3LFN3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:29:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161793Ab3LFNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tristan Rice <rice@outerearth.net>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 184/272] HID: enable Mayflash USB Gamecube Adapter
Date: Fri,  6 Dec 2013 12:57:53 +0000
Message-Id: <1386334761-25517-185-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Rice <rice@outerearth.net>

commit e17f5d7667c5414b8f12a93ef14aae0824bd2beb upstream.

This is a patch that adds the new Mayflash Gamecube Controller to USB adapter
(ID 1a34:f705 ACRUX) to the ACRUX driver (drivers/hid/hid-axff.c) with full
force feedback support.

Signed-off-by: Tristan Rice <rice@outerearth.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-axff.c | 3 ++-
 drivers/hid/hid-core.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index 64ab94a..a594e47 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -95,7 +95,7 @@ static int axff_init(struct hid_device *hid)
 		}
 	}
 
-	if (field_count < 4) {
+	if (field_count < 4 && hid->product != 0xf705) {
 		hid_err(hid, "not enough fields in the report: %d\n",
 			field_count);
 		return -ENODEV;
@@ -180,6 +180,7 @@ static void ax_remove(struct hid_device *hdev)
 
 static const struct hid_device_id ax_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802), },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0xf705), },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ax_devices);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 662b740..3eb8c11 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1562,6 +1562,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0xf705) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICTRACKPAD) },
-- 
1.8.3.2

