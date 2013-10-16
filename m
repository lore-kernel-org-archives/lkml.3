Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435Ab3JPR3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:29:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:21380 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761278Ab3JPRWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417850999"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 06/28] dmaengine: jz4740: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:24 +0530
Message-Id: <1381940926-25564-7-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/dma-jz4740.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index b0c0c82..94c380f 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -491,7 +491,7 @@ static enum dma_status jz4740_dma_tx_status(struct dma_chan *c,
 	unsigned long flags;
 
 	status = dma_cookie_status(c, cookie, state);
-	if (status == DMA_SUCCESS || !state)
+	if (status == DMA_COMPLETE || !state)
 		return status;
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);
-- 
1.7.0.4

