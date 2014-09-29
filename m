Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaI2OdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:33:22 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50570 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754267AbaI2ObM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:12 -0400
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
Subject: [PATCH v13 01/12] asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP
Date: Mon, 29 Sep 2014 15:29:20 +0100
Message-Id: <1412000971-9242-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The !CONFIG_GENERIC_IOMAP version of ioport_map() is wrong.  It returns a
mapped, i.e., virtual, address that can start from zero and completely
ignores the PCI_IOBASE and IO_SPACE_LIMIT that most architectures that use
!CONFIG_GENERIC_MAP define.

Tested-by: Tanmay Inamdar <tinamdar@apm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 975e1cc..b8fdc57 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -331,7 +331,7 @@ static inline void iounmap(void __iomem *addr)
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
-	return (void __iomem *) port;
+	return PCI_IOBASE + (port & IO_SPACE_LIMIT);
 }
 
 static inline void ioport_unmap(void __iomem *p)
-- 
2.1.1

