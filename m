Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaFGBcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbaFGBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "AceLan Kao" <acelan.kao@canonical.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.579836525@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 50/92] HID: usbhid: quirk for Synaptics Large Touchccreen
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 8171a67d587a09e14a4949a81e070345fedcf410 upstream.

BugLink: http://bugs.launchpad.net/bugs/1180881

Synaptics large touchscreen doesn't support some of the report request
while initializing. The unspoorted request will make the device unreachable,
and will lead to the following usb_submit_urb() function call timeout.
So, add the IDs into HID_QUIRK_NO_INIT_REPORTS quirk.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2:
 - Adjust context
 - Add definition of USB_VENDOR_ID_SYNAPTICS]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -678,6 +678,10 @@
 #define USB_DEVICE_ID_SYMBOL_SCANNER_1	0x0800
 #define USB_DEVICE_ID_SYMBOL_SCANNER_2	0x1300
 
+#define USB_VENDOR_ID_SYNAPTICS		0x06cb
+#define USB_DEVICE_ID_SYNAPTICS_LTS1	0x0af8
+#define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
+
 #define USB_VENDOR_ID_THRUSTMASTER	0x044f
 
 #define USB_VENDOR_ID_TOPSEED		0x0766
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -100,6 +100,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };

