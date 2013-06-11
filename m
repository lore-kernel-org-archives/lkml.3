Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab3FKUel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:34:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3FKUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 06/32] ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
Date: Tue, 11 Jun 2013 13:03:05 -0700
Message-Id: <20130611200126.921870127@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8eafc0a161123d90617c9ca2eddfe87b382b1b89 upstream.

... instead of applying to all interfaces.

Reference: http://forums.gentoo.org/viewtopic-p-6886404.html

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -157,7 +157,13 @@
 	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL
 },
 {
-	USB_DEVICE(0x046d, 0x0990),
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x046d,
+	.idProduct = 0x0990,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.vendor_name = "Logitech, Inc.",
 		.product_name = "QuickCam Pro 9000",


