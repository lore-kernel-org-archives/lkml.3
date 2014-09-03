Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaICJ4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:07 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57314 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755408AbaICJ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 24/56] ALSA: usb-audio: fix BOSS ME-25 MIDI regression
Date: Wed,  3 Sep 2014 11:26:43 +0200
Message-Id: <925eb23fcf4937e2d239f785ac35d06ee2ab36aa.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 53da5ebfef66ea6e478ad9c6add3781472b79475 upstream.

The BOSS ME-25 turns out not to have any useful descriptors in its MIDI
interface, so its needs a quirk entry after all.

Reported-and-tested-by: Kees van Veen <kees.vanveen@gmail.com>
Fixes: 8e5ced83dd1c ("ALSA: usb-audio: remove superfluous Roland quirks")
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/quirks-table.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index f5f0595ef9c7..0a81a51dd997 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1582,6 +1582,35 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
+	/* BOSS ME-25 */
+	USB_DEVICE(0x0582, 0x0113),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_MIDI_FIXED_ENDPOINT,
+				.data = & (const struct snd_usb_midi_endpoint_info) {
+					.out_cables = 0x0001,
+					.in_cables  = 0x0001
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+{
 	/* only 44.1 kHz works at the moment */
 	USB_DEVICE(0x0582, 0x0120),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-- 
2.1.0

