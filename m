Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3LJIYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:24:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3LJIBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 39/52] HID: usbhid: quirk for SiS Touchscreen
Date: Tue, 10 Dec 2013 00:01:12 -0800
Message-Id: <20131210075956.947799041@linuxfoundation.org>
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

commit 684524d35fe8d13be1f2649633e43bd02c96c695 upstream.

BugLink: http://bugs.launchpad.net/bugs/1180881

This device needs to be added to the quirks list with HID_QUIRK_NO_INIT_REPORTS,
otherwise it causes 10 seconds timeout during report initialization.

[12431.828467] hid-multitouch 0003:0457:1013.0475: usb_submit_urb(ctrl) failed: -1
[12431.828507] hid-multitouch 0003:0457:1013.0475: timeout initializing reports

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -915,4 +915,7 @@
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 
+#define USB_VENDOR_ID_SIS	0x0457
+#define USB_DEVICE_ID_SIS_TS	0x1013
+
 #endif
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -114,6 +114,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SIS, USB_DEVICE_ID_SIS_TS, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };


