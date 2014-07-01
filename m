Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaGASod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:44:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50154 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932389AbaGASoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:30 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 7/9] pci: of: Parse and map the IRQ when adding the PCI device.
Date: Tue,  1 Jul 2014 19:43:32 +0100
Message-Id: <1404240214-9804-8-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the default implementation of pcibios_add_device() to
parse and map the IRQ of the device if a DT binding is available.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 63a54a3..8e65dc3 100644
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
@@ -1453,6 +1454,9 @@ EXPORT_SYMBOL(pcim_pin_device);
  */
 int __weak pcibios_add_device(struct pci_dev *dev)
 {
+#ifdef CONFIG_OF
+	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
+#endif
 	return 0;
 }
 
-- 
2.0.0

