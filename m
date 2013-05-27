Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3E0MPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:15:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:60466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3E0MOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="247199731"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org
Subject: [PATCH 09/12] tegra20-apb-dma: remove useless use of lock
Date: Mon, 27 May 2013 15:14:39 +0300
Message-Id: <1369656882-25241-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to dma_cookie_status() description locking is not required.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org
---
 drivers/dma/tegra20-apb-dma.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 33f59ec..019ccfa 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -767,13 +767,11 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	unsigned long flags;
 	unsigned int residual;
 
-	spin_lock_irqsave(&tdc->lock, flags);
-
 	ret = dma_cookie_status(dc, cookie, txstate);
-	if (ret == DMA_SUCCESS) {
-		spin_unlock_irqrestore(&tdc->lock, flags);
+	if (ret == DMA_SUCCESS)
 		return ret;
-	}
+
+	spin_lock_irqsave(&tdc->lock, flags);
 
 	/* Check on wait_ack desc status */
 	list_for_each_entry(dma_desc, &tdc->free_dma_desc, node) {
-- 
1.8.2.rc0.22.gb3600c3

