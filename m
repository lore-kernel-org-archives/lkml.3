Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3FKUYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:24:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3FKUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 11/79] ALSA: usb-audio: fix Roland/Cakewalk UM-3G support
Date: Tue, 11 Jun 2013 13:02:37 -0700
Message-Id: <20130611195313.885564838@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit a0c6d309c6df14655f9962f666d1da96318b0b7c upstream.

Commit 927c9423dd5f2d1c0b93d5e694ab84b4a5559713 (ALSA: usb-audio: add
Edirol UM-3G support) used a wrong quirk type, which would make the
driver refuse to attach with the error message "MIDIStreaming interface
descriptor not found".

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1714,7 +1714,11 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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


