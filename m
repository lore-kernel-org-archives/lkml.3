Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3AXWrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:47:40 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:50265 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756253Ab3AXWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:47:28 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 17:47:28 EST
Message-ID: <5101B7CE.4070102@semaphore.gr>
Date: Fri, 25 Jan 2013 00:38:06 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: [PATCH next-20130124] Sound: pci: Fix unused variable warning in
 patch_sigmatel.c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warnings

sound/pci/hda/patch_sigmatel.c: In function ‘stac92hd71bxx_fixup_hp’:
sound/pci/hda/patch_sigmatel.c:2434:24: warning: unused variable ‘spec’ [-Wunused-variable]

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 sound/pci/hda/patch_sigmatel.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 0aa0ceb..f269d1f 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -2365,7 +2365,6 @@ static void stac92hd71bxx_fixup_ref(struct hda_codec *codec,
 static void stac92hd71bxx_fixup_hp_m4(struct hda_codec *codec,
 				      const struct hda_fixup *fix, int action)
 {
-	struct sigmatel_spec *spec = codec->spec;
 	struct hda_jack_tbl *jack;
 
 	if (action != HDA_FIXUP_ACT_PRE_PROBE)
@@ -2381,7 +2380,7 @@ static void stac92hd71bxx_fixup_hp_m4(struct hda_codec *codec,
 	if (jack)
 		jack->private_data = 0x02;
 
-	spec->gpio_mask |= 0x02;
+	((struct sigmatel_spec *)codec->spec)->gpio_mask |= 0x02;
 
 	/* enable internal microphone */
 	snd_hda_codec_set_pincfg(codec, 0x0e, 0x01813040);
@@ -2420,19 +2419,15 @@ static void stac92hd71bxx_fixup_hp_dv5(struct hda_codec *codec,
 static void stac92hd71bxx_fixup_hp_hdx(struct hda_codec *codec,
 				       const struct hda_fixup *fix, int action)
 {
-	struct sigmatel_spec *spec = codec->spec;
-
 	if (action != HDA_FIXUP_ACT_PRE_PROBE)
 		return;
-	spec->gpio_led = 0x08;
+	((struct sigmatel_spec *)codec->spec)->gpio_led = 0x08;
 }
 
 
 static void stac92hd71bxx_fixup_hp(struct hda_codec *codec,
 				   const struct hda_fixup *fix, int action)
 {
-	struct sigmatel_spec *spec = codec->spec;
-
 	if (action != HDA_FIXUP_ACT_PRE_PROBE)
 		return;
 
@@ -2456,8 +2451,9 @@ static void stac92hd71bxx_fixup_hp(struct hda_codec *codec,
 
 	if (find_mute_led_cfg(codec, 1))
 		snd_printd("mute LED gpio %d polarity %d\n",
-				spec->gpio_led,
-				spec->gpio_led_polarity);
+			((struct sigmatel_spec *)codec->spec)->gpio_led,
+			((struct sigmatel_spec *)codec->spec)->
+							gpio_led_polarity);
 
 }
 
-- 
1.8.1

