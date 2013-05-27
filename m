Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3E0MOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:14:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:60466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab3E0MOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="308456468"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 02/12] mxs-dma: remove useless variable
Date: Mon, 27 May 2013 15:14:32 +0300
Message-Id: <1369656882-25241-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

last_used variable is applied only once, so, let's substitute it by its value.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/mxs-dma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b48a79c..b3a6379 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -622,10 +622,8 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
 			dma_cookie_t cookie, struct dma_tx_state *txstate)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
-	dma_cookie_t last_used;
 
-	last_used = chan->cookie;
-	dma_set_tx_state(txstate, chan->completed_cookie, last_used, 0);
+	dma_set_tx_state(txstate, chan->completed_cookie, chan->cookie, 0);
 
 	return mxs_chan->status;
 }
-- 
1.8.2.rc0.22.gb3600c3

