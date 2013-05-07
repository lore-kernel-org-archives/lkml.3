Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab3EGD6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:58:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3EGD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:43 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6lamFAHPntAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Xk9mNr9HKNEA:10 a=8b9GpE9nAAAA:8 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=8NEP1B8RWw4A:10 a=RUNXi7WdHkcA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035841.393724748@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [003/126] ASoC: spear_pcm: Update to new pcm_new() API
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0003-ASoC-spear_pcm-Update-to-new-pcm_new-API.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 59d9cc2a5073ab4b8c8f8bdbacf230a538abc55d ]

Commit 552d1ef6 ("ASoC: core - Optimise and refactor pcm_new() to pass only
rtd") updated the pcm_new() callback to take the rtd as the only parameter. The
spear PCM driver (which was merged much later) still uses the old API. This
patch updates the driver to the new API.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/spear/spear_pcm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/spear/spear_pcm.c b/sound/soc/spear/spear_pcm.c
index 8c7f237..8cf6d70 100644
--- a/sound/soc/spear/spear_pcm.c
+++ b/sound/soc/spear/spear_pcm.c
@@ -149,9 +149,9 @@ static void spear_pcm_free(struct snd_pcm *pcm)
 
 static u64 spear_pcm_dmamask = DMA_BIT_MASK(32);
 
-static int spear_pcm_new(struct snd_card *card,
-		struct snd_soc_dai *dai, struct snd_pcm *pcm)
+static int spear_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
+	struct snd_card *card = rtd->card->snd_card;
 	int ret;
 
 	if (!card->dev->dma_mask)
@@ -159,16 +159,16 @@ static int spear_pcm_new(struct snd_card *card,
 	if (!card->dev->coherent_dma_mask)
 		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
-	if (dai->driver->playback.channels_min) {
-		ret = spear_pcm_preallocate_dma_buffer(pcm,
+	if (rtd->cpu_dai->driver->playback.channels_min) {
+		ret = spear_pcm_preallocate_dma_buffer(rtd->pcm,
 				SNDRV_PCM_STREAM_PLAYBACK,
 				spear_pcm_hardware.buffer_bytes_max);
 		if (ret)
 			return ret;
 	}
 
-	if (dai->driver->capture.channels_min) {
-		ret = spear_pcm_preallocate_dma_buffer(pcm,
+	if (rtd->cpu_dai->driver->capture.channels_min) {
+		ret = spear_pcm_preallocate_dma_buffer(rtd->pcm,
 				SNDRV_PCM_STREAM_CAPTURE,
 				spear_pcm_hardware.buffer_bytes_max);
 		if (ret)
-- 
1.7.10.4


