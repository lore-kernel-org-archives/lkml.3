Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaJVQNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:13:51 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53916 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753579AbaJVPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Barry Song <baohua@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-rpi-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Subject: [PATCH v3 03/59] dmaengine: Make the destination abbreviation coherent
Date: Wed, 22 Oct 2014 17:43:17 +0200
Message-Id: <1413992653-21963-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmaengine header abbreviates destination as at least two different strings.
Make a coherent use of a single one.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/dma/bcm2835-dma.c             | 2 +-
 drivers/dma/edma.c                    | 2 +-
 drivers/dma/fsl-edma.c                | 2 +-
 drivers/dma/nbpfaxi.c                 | 2 +-
 drivers/dma/omap-dma.c                | 2 +-
 drivers/dma/pl330.c                   | 2 +-
 drivers/dma/sirf-dma.c                | 2 +-
 include/linux/dmaengine.h             | 8 ++++----
 sound/soc/soc-generic-dmaengine-pcm.c | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 68007974961a..8a6a9c27fe83 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -571,7 +571,7 @@ static int bcm2835_dma_device_slave_caps(struct dma_chan *dchan,
 	struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
-	caps->dstn_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	caps->dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = false;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 123f578d6dd3..790054eef76c 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -998,7 +998,7 @@ static int edma_dma_device_slave_caps(struct dma_chan *dchan,
 				      struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = EDMA_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = EDMA_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = EDMA_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index 3c5711d5fe97..13df85a16438 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -781,7 +781,7 @@ static int fsl_dma_device_slave_caps(struct dma_chan *dchan,
 		struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = FSL_EDMA_BUSWIDTHS;
-	caps->dstn_addr_widths = FSL_EDMA_BUSWIDTHS;
+	caps->dst_addr_widths = FSL_EDMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 5aeada56a442..b4a61ccbb443 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1076,7 +1076,7 @@ static int nbpf_slave_caps(struct dma_chan *dchan,
 			   struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = NBPF_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = NBPF_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = NBPF_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = false;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index bbea8243f9e8..8035b8c33cfd 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1100,7 +1100,7 @@ static int omap_dma_device_slave_caps(struct dma_chan *dchan,
 				      struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = OMAP_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = OMAP_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = OMAP_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4839bfa74a10..b563bfa6cc4d 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2576,7 +2576,7 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
 	struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = PL330_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = PL330_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = PL330_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = false;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index aac03ab10c54..149d7fddfa75 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -652,7 +652,7 @@ static int sirfsoc_dma_device_slave_caps(struct dma_chan *dchan,
 	struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 653a1fd07ae8..4d912575fec0 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -387,7 +387,7 @@ enum dma_residue_granularity {
 /* struct dma_slave_caps - expose capabilities of a slave channel only
  *
  * @src_addr_widths: bit mask of src addr widths the channel supports
- * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
+ * @dst_addr_widths: bit mask of dstn addr widths the channel supports
  * @directions: bit mask of slave direction the channel supported
  * 	since the enum dma_transfer_direction is not defined as bits for each
  * 	type of direction, the dma controller should fill (1 << <TYPE>) and same
@@ -398,7 +398,7 @@ enum dma_residue_granularity {
  */
 struct dma_slave_caps {
 	u32 src_addr_widths;
-	u32 dstn_addr_widths;
+	u32 dst_addr_widths;
 	u32 directions;
 	bool cmd_pause;
 	bool cmd_terminate;
@@ -638,10 +638,10 @@ struct dma_device {
 	void (*device_free_chan_resources)(struct dma_chan *chan);
 
 	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy)(
-		struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 		size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
-		struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
+		struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 		unsigned int src_cnt, size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor_val)(
 		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index b329b84bc5af..851f7afcd5dc 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -151,7 +151,7 @@ static int dmaengine_pcm_set_runtime_hwparams(struct snd_pcm_substream *substrea
 			hw.info |= SNDRV_PCM_INFO_BATCH;
 
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			addr_widths = dma_caps.dstn_addr_widths;
+			addr_widths = dma_caps.dst_addr_widths;
 		else
 			addr_widths = dma_caps.src_addr_widths;
 	}
-- 
2.1.1

