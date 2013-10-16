Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab3JPRX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:53135 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761115Ab3JPRXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851308"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 15/28] dmaengine: k3dma: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:33 +0530
Message-Id: <1381940926-25564-16-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/dma/k3dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index da43062..e260754 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -344,7 +344,7 @@ static enum dma_status k3_dma_tx_status(struct dma_chan *chan,
 	size_t bytes = 0;
 
 	ret = dma_cookie_status(&c->vc.chan, cookie, state);
-	if (ret == DMA_SUCCESS)
+	if (ret == DMA_COMPLETE)
 		return ret;
 
 	spin_lock_irqsave(&c->vc.lock, flags);
-- 
1.7.0.4

