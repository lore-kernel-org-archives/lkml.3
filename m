Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaHFEom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:44:42 -0400
Received: from s87.loopia.se ([194.9.94.112]:34701 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaHFEok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:44:40 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: lgirdwood@gmail.com, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 15/15] ASoC: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:44:26 -0700
Message-Id: <1407300266-534-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 sound/soc/atmel/atmel_ssc_dai.c | 2 +-
 sound/soc/sh/dma-sh7760.c       | 2 +-
 sound/soc/sh/rcar/gen.c         | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index f403f39..eb2ed21 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -201,7 +201,7 @@ static int atmel_ssc_startup(struct snd_pcm_substream *substream,
 	struct atmel_pcm_dma_params *dma_params;
 	int dir, dir_mask;
 
-	pr_debug("atmel_ssc_startup: SSC_SR=0x%u\n",
+	pr_debug("atmel_ssc_startup: SSC_SR=0x%x\n",
 		ssc_readl(ssc_p->ssc->regs, SR));
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
diff --git a/sound/soc/sh/dma-sh7760.c b/sound/soc/sh/dma-sh7760.c
index c85f8eb..5a71f74 100644
--- a/sound/soc/sh/dma-sh7760.c
+++ b/sound/soc/sh/dma-sh7760.c
@@ -204,7 +204,7 @@ static int camelot_prepare(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct camelot_pcm *cam = &cam_pcm_data[rtd->cpu_dai->id];
 
-	pr_debug("PCM data: addr 0x%08ulx len %d\n",
+	pr_debug("PCM data: addr 0x%08lx len %d\n",
 		 (u32)runtime->dma_addr, runtime->dma_bytes);
  
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
diff --git a/sound/soc/sh/rcar/gen.c b/sound/soc/sh/rcar/gen.c
index 3fdf3be..0f25ee6 100644
--- a/sound/soc/sh/rcar/gen.c
+++ b/sound/soc/sh/rcar/gen.c
@@ -69,7 +69,7 @@ u32 rsnd_read(struct rsnd_priv *priv,
 
 	regmap_fields_read(gen->regs[reg], rsnd_mod_id(mod), &val);
 
-	dev_dbg(dev, "r %s - 0x%04d : %08x\n", rsnd_mod_name(mod), reg, val);
+	dev_dbg(dev, "r %s - 0x%04x : %08x\n", rsnd_mod_name(mod), reg, val);
 
 	return val;
 }
@@ -86,7 +86,7 @@ void rsnd_write(struct rsnd_priv *priv,
 
 	regmap_fields_write(gen->regs[reg], rsnd_mod_id(mod), data);
 
-	dev_dbg(dev, "w %s - 0x%04d : %08x\n", rsnd_mod_name(mod), reg, data);
+	dev_dbg(dev, "w %s - 0x%04x : %08x\n", rsnd_mod_name(mod), reg, data);
 }
 
 void rsnd_bset(struct rsnd_priv *priv, struct rsnd_mod *mod,
@@ -101,7 +101,7 @@ void rsnd_bset(struct rsnd_priv *priv, struct rsnd_mod *mod,
 	regmap_fields_update_bits(gen->regs[reg], rsnd_mod_id(mod),
 				  mask, data);
 
-	dev_dbg(dev, "b %s - 0x%04d : %08x/%08x\n",
+	dev_dbg(dev, "b %s - 0x%04x : %08x/%08x\n",
 		rsnd_mod_name(mod), reg, data, mask);
 }
 
-- 
2.0.0.526.g5318336

