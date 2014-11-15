Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaKOTyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:54:40 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40174 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbaKOTyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:54:38 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: t7l66xb: prepare/unprepare clocks
Date: Sat, 15 Nov 2014 22:54:28 +0300
Message-Id: <1416081269-28567-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change clk_enable/disable() calls to clk_prepare_enable() and
clk_disable_unrepapre().

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/mfd/t7l66xb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 9e04a74..439d905 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -87,7 +87,7 @@ static int t7l66xb_mmc_enable(struct platform_device *mmc)
 	unsigned long flags;
 	u8 dev_ctl;
 
-	clk_enable(t7l66xb->clk32k);
+	clk_prepare_enable(t7l66xb->clk32k);
 
 	spin_lock_irqsave(&t7l66xb->lock, flags);
 
@@ -118,7 +118,7 @@ static int t7l66xb_mmc_disable(struct platform_device *mmc)
 
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 
-	clk_disable(t7l66xb->clk32k);
+	clk_disable_unprepare(t7l66xb->clk32k);
 
 	return 0;
 }
@@ -285,7 +285,7 @@ static int t7l66xb_suspend(struct platform_device *dev, pm_message_t state)
 
 	if (pdata && pdata->suspend)
 		pdata->suspend(dev);
-	clk_disable(t7l66xb->clk48m);
+	clk_disable_unprepare(t7l66xb->clk48m);
 
 	return 0;
 }
@@ -295,7 +295,7 @@ static int t7l66xb_resume(struct platform_device *dev)
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
 	struct t7l66xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 
-	clk_enable(t7l66xb->clk48m);
+	clk_prepare_enable(t7l66xb->clk48m);
 	if (pdata && pdata->resume)
 		pdata->resume(dev);
 
@@ -369,7 +369,7 @@ static int t7l66xb_probe(struct platform_device *dev)
 		goto err_ioremap;
 	}
 
-	clk_enable(t7l66xb->clk48m);
+	clk_prepare_enable(t7l66xb->clk48m);
 
 	if (pdata && pdata->enable)
 		pdata->enable(dev);
@@ -414,9 +414,9 @@ static int t7l66xb_remove(struct platform_device *dev)
 	int ret;
 
 	ret = pdata->disable(dev);
-	clk_disable(t7l66xb->clk48m);
+	clk_disable_unprepare(t7l66xb->clk48m);
 	clk_put(t7l66xb->clk48m);
-	clk_disable(t7l66xb->clk32k);
+	clk_disable_unprepare(t7l66xb->clk32k);
 	clk_put(t7l66xb->clk32k);
 	t7l66xb_detach_irq(dev);
 	iounmap(t7l66xb->scr);
-- 
2.1.1

