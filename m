Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3HMM05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:26:57 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38873 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab3HMM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:26:14 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 5/5] PCI: mvebu: add support for Marvell Dove SoCs
Date: Tue, 13 Aug 2013 14:25:24 +0200
Message-Id: <1376396724-32048-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a compatible for the PCIe controller found on Marvell
Dove SoCs. Binding documentation and Kconfig entry are also updated.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- nothing changed

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
index 8bb3245..08c716b 100644
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
index a9ad4b3..88c6790 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -975,6 +975,7 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 static const struct of_device_id mvebu_pcie_of_match_table[] = {
 	{ .compatible = "marvell,armada-xp-pcie", },
 	{ .compatible = "marvell,armada-370-pcie", },
+	{ .compatible = "marvell,dove-pcie", },
 	{ .compatible = "marvell,kirkwood-pcie", },
 	{},
 };
-- 
1.7.10.4

