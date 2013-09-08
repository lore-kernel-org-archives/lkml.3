Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab3IHDUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755652Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Torstein Hegge" <hegge@resisty.net>,
        "Daniel Mack" <zonque@gmail.com>, "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.639929663@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [019/121] ALSA: usb: Parse UAC2 extension unit like for UAC1
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Torstein Hegge <hegge@resisty.net>

commit 61ac51301e6c6d4ed977d7674ce2b8e713619a9b upstream.

UAC2_EXTENSION_UNIT_V2 differs from UAC1_EXTENSION_UNIT, but can be handled in
the same way when parsing the unit. Otherwise parse_audio_unit() fails when it
sees an extension unit on a UAC2 device.

UAC2_EXTENSION_UNIT_V2 is outside the range allocated by UAC1.

Signed-off-by: Torstein Hegge <hegge@resisty.net>
Acked-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -722,7 +722,8 @@ static int check_input_term(struct mixer
 		case UAC1_PROCESSING_UNIT:
 		case UAC1_EXTENSION_UNIT:
 		/* UAC2_PROCESSING_UNIT_V2 */
-		/* UAC2_EFFECT_UNIT */ {
+		/* UAC2_EFFECT_UNIT */
+		case UAC2_EXTENSION_UNIT_V2: {
 			struct uac_processing_unit_descriptor *d = p1;
 
 			if (state->mixer->protocol == UAC_VERSION_2 &&
@@ -1967,6 +1968,8 @@ static int parse_audio_unit(struct mixer
 			return parse_audio_extension_unit(state, unitid, p1);
 		else /* UAC_VERSION_2 */
 			return parse_audio_processing_unit(state, unitid, p1);
+	case UAC2_EXTENSION_UNIT_V2:
+		return parse_audio_extension_unit(state, unitid, p1);
 	default:
 		snd_printk(KERN_ERR "usbaudio: unit %u: unexpected type 0x%02x\n", unitid, p1[2]);
 		return -EINVAL;

