Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab3BNJAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:00:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:7422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933417Ab3BNJAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:00:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="290991814"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 6/6] dma: tegra20-apb-dma: remove unnecessary assignment
Date: Thu, 14 Feb 2013 11:00:20 +0200
Message-Id: <1360832420-6349-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to assign 0 to residue, because dma_cookie_status() does this
for us.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 6c14481..c71812f 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -767,7 +767,6 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 
 	ret = dma_cookie_status(dc, cookie, txstate);
 	if (ret == DMA_SUCCESS) {
-		dma_set_residue(txstate, 0);
 		spin_unlock_irqrestore(&tdc->lock, flags);
 		return ret;
 	}
-- 
1.7.10.4

