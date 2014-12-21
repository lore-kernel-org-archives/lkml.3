Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaLUMc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:32:28 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41798 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaLUMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:32:27 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: hda: patch_analog.c:  Remove some unused functions
Date: Sun, 21 Dec 2014 13:35:12 +0100
Message-Id: <1419165312-28886-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ad198x_ch_mode_get() ad198x_ch_mode_info() ad198x_ch_mode_info()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/hda/patch_analog.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 06275f8..0e76dcc 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -697,39 +697,6 @@ static int patch_ad1981(struct hda_codec *codec)
  *      E/F quad mic array
  */
 
-#ifdef ENABLE_AD_STATIC_QUIRKS
-static int ad198x_ch_mode_info(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_info *uinfo)
-{
-	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct ad198x_spec *spec = codec->spec;
-	return snd_hda_ch_mode_info(codec, uinfo, spec->channel_mode,
-				    spec->num_channel_mode);
-}
-
-static int ad198x_ch_mode_get(struct snd_kcontrol *kcontrol,
-			      struct snd_ctl_elem_value *ucontrol)
-{
-	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct ad198x_spec *spec = codec->spec;
-	return snd_hda_ch_mode_get(codec, ucontrol, spec->channel_mode,
-				   spec->num_channel_mode, spec->multiout.max_channels);
-}
-
-static int ad198x_ch_mode_put(struct snd_kcontrol *kcontrol,
-			      struct snd_ctl_elem_value *ucontrol)
-{
-	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct ad198x_spec *spec = codec->spec;
-	int err = snd_hda_ch_mode_put(codec, ucontrol, spec->channel_mode,
-				      spec->num_channel_mode,
-				      &spec->multiout.max_channels);
-	if (err >= 0 && spec->need_dac_fix)
-		spec->multiout.num_dacs = spec->multiout.max_channels / 2;
-	return err;
-}
-#endif /* ENABLE_AD_STATIC_QUIRKS */
-
 static int ad1988_auto_smux_enum_info(struct snd_kcontrol *kcontrol,
 				      struct snd_ctl_elem_info *uinfo)
 {
-- 
1.7.10.4

