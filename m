Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbbATTn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:43:26 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:21454 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbbATTnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:43:24 -0500
X-Mailbox-Line: From c5ce41929ab14a3d200a6237181715539712ef07 Mon Sep 17 00:00:00 2001
Message-Id: <c5ce41929ab14a3d200a6237181715539712ef07.1421782532.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 19 Jan 2015 18:38:34 +0100
Subject: [PATCH v10 2/9] ASoC: kirkwood: check the DAI type from the DAI name
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the DAIs are created from a graph of ports, their types are not tied
to their ID.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/kirkwood/kirkwood-i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 62d9c12..357f963 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -263,7 +263,7 @@ static int kirkwood_i2s_play_trigger(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_TRIGGER_START:
 		/* configure */
 		ctl = priv->ctl_play;
-		if (dai->id == 0)
+		if (dai->name[0] == 'i')
 			ctl &= ~KIRKWOOD_PLAYCTL_SPDIF_EN;	/* i2s */
 		else
 			ctl &= ~KIRKWOOD_PLAYCTL_I2S_EN;	/* spdif */
@@ -331,7 +331,7 @@ static int kirkwood_i2s_rec_trigger(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_TRIGGER_START:
 		/* configure */
 		ctl = priv->ctl_rec;
-		if (dai->id == 0)
+		if (dai->name[0] == 'i')
 			ctl &= ~KIRKWOOD_RECCTL_SPDIF_EN;	/* i2s */
 		else
 			ctl &= ~KIRKWOOD_RECCTL_I2S_EN;		/* spdif */
-- 
2.1.4

