Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3E0MR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:17:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:60466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab3E0MOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="308456481"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 06/12] mmp_pdma: remove useless use of lock
Date: Mon, 27 May 2013 15:14:36 +0300
Message-Id: <1369656882-25241-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to dma_cookie_status() description locking is not required.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/mmp_pdma.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c26699f..ad4b0a7 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -632,15 +632,7 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
 static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
 			dma_cookie_t cookie, struct dma_tx_state *txstate)
 {
-	struct mmp_pdma_chan *chan = to_mmp_pdma_chan(dchan);
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
 
 /**
-- 
1.8.2.rc0.22.gb3600c3

