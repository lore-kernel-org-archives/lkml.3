Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaJKQP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:15:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:1839 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaJKQPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:15:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750282"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] spi/spi-dw-mid.c: use dmaengine_slave_config() API
Date: Sat, 11 Oct 2014 21:10:36 +0530
Message-Id: <1413042040-28222-8-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_slave_config() API instead of
accessing the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/spi/spi-dw-mid.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 6d207af..6c8ad64 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -139,8 +139,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	txconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 	txconf.device_fc = false;
 
-	txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
-				       (unsigned long) &txconf);
+	dmaengine_slave_config(txchan, &txconf);
 
 	memset(&dws->tx_sgl, 0, sizeof(dws->tx_sgl));
 	dws->tx_sgl.dma_address = dws->tx_dma;
@@ -162,8 +161,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	rxconf.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 	rxconf.device_fc = false;
 
-	rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,
-				       (unsigned long) &rxconf);
+	dmaengine_slave_config(txchan, &rxconf);
 
 	memset(&dws->rx_sgl, 0, sizeof(dws->rx_sgl));
 	dws->rx_sgl.dma_address = dws->rx_dma;
-- 
1.7.0.4

