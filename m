Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3GOME5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:04:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:10362 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab3GOMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:04:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="331525545"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/6] dma: dw: return DMA_SUCCESS immediately from device_tx_status()
Date: Mon, 15 Jul 2013 15:04:40 +0300
Message-Id: <1373889881-21075-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point to go throught the rest of the function if first call to
dma_cookie_status() returned DMA_SUCCESS.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index f70c6b4..22fc7b3 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -1098,12 +1098,12 @@ dwc_tx_status(struct dma_chan *chan,
 	enum dma_status		ret;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret != DMA_SUCCESS) {
-		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+	if (ret == DMA_SUCCESS)
+		return ret;
 
-		ret = dma_cookie_status(chan, cookie, txstate);
-	}
+	dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
 
+	ret = dma_cookie_status(chan, cookie, txstate);
 	if (ret != DMA_SUCCESS)
 		dma_set_residue(txstate, dwc_get_residue(dwc));
 
-- 
1.8.3.2

