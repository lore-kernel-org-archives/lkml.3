Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbaIOWUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaIOWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Tim Gardner <tim.gardner@canonical.com>,
        Kees van Veen <kees.vanveen@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/187] ALSA: usb-audio: fix BOSS ME-25 MIDI regression
Date: Mon, 15 Sep 2014 15:07:37 -0700
Message-Id: <1410818997-9432-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 53da5ebfef66ea6e478ad9c6add3781472b79475 upstream.

The BOSS ME-25 turns out not to have any useful descriptors in its MIDI
interface, so its needs a quirk entry after all.

Reported-and-tested-by: Kees van Veen <kees.vanveen@gmail.com>
Fixes: 8e5ced83dd1c ("ALSA: usb-audio: remove superfluous Roland quirks")
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Kees van Veen <kees.vanveen@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/quirks-table.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index f5f0595..0a81a51 100644
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
1.9.1

