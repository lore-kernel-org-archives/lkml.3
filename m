Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab3JPRWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:22:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:21380 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761277Ab3JPRWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417850970"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 05/28] dmaengine: cppi41: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:23 +0530
Message-Id: <1381940926-25564-6-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/cppi41.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 167c022..278b305 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -353,7 +353,7 @@ static enum dma_status cppi41_dma_tx_status(struct dma_chan *chan,
 
 	/* lock */
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (txstate && ret == DMA_SUCCESS)
+	if (txstate && ret == DMA_COMPLETE)
 		txstate->residue = c->residue;
 	/* unlock */
 
-- 
1.7.0.4

