Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaEHTcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:32:50 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62118 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbaEHTct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:32:49 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: linux-kernel@vger.kernel.org, berthe.ab@gmail.com
Subject: [PATCH 809/809] drivers: bus: omap_l3: replacing kzalloc with devm_kzalloc This replace kzalloc with devm_kzalloc and remove kfree
Date: Thu,  8 May 2014 21:32:38 +0200
Message-Id: <1399577558-13568-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/bus/omap_l3_noc.c | 11 +++--------
 drivers/bus/omap_l3_smx.c | 11 +++--------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae..d25d727 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -134,7 +134,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	struct resource	*res;
 	int ret;
 
-	l3 = kzalloc(sizeof(*l3), GFP_KERNEL);
+	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
 	if (!l3)
 		return -ENOMEM;
 
@@ -142,15 +142,13 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "couldn't find resource 0\n");
-		ret = -ENODEV;
-		goto err0;
+		return -ENODEV;
 	}
 
 	l3->l3_base[0] = ioremap(res->start, resource_size(res));
 	if (!l3->l3_base[0]) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -214,8 +212,6 @@ err2:
 	iounmap(l3->l3_base[1]);
 err1:
 	iounmap(l3->l3_base[0]);
-err0:
-	kfree(l3);
 	return ret;
 }
 
@@ -228,7 +224,6 @@ static int omap4_l3_remove(struct platform_device *pdev)
 	iounmap(l3->l3_base[0]);
 	iounmap(l3->l3_base[1]);
 	iounmap(l3->l3_base[2]);
-	kfree(l3);
 
 	return 0;
 }
diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc2164..e062aba 100644
--- a/drivers/bus/omap_l3_smx.c
+++ b/drivers/bus/omap_l3_smx.c
@@ -217,7 +217,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	l3 = kzalloc(sizeof(*l3), GFP_KERNEL);
+	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
 	if (!l3)
 		return -ENOMEM;
 
@@ -226,14 +226,12 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "couldn't find resource\n");
-		ret = -ENODEV;
-		goto err0;
+		return -ENODEV;
 	}
 	l3->rt = ioremap(res->start, resource_size(res));
 	if (!l3->rt) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	l3->debug_irq = platform_get_irq(pdev, 0);
@@ -260,8 +258,6 @@ err2:
 	free_irq(l3->debug_irq, l3);
 err1:
 	iounmap(l3->rt);
-err0:
-	kfree(l3);
 	return ret;
 }
 
@@ -272,7 +268,6 @@ static int __exit omap3_l3_remove(struct platform_device *pdev)
 	free_irq(l3->app_irq, l3);
 	free_irq(l3->debug_irq, l3);
 	iounmap(l3->rt);
-	kfree(l3);
 
 	return 0;
 }
-- 
1.8.3.2

