Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3FJLvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:51:37 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49949 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab3FJLuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:46 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 13/15] pci: mvebu: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:11 +0530
Message-Id: <1370864113-17895-14-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-pci@vger.kernel.org
CC: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/host/pci-mvebu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 13a633b..e714876 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -752,7 +752,7 @@ mvebu_pcie_map_registers(struct platform_device *pdev,
 	if (ret)
 		return NULL;
 
-	return devm_request_and_ioremap(&pdev->dev, &regs);
+	return devm_ioremap_resource(&pdev->dev, &regs);
 }
 
 static int __init mvebu_pcie_probe(struct platform_device *pdev)
@@ -842,9 +842,10 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 
 		port->base = mvebu_pcie_map_registers(pdev, child, port);
-		if (!port->base) {
+		if (IS_ERR(port->base)) {
 			dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
 				port->port, port->lane);
+			port->base = NULL;
 			continue;
 		}
 
-- 
1.7.9.5

