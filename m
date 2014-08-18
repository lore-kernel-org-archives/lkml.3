Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHRTBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:01:10 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:45136 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaHRTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:01:08 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Gerhard Sittig <gsi@denx.de>, Rob Herring <robh@kernel.org>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] powerpc: Fix build failure for PPC_32
Date: Mon, 18 Aug 2014 15:01:04 -0400
Message-Id: <1408388465-26577-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ppc 32 build failure as reported here:

http://kisskb.ellerman.id.au/kisskb/buildresult/11663513/

The error is that pci_32.o was not being built for PPC_32. Fix error by adding
it in the Makefile. Tested using the ppc cross compiler.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 670c312..3206ba1 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -89,7 +89,7 @@ extra-y				+= vmlinux.lds
 
 obj-$(CONFIG_RELOCATABLE_PPC32)	+= reloc_32.o
 
-obj-$(CONFIG_PPC32)		+= entry_32.o setup_32.o
+obj-$(CONFIG_PPC32)		+= entry_32.o setup_32.o pci_32.o
 obj-$(CONFIG_PPC64)		+= dma-iommu.o iommu.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_MODULES)		+= ppc_ksyms.o
-- 
1.9.1

