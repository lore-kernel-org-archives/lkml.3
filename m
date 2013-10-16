Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467Ab3JPRXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:53135 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202Ab3JPRXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851315"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: [PATCH 16/28] dmaengine: mmp_tdma: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:34 +0530
Message-Id: <1381940926-25564-17-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Zhangfei Gao <zhangfei.gao@gmail.com>
---
 drivers/dma/mmp_tdma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 8f3e865..2b4026d 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -163,7 +163,7 @@ static void mmp_tdma_disable_chan(struct mmp_tdma_chan *tdmac)
 	/* disable irq */
 	writel(0, tdmac->reg_base + TDIMR);
 
-	tdmac->status = DMA_SUCCESS;
+	tdmac->status = DMA_COMPLETE;
 }
 
 static void mmp_tdma_resume_chan(struct mmp_tdma_chan *tdmac)
@@ -398,7 +398,7 @@ static struct dma_async_tx_descriptor *mmp_tdma_prep_dma_cyclic(
 	int num_periods = buf_len / period_len;
 	int i = 0, buf = 0;
 
-	if (tdmac->status != DMA_SUCCESS)
+	if (tdmac->status != DMA_COMPLETE)
 		return NULL;
 
 	if (period_len > TDMA_MAX_XFER_BYTES) {
@@ -532,7 +532,7 @@ static int mmp_tdma_chan_init(struct mmp_tdma_device *tdev,
 	tdmac->idx	   = idx;
 	tdmac->type	   = type;
 	tdmac->reg_base	   = (unsigned long)tdev->base + idx * 4;
-	tdmac->status = DMA_SUCCESS;
+	tdmac->status = DMA_COMPLETE;
 	tdev->tdmac[tdmac->idx] = tdmac;
 	tasklet_init(&tdmac->tasklet, dma_do_tasklet, (unsigned long)tdmac);
 
-- 
1.7.0.4

