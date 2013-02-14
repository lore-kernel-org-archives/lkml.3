Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3BNIl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:41:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:5556 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab3BNIl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="256834107"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] dw_dmac: apply default dma_mask if needed
Date: Thu, 14 Feb 2013 10:41:09 +0200
Message-Id: <1360831270-5777-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases we got the device without dma_mask configured. We have to apply
the default value to avoid crashes during memory mapping.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Since v1:
- rebased on top of recent next branch from Vinod
 drivers/dma/dw_dmac.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 6694676..4c83f18 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1661,6 +1661,12 @@ static int dw_probe(struct platform_device *pdev)
 	if (!regs)
 		return -EBUSY;
 
+	/* Apply default dma_mask if needed */
+	if (!pdev->dev.dma_mask) {
+		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	}
+
 	dw_params = dma_read_byaddr(regs, DW_PARAMS);
 	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
 
-- 
1.7.10.4

