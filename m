Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386AbaDJDpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:45:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934653AbaDJDWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torstein Hegge <hegge@resisty.net>, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 104/134] ALSA: usb: Parse UAC2 extension unit like for UAC1
Date: Wed,  9 Apr 2014 20:23:40 -0700
Message-Id: <20140410032313.123627434@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    5 ++++-
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
@@ -1975,6 +1976,8 @@ static int parse_audio_unit(struct mixer
 			return parse_audio_extension_unit(state, unitid, p1);
 		else /* UAC_VERSION_2 */
 			return parse_audio_processing_unit(state, unitid, p1);
+	case UAC2_EXTENSION_UNIT_V2:
+		return parse_audio_extension_unit(state, unitid, p1);
 	default:
 		snd_printk(KERN_ERR "usbaudio: unit %u: unexpected type 0x%02x\n", unitid, p1[2]);
 		return -EINVAL;


