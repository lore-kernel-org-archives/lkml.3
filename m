Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3FRLof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56049 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab3FRLoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 36/93] ALSA: usb-audio: fix Roland/Cakewalk UM-3G support
Date: Tue, 18 Jun 2013 12:42:44 +0100
Message-Id: <1371555821-12820-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit a0c6d309c6df14655f9962f666d1da96318b0b7c upstream.

Commit 927c9423dd5f2d1c0b93d5e694ab84b4a5559713 (ALSA: usb-audio: add
Edirol UM-3G support) used a wrong quirk type, which would make the
driver refuse to attach with the error message "MIDIStreaming interface
descriptor not found".

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/quirks-table.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 128eb0c..1375633 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1622,7 +1622,11 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	USB_DEVICE_VENDOR_SPEC(0x0582, 0x0108),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.ifnum = 0,
-		.type = QUIRK_MIDI_STANDARD_INTERFACE
+		.type = QUIRK_MIDI_FIXED_ENDPOINT,
+		.data = & (const struct snd_usb_midi_endpoint_info) {
+			.out_cables = 0x0007,
+			.in_cables  = 0x0007
+		}
 	}
 },
 {
-- 
1.8.1.2

