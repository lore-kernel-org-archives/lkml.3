Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3LBTQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:16:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LBTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tristan Rice <rice@outerearth.net>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 162/173] HID: enable Mayflash USB Gamecube Adapter
Date: Mon,  2 Dec 2013 11:12:25 -0800
Message-Id: <20131202191201.770570883@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Rice <rice@outerearth.net>

commit e17f5d7667c5414b8f12a93ef14aae0824bd2beb upstream.

This is a patch that adds the new Mayflash Gamecube Controller to USB adapter
(ID 1a34:f705 ACRUX) to the ACRUX driver (drivers/hid/hid-axff.c) with full
force feedback support.

Signed-off-by: Tristan Rice <rice@outerearth.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-axff.c |    3 ++-
 drivers/hid/hid-core.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -95,7 +95,7 @@ static int axff_init(struct hid_device *
 		}
 	}
 
-	if (field_count < 4) {
+	if (field_count < 4 && hid->product != 0xf705) {
 		hid_err(hid, "not enough fields in the report: %d\n",
 			field_count);
 		return -ENODEV;
@@ -180,6 +180,7 @@ static void ax_remove(struct hid_device
 
 static const struct hid_device_id ax_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802), },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0xf705), },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ax_devices);
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1562,6 +1562,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0xf705) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICTRACKPAD) },


