Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3EVVSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:18:16 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35997 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3EVVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:18:14 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] HID: usbhid: ignore Jabra speakerphones HID interface
Date: Wed, 22 May 2013 14:17:54 -0700
Message-Id: <1369257474-26389-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a quirk to ignore Jabra speakerphone 410 and 510 devices HID
interface.
On those devices, the USB audio interface is working nicely,
but the HID interface is not working with the kernel usbhid driver,
and it requires a specific userspace program.
We could unbind it from userspace but just attaching the usbhid driver has
sometimes nasty effects:
either confusing the device state machine or triggering a storm of volume key
events making eventual sound UI blinking like crazy.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/hid/hid-ids.h           | 4 ++++
 drivers/hid/usbhid/hid-quirks.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 38535c9..533815b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -447,6 +447,10 @@
 #define USB_VENDOR_ID_IRTOUCHSYSTEMS	0x6615
 #define USB_DEVICE_ID_IRTOUCH_INFRARED_USB	0x0070
 
+#define USB_VENDOR_ID_JABRA		0x0b0e
+#define USB_DEVICE_ID_JABRA_SPEAK_410	0x0412
+#define USB_DEVICE_ID_JABRA_SPEAK_510	0x0420
+
 #define USB_VENDOR_ID_JESS		0x0c45
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 19b8360..d8c9aaf 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -109,6 +109,9 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
+
+	{ USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_SPEAK_410, HID_QUIRK_IGNORE },
+	{ USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_SPEAK_510, HID_QUIRK_IGNORE },
 	{ 0, 0 }
 };
 
-- 
1.8.2.1

