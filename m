Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3E0MOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:14:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:12933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3E0MOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="343975688"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 05/12] fsldma: remove useless use of lock
Date: Mon, 27 May 2013 15:14:35 +0300
Message-Id: <1369656882-25241-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to dma_cookie_status() description locking is not required.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Zhang Wei <zw@zh-kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/dma/fsldma.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 49e8fbd..b3f3e90 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -979,15 +979,7 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 					dma_cookie_t cookie,
 					struct dma_tx_state *txstate)
 {
-	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	enum dma_status ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
-	ret = dma_cookie_status(dchan, cookie, txstate);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
-
-	return ret;
+	return dma_cookie_status(dchan, cookie, txstate);
 }
 
 /*----------------------------------------------------------------------------*/
-- 
1.8.2.rc0.22.gb3600c3

