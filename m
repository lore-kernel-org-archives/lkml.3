Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaJKQPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:15:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:2815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaJKQPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:15:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750256"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] net: ks8842: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:34 +0530
Message-Id: <1413042040-28222-6-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_terminate_all() API instead of
accessing the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/net/ethernet/micrel/ks8842.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 822616e..0c33b92 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -875,13 +875,11 @@ static void ks8842_stop_dma(struct ks8842_adapter *adapter)
 
 	tx_ctl->adesc = NULL;
 	if (tx_ctl->chan)
-		tx_ctl->chan->device->device_control(tx_ctl->chan,
-			DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(tx_ctl->chan);
 
 	rx_ctl->adesc = NULL;
 	if (rx_ctl->chan)
-		rx_ctl->chan->device->device_control(rx_ctl->chan,
-			DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(rx_ctl->chan);
 
 	if (sg_dma_address(&rx_ctl->sg))
 		dma_unmap_single(adapter->dev, sg_dma_address(&rx_ctl->sg),
-- 
1.7.0.4

