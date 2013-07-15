Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab3GOME7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:04:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:36816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab3GOME4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:04:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="345768982"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/6] dma: dw: return DMA_PAUSED only if cookie status is DMA_IN_PROGRESS
Date: Mon, 15 Jul 2013 15:04:41 +0300
Message-Id: <1373889881-21075-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To obey a usual practice let's return DMA_PAUSED status only if
dma_cookie_status returned DMA_IN_PROGRESS.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 22fc7b3..062b3be 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -1107,7 +1107,7 @@ dwc_tx_status(struct dma_chan *chan,
 	if (ret != DMA_SUCCESS)
 		dma_set_residue(txstate, dwc_get_residue(dwc));
 
-	if (dwc->paused)
+	if (dwc->paused && ret == DMA_IN_PROGRESS)
 		return DMA_PAUSED;
 
 	return ret;
-- 
1.8.3.2

