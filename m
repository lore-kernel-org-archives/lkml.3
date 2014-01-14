Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaANL7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:59:24 -0500
Received: from sauhun.de ([89.238.76.85]:47837 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANL7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:59:21 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/7] drivers/pci/host: don't check resource with devm_ioremap_resource
Date: Tue, 14 Jan 2014 12:58:55 +0100
Message-Id: <1389700739-3696-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

Should go via subsystem tree

 drivers/pci/host/pci-imx6.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pci/host/pci-imx6.c b/drivers/pci/host/pci-imx6.c
index bd70af8..5002e23 100644
--- a/drivers/pci/host/pci-imx6.c
+++ b/drivers/pci/host/pci-imx6.c
@@ -426,11 +426,6 @@ static int __init imx6_pcie_probe(struct platform_device *pdev)
 		"imprecise external abort");
 
 	dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!dbi_base) {
-		dev_err(&pdev->dev, "dbi_base memory resource not found\n");
-		return -ENODEV;
-	}
-
 	pp->dbi_base = devm_ioremap_resource(&pdev->dev, dbi_base);
 	if (IS_ERR(pp->dbi_base)) {
 		ret = PTR_ERR(pp->dbi_base);
-- 
1.8.5.1

