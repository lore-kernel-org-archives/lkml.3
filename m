Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800AbaKLBp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:45:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934786AbaKLBpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:45:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.14 155/203] HID: usbhid: enable always-poll quirk for Elan Touchscreen
Date: Wed, 12 Nov 2014 10:17:05 +0900
Message-Id: <20141112011549.804882258@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit bfe3c873e978d78b542a5852575dd74f4d1a5838 upstream.

Enable the always-poll quirk for Elan Touchscreens found on some recent
Samsung laptops.

Without this quirk the device keeps disconnecting from the bus (and is
re-enumerated) unless opened (and kept open, should an input event
occur).

Note that while the device can be run-time suspended, the autosuspend
timeout must be high enough to allow the device to be polled at least
once before being suspended. Specifically, using autosuspend_delay_ms=0
will still cause the device to disconnect on input events.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -292,6 +292,9 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
+#define USB_VENDOR_ID_ELAN		0x04f3
+#define USB_DEVICE_ID_ELAN_TOUCHSCREEN	0x0089
+
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -69,6 +69,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },


