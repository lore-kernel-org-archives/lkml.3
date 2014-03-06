Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaCFUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:09:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaCFUJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:09:37 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 2/4] portdrv: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Thu,  6 Mar 2014 21:11:22 +0100
Message-Id: <b1f560f01a176784ebfff28b84574d2850413729.1394128952.git.agordeev@redhat.com>
In-Reply-To: <cover.1394128952.git.agordeev@redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pcie/portdrv_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 986f8ea..0b1efb2 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -99,7 +99,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 	for (i = 0; i < nr_entries; i++)
 		msix_entries[i].entry = i;
 
-	status = pci_enable_msix(dev, msix_entries, nr_entries);
+	status = pci_enable_msix_exact(dev, msix_entries, nr_entries);
 	if (status)
 		goto Exit;
 
@@ -171,7 +171,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 		pci_disable_msix(dev);
 
 		/* Now allocate the MSI-X vectors for real */
-		status = pci_enable_msix(dev, msix_entries, nvec);
+		status = pci_enable_msix_exact(dev, msix_entries, nvec);
 		if (status)
 			goto Exit;
 	}
-- 
1.7.7.6

