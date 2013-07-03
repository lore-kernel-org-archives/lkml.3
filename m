Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3GCTFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:05:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027Ab3GCTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:31 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IFNi_FqrRewA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=18N2Q4z3e8QA:10 a=VwQbUJbxAAAA:8 a=MbhKCQfYMch5vn3wT6AA:9 a=7t4jVOfIR2gA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184056.615894208@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [072/141] ALSA: usb-audio: fix Roland/Cakewalk UM-3G support
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0072-ALSA-usb-audio-fix-Roland-Cakewalk-UM-3G-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

[ Upstream commit a0c6d309c6df14655f9962f666d1da96318b0b7c ]

Commit 927c9423dd5f2d1c0b93d5e694ab84b4a5559713 (ALSA: usb-audio: add
Edirol UM-3G support) used a wrong quirk type, which would make the
driver refuse to attach with the error message "MIDIStreaming interface
descriptor not found".

Cc: <stable@vger.kernel.org> # 3.3 and later
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/quirks-table.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d73ac9b..0f7c933 100644
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
1.7.10.4


