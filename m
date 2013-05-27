Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3E0MR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:17:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:21067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab3E0MOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="320182127"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 04/12] ep93xx_dma: remove useless use of lock
Date: Mon, 27 May 2013 15:14:34 +0300
Message-Id: <1369656882-25241-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to dma_cookie_status() description locking is not required.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/ep93xx_dma.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index f2bf8c0..591cd8c 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -1313,15 +1313,7 @@ static enum dma_status ep93xx_dma_tx_status(struct dma_chan *chan,
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *state)
 {
-	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
-	enum dma_status ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&edmac->lock, flags);
-	ret = dma_cookie_status(chan, cookie, state);
-	spin_unlock_irqrestore(&edmac->lock, flags);
-
-	return ret;
+	return dma_cookie_status(chan, cookie, state);
 }
 
 /**
-- 
1.8.2.rc0.22.gb3600c3

