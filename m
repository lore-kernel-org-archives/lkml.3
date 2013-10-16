Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336Ab3JPR2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:28:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:32753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357Ab3JPRWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851259"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 09/28] dmaengine: edma: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:27 +0530
Message-Id: <1381940926-25564-10-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 098a8da..29fa358 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -576,7 +576,7 @@ static enum dma_status edma_tx_status(struct dma_chan *chan,
 	unsigned long flags;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret == DMA_SUCCESS || !txstate)
+	if (ret == DMA_COMPLETE || !txstate)
 		return ret;
 
 	spin_lock_irqsave(&echan->vchan.lock, flags);
-- 
1.7.0.4

