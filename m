Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3E0MR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:17:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:32011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab3E0MOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="343975683"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 07/12] mpc512x_dma: remove useless use of lock
Date: Mon, 27 May 2013 15:14:37 +0300
Message-Id: <1369656882-25241-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to dma_cookie_status() description locking is not required.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/mpc512x_dma.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 2d95673..2fe4353 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -556,15 +556,7 @@ static enum dma_status
 mpc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	       struct dma_tx_state *txstate)
 {
-	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
-	enum dma_status ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&mchan->lock, flags);
-	ret = dma_cookie_status(chan, cookie, txstate);
-	spin_unlock_irqrestore(&mchan->lock, flags);
-
-	return ret;
+	return dma_cookie_status(chan, cookie, txstate);
 }
 
 /* Prepare descriptor for memory to memory copy */
-- 
1.8.2.rc0.22.gb3600c3

