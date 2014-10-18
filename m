Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaJRWrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:47:47 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:47586 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaJRWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:47:46 -0400
From: Vlad Catoi <vladcatoi@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, Daniel Mack <zonque@gmail.com>,
        Eduard Gilmutdinov <edgilmutdinov@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Vlad Catoi <vladcatoi@gmail.com>
Subject: [PATCH 1/1] snd-usb-audio: Add support for Steinberg UR22 USB interface
Date: Sat, 18 Oct 2014 17:45:41 -0500
Message-Id: <1413672341-3703-1-git-send-email-vladcatoi@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for Steinberg UR22 USB interface via quirks table patch

See Ubuntu bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1317244
Also see threads:
http://linux-audio.4202.n7.nabble.com/Support-for-Steinberg-UR22-Yamaha-USB-chipset-0499-1509-tc82888.html#a82917
http://www.steinberg.net/forums/viewtopic.php?t=62290

Tested by at least 4 people judging by the threads.
Did not test MIDI interface, but audio output and capture both are
functional. Built 3.17 kernel with this driver on Ubuntu 14.04 & tested with mpg123
Patch applied to 3.13 Ubuntu kernel works well enough for daily use.

Signed-off-by: Vlad Catoi <vladcatoi@gmail.com>
---
 sound/usb/quirks-table.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 223c47b..c657752 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -385,6 +385,36 @@ YAMAHA_DEVICE(0x105d, NULL),
 	}
 },
 {
+	USB_DEVICE(0x0499, 0x1509),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		/* .vendor_name = "Yamaha", */
+		/* .product_name = "Steinberg UR22", */
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_MIDI_YAMAHA
+			},
+			{
+				.ifnum = 4,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+{
 	USB_DEVICE(0x0499, 0x150a),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		/* .vendor_name = "Yamaha", */
-- 
1.9.1

