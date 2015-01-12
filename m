Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbbALTKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:10:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbbALSFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 033/216] HID: yet another buggy ELAN touchscreen
Date: Mon, 12 Jan 2015 18:02:30 +0000
Message-Id: <1421085933-32536-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit a32c99e7ab8410bae7c276a7e94ca84d108de034 upstream.

The touchscreen needs the same quirk as the other models.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Reported-by: Bryan Poling <poli0048@umn.edu>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 drivers/usb/core/quirks.c       | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7c36ad6deb3f..ab9d3da01930 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -300,6 +300,7 @@
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN	0x0089
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_009B	0x009b
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_0103	0x0103
+#define USB_DEVICE_ID_ELAN_TOUCHSCREEN_010c	0x010c
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_016F	0x016f
 
 #define USB_VENDOR_ID_ELECOM		0x056e
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index ce52ae7565fa..7f16acb84f90 100644
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
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 7f4a4412b2fc..666399a23da3 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -103,6 +103,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04f3, 0x009b), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
+	{ USB_DEVICE(0x04f3, 0x010c), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	{ USB_DEVICE(0x04f3, 0x016f), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
-- 
2.1.4

