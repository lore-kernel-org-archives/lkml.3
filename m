Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaIQQlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbaIQQlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:41:10 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 1/2] PCI: Remove pci_find_upstream_pcie_bridge()
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 10:41:07 -0600
Message-ID: <20140917164106.21584.20401.stgit@gimli.home>
In-Reply-To: <20140917163930.21584.69496.stgit@gimli.home>
References: <20140917163930.21584.69496.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now dead code.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/search.c |   34 ----------------------------------
 include/linux/pci.h  |   11 -----------
 2 files changed, 45 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 827ad83..a81f413 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -103,40 +103,6 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 	return ret;
 }
 
-/*
- * find the upstream PCIe-to-PCI bridge of a PCI device
- * if the device is PCIE, return NULL
- * if the device isn't connected to a PCIe bridge (that is its parent is a
- * legacy PCI bridge and the bridge is directly connected to bus 0), return its
- * parent
- */
-struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
-{
-	struct pci_dev *tmp = NULL;
-
-	if (pci_is_pcie(pdev))
-		return NULL;
-	while (1) {
-		if (pci_is_root_bus(pdev->bus))
-			break;
-		pdev = pdev->bus->self;
-		/* a p2p bridge */
-		if (!pci_is_pcie(pdev)) {
-			tmp = pdev;
-			continue;
-		}
-		/* PCI device should connect to a PCIe bridge */
-		if (pci_pcie_type(pdev) != PCI_EXP_TYPE_PCI_BRIDGE) {
-			/* Busted hardware? */
-			WARN_ON_ONCE(1);
-			return NULL;
-		}
-		return pdev;
-	}
-
-	return tmp;
-}
-
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
 	struct pci_bus *child;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 61978a4..b4fb9f4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1828,15 +1828,4 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 			   int (*fn)(struct pci_dev *pdev,
 				     u16 alias, void *data), void *data);
 
-/**
- * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device
- * @pdev: the PCI device
- *
- * if the device is PCIE, return NULL
- * if the device isn't connected to a PCIe bridge (that is its parent is a
- * legacy PCI bridge and the bridge is directly connected to bus 0), return its
- * parent
- */
-struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
-
 #endif /* LINUX_PCI_H */

