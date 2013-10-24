Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3JXPYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:24:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3JXPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:23:16 -0400
Message-Id: <20131024152313.607345011@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Oct 2013 08:19:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS
References: <20131024151921.537751910@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-kernel-remove-CONFIG_USE_GENERIC_SMP_HELPERS.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've switched over every architecture that supports SMP to it, so remove
the new useless config variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/Kconfig          |    3 ---
 arch/alpha/Kconfig    |    1 -
 arch/arc/Kconfig      |    1 -
 arch/arm/Kconfig      |    1 -
 arch/arm64/Kconfig    |    1 -
 arch/blackfin/Kconfig |    1 -
 arch/hexagon/Kconfig  |    1 -
 arch/ia64/Kconfig     |    1 -
 arch/m32r/Kconfig     |    1 -
 arch/metag/Kconfig    |    1 -
 arch/mips/Kconfig     |    1 -
 arch/mn10300/Kconfig  |    1 -
 arch/parisc/Kconfig   |    1 -
 arch/powerpc/Kconfig  |    1 -
 arch/s390/Kconfig     |    1 -
 arch/sh/Kconfig       |    1 -
 arch/sparc/Kconfig    |    1 -
 arch/tile/Kconfig     |    1 -
 arch/x86/Kconfig      |    1 -
 block/blk-mq.c        |    4 ++--
 block/blk-softirq.c   |    4 ++--
 block/blk-sysfs.c     |    2 +-
 include/linux/smp.h   |    4 ----
 kernel/Kconfig.hz     |    2 +-
 kernel/smp.c          |    2 --
 25 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index af2cc6e..63c53c6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -207,9 +207,6 @@ config HAVE_DMA_ATTRS
 config HAVE_DMA_CONTIGUOUS
 	bool
 
-config USE_GENERIC_SMP_HELPERS
-	bool
-
 config GENERIC_SMP_IDLE_THREAD
        bool
 
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 35a300d..8d2a483 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -522,7 +522,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 91dbb27..9c2ddbf 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -119,7 +119,6 @@ config ARC_PLAT_NEEDS_CPU_TO_DMA
 config SMP
 	bool "Symmetric Multi-Processing (Incomplete)"
 	default n
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..a671b58 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1467,7 +1467,6 @@ config SMP
 	depends on GENERIC_CLOCKEVENTS
 	depends on HAVE_SMP
 	depends on MMU || ARM_MPU
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..7020613 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -140,7 +140,6 @@ config ARM64_64K_PAGES
 
 config SMP
 	bool "Symmetric Multi-Processing"
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU.  If
 	  you say N here, the kernel will run on single and
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f78c9a2..e06b5d8 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -34,7 +34,6 @@ config BLACKFIN
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 99041b0..09df260 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -4,7 +4,6 @@ comment "Linux Kernel Configuration for Hexagon"
 config HEXAGON
 	def_bool y
 	select HAVE_OPROFILE
-	select USE_GENERIC_SMP_HELPERS if SMP
 	# Other pending projects/to-do items.
 	# select HAVE_REGS_AND_STACK_ACCESS_API
 	# select HAVE_HW_BREAKPOINT if PERF_EVENTS
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 7740ab1..dfe85e9 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -343,7 +343,6 @@ config FORCE_MAX_ZONEORDER
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N.  If you have a system with more
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 75661fb..09ef94a 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -275,7 +275,6 @@ source "kernel/Kconfig.preempt"
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 36368eb..e56abd2 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -111,7 +111,6 @@ config METAG_META21
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on METAG_META21 && METAG_META21_MMU
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one thread running
 	  Linux. If you have a system with only one thread running Linux,
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f75ab4a..f745dc3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2140,7 +2140,6 @@ source "mm/Kconfig"
 config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 6aaa160..8bde923 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -181,7 +181,6 @@ endmenu
 config SMP
 	bool "Symmetric multi-processing support"
 	default y
-	select USE_GENERIC_SMP_HELPERS
 	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index ad2ce8d..0c08dc8 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -226,7 +226,6 @@ endchoice
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 38f3b7e..2bc9c49 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -106,7 +106,6 @@ config PPC
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
 	select HAVE_DEBUG_KMEMLEAK
 	select GENERIC_ATOMIC64 if PPC32
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 7143793..8fed3f5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -140,7 +140,6 @@ config S390
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select SYSCTL_EXCEPTION_TRACE
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 224f4bc..e78561b 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -711,7 +711,6 @@ config CC_STACKPROTECTOR
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 78c4fdb..8591b20 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -28,7 +28,6 @@ config SPARC
 	select HAVE_ARCH_JUMP_LABEL
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select HAVE_BPF_JIT
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index d45a2c4..b3692ce 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -8,7 +8,6 @@ config TILE
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
 	select SYSCTL_EXCEPTION_TRACE
-	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_DEBUG_KMEMLEAK
 	select GENERIC_IRQ_PROBE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 145d703..f137df2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -90,7 +90,6 @@ config X86
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CLOCKEVENTS_MIN_ADJUST
 	select IRQ_FORCED_THREADING
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select CLKEVT_I8253
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f21ec96..d43a7e8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -318,7 +318,7 @@ void __blk_mq_end_io(struct request *rq, int error)
 		blk_mq_complete_request(rq, error);
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#if defined(CONFIG_SMP)
 
 /*
  * Called with interrupts disabled.
@@ -360,7 +360,7 @@ static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
 
 	return true;
 }
-#else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+#else /* CONFIG_SMP */
 static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
 			  struct request *rq, const int error)
 {
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ec9e606..ed07d79 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -36,7 +36,7 @@ static void blk_done_softirq(struct softirq_action *h)
 	}
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 static void trigger_softirq(void *data)
 {
 	struct request *rq = data;
@@ -71,7 +71,7 @@ static int raise_blk_irq(int cpu, struct request *rq)
 
 	return 1;
 }
-#else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+#else /* CONFIG_SMP */
 static int raise_blk_irq(int cpu, struct request *rq)
 {
 	return 1;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4f8c4d9..9777952 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -288,7 +288,7 @@ static ssize_t
 queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 {
 	ssize_t ret = -EINVAL;
-#if defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 	unsigned long val;
 
 	ret = queue_var_store(&val, page, count);
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 731f523..7885151 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -106,14 +106,10 @@ void kick_all_cpus_sync(void);
 /*
  * Generic and arch helpers
  */
-#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void __init call_function_init(void);
 void generic_smp_call_function_single_interrupt(void);
 #define generic_smp_call_function_interrupt \
 	generic_smp_call_function_single_interrupt
-#else
-static inline void call_function_init(void) { }
-#endif
 
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 94fabd5..2a202a8 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
+	def_bool HIGH_RES_TIMERS
diff --git a/kernel/smp.c b/kernel/smp.c
index bc400e3..2b83645 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -15,7 +15,6 @@
 
 #include "smpboot.h"
 
-#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 enum {
 	CSD_FLAG_LOCK		= 0x01,
 	CSD_FLAG_WAIT		= 0x02,
@@ -463,7 +462,6 @@ int smp_call_function(smp_call_func_t func, void *info, int wait)
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
-#endif /* USE_GENERIC_SMP_HELPERS */
 
 /* Setup configured maximum number of CPUs to activate */
 unsigned int setup_max_cpus = NR_CPUS;
-- 
1.7.10.4


