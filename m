Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaFCMTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:19:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaFCLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: AceLan Kao <acelan.kao@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 025/138] HID: usbhid: quirk for Synaptics HD touchscreen
Date: Tue,  3 Jun 2014 12:37:51 +0100
Message-Id: <1401795584-22664-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit d8e2e7581d2521910398c4c80d7a3b78e84da7d5 upstream.

Add Synaptics HD touchscreen(06cb:0ac3) to no init report quirk.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7c8591895c66..4a71fd269c5b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -807,6 +807,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DPAD	0x0013
 #define USB_DEVICE_ID_SYNAPTICS_LTS1	0x0af8
 #define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
+#define USB_DEVICE_ID_SYNAPTICS_HD	0x0ac3
 
 #define USB_VENDOR_ID_THINGM		0x27b8
 #define USB_DEVICE_ID_BLINK1		0x01ed
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0db9a67278ba..c0c0fcf69688 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -115,6 +115,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SIS, USB_DEVICE_ID_SIS_TS, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
 
 	{ 0, 0 }
 };
-- 
1.9.1

