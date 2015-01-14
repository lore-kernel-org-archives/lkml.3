Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbbANI0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:26:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbbANH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Bryan Poling <poli0048@umn.edu>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.18 051/150] HID: yet another buggy ELAN touchscreen
Date: Tue, 13 Jan 2015 23:22:02 -0800
Message-Id: <20150114072058.193245351@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit a32c99e7ab8410bae7c276a7e94ca84d108de034 upstream.

The touchscreen needs the same quirk as the other models.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Reported-by: Bryan Poling <poli0048@umn.edu>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 drivers/usb/core/quirks.c       |    3 +++
 3 files changed, 5 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -300,6 +300,7 @@
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN	0x0089
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_009B	0x009b
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_0103	0x0103
+#define USB_DEVICE_ID_ELAN_TOUCHSCREEN_010c	0x010c
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_016F	0x016f
 
 #define USB_VENDOR_ID_ELECOM		0x056e
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -73,6 +73,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_009B, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_0103, HID_QUIRK_ALWAYS_POLL },
+	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_010c, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_016F, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -103,6 +103,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x04f3, 0x009b), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
+	{ USB_DEVICE(0x04f3, 0x010c), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	{ USB_DEVICE(0x04f3, 0x016f), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 


