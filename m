Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbbA2C7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:59:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47014 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965372AbbA2Chy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 022/139] [media] sound: simplify au0828 quirk table
Date: Wed, 28 Jan 2015 14:19:25 -0800
Message-Id: <1422483682-15393-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit 5d1f00a20d2d56ed480e64e938a2391353ee565b upstream.

Add a macro to simplify au0828 quirk table. That makes easier
to check it against the USB IDs at drivers/media/usb/au0828/au0828-cards.c.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
[ kamal: backport to 3.13-stable: context (removed entries order) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/au0828/au0828-cards.c |   5 +
 sound/usb/quirks-table.h                | 158 +++++++-------------------------
 2 files changed, 36 insertions(+), 127 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index dd32dec..1d4b110 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -36,6 +36,11 @@ static void hvr950q_cs5340_audio(void *priv, int enable)
 		au0828_clear(dev, REG_000, 0x10);
 }
 
+/*
+ * WARNING: There's a quirks table at sound/usb/quirks-table.h
+ * that should also be updated every time a new device with V4L2 support
+ * is added here.
+ */
 struct au0828_board au0828_boards[] = {
 	[AU0828_BOARD_UNKNOWN] = {
 		.name	= "Unknown board",
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8590a32..cf946cd 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2743,133 +2743,37 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
-/* Hauppauge HVR-950Q and HVR-850 */
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7200),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7240),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-850",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7210),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7217),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721b),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721e),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721f),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7280),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x0fd9, 0x0008),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
+/*
+ * Auvitek au0828 devices with audio interface.
+ * This should be kept in sync with drivers/media/usb/au0828/au0828-cards.c
+ * Please notice that some drivers are DVB only, and don't need to be
+ * here. That's the case, for example, of DVICO_FUSIONHDTV7.
+ */
+
+#define AU0828_DEVICE(vid, pid, vname, pname) { \
+	USB_DEVICE_VENDOR_SPEC(vid, pid), \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+		       USB_DEVICE_ID_MATCH_INT_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS, \
+	.bInterfaceClass = USB_CLASS_AUDIO, \
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL, \
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) { \
+		.vendor_name = vname, \
+		.product_name = pname, \
+		.ifnum = QUIRK_ANY_INTERFACE, \
+		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
+	} \
+}
+
+AU0828_DEVICE(0x2040, 0x7200, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7210, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7217, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x721b, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x721e, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x721f, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
+AU0828_DEVICE(0x2040, 0x7280, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x0fd9, 0x0008, "Hauppauge", "HVR-950Q"),
 
 /* Digidesign Mbox */
 {
-- 
1.9.1

