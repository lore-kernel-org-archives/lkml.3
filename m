Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3E0MRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:17:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:14005 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab3E0MOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="340798910"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 08/12] pch_dma: remove useless use of lock
Date: Mon, 27 May 2013 15:14:38 +0300
Message-Id: <1369656882-25241-9-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to dma_cookie_status() description locking is not required.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/pch_dma.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index ce3dc3e..237f1d5 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -564,14 +564,7 @@ static void pd_free_chan_resources(struct dma_chan *chan)
 static enum dma_status pd_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 				    struct dma_tx_state *txstate)
 {
-	struct pch_dma_chan *pd_chan = to_pd_chan(chan);
-	enum dma_status ret;
-
-	spin_lock_irq(&pd_chan->lock);
-	ret = dma_cookie_status(chan, cookie, txstate);
-	spin_unlock_irq(&pd_chan->lock);
-
-	return ret;
+	return dma_cookie_status(chan, cookie, txstate);
 }
 
 static void pd_issue_pending(struct dma_chan *chan)
-- 
1.8.2.rc0.22.gb3600c3

