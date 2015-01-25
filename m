Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbbAYTR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:17:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbbAYSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.14 49/98] [media] sound: simplify au0828 quirk table
Date: Sun, 25 Jan 2015 10:07:07 -0800
Message-Id: <20150125180714.996599830@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit 5d1f00a20d2d56ed480e64e938a2391353ee565b upstream.

Add a macro to simplify au0828 quirk table. That makes easier
to check it against the USB IDs at drivers/media/usb/au0828/au0828-cards.c.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/au0828/au0828-cards.c |    5 +
 sound/usb/quirks-table.h                |  158 ++++++--------------------------
 2 files changed, 36 insertions(+), 127 deletions(-)

--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -36,6 +36,11 @@ static void hvr950q_cs5340_audio(void *p
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
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2804,133 +2804,37 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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


