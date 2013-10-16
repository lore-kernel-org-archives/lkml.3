Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578Ab3JPRZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:25:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:60715 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761447Ab3JPRXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851356"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 23/28] dmaengine: ste: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:41 +0530
Message-Id: <1381940926-25564-24-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3d5e4ee..b8c031b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2627,7 +2627,7 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 	}
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret != DMA_SUCCESS)
+	if (ret != DMA_COMPLETE)
 		dma_set_residue(txstate, stedma40_residue(chan));
 
 	if (d40_is_paused(d40c))
-- 
1.7.0.4

