Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3LJIYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:24:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3LJIBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 38/52] HID: usbhid: quirk for Synaptics Large Touchccreen
Date: Tue, 10 Dec 2013 00:01:11 -0800
Message-Id: <20131210075956.879511781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    2 ++
 drivers/hid/usbhid/hid-quirks.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -786,6 +786,8 @@
 #define USB_DEVICE_ID_SYNAPTICS_COMP_TP	0x0009
 #define USB_DEVICE_ID_SYNAPTICS_WTP	0x0010
 #define USB_DEVICE_ID_SYNAPTICS_DPAD	0x0013
+#define USB_DEVICE_ID_SYNAPTICS_LTS1	0x0af8
+#define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
 
 #define USB_VENDOR_ID_THINGM		0x27b8
 #define USB_DEVICE_ID_BLINK1		0x01ed
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -112,6 +112,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };


