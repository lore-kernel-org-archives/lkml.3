Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaKFIw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:52:57 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61374 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaKFIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:52:56 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: tc6393xb: prepare/unprepare clocks
Date: Thu,  6 Nov 2014 11:52:38 +0300
Message-Id: <1415263958-16644-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change clk_enable/disable() calls to clk_prepare_enable() and
clk_disable_unrepapre().

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/mfd/tc6393xb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 48579e5..abcb4eb 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -665,7 +665,7 @@ static int tc6393xb_probe(struct platform_device *dev)
 		goto err_ioremap;
 	}
 
-	ret = clk_enable(tc6393xb->clk);
+	ret = clk_prepare_enable(tc6393xb->clk);
 	if (ret)
 		goto err_clk_enable;
 
@@ -728,7 +728,7 @@ err_gpio_add:
 		temp = gpiochip_remove(&tc6393xb->gpio);
 	tcpd->disable(dev);
 err_enable:
-	clk_disable(tc6393xb->clk);
+	clk_disable_unprepare(tc6393xb->clk);
 err_clk_enable:
 	iounmap(tc6393xb->scr);
 err_ioremap:
@@ -764,7 +764,7 @@ static int tc6393xb_remove(struct platform_device *dev)
 	}
 
 	ret = tcpd->disable(dev);
-	clk_disable(tc6393xb->clk);
+	clk_disable_unprepare(tc6393xb->clk);
 	iounmap(tc6393xb->scr);
 	release_resource(&tc6393xb->rscr);
 	clk_put(tc6393xb->clk);
@@ -792,7 +792,7 @@ static int tc6393xb_suspend(struct platform_device *dev, pm_message_t state)
 			ioread8(tc6393xb->scr + SCR_GPI_BCR(i));
 	}
 	ret = tcpd->suspend(dev);
-	clk_disable(tc6393xb->clk);
+	clk_disable_unprepare(tc6393xb->clk);
 
 	return ret;
 }
@@ -804,7 +804,7 @@ static int tc6393xb_resume(struct platform_device *dev)
 	int ret;
 	int i;
 
-	clk_enable(tc6393xb->clk);
+	clk_prepare_enable(tc6393xb->clk);
 
 	ret = tcpd->resume(dev);
 	if (ret)
-- 
2.1.1

