Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3A2PHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:07:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:45773 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab3A2PHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,561,1355126400"; 
   d="scan'208";a="196278770"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: apply default dma_mask if needed
Date: Tue, 29 Jan 2013 17:06:24 +0200
Message-Id: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases we got the device without dma_mask configured. We have to apply
the default value to avoid crashes during memory mapping.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index e8d0679..a572a1e 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1673,6 +1673,12 @@ static int dw_probe(struct platform_device *pdev)
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
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

