Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3AQCyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54220 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab3AQCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:37 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 27/86] arch/mips: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:19 -0800
Message-Id: <1358391258-1771-28-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/Kconfig |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 2ac626a..e96cf7a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -170,7 +170,7 @@ config MACH_DECSTATION
 	select SYS_HAS_CPU_R3000
 	select SYS_HAS_CPU_R4X00
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_128HZ
 	select SYS_SUPPORTS_256HZ
@@ -206,7 +206,7 @@ config MACH_JAZZ
 	select ISA
 	select SYS_HAS_CPU_R4X00
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_100HZ
 	help
 	 This a family of machines based on the MIPS R4030 chipset which was
@@ -396,7 +396,6 @@ config PNX8550_STB810
 
 config PMC_MSP
 	bool "PMC-Sierra MSP chipsets"
-	depends on EXPERIMENTAL
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
@@ -495,8 +494,7 @@ config SGI_IP27
 	  here.
 
 config SGI_IP28
-	bool "SGI IP28 (Indigo2 R10k) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "SGI IP28 (Indigo2 R10k)"
 	select FW_ARC
 	select FW_ARC64
 	select BOOT_ELF64
@@ -554,7 +552,6 @@ config SGI_IP32
 
 config SIBYTE_CRHINE
 	bool "Sibyte BCM91120C-CRhine"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -565,7 +562,6 @@ config SIBYTE_CRHINE
 
 config SIBYTE_CARMEL
 	bool "Sibyte BCM91120x-Carmel"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -576,7 +572,6 @@ config SIBYTE_CARMEL
 
 config SIBYTE_CRHONE
 	bool "Sibyte BCM91125C-CRhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125
@@ -588,7 +583,6 @@ config SIBYTE_CRHONE
 
 config SIBYTE_RHONE
 	bool "Sibyte BCM91125E-Rhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125H
@@ -613,7 +607,6 @@ config SIBYTE_SWARM
 
 config SIBYTE_LITTLESUR
 	bool "Sibyte BCM91250C2-LittleSur"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select HAVE_PATA_PLATFORM
@@ -627,7 +620,6 @@ config SIBYTE_LITTLESUR
 
 config SIBYTE_SENTOSA
 	bool "Sibyte BCM91250E-Sentosa"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select NR_CPUS_DEFAULT_2
@@ -676,7 +668,7 @@ config SNI_RM
 	select R5000_CPU_SCACHE
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_SUPPORTS_LITTLE_ENDIAN
@@ -780,7 +772,6 @@ config CAVIUM_OCTEON_REFERENCE_BOARD
 
 config NLM_XLR_BOARD
 	bool "Netlogic XLR/XLS based systems"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLR
@@ -809,7 +800,6 @@ config NLM_XLR_BOARD
 
 config NLM_XLP_BOARD
 	bool "Netlogic XLP based systems"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLP
@@ -1375,7 +1365,6 @@ config CPU_R5500
 
 config CPU_R6000
 	bool "R6000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R6000
 	select CPU_SUPPORTS_32BIT_KERNEL
 	help
@@ -1393,7 +1382,6 @@ config CPU_NEVADA
 
 config CPU_R8000
 	bool "R8000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R8000
 	select CPU_HAS_PREFETCH
 	select CPU_SUPPORTS_64BIT_KERNEL
@@ -1768,7 +1756,7 @@ config PAGE_SIZE_4KB
 
 config PAGE_SIZE_8KB
 	bool "8kB"
-	depends on (EXPERIMENTAL && CPU_R8000) || CPU_CAVIUM_OCTEON
+	depends on CPU_R8000 || CPU_CAVIUM_OCTEON
 	help
 	  Using 8kB page size will result in higher performance kernel at
 	  the price of higher memory consumption.  This option is available
@@ -1795,7 +1783,7 @@ config PAGE_SIZE_32KB
 
 config PAGE_SIZE_64KB
 	bool "64kB"
-	depends on EXPERIMENTAL && !CPU_R3000 && !CPU_TX39XX
+	depends on !CPU_R3000 && !CPU_TX39XX
 	help
 	  Using 64kB page size will result in higher performance kernel at
 	  the price of higher memory consumption.  This option is available on
@@ -2312,8 +2300,7 @@ config HZ
 source "kernel/Kconfig.preempt"
 
 config KEXEC
-	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Kexec system call"
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
-- 
1.7.9.5

