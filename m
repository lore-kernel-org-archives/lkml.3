Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498Ab3JPRX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:64778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761446Ab3JPRXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851320"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 18/28] dmaengine: mxs-dma: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:36 +0530
Message-Id: <1381940926-25564-19-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/mxs-dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index ccd13df..7ab7cec 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -224,7 +224,7 @@ static void mxs_dma_enable_chan(struct mxs_dma_chan *mxs_chan)
 
 static void mxs_dma_disable_chan(struct mxs_dma_chan *mxs_chan)
 {
-	mxs_chan->status = DMA_SUCCESS;
+	mxs_chan->status = DMA_COMPLETE;
 }
 
 static void mxs_dma_pause_chan(struct mxs_dma_chan *mxs_chan)
@@ -312,12 +312,12 @@ static irqreturn_t mxs_dma_int_handler(int irq, void *dev_id)
 			if (mxs_chan->flags & MXS_DMA_SG_LOOP)
 				mxs_chan->status = DMA_IN_PROGRESS;
 			else
-				mxs_chan->status = DMA_SUCCESS;
+				mxs_chan->status = DMA_COMPLETE;
 		}
 
 		stat1 &= ~(1 << channel);
 
-		if (mxs_chan->status == DMA_SUCCESS)
+		if (mxs_chan->status == DMA_COMPLETE)
 			dma_cookie_complete(&mxs_chan->desc);
 
 		/* schedule tasklet on this channel */
-- 
1.7.0.4

