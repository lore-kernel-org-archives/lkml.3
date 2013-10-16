Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574Ab3JPRYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:24:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:55772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761481Ab3JPRX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851384"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 25/28] dmaengine: txx9: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:43 +0530
Message-Id: <1381940926-25564-26-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/txx9dmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 71e8e77..c2829b4 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -962,8 +962,8 @@ txx9dmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	enum dma_status ret;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret == DMA_SUCCESS)
-		return DMA_SUCCESS;
+	if (ret == DMA_COMPLETE)
+		return DMA_COMPLETE;
 
 	spin_lock_bh(&dc->lock);
 	txx9dmac_scan_descriptors(dc);
-- 
1.7.0.4

