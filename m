Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3CKHmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:42:40 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57366 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3CKHmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:42:38 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, juhosg@openwrt.org, blogic@openwrt.org,
        xsecute@googlemail.com, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] pci: convert to devm_ioremap_resource()
Date: Mon, 11 Mar 2013 09:42:33 +0200
Message-Id: <1362987753-6607-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 arch/mips/pci/pci-ar724x.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

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

