Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3EVVkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:40:09 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50510 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3EVVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:40:07 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] HID: usbhid: ignore Jabra speakerphones HID interface
Date: Wed, 22 May 2013 14:39:50 -0700
Message-Id: <1369258790-30629-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <CAP_ceTxhMut6Gewj=WxqAREusK4ZpwOyptAOAm9YT=LvEJcXCQ@mail.gmail.com>
References: <CAP_ceTxhMut6Gewj=WxqAREusK4ZpwOyptAOAm9YT=LvEJcXCQ@mail.gmail.com>
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
 drivers/hid/hid-core.c | 2 ++
 drivers/hid/hid-ids.h  | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 264f550..5d2ef66 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2042,6 +2042,8 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1006) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1007) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IMATION, USB_DEVICE_ID_DISC_STAKKA) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_SPEAK_410) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_SPEAK_510) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KBGEAR, USB_DEVICE_ID_KBGEAR_JAMSTUDIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, USB_DEVICE_ID_KWORLD_RADIO_FM700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_GPEN_560) },
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
 
-- 
1.8.2.1

