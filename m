Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3HLSsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:48:10 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:40730 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3HLSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:47:07 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 5/9] PCI: mvebu: add support for Marvell Dove SoCs
Date: Mon, 12 Aug 2013 20:46:51 +0200
Message-Id: <1376333215-12885-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a compatible for the PCIe controller found on Marvell
Dove SoCs. Binding documentation and Kconfig entry are also updated.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 Documentation/devicetree/bindings/pci/mvebu-pci.txt |    1 +
 drivers/pci/host/Kconfig                            |    2 +-
 drivers/pci/host/pci-mvebu.c                        |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
index f2fa261..cf470a9 100644
--- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
+++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
@@ -5,6 +5,7 @@ Mandatory properties:
 - compatible: one of the following values:
     marvell,armada-370-pcie
     marvell,armada-xp-pcie
+    marvell,dove-pcie
     marvell,kirkwood-pcie
 - #address-cells, set to <3>
 - #size-cells, set to <2>
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 1184ff6..492eec9 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -3,7 +3,7 @@ menu "PCI host controller drivers"
 
 config PCI_MVEBU
 	bool "Marvell EBU PCIe controller"
-	depends on ARCH_MVEBU || ARCH_KIRKWOOD
+	depends on ARCH_MVEBU || ARCH_DOVE || ARCH_KIRKWOOD
 
 config PCIE_DW
 	bool
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index bdad4d4..b204c1d 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -986,6 +986,7 @@ static int mvebu_pcie_remove(struct platform_device *pdev)
 static const struct of_device_id mvebu_pcie_of_match_table[] = {
 	{ .compatible = "marvell,armada-xp-pcie", },
 	{ .compatible = "marvell,armada-370-pcie", },
+	{ .compatible = "marvell,dove-pcie", },
 	{ .compatible = "marvell,kirkwood-pcie", },
 	{},
 };
-- 
1.7.10.4

