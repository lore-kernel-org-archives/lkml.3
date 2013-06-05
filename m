Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3FEM04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:26:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:25804 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab3FEM0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,806,1363158000"; 
   d="scan'208";a="250953565"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/4] dw_dmac: don't check resource with devm_ioremap_resource
Date: Wed,  5 Jun 2013 15:26:43 +0300
Message-Id: <1370435206-13474-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/dma/dw_dmac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 724083d..2b65ba6 100644
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

