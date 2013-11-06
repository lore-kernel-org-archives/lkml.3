Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3KFKRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:17:18 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37934 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3KFKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 13/13] ASoC: ux500_pcm: Take out pointless dev_dbg() call
Date: Wed,  6 Nov 2013 10:16:25 +0000
Message-Id: <1383732985-18928-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_pcm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index acfec98..fd7f12e 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -65,14 +65,10 @@ static struct dma_chan *ux500_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
 	struct snd_pcm_substream *substream)
 {
 	struct snd_soc_dai *dai = rtd->cpu_dai;
-	struct device *dev = dai->dev;
 	u16 per_data_width, mem_data_width;
 	struct stedma40_chan_cfg *dma_cfg;
 	struct ux500_msp_dma_params *dma_params;
 
-	dev_dbg(dev, "%s: MSP %d (%s): Enter.\n", __func__, dai->id,
-		snd_pcm_stream_str(substream));
-
 	dma_params = snd_soc_dai_get_dma_data(dai, substream);
 	dma_cfg = dma_params->dma_cfg;
 
-- 
1.8.1.2

