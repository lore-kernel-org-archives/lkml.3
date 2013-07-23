Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037Ab3GWSD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:26 -0400
Received: from sauhun.de ([89.238.76.85]:58737 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933982Ab3GWSDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:22 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 13/27] drivers/pci/host: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:46 +0200
Message-Id: <1374602524-3398-14-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/pci/host/pcie-designware.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 26bdbda..f0ba6ef 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -817,28 +817,16 @@ static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
 	int ret;
 
 	elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!elbi_base) {
-		dev_err(&pdev->dev, "couldn't get elbi base resource\n");
-		return -EINVAL;
-	}
 	pp->elbi_base = devm_ioremap_resource(&pdev->dev, elbi_base);
 	if (IS_ERR(pp->elbi_base))
 		return PTR_ERR(pp->elbi_base);
 
 	phy_base = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!phy_base) {
-		dev_err(&pdev->dev, "couldn't get phy base resource\n");
-		return -EINVAL;
-	}
 	pp->phy_base = devm_ioremap_resource(&pdev->dev, phy_base);
 	if (IS_ERR(pp->phy_base))
 		return PTR_ERR(pp->phy_base);
 
 	purple_base = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	if (!purple_base) {
-		dev_err(&pdev->dev, "couldn't get purple base resource\n");
-		return -EINVAL;
-	}
 	pp->purple_base = devm_ioremap_resource(&pdev->dev, purple_base);
 	if (IS_ERR(pp->purple_base))
 		return PTR_ERR(pp->purple_base);
-- 
1.7.10.4

