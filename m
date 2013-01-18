Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3ARPLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:11:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:20906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3ARPLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:11:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,493,1355126400"; 
   d="scan'208";a="275509719"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: print out DW_PARAMS and DWC_PARAMS when debug
Date: Fri, 18 Jan 2013 17:10:59 +0200
Message-Id: <1358521859-28258-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's usefull to have the values of the DW_PARAMS and DWC_PARAMS printed when
debug mode is enabled.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1498b27..72e6316 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1610,6 +1610,8 @@ static int dw_probe(struct platform_device *pdev)
 	dw_params = dma_read_byaddr(regs, DW_PARAMS);
 	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
 
+	dev_dbg(&pdev->dev, "DW_PARAMS: 0x%08x\n", dw_params);
+
 	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata)
 		pdata = dw_dma_parse_dt(pdev);
@@ -1723,6 +1725,9 @@ static int dw_probe(struct platform_device *pdev)
 			dwc_params = dma_read_byaddr(regs + r * sizeof(u32),
 						     DWC_PARAMS);
 
+			dev_dbg(&pdev->dev, "DWC_PARAMS[%d]: 0x%08x\n", i,
+					    dwc_params);
+
 			/* Decode maximum block size for given channel. The
 			 * stored 4 bit value represents blocks from 0x00 for 3
 			 * up to 0x0a for 4095. */
-- 
1.7.10.4

