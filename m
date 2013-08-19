Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3HSIwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:52:08 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12631 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab3HSIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:52:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="29716862"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] MIPS: ath79: simplify platform_get_resource_byname/devm_ioremap_resource
Date: Mon, 19 Aug 2013 10:51:56 +0200
Message-Id: <1376902316-18520-7-git-send-email-Julia.Lawall@lip6.fr>
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
 arch/mips/pci/pci-ar71xx.c |    3 ---
 arch/mips/pci/pci-ar724x.c |    9 ---------
 2 files changed, 12 deletions(-)

diff --git a/arch/mips/pci/pci-ar71xx.c b/arch/mips/pci/pci-ar71xx.c
index 18517dd..d471a26 100644
--- a/arch/mips/pci/pci-ar71xx.c
+++ b/arch/mips/pci/pci-ar71xx.c
@@ -363,9 +363,6 @@ static int ar71xx_pci_probe(struct platform_device *pdev)
 	spin_lock_init(&apc->lock);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg_base");
-	if (!res)
-		return -EINVAL;
-
 	apc->cfg_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(apc->cfg_base))
 		return PTR_ERR(apc->cfg_base);
diff --git a/arch/mips/pci/pci-ar724x.c b/arch/mips/pci/pci-ar724x.c
index 65ec032..785b265 100644
--- a/arch/mips/pci/pci-ar724x.c
+++ b/arch/mips/pci/pci-ar724x.c
@@ -362,25 +362,16 @@ static int ar724x_pci_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ctrl_base");
-	if (!res)
-		return -EINVAL;
-
 	apc->ctrl_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(apc->ctrl_base))
 		return PTR_ERR(apc->ctrl_base);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg_base");
-	if (!res)
-		return -EINVAL;
-
 	apc->devcfg_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(apc->devcfg_base))
 		return PTR_ERR(apc->devcfg_base);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "crp_base");
-	if (!res)
-		return -EINVAL;
-
 	apc->crp_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(apc->crp_base))
 		return PTR_ERR(apc->crp_base);

