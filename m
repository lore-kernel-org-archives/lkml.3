Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaABKl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:41:58 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbaABKl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:41:57 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH] PCI: mvebu: Remove redundant code
Date: Thu,  2 Jan 2014 11:41:36 +0100
Message-Id: <1388659296-21569-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the commit b42285f66f871a989, Sebastian moved clock enable before
register access, but during the merge of the commit
9f352f0e6c0fa2dc608812df "PCI: mvebu: Dynamically detect if the PEX
link is up to enable hot plug", the moved part was added back.

This patch fixes this by removing the redundant code.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/pci/host/pci-mvebu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 2aa7b77c7c88..0b4b99fa1fb5 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -954,14 +954,6 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 
 		mvebu_pcie_set_local_dev_nr(port, 1);
 
-		port->clk = of_clk_get_by_name(child, NULL);
-		if (IS_ERR(port->clk)) {
-			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
-			       port->port, port->lane);
-			iounmap(port->base);
-			continue;
-		}
-
 		port->dn = child;
 		spin_lock_init(&port->conf_lock);
 		mvebu_sw_pci_bridge_init(port);
-- 
1.8.1.2

