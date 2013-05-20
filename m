Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3ETHsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:48:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:42813 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3ETHsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,706,1363158000"; 
   d="scan'208";a="244017252"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] dw_dmac: don't check resource with devm_ioremap_resource
Date: Mon, 20 May 2013 10:47:56 +0300
Message-Id: <1369036076-26660-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Since v1:
 - fix commit message to be along with other similar patches
 drivers/dma/dw_dmac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 89b655e..6dc6866 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1670,14 +1670,11 @@ static int dw_probe(struct platform_device *pdev)
 	int			err;
 	int			i;
 
-	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!io)
-		return -EINVAL;
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
 
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(&pdev->dev, io);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
-- 
1.8.2.rc0.22.gb3600c3

