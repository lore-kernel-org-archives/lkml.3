Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab3APAJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:09:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:42985 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab3AOWdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 136/221] Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"
Date: Tue, 15 Jan 2013 10:51:03 -0800
Message-Id: <20130115185007.870436652@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -553,24 +553,12 @@ static int conexant_build_controls(struc
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int conexant_suspend(struct hda_codec *codec)
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
-#ifdef CONFIG_PM
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 #ifdef CONFIG_SND_HDA_INPUT_BEEP
@@ -4393,10 +4381,6 @@ static const struct hda_codec_ops cx_aut
 	.init = cx_auto_init,
 	.free = conexant_free,
 	.unsol_event = snd_hda_jack_unsol_event,
-#ifdef CONFIG_PM
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 /*


