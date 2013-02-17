Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3BQXCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:02:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45762 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab3BQWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:40 -0500
Message-Id: <20130217225006.178382908@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Nicholas Santos <nicholas.santos@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 39/66] HID: usbhid: quirk for Formosa IR receiver
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Santos <nicholas.santos@gmail.com>

commit 320cde19a4e8f122b19d2df7a5c00636e11ca3fb upstream.

Patch to add the Formosa Industrial Computing, Inc. Infrared Receiver
[IR605A/Q] to hid-ids.h and hid-quirks.c.  This IR receiver causes about a 10
second timeout when the usbhid driver attempts to initialze the device.  Adding
this device to the quirks list with HID_QUIRK_NO_INIT_REPORTS removes the
delay.

Signed-off-by: Nicholas Santos <nicholas.santos@gmail.com>
[jkosina@suse.cz: fix ordering]
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -278,6 +278,9 @@
 #define USB_VENDOR_ID_EZKEY		0x0518
 #define USB_DEVICE_ID_BTC_8193		0x0002
 
+#define USB_VENDOR_ID_FORMOSA          0x147a
+#define USB_DEVICE_ID_FORMOSA_IR_RECEIVER      0xe03e
+
 #define USB_VENDOR_ID_FREESCALE		0x15A2
 #define USB_DEVICE_ID_FREESCALE_MX28	0x004F
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -68,6 +68,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },


