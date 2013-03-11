Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3CKPYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:24:43 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:52227 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3CKPYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:24:41 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, juhosg@openwrt.org, blogic@openwrt.org,
        kaloz@openwrt.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] pci: use newly introduced devm_ioremap_resource()
Date: Mon, 11 Mar 2013 17:24:37 +0200
Message-Id: <1363015477-29685-1-git-send-email-silviupopescu1990@gmail.com>
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
 arch/mips/pci/pci-ar71xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.7.9.5

