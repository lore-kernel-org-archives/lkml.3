Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3BLK7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:59:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:3410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab3BLK7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:59:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="201419211"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/6] dma: tegra20-apb-dma: remove unnecessary assignment
Date: Tue, 12 Feb 2013 12:58:39 +0200
Message-Id: <1360666720-19006-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to assign 0 to residue, because dma_cookie_status() does this
for us.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/tegra20-apb-dma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 46e4630..fcee27e 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -769,7 +769,6 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 
 	ret = dma_cookie_status(dc, cookie, txstate);
 	if (ret == DMA_SUCCESS) {
-		dma_set_residue(txstate, 0);
 		spin_unlock_irqrestore(&tdc->lock, flags);
 		return ret;
 	}
-- 
1.7.10.4

