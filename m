Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab3HSIwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:52:11 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12631 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab3HSIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="29716859"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] mtd: fsmc_nand: simplify platform_get_resource_byname/devm_ioremap_resource
Date: Mon, 19 Aug 2013 10:51:53 +0200
Message-Id: <1376902316-18520-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource_byname when the value is passed to devm_ioremap_resource.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,e,e1;
expression ret != 0;
identifier l;
@@

  res = platform_get_resource_byname(...);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/nand/fsmc_nand.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 2a3b1b9..3dc1a75 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -958,9 +958,6 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_data");
-	if (!res)
-		return -EINVAL;
-
 	host->data_va = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(host->data_va))
 		return PTR_ERR(host->data_va);
@@ -968,25 +965,16 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	host->data_pa = (dma_addr_t)res->start;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_addr");
-	if (!res)
-		return -EINVAL;
-
 	host->addr_va = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(host->addr_va))
 		return PTR_ERR(host->addr_va);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_cmd");
-	if (!res)
-		return -EINVAL;
-
 	host->cmd_va = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(host->cmd_va))
 		return PTR_ERR(host->cmd_va);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "fsmc_regs");
-	if (!res)
-		return -EINVAL;
-
 	host->regs_va = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(host->regs_va))
 		return PTR_ERR(host->regs_va);

