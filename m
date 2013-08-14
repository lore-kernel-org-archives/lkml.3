Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab3HNJU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:20:59 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57951
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759570Ab3HNJLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908315"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: kernel-janitors@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/29] tegra: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:10 +0200
Message-Id: <1376471493-22215-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/iommu/tegra-smmu.c  |    2 --
 drivers/memory/tegra20-mc.c |    2 --
 drivers/memory/tegra30-mc.c |    2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index f6f120e..e066560 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1177,8 +1177,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			return -ENODEV;
 		smmu->regs[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(smmu->regs[i]))
 			return PTR_ERR(smmu->regs[i]);
diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index 0548eea..7cd82b8 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -218,8 +218,6 @@ static int tegra20_mc_probe(struct platform_device *pdev)
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			return -ENODEV;
 		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(mc->regs[i]))
 			return PTR_ERR(mc->regs[i]);
diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index 58d2979..ef79345 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -340,8 +340,6 @@ static int tegra30_mc_probe(struct platform_device *pdev)
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			return -ENODEV;
 		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(mc->regs[i]))
 			return PTR_ERR(mc->regs[i]);

