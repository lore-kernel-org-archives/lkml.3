Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbbAWWfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:35:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48427 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbbAWWdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:33:45 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 5/6] PCI: update dma configuration from DT
Date: Fri, 23 Jan 2015 17:32:38 -0500
Message-ID: <1422052359-12384-6-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a DT node available for the root bridge's parent device,
use the dma configuration from that device node. For example, keystone
PCI devices would require dma_pfn_offset to be set correctly in the
device structure of the pci device in order to have the correct dma mask.
The DT node will have dma-ranges defined for this. Also support using
the DT property dma-coherent to allow coherent DMA operation by the
PCI device.

This patch use the new helper function of_pci_dma_configure() to update
the device dma configuration.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/pci/probe.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 23212f8..d7dcd6c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -6,6 +6,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/of_pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -1520,6 +1521,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.dma_parms = &dev->dma_parms;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
+	of_pci_dma_configure(dev);
 
 	pci_set_dma_max_seg_size(dev, 65536);
 	pci_set_dma_seg_boundary(dev, 0xffffffff);
-- 
1.7.9.5

