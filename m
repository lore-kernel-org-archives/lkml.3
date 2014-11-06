Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaKFWoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaKFWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:01 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Catoi <vladcatoi@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 081/162] ALSA: usb-audio: Add support for Steinberg UR22 USB interface
Date: Thu,  6 Nov 2014 14:35:45 -0800
Message-Id: <1415313426-9622-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Catoi <vladcatoi@gmail.com>

commit f0b127fbfdc8756eba7437ab668f3169280bd358 upstream.

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
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/quirks-table.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 0e52836..8590a32 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -386,6 +386,36 @@ YAMAHA_DEVICE(0x105d, NULL),
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

