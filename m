Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3GWIXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:23:18 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:34720 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab3GWIXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:23:16 -0400
Date: Tue, 23 Jul 2013 10:23:20 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] ARM: kirkwood: enable S/PDIF
Message-ID: <20130723102320.56bc4555@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables S/PDIF.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/kirkwood/kirkwood-i2s.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 4c9dad3..ad94c50 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -159,6 +159,7 @@ static int kirkwood_i2s_hw_params(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_FORMAT_S16_LE:
 		i2s_value |= KIRKWOOD_I2S_CTL_SIZE_16;
 		ctl_play = KIRKWOOD_PLAYCTL_SIZE_16_C |
+			   KIRKWOOD_PLAYCTL_SPDIF_EN |
 			   KIRKWOOD_PLAYCTL_I2S_EN;
 		ctl_rec = KIRKWOOD_RECCTL_SIZE_16_C |
 			  KIRKWOOD_RECCTL_I2S_EN;
@@ -169,6 +170,7 @@ static int kirkwood_i2s_hw_params(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_FORMAT_S20_3LE:
 		i2s_value |= KIRKWOOD_I2S_CTL_SIZE_20;
 		ctl_play = KIRKWOOD_PLAYCTL_SIZE_20 |
+			   KIRKWOOD_PLAYCTL_SPDIF_EN |
 			   KIRKWOOD_PLAYCTL_I2S_EN;
 		ctl_rec = KIRKWOOD_RECCTL_SIZE_20 |
 			  KIRKWOOD_RECCTL_I2S_EN;
@@ -177,6 +179,7 @@ static int kirkwood_i2s_hw_params(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_FORMAT_S24_LE:
 		i2s_value |= KIRKWOOD_I2S_CTL_SIZE_24;
 		ctl_play = KIRKWOOD_PLAYCTL_SIZE_24 |
+			   KIRKWOOD_PLAYCTL_SPDIF_EN |
 			   KIRKWOOD_PLAYCTL_I2S_EN;
 		ctl_rec = KIRKWOOD_RECCTL_SIZE_24 |
 			  KIRKWOOD_RECCTL_I2S_EN;

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
