Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbaFQT1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657AbaFQT1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:27:40 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed bit
	when clearing the Slot Status register's event bits
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 13:27:34 -0600
Message-ID: <20140617192734.30783.71260.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During PCIe hot-plug initialization - pciehp_probe - data structures
related to slot capabilities are set up.  As part of this set up, ISRs are
put in place to handle slot events and all event bits are cleared out.

This patch adds the Data Link Layer State Changed (PCI_EXP_SLTSTA_DLLSC)
Slot Status bit to the event bits that are cleared out during
initialization.

Reference:
  PCI-SIG.  PCI Express Base Specification Revision 4.0 Version 0.3
  (PCI-SIG, 2014): 7.8.11. Slot Status Register (Offset 1Ah).

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/pciehp_hpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 42914e0..0568416 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -794,7 +794,7 @@ struct controller *pcie_init(struct pcie_device *dev)
 	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
 		PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
 		PCI_EXP_SLTSTA_MRLSC | PCI_EXP_SLTSTA_PDC |
-		PCI_EXP_SLTSTA_CC);
+		PCI_EXP_SLTSTA_CC | PCI_EXP_SLTSTA_DLLSC);
 
 	/* Disable software notification */
 	pcie_disable_notification(ctrl);

