Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3CVOnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:43:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:38743 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571Ab3CVOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,892,1355126400"; 
   d="scan'208";a="274620703"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/4] dw_dmac: fix style of the comments
Date: Fri, 22 Mar 2013 16:43:18 +0200
Message-Id: <1363963401-7924-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use capital letter as a first one in the comments.
There is no functional changes.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 43e2e89..d6dbb14 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -173,7 +173,7 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 		return;
 
 	if (dws && dws->cfg_hi == ~0 && dws->cfg_lo == ~0) {
-		/* autoconfigure based on request line from DT */
+		/* Autoconfigure based on request line from DT */
 		if (dwc->direction == DMA_MEM_TO_DEV)
 			cfghi = DWC_CFGH_DST_PER(dwc->request_line);
 		else if (dwc->direction == DMA_DEV_TO_MEM)
@@ -473,16 +473,16 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 			(unsigned long long)llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
-		/* initial residue value */
+		/* Initial residue value */
 		dwc->residue = desc->total_len;
 
-		/* check first descriptors addr */
+		/* Check first descriptors addr */
 		if (desc->txd.phys == llp) {
 			spin_unlock_irqrestore(&dwc->lock, flags);
 			return;
 		}
 
-		/* check first descriptors llp */
+		/* Check first descriptors llp */
 		if (desc->lli.llp == llp) {
 			/* This one is currently in progress */
 			dwc->residue -= dwc_get_sent(dwc);
@@ -588,7 +588,7 @@ inline dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan)
 }
 EXPORT_SYMBOL(dw_dma_get_dst_addr);
 
-/* called with dwc->lock held and all DMAC interrupts disabled */
+/* Called with dwc->lock held and all DMAC interrupts disabled */
 static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 		u32 status_err, u32 status_xfer)
 {
@@ -626,7 +626,7 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 
 		dwc_chan_disable(dw, dwc);
 
-		/* make sure DMA does not restart by loading a new list */
+		/* Make sure DMA does not restart by loading a new list */
 		channel_writel(dwc, LLP, 0);
 		channel_writel(dwc, CTL_LO, 0);
 		channel_writel(dwc, CTL_HI, 0);
@@ -1256,7 +1256,7 @@ static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
 	struct dw_dma_filter_args *fargs = param;
 	struct dw_dma_slave *dws = &dwc->slave;
 
-	/* ensure the device matches our channel */
+	/* Ensure the device matches our channel */
         if (chan->device != &fargs->dw->dma)
                 return false;
 
@@ -1323,7 +1323,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-	/* assert channel is idle */
+	/* Assert channel is idle */
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
 		dev_err(chan2dev(&dwc->chan),
 			"BUG: Attempted to start non-idle channel\n");
@@ -1335,7 +1335,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
 
-	/* setup DMAC channel registers */
+	/* Setup DMAC channel registers */
 	channel_writel(dwc, LLP, dwc->cdesc->desc[0]->txd.phys);
 	channel_writel(dwc, CTL_LO, DWC_CTLL_LLP_D_EN | DWC_CTLL_LLP_S_EN);
 	channel_writel(dwc, CTL_HI, 0);
@@ -1502,7 +1502,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		last = desc;
 	}
 
-	/* lets make a cyclic list */
+	/* Let's make a cyclic list */
 	last->lli.llp = cdesc->desc[0]->txd.phys;
 
 	dev_dbg(chan2dev(&dwc->chan), "cyclic prepared buf 0x%llx len %zu "
@@ -1707,7 +1707,7 @@ static int dw_probe(struct platform_device *pdev)
 
 	dw->regs = regs;
 
-	/* get hardware configuration parameters */
+	/* Get hardware configuration parameters */
 	if (autocfg) {
 		max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
 
@@ -1729,10 +1729,10 @@ static int dw_probe(struct platform_device *pdev)
 	/* Calculate all channel mask before DMA setup */
 	dw->all_chan_mask = (1 << nr_channels) - 1;
 
-	/* force dma off, just in case */
+	/* Force dma off, just in case */
 	dw_dma_off(dw);
 
-	/* disable BLOCK interrupts as well */
+	/* Disable BLOCK interrupts as well */
 	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 
 	err = devm_request_irq(&pdev->dev, irq, dw_dma_interrupt, 0,
@@ -1742,7 +1742,7 @@ static int dw_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dw);
 
-	/* create a pool of consistent memory blocks for hardware descriptors */
+	/* Create a pool of consistent memory blocks for hardware descriptors */
 	dw->desc_pool = dmam_pool_create("dw_dmac_desc_pool", &pdev->dev,
 					 sizeof(struct dw_desc), 4, 0);
 	if (!dw->desc_pool) {
@@ -1783,7 +1783,7 @@ static int dw_probe(struct platform_device *pdev)
 
 		dwc->direction = DMA_TRANS_NONE;
 
-		/* hardware configuration */
+		/* Hardware configuration */
 		if (autocfg) {
 			unsigned int dwc_params;
 
-- 
1.8.2.rc0.22.gb3600c3

