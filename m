Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756Ab3BANNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:45315 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422659Ab3BANMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:12:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Santos <nicholas.santos@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 59/89] HID: usbhid: quirk for Formosa IR receiver
Date: Fri,  1 Feb 2013 14:08:14 +0100
Message-Id: <20130201130211.739004292@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -305,6 +305,9 @@
 #define USB_VENDOR_ID_EZKEY		0x0518
 #define USB_DEVICE_ID_BTC_8193		0x0002
 
+#define USB_VENDOR_ID_FORMOSA          0x147a
+#define USB_DEVICE_ID_FORMOSA_IR_RECEIVER      0xe03e
+
 #define USB_VENDOR_ID_FREESCALE		0x15A2
 #define USB_DEVICE_ID_FREESCALE_MX28	0x004F
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -70,6 +70,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },


