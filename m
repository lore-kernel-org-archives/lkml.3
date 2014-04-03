Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaDCWSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:31 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49197 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaDCWRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:48 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 16/20] build: add libfdt include path globally
Date: Thu,  3 Apr 2014 17:16:59 -0500
Message-Id: <1396563423-30893-17-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

In order use libfdt headers more widely available, make the libfdt
include path globally available. It's a bit ugly, but other solutions
would probably make importing libfdt more difficult.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Makefile                         | 5 +++++
 arch/mips/cavium-octeon/Makefile | 3 ---
 arch/mips/mti-sead3/Makefile     | 2 --
 drivers/of/Makefile              | 2 --
 include/linux/of_fdt.h           | 2 ++
 lib/Makefile                     | 2 --
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 3cb01b3..a6a858f 100644
--- a/Makefile
+++ b/Makefile
@@ -692,6 +692,11 @@ ifdef CONFIG_DYNAMIC_FTRACE
 endif
 endif
 
+ifdef CONFIG_LIBFDT
+KBUILD_CFLAGS += -I$(srctree)/scripts/dtc/libfdt
+KBUILD_AFLAGS += -I$(srctree)/scripts/dtc/libfdt
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index 4e95204..833055b 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -9,9 +9,6 @@
 # Copyright (C) 2005-2009 Cavium Networks
 #
 
-CFLAGS_octeon-platform.o = -I$(src)/../../../scripts/dtc/libfdt
-CFLAGS_setup.o = -I$(src)/../../../scripts/dtc/libfdt
-
 obj-y := cpu.o setup.o octeon-platform.o octeon-irq.o csrc-octeon.o
 obj-y += dma-octeon.o
 obj-y += octeon-memcpy.o
diff --git a/arch/mips/mti-sead3/Makefile b/arch/mips/mti-sead3/Makefile
index 071786f..be11420 100644
--- a/arch/mips/mti-sead3/Makefile
+++ b/arch/mips/mti-sead3/Makefile
@@ -21,7 +21,5 @@ obj-$(CONFIG_EARLY_PRINTK)	+= sead3-console.o
 obj-$(CONFIG_USB_EHCI_HCD)	+= sead3-ehci.o
 obj-$(CONFIG_OF)		+= sead3.dtb.o
 
-CFLAGS_sead3-setup.o = -I$(src)/../../../scripts/dtc/libfdt
-
 $(obj)/%.dtb: $(obj)/%.dts
 	$(call if_changed,dtc)
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 9891232..ed9660a 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -10,5 +10,3 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
-
-CFLAGS_fdt.o = -I$(src)/../../scripts/dtc/libfdt
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 348dae2..d7b7fdd 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -27,6 +27,8 @@
 #define OF_DT_VERSION		0x10
 
 #ifndef __ASSEMBLY__
+#include <linux/libfdt.h>
+
 /*
  * This is what gets passed to the kernel by prom_init or kexec
  *
diff --git a/lib/Makefile b/lib/Makefile
index 02da5b6..c7d3a82 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -150,8 +150,6 @@ obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o
-$(foreach file, $(libfdt_files), \
-	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 
 obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
-- 
1.8.3.2

