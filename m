Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaJKQPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:15:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:48584 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaJKQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750183"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] mtd: fsmc_nand: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:32 +0530
Message-Id: <1413042040-28222-4-git-send-email-vinod.koul@intel.com>
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
 drivers/mtd/nand/fsmc_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 1550692..7a91587 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -605,7 +605,7 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	wait_for_completion_timeout(&host->dma_access_complete,
 				msecs_to_jiffies(3000));
 	if (ret <= 0) {
-		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(chan);
 		dev_err(host->dev, "wait_for_completion_timeout\n");
 		if (!ret)
 			ret = -ETIMEDOUT;
-- 
1.7.0.4

