Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937181Ab3DJXTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:19:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936816Ab3DJWrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 03/64] ASoC: spear_pcm: Update to new pcm_new() API
Date: Wed, 10 Apr 2013 15:46:00 -0700
Message-Id: <20130410224333.900008692@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 59d9cc2a5073ab4b8c8f8bdbacf230a538abc55d upstream.

Commit 552d1ef6 ("ASoC: core - Optimise and refactor pcm_new() to pass only
rtd") updated the pcm_new() callback to take the rtd as the only parameter. The
spear PCM driver (which was merged much later) still uses the old API. This
patch updates the driver to the new API.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/spear/spear_pcm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/spear/spear_pcm.c
+++ b/sound/soc/spear/spear_pcm.c
@@ -149,9 +149,9 @@ static void spear_pcm_free(struct snd_pc
 
 static u64 spear_pcm_dmamask = DMA_BIT_MASK(32);
 
-static int spear_pcm_new(struct snd_card *card,
-		struct snd_soc_dai *dai, struct snd_pcm *pcm)
+static int spear_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
+	struct snd_card *card = rtd->card->snd_card;
 	int ret;
 
 	if (!card->dev->dma_mask)
@@ -159,16 +159,16 @@ static int spear_pcm_new(struct snd_card
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


