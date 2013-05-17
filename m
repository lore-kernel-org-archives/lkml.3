Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3EQLrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:47:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:40160 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab3EQLrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,691,1363158000"; 
   d="scan'208";a="303942162"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: print message if IO resource is not found
Date: Fri, 17 May 2013 14:47:15 +0300
Message-Id: <1368791235-10242-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() will print a message if resource is not found.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2e5deaa..29990b9 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1667,14 +1667,11 @@ static int dw_probe(struct platform_device *pdev)
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

