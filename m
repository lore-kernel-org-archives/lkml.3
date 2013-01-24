Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3AXDjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:39:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3AXDaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 38/74] Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"
Date: Thu, 24 Jan 2013 01:26:50 -0200
Message-Id: <1358998046-613-39-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: s/CONFIG_PM/CONFIG_SND_HDA_POWER_SAVE/, adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_conexant.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 808d5fd..908fc7f 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -553,24 +553,12 @@ static int conexant_build_controls(struct hda_codec *codec)
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
@@ -4401,10 +4389,6 @@ static const struct hda_codec_ops cx_auto_patch_ops = {
 	.init = cx_auto_init,
 	.free = conexant_free,
 	.unsol_event = cx_auto_unsol_event,
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 /*
-- 
1.7.9.5

