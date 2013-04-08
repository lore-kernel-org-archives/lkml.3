Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936482Ab3DHKTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:19:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935529Ab3DHJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Boyer <jwboyer@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 023/102] HID: usbhid: quirk for Realtek Multi-card reader
Date: Mon,  8 Apr 2013 10:49:38 +0100
Message-Id: <1365414657-29191-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 3d464d9b71ef2f2b40a4bc9dcf06794fd1be9d12 upstream.

This device needs to be added to the quirks list with HID_QUIRK_NO_INIT_REPORTS,
otherwise it causes 10 seconds timeout during report initialization.

This fixes Red Hat bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=806587

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-ids.h           | 3 +++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c04eec3..b57671c 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -656,6 +656,9 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
 #define USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN	0x3001
 
+#define USB_VENDOR_ID_REALTEK		0x0bda
+#define USB_DEVICE_ID_REALTEK_READER	0x0152
+
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
 #define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 1a4bc41..a73bb7a 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -79,6 +79,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_REALTEK, USB_DEVICE_ID_REALTEK_READER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
-- 
1.8.1.2

