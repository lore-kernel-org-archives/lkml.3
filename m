Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDNJn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:43:56 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:29989 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaDNJny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:43:54 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] driver/snd: es18xx driver should use udelay error
Date: Mon, 14 Apr 2014 17:43:08 +0800
Message-Id: <1397468588-18559-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>

udelay with more than 20000 may cause __bad_udelay.
Use mdelay for instead.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 sound/isa/es18xx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 1c16830..8d3a3b6 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -520,7 +520,7 @@ static int snd_es18xx_playback1_trigger(struct snd_es18xx *chip,
 			snd_es18xx_mixer_write(chip, 0x78, 0x93);
 #ifdef AVOID_POPS
 		/* Avoid pops */
-                udelay(100000);
+		mudelay(100);
 		if (chip->caps & ES18XX_PCM2)
 			/* Restore Audio 2 volume */
 			snd_es18xx_mixer_write(chip, 0x7C, chip->audio2_vol);
@@ -537,7 +537,7 @@ static int snd_es18xx_playback1_trigger(struct snd_es18xx *chip,
                 /* Stop DMA */
                 snd_es18xx_mixer_write(chip, 0x78, 0x00);
 #ifdef AVOID_POPS
-                udelay(25000);
+		mdelay(25);
 		if (chip->caps & ES18XX_PCM2)
 			/* Set Audio 2 volume to 0 */
 			snd_es18xx_mixer_write(chip, 0x7C, 0);
@@ -596,7 +596,7 @@ static int snd_es18xx_capture_prepare(struct snd_pcm_substream *substream)
 	snd_es18xx_write(chip, 0xA5, count >> 8);
 
 #ifdef AVOID_POPS
-	udelay(100000);
+	mdelay(100);
 #endif
 
         /* Set format */
@@ -691,7 +691,7 @@ static int snd_es18xx_playback2_trigger(struct snd_es18xx *chip,
                 snd_es18xx_write(chip, 0xB8, 0x05);
 #ifdef AVOID_POPS
 		/* Avoid pops */
-                udelay(100000);
+		mdelay(100);
                 /* Enable Audio 1 */
                 snd_es18xx_dsp_command(chip, 0xD1);
 #endif
@@ -705,7 +705,7 @@ static int snd_es18xx_playback2_trigger(struct snd_es18xx *chip,
                 snd_es18xx_write(chip, 0xB8, 0x00);
 #ifdef AVOID_POPS
 		/* Avoid pops */
-                udelay(25000);
+		mdelay(25);
                 /* Disable Audio 1 */
                 snd_es18xx_dsp_command(chip, 0xD3);
 #endif
-- 
1.7.10.4

