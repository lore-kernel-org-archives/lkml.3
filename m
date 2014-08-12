Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaHLQ3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:29:03 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51294 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753896AbaHLQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:28:54 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 02/12] PCI: OF: Parse and map the IRQ when adding the PCI device.
Date: Tue, 12 Aug 2014 17:25:15 +0100
Message-Id: <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the default implementation of pcibios_add_device() to
parse and map the IRQ of the device if a DT binding is available.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1c8592b..29d1775 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/log2.h>
+#include <linux/of_pci.h>
 #include <linux/pci-aspm.h>
 #include <linux/pm_wakeup.h>
 #include <linux/interrupt.h>
@@ -1453,6 +1454,8 @@ EXPORT_SYMBOL(pcim_pin_device);
  */
 int __weak pcibios_add_device(struct pci_dev *dev)
 {
+	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
+
 	return 0;
 }
 
-- 
2.0.4

