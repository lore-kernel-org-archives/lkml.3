Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaLXWMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:12:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44534 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaLXWMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:12:22 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <will.deacon@arm.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v2 2/2] PCI: update dma configuration from DT
Date: Wed, 24 Dec 2014 17:11:39 -0500
Message-ID: <1419459099-6667-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com>
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com>
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

