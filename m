Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaI2ObR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:31:17 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50504 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754066AbaI2ObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:08 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH v13 04/12] of/pci: Define of_pci_range_to_resource() only when CONFIG_PCI=y
Date: Mon, 29 Sep 2014 15:29:23 +0100
Message-Id: <1412000971-9242-5-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

of_pci_range_to_resource() was previously defined always, but it's only
used by PCI code, so move the definition inside the CONFIG_OF_ADDRESS &&
CONFIG_PCI block.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/of_address.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index f8cc7da..ecf913c 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -23,17 +23,6 @@ struct of_pci_range {
 #define for_each_of_pci_range(parser, range) \
 	for (; of_pci_range_parser_one(parser, range);)
 
-static inline void of_pci_range_to_resource(struct of_pci_range *range,
-					    struct device_node *np,
-					    struct resource *res)
-{
-	res->flags = range->flags;
-	res->start = range->cpu_addr;
-	res->end = range->cpu_addr + range->size - 1;
-	res->parent = res->child = res->sibling = NULL;
-	res->name = np->full_name;
-}
-
 /* Translate a DMA address from device space to CPU space */
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const __be32 *in_addr);
@@ -140,6 +129,18 @@ extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
 			       u64 *size, unsigned int *flags);
 extern int of_pci_address_to_resource(struct device_node *dev, int bar,
 				      struct resource *r);
+
+static inline void of_pci_range_to_resource(struct of_pci_range *range,
+					    struct device_node *np,
+					    struct resource *res)
+{
+	res->flags = range->flags;
+	res->start = range->cpu_addr;
+	res->end = range->cpu_addr + range->size - 1;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+}
+
 #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
 static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
 				             struct resource *r)
@@ -155,4 +156,3 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
 #endif /* CONFIG_OF_ADDRESS && CONFIG_PCI */
 
 #endif /* __OF_ADDRESS_H */
-
-- 
2.1.1

