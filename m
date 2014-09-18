Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaIRBcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:32:06 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54509 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754154AbaIRBcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:32:02 -0400
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v11 03/10] ARM: Define PCI_IOBASE as the base of virtual PCI IO space.
Date: Thu, 18 Sep 2014 02:30:18 +0100
Message-Id: <1411003825-21521-4-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for calls into OF code that parses PCI ranges.
It signals support for memory mapped PCI I/O accesses that
are described be device trees.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm/include/asm/io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 3d23418..22b7529 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -178,6 +178,7 @@ static inline void __iomem *__typesafe_io(unsigned long addr)
 
 /* PCI fixed i/o mapping */
 #define PCI_IO_VIRT_BASE	0xfee00000
+#define PCI_IOBASE		PCI_IO_VIRT_BASE
 
 #if defined(CONFIG_PCI)
 void pci_ioremap_set_mem_type(int mem_type);
-- 
2.1.0

