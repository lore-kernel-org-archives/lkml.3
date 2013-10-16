Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369Ab3JPRWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:22:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:32753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761142Ab3JPRWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851246"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/28] dmaengine: dw: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:26 +0530
Message-Id: <1381940926-25564-9-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 89eb89f..2c29331 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -1098,13 +1098,13 @@ dwc_tx_status(struct dma_chan *chan,
 	enum dma_status		ret;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret == DMA_SUCCESS)
+	if (ret == DMA_COMPLETE)
 		return ret;
 
 	dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret != DMA_SUCCESS)
+	if (ret != DMA_COMPLETE)
 		dma_set_residue(txstate, dwc_get_residue(dwc));
 
 	if (dwc->paused && ret == DMA_IN_PROGRESS)
-- 
1.7.0.4

