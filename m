Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaJKQPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:15:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:2435 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaJKQPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750214"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] mtd: sh_flctl: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:33 +0530
Message-Id: <1413042040-28222-5-git-send-email-vinod.koul@intel.com>
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
 drivers/mtd/nand/sh_flctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index c067023..0ed7c60 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -395,7 +395,7 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 				msecs_to_jiffies(3000));
 
 	if (ret <= 0) {
-		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(chan);
 		dev_err(&flctl->pdev->dev, "wait_for_completion_timeout\n");
 	}
 
-- 
1.7.0.4

