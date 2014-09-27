Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaI0Izf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:55:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38657 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbaI0Izc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:55:32 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/9] dmaengine: Make the destination abbreviation coherent
Date: Sat, 27 Sep 2014 10:54:37 +0200
Message-Id: <1411808085-27792-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmaengine header abbreviates destination as at least two different strings.
Make a coherent use of a single one.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/bcm2835-dma.c |  2 +-
 drivers/dma/edma.c        |  2 +-
 drivers/dma/fsl-edma.c    |  2 +-
 drivers/dma/omap-dma.c    |  2 +-
 drivers/dma/pl330.c       |  2 +-
 drivers/dma/sirf-dma.c    |  2 +-
 include/linux/dmaengine.h | 12 ++++++------
 7 files changed, 12 insertions(+), 12 deletions(-)

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
index 7b65633f495e..b3d641881d9d 100644
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
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 4cf7d9a950d7..51dee6636a37 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1095,7 +1095,7 @@ static int omap_dma_device_slave_caps(struct dma_chan *dchan,
 				      struct dma_slave_caps *caps)
 {
 	caps->src_addr_widths = OMAP_DMA_BUSWIDTHS;
-	caps->dstn_addr_widths = OMAP_DMA_BUSWIDTHS;
+	caps->dst_addr_widths = OMAP_DMA_BUSWIDTHS;
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index d5149aacd2fe..8904891ed5d5 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2583,7 +2583,7 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
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
index 1f9e642c66ad..f4b71ce1a0a6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -388,7 +388,7 @@ enum dma_residue_granularity {
 /* struct dma_slave_caps - expose capabilities of a slave channel only
  *
  * @src_addr_widths: bit mask of src addr widths the channel supports
- * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
+ * @dst_addr_widths: bit mask of dstn addr widths the channel supports
  * @directions: bit mask of slave direction the channel supported
  * 	since the enum dma_transfer_direction is not defined as bits for each
  * 	type of direction, the dma controller should fill (1 << <TYPE>) and same
@@ -399,7 +399,7 @@ enum dma_residue_granularity {
  */
 struct dma_slave_caps {
 	u32 src_addr_widths;
-	u32 dstn_addr_widths;
+	u32 dst_addr_widths;
 	u32 directions;
 	bool cmd_pause;
 	bool cmd_terminate;
@@ -639,10 +639,10 @@ struct dma_device {
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
@@ -935,11 +935,11 @@ async_dma_find_channel(enum dma_transaction_type type)
 #endif /* CONFIG_ASYNC_TX_DMA */
 
 dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
-	void *dest, void *src, size_t len);
+	void *dst, void *src, size_t len);
 dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
 	struct page *page, unsigned int offset, void *kdata, size_t len);
 dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
-	struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
+	struct page *dst_pg, unsigned int dst_off, struct page *src_pg,
 	unsigned int src_off, size_t len);
 void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan);
-- 
2.1.0

