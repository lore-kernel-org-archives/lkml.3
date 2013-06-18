Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3FRMAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:00:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3FRLof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 42/93] ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
Date: Tue, 18 Jun 2013 12:42:50 +0100
Message-Id: <1371555821-12820-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8eafc0a161123d90617c9ca2eddfe87b382b1b89 upstream.

... instead of applying to all interfaces.

Reference: http://forums.gentoo.org/viewtopic-p-6886404.html

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/quirks-table.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 1375633..cfb8033 100644
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
-- 
1.8.1.2

