Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3KOJ5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:57:18 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:35217 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3KOJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:57:10 -0500
MIME-Version: 1.0
Date: Fri, 15 Nov 2013 17:57:09 +0800
Message-ID: <CAPgLHd_MgPJvMmijLXk2YERqy1BkG8jr6PZtiVjuSXcPmebuMQ@mail.gmail.com>
Subject: [PATCH] dma: k3dma: add missing clk_disable_unprepare() on error in k3_dma_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing clk_disable_unprepare() before return
from k3_dma_probe() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/k3dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index a2c330f..892704f 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -750,7 +750,7 @@ static int k3_dma_probe(struct platform_device *op)
 
 	ret = dma_async_device_register(&d->slave);
 	if (ret)
-		return ret;
+		goto dma_async_register_fail;
 
 	ret = of_dma_controller_register((&op->dev)->of_node,
 					k3_of_dma_simple_xlate, d);
@@ -767,6 +767,8 @@ static int k3_dma_probe(struct platform_device *op)
 
 of_dma_register_fail:
 	dma_async_device_unregister(&d->slave);
+dma_async_register_fail:
+	clk_disable_unprepare(d->clk);
 	return ret;
 }
 

