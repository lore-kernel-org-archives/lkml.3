Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaKQODy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:03:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48958 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752739AbaKQNpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 03/61] dmaengine: Make the destination abbreviation coherent
Date: Mon, 17 Nov 2014 14:41:57 +0100
Message-Id: <1416231775-31252-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/at_xdmac.c                | 2 +-
 drivers/dma/bcm2835-dma.c             | 2 +-
 drivers/dma/edma.c                    | 2 +-
 drivers/dma/fsl-edma.c                | 2 +-
 drivers/dma/nbpfaxi.c                 | 2 +-
 drivers/dma/omap-dma.c                | 2 +-
 drivers/dma/pl330.c                   | 2 +-
 drivers/dma/sirf-dma.c                | 2 +-
 include/linux/dmaengine.h             | 8 ++++----
 sound/soc/soc-generic-dmaengine-pcm.c | 2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 89c43be20a38..bdc193cb82b7 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1219,7 +1219,7 @@ static int at_xdmac_device_slave_caps(struct dma_chan *dchan,
 {
 
 	caps->src_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 918b7b3f766f..3feba6c25836 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -569,7 +569,7 @@ static int bcm2835_dma_device_slave_caps(struct dma_chan *dchan,
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
index a7a36835a233..9d20de73ebae 100644
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
index 6ea1aded7e74..a8aa5b6bb5e2 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1098,7 +1098,7 @@ static int omap_dma_device_slave_caps(struct dma_chan *dchan,
 				      struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = OMAP_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = OMAP_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = OMAP_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 38c961705836..3c9f715cb8d7 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2588,7 +2588,7 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
 	struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = PL330_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = PL330_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = PL330_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = false;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index feb1e8ab8d7b..e0aa759139f3 100644
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

