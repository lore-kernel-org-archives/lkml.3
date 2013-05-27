Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3E0MPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:15:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:61119 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab3E0MOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="308456492"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 10/12] ipu_idmac: re-use dma_cookie_status()
Date: Mon, 27 May 2013 15:14:40 +0300
Message-Id: <1369656882-25241-11-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to use generic dma_cookie_status() that allows user to get standard
possible return codes independently of the DMAC driver in charge.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/ipu/ipu_idmac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index d39c2cd..608d4a2 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1593,10 +1593,7 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 static enum dma_status idmac_tx_status(struct dma_chan *chan,
 		       dma_cookie_t cookie, struct dma_tx_state *txstate)
 {
-	dma_set_tx_state(txstate, chan->completed_cookie, chan->cookie, 0);
-	if (cookie != chan->cookie)
-		return DMA_ERROR;
-	return DMA_SUCCESS;
+	return dma_cookie_status(chan, cookie, txstate);
 }
 
 static int __init ipu_idmac_init(struct ipu *ipu)
-- 
1.8.2.rc0.22.gb3600c3

