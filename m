Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaJKQPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:15:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:2815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaJKQPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750265"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] spi/atmel: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:35 +0530
Message-Id: <1413042040-28222-7-git-send-email-vinod.koul@intel.com>
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
 drivers/spi/spi-atmel.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 113c83f..649dcb5 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -482,11 +482,9 @@ error:
 static void atmel_spi_stop_dma(struct atmel_spi *as)
 {
 	if (as->dma.chan_rx)
-		as->dma.chan_rx->device->device_control(as->dma.chan_rx,
-							DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(as->dma.chan_rx);
 	if (as->dma.chan_tx)
-		as->dma.chan_tx->device->device_control(as->dma.chan_tx,
-							DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(as->dma.chan_tx);
 }
 
 static void atmel_spi_release_dma(struct atmel_spi *as)
-- 
1.7.0.4

