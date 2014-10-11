Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaJKQOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:14:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:2781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaJKQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750147"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] dmaengine: coh901318: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:30 +0530
Message-Id: <1413042040-28222-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_terminate_all() API instead of accessing
the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/coh901318.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 3c6716e..e88588d 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -2156,7 +2156,7 @@ coh901318_free_chan_resources(struct dma_chan *chan)
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(chan);
 }
 
 
-- 
1.7.0.4

