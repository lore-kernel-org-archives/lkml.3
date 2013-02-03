Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3BCOz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34167 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab3BCOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:19 -0500
Message-Id: <20130203144646.702712988@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 030/128] Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat
 codecs"
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 7ed4165e2d01bdbbb4c1086eb73eadf0f64cbbf0 upstream.

This reverts commit 697c373e34613609cb5450f98b91fefb6e910588.

The original patch was meant to remove clicking, but in fact caused even
more clicking instead.

Thanks to c4pp4 for doing most of the work with this bug.

BugLink: https://bugs.launchpad.net/bugs/886975
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -592,24 +592,12 @@ static int conexant_build_controls(struc
 	return 0;
 }
 
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-static int conexant_suspend(struct hda_codec *codec, pm_message_t state)
-{
-	snd_hda_shutup_pins(codec);
-	return 0;
-}
-#endif
-
 static const struct hda_codec_ops conexant_patch_ops = {
 	.build_controls = conexant_build_controls,
 	.build_pcms = conexant_build_pcms,
 	.init = conexant_init,
 	.free = conexant_free,
 	.set_power_state = conexant_set_power,
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 #ifdef CONFIG_SND_HDA_INPUT_BEEP
@@ -4429,10 +4417,6 @@ static const struct hda_codec_ops cx_aut
 	.init = cx_auto_init,
 	.free = conexant_free,
 	.unsol_event = cx_auto_unsol_event,
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 /*


