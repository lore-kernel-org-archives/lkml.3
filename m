Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3CLLaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:30:15 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43906 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3CLLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:30:13 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, juhosg@openwrt.org, blogic@openwrt.org,
        kaloz@openwrt.org, xsecute@googlemail.com,
        linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH v3] pci: convert to devm_ioremap_resource()
Date: Tue, 12 Mar 2013 13:30:05 +0200
Message-Id: <1363087805-6463-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 arch/mips/pci/pci-ar71xx.c |    6 +++---
 arch/mips/pci/pci-ar724x.c |   18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/mips/pci/pci-ar71xx.c b/arch/mips/pci/pci-ar71xx.c
index 412ec02..18517dd 100644
--- a/arch/mips/pci/pci-ar71xx.c
+++ b/arch/mips/pci/pci-ar71xx.c
@@ -366,9 +366,9 @@ static int ar71xx_pci_probe(struct platform_device *pdev)
 	if (!res)
 		return -EINVAL;
 
-	apc->cfg_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!apc->cfg_base)
-		return -ENOMEM;
+	apc->cfg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(apc->cfg_base))
+		return PTR_ERR(apc->cfg_base);
 
 	apc->irq = platform_get_irq(pdev, 0);
 	if (apc->irq < 0)
diff --git a/arch/mips/pci/pci-ar724x.c b/arch/mips/pci/pci-ar724x.c
index 8a0700d..65ec032 100644
--- a/arch/mips/pci/pci-ar724x.c
+++ b/arch/mips/pci/pci-ar724x.c
@@ -365,25 +365,25 @@ static int ar724x_pci_probe(struct platform_device *pdev)
 	if (!res)
 		return -EINVAL;
 
-	apc->ctrl_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (apc->ctrl_base == NULL)
-		return -EBUSY;
+	apc->ctrl_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(apc->ctrl_base))
+		return PTR_ERR(apc->ctrl_base);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg_base");
 	if (!res)
 		return -EINVAL;
 
-	apc->devcfg_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!apc->devcfg_base)
-		return -EBUSY;
+	apc->devcfg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(apc->devcfg_base))
+		return PTR_ERR(apc->devcfg_base);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "crp_base");
 	if (!res)
 		return -EINVAL;
 
-	apc->crp_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (apc->crp_base == NULL)
-		return -EBUSY;
+	apc->crp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(apc->crp_base))
+		return PTR_ERR(apc->crp_base);
 
 	apc->irq = platform_get_irq(pdev, 0);
 	if (apc->irq < 0)
-- 
1.7.9.5

