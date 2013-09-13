Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3IMN7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:59:30 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:39930 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3IMN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:59:21 -0400
Date: Fri, 13 Sep 2013 15:59:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] generic hardirq removal patch for 3.12-rc1
Message-ID: <20130913155913.67869091@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091313-2966-0000-0000-000008BF1AD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'genirq' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git genirq

to receive the following updates:
All architectures now use generic hardirqs, s390 has been last to
switch. With that the code under CONFIG_GENERIC_HARDIRQS and the
related HAVE_GENERIC_HARDIRQS and GENERIC_HARDIRQS config options
can be removed. Yay!

Martin Schwidefsky (1):
      Remove GENERIC_HARDIRQ config option

 arch/alpha/Kconfig                     |    1 -
 arch/arc/Kconfig                       |    1 -
 arch/arm/Kconfig                       |    1 -
 arch/arm64/Kconfig                     |    1 -
 arch/avr32/Kconfig                     |    1 -
 arch/blackfin/Kconfig                  |    1 -
 arch/c6x/Kconfig                       |    1 -
 arch/cris/Kconfig                      |    1 -
 arch/frv/Kconfig                       |    1 -
 arch/h8300/Kconfig                     |    1 -
 arch/hexagon/Kconfig                   |    1 -
 arch/ia64/Kconfig                      |    1 -
 arch/m32r/Kconfig                      |    1 -
 arch/m68k/Kconfig                      |    1 -
 arch/metag/Kconfig                     |    1 -
 arch/microblaze/Kconfig                |    1 -
 arch/mips/Kconfig                      |    1 -
 arch/mn10300/Kconfig                   |    1 -
 arch/openrisc/Kconfig                  |    1 -
 arch/parisc/Kconfig                    |    1 -
 arch/powerpc/Kconfig                   |    1 -
 arch/s390/Kconfig                      |    1 -
 arch/score/Kconfig                     |    1 -
 arch/sh/Kconfig                        |    1 -
 arch/sparc/Kconfig                     |    1 -
 arch/tile/Kconfig                      |    1 -
 arch/um/Kconfig.common                 |    1 -
 arch/um/defconfig                      |    2 -
 arch/unicore32/Kconfig                 |    1 -
 arch/x86/Kconfig                       |    1 -
 arch/xtensa/Kconfig                    |    1 -
 arch/xtensa/configs/common_defconfig   |    1 -
 arch/xtensa/configs/iss_defconfig      |    1 -
 arch/xtensa/configs/s6105_defconfig    |    1 -
 drivers/block/mtip32xx/Kconfig         |    2 +-
 drivers/char/random.c                  |    5 +-
 drivers/dma/dw/Kconfig                 |    1 -
 drivers/gpio/Kconfig                   |    6 +-
 drivers/hid/Kconfig                    |    2 +-
 drivers/i2c/Kconfig                    |    1 -
 drivers/i2c/busses/Kconfig             |    6 +-
 drivers/iio/Kconfig                    |    1 -
 drivers/infiniband/hw/qib/Kconfig      |    2 +-
 drivers/input/keyboard/Kconfig         |    4 +-
 drivers/input/serio/Kconfig            |    1 -
 drivers/input/touchscreen/Kconfig      |    4 +-
 drivers/media/platform/Kconfig         |    2 +-
 drivers/media/radio/Kconfig            |    2 +-
 drivers/mfd/Kconfig                    |  126 +++++++++++++++-----------------
 drivers/misc/cb710/Kconfig             |    2 +-
 drivers/mmc/host/Kconfig               |    2 +-
 drivers/net/ethernet/cadence/Kconfig   |    2 +-
 drivers/net/wireless/p54/Kconfig       |    2 +-
 drivers/net/wireless/ti/wl1251/Kconfig |    2 +-
 drivers/net/wireless/ti/wlcore/Kconfig |    2 +-
 drivers/pci/msi.c                      |   22 ------
 drivers/power/Kconfig                  |    3 +-
 drivers/pps/clients/Kconfig            |    2 +-
 drivers/spi/Kconfig                    |    3 +-
 drivers/tty/serial/Kconfig             |    2 +-
 drivers/usb/dwc3/Kconfig               |    2 +-
 drivers/usb/gadget/Kconfig             |    4 +-
 drivers/usb/host/Kconfig               |    1 -
 drivers/usb/musb/Kconfig               |    1 -
 drivers/usb/renesas_usbhs/Kconfig      |    2 +-
 drivers/w1/masters/Kconfig             |    2 +-
 include/linux/cpu_rmap.h               |    3 -
 include/linux/hardirq.h                |    4 -
 include/linux/interrupt.h              |   75 +------------------
 include/linux/irq.h                    |    9 ---
 include/linux/irqdesc.h                |    3 -
 include/linux/irqnr.h                  |   19 -----
 include/linux/kernel_stat.h            |   34 ---------
 kernel/Makefile                        |    2 +-
 kernel/irq/Kconfig                     |   12 ---
 kernel/softirq.c                       |    2 -
 lib/Kconfig.debug                      |    2 +-
 lib/cpu_rmap.c                         |    6 --
 net/Kconfig                            |    2 +-
 sound/soc/codecs/Kconfig               |    2 +-
 sound/soc/samsung/Kconfig              |    6 +-
 81 files changed, 100 insertions(+), 337 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 082d9b4..35a300d 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -7,7 +7,6 @@ config ALPHA
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
-	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 68fcbb2..91dbb27 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -20,7 +20,6 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d13f674..3f7714d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -37,7 +37,6 @@ config ARM
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_IRQ_TIME_ACCOUNTING
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ae323a4..c044548 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -23,7 +23,6 @@ config ARM64
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_DMA_COHERENT
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 549903c..b6878eb 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -6,7 +6,6 @@ config AVR32
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 3b6abc5..f78c9a2 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -32,7 +32,6 @@ config BLACKFIN
 	select HAVE_UNDERSCORE_SYMBOL_PREFIX
 	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index f6a3648..957dd00 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -10,7 +10,6 @@ config C6X
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
 	select SPARSE_IRQ
 	select IRQ_DOMAIN
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index c699d32..02380be 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -41,7 +41,6 @@ config CRIS
 	default y
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_UID16
 	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 4b6628e..34aa193 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -5,7 +5,6 @@ config FRV
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
-	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 3d6759e..24b1dc2 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -2,7 +2,6 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
 	select VIRT_TO_BUS
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 77d442a..99041b0 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -15,7 +15,6 @@ config HEXAGON
 	# select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
-	select HAVE_GENERIC_HARDIRQS
 	# GENERIC_ALLOCATOR is used by dma_alloc_coherent()
 	select GENERIC_ALLOCATOR
 	select GENERIC_IRQ_SHOW
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index a86a56d..7740ab1 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -21,7 +21,6 @@ config IA64
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 29a7ef4..75661fb 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -9,7 +9,6 @@ config M32R
 	select HAVE_KERNEL_LZMA
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_DEBUG_BUGVERBOSE
-	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index c3cda41..311a300 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -4,7 +4,6 @@ config M68K
 	select HAVE_IDE
 	select HAVE_AOUT if MMU
 	select HAVE_DEBUG_BUGVERBOSE
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index cfd831c..36368eb 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -13,7 +13,6 @@ config METAG
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 3f6659c..b82f82b 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -18,7 +18,6 @@ config MICROBLAZE
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
-	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index a9668d4..f75ab4a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -25,7 +25,6 @@ config MIPS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 70e4f66..6aaa160 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -1,7 +1,6 @@
 config MN10300
 	def_bool y
 	select HAVE_OPROFILE
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index d60bf98..9488209 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -11,7 +11,6 @@ config OPENRISC
 	select HAVE_MEMBLOCK
 	select ARCH_REQUIRE_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index aa399a5..ad2ce8d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -14,7 +14,6 @@ config PARISC
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select HAVE_GENERIC_HARDIRQS
 	select BROKEN_RODATA
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PCI_IOMAP
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6b7530f..38f3b7e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -114,7 +114,6 @@ config PPC
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
-	select HAVE_GENERIC_HARDIRQS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select SPARSE_IRQ
 	select IRQ_DOMAIN
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3ec2728..dcc6ac2 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -116,7 +116,6 @@ config S390
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 5fc2375..a1be70d 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -2,7 +2,6 @@ menu "Machine selection"
 
 config SCORE
        def_bool y
-       select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
        select GENERIC_IOMAP
        select GENERIC_ATOMIC64
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 1018ed3..224f4bc 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -26,7 +26,6 @@ config SUPERH
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_GENERIC_HARDIRQS
 	select MAY_HAVE_SPARSE_IRQ
 	select IRQ_FORCED_THREADING
 	select RTC_LIB
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 1570ad2..2137ad6 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -26,7 +26,6 @@ config SPARC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 932fa14..8a7cc66 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -11,7 +11,6 @@ config TILE
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_DEBUG_KMEMLEAK
-	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index bceee66..8ddea1f 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -6,7 +6,6 @@ config DEFCONFIG_LIST
 config UML
 	bool
 	default y
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_UID16
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 08107a7..2665e6b 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -129,12 +129,10 @@ CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_FHANDLE is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HAVE_GENERIC_HARDIRQS=y
 
 #
 # IRQ subsystem
 #
-CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_SHOW=y
 
 #
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 41bcc00..82cdd89 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -2,7 +2,6 @@ config UNICORE32
 	def_bool y
 	select HAVE_MEMBLOCK
 	select HAVE_GENERIC_DMA_COHERENT
-	select HAVE_GENERIC_HARDIRQS
 	select HAVE_DMA_ATTRS
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 30c40f0..e241a19 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,7 +82,6 @@ config X86
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_GENERIC_HARDIRQS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 7ea6451..8d24dcb 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -7,7 +7,6 @@ config XTENSA
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
-	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
index a182a4e..f6000fe 100644
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -8,7 +8,6 @@ CONFIG_XTENSA=y
 # CONFIG_UID16 is not set
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 CONFIG_HAVE_DEC_LOCK=y
-CONFIG_GENERIC_HARDIRQS=y
 
 #
 # Code maturity level options
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 77c52f8..4f23320 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -9,7 +9,6 @@ CONFIG_XTENSA=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_HARDIRQS=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_NO_IOPORT=y
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 4799c6a..d929f77 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -9,7 +9,6 @@ CONFIG_XTENSA=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_HARDIRQS=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_NO_IOPORT=y
diff --git a/drivers/block/mtip32xx/Kconfig b/drivers/block/mtip32xx/Kconfig
index 1fca1f99..0ba837f 100644
--- a/drivers/block/mtip32xx/Kconfig
+++ b/drivers/block/mtip32xx/Kconfig
@@ -4,6 +4,6 @@
 
 config BLK_DEV_PCIESSD_MTIP32XX
 	tristate "Block Device Driver for Micron PCIe SSDs"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	help
           This enables the block driver for Micron PCIe SSDs.
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0d91fe5..7737b5b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -255,10 +255,7 @@
 #include <linux/fips.h>
 #include <linux/ptrace.h>
 #include <linux/kmemcheck.h>
-
-#ifdef CONFIG_GENERIC_HARDIRQS
-# include <linux/irq.h>
-#endif
+#include <linux/irq.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
diff --git a/drivers/dma/dw/Kconfig b/drivers/dma/dw/Kconfig
index dde1324..dcfe964 100644
--- a/drivers/dma/dw/Kconfig
+++ b/drivers/dma/dw/Kconfig
@@ -4,7 +4,6 @@
 
 config DW_DMAC_CORE
 	tristate "Synopsys DesignWare AHB DMA support"
-	depends on GENERIC_HARDIRQS
 	select DMA_ENGINE
 
 config DW_DMAC
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 5cb2181..b6ed304 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -322,7 +322,7 @@ config GPIO_ICH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
@@ -396,7 +396,7 @@ config GPIO_MAX732X
 
 config GPIO_MAX732X_IRQ
 	bool "Interrupt controller support for MAX732x"
-	depends on GPIO_MAX732X=y && GENERIC_HARDIRQS
+	depends on GPIO_MAX732X=y
 	help
 	  Say yes here to enable the max732x to be used as an interrupt
 	  controller. It requires the driver to be built in the kernel.
@@ -661,7 +661,7 @@ config GPIO_TIMBERDALE
 
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select MFD_CORE
 	select MFD_RDC321X
 	help
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3d7c9f6..71b70e3 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -773,7 +773,7 @@ config HID_ZYDACRON
 
 config HID_SENSOR_HUB
 	tristate "HID Sensors framework support"
-	depends on HID && GENERIC_HARDIRQS
+	depends on HID
 	select MFD_CORE
 	default n
 	---help---
diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index e380c6e..7b7ea32 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -75,7 +75,6 @@ config I2C_HELPER_AUTO
 
 config I2C_SMBUS
 	tristate "SMBus-specific protocols" if !I2C_HELPER_AUTO
-	depends on GENERIC_HARDIRQS
 	help
 	  Say Y here if you want support for SMBus extensions to the I2C
 	  specification. At the moment, the only supported extension is
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index fcdd321..cdcbd83 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -115,7 +115,7 @@ config I2C_I801
 
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select LPC_SCH
 	help
 	  Say Y here if you want to use SMBus controller on the Intel SCH
@@ -546,7 +546,6 @@ config I2C_NUC900
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
-	depends on GENERIC_HARDIRQS
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -791,7 +790,7 @@ config I2C_DIOLAN_U2C
 
 config I2C_PARPORT
 	tristate "Parallel port adapter"
-	depends on PARPORT && GENERIC_HARDIRQS
+	depends on PARPORT
 	select I2C_ALGOBIT
 	select I2C_SMBUS
 	help
@@ -816,7 +815,6 @@ config I2C_PARPORT
 
 config I2C_PARPORT_LIGHT
 	tristate "Parallel port adapter (light)"
-	depends on GENERIC_HARDIRQS
 	select I2C_ALGOBIT
 	select I2C_SMBUS
 	help
diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index cbea327..90cf0cd 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig IIO
 	tristate "Industrial I/O support"
-	depends on GENERIC_HARDIRQS
 	help
 	  The industrial I/O subsystem provides a unified framework for
 	  drivers for many different types of embedded sensors using a
diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
index d03ca4c..495be09 100644
--- a/drivers/infiniband/hw/qib/Kconfig
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -8,7 +8,7 @@ config INFINIBAND_QIB
 
 config INFINIBAND_QIB_DCA
 	bool "QIB DCA support"
-	depends on INFINIBAND_QIB && DCA && SMP && GENERIC_HARDIRQS && !(INFINIBAND_QIB=y && DCA=m)
+	depends on INFINIBAND_QIB && DCA && SMP && !(INFINIBAND_QIB=y && DCA=m)
 	default y
 	---help---
 	Setting this enables DCA support on some Intel chip sets
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 269d4c3..c1edd39 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -224,7 +224,7 @@ config KEYBOARD_TCA6416
 
 config KEYBOARD_TCA8418
 	tristate "TCA8418 Keypad Support"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	select INPUT_MATRIXKMAP
 	help
 	  This driver implements basic keypad functionality
@@ -303,7 +303,7 @@ config KEYBOARD_HP7XX
 
 config KEYBOARD_LM8323
 	tristate "LM8323 keypad chip"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	depends on LEDS_CLASS
 	help
 	  If you say yes here you get support for the National Semiconductor
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 1e691a3..33b3e88 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -239,7 +239,6 @@ config SERIO_PS2MULT
 
 config SERIO_ARC_PS2
 	tristate "ARC PS/2 support"
-	depends on GENERIC_HARDIRQS
 	help
 	  Say Y here if you have an ARC FPGA platform with a PS/2
 	  controller in it.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9758b..e09ec67 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -389,7 +389,7 @@ config TOUCHSCREEN_MCS5000
 
 config TOUCHSCREEN_MMS114
 	tristate "MELFAS MMS114 touchscreen"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	help
 	  Say Y here if you have the MELFAS MMS114 touchscreen controller
 	  chip in your system.
@@ -845,7 +845,7 @@ config TOUCHSCREEN_TSC_SERIO
 
 config TOUCHSCREEN_TSC2005
         tristate "TSC2005 based touchscreens"
-        depends on SPI_MASTER && GENERIC_HARDIRQS
+        depends on SPI_MASTER
         help
           Say Y here if you have a TSC2005 based touchscreen.
 
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8068d7b..c7caf94 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -203,7 +203,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 39882dd..6ecdc39 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -214,7 +214,7 @@ config RADIO_TIMBERDALE
 
 config RADIO_WL1273
 	tristate "Texas Instruments WL1273 I2C FM Radio"
-	depends on I2C && VIDEO_V4L2 && GENERIC_HARDIRQS
+	depends on I2C && VIDEO_V4L2
 	select MFD_CORE
 	select MFD_WL1273_CORE
 	select FW_LOADER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e0e46f5..914c3d1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -23,7 +23,7 @@ config MFD_AS3711
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  Support for the AS3711 PMIC from AMS
 
@@ -40,7 +40,7 @@ config PMIC_ADP5520
 config MFD_AAT2870_CORE
 	bool "AnalogicTech AAT2870"
 	select MFD_CORE
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GPIOLIB
 	help
 	  If you say yes here you get support for the AAT2870.
 	  This driver provides common support for accessing the device,
@@ -78,7 +78,7 @@ config MFD_CROS_EC_SPI
 
 config MFD_ASIC3
 	bool "Compaq ASIC3"
-	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
+	depends on GPIOLIB && ARM
 	select MFD_CORE
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
@@ -104,7 +104,7 @@ config MFD_DA9052_SPI
 	select REGMAP_SPI
 	select REGMAP_IRQ
 	select PMIC_DA9052
-	depends on SPI_MASTER=y && GENERIC_HARDIRQS
+	depends on SPI_MASTER=y
 	help
 	  Support for the Dialog Semiconductor DA9052 PMIC
 	  when controlled using SPI. This driver provides common support
@@ -116,7 +116,7 @@ config MFD_DA9052_I2C
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select PMIC_DA9052
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  Support for the Dialog Semiconductor DA9052 PMIC
 	  when controlled using I2C. This driver provides common support
@@ -128,7 +128,7 @@ config MFD_DA9055
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select MFD_CORE
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  Say yes here for support of Dialog Semiconductor DA9055. This is
 	  a Power Management IC. This driver provides common support for
@@ -144,7 +144,7 @@ config MFD_DA9063
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  Say yes here for support for the Dialog Semiconductor DA9063 PMIC.
 	  This includes the I2C driver and core APIs.
@@ -156,7 +156,7 @@ config MFD_MC13783
 
 config MFD_MC13XXX
 	tristate
-	depends on (SPI_MASTER || I2C) && GENERIC_HARDIRQS
+	depends on (SPI_MASTER || I2C)
 	select MFD_CORE
 	select MFD_MC13783
 	help
@@ -167,7 +167,7 @@ config MFD_MC13XXX
 
 config MFD_MC13XXX_SPI
 	tristate "Freescale MC13783 and MC13892 SPI interface"
-	depends on SPI_MASTER && GENERIC_HARDIRQS
+	depends on SPI_MASTER
 	select REGMAP_SPI
 	select MFD_MC13XXX
 	help
@@ -175,7 +175,7 @@ config MFD_MC13XXX_SPI
 
 config MFD_MC13XXX_I2C
 	tristate "Freescale MC13892 I2C interface"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	select REGMAP_I2C
 	select MFD_MC13XXX
 	help
@@ -183,7 +183,7 @@ config MFD_MC13XXX_I2C
 
 config HTC_EGPIO
 	bool "HTC EGPIO support"
-	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
+	depends on GPIOLIB && ARM
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
@@ -192,7 +192,6 @@ config HTC_EGPIO
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
 	select MFD_CORE
-	depends on GENERIC_HARDIRQS
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
@@ -210,7 +209,7 @@ config HTC_I2CPLD
 
 config LPC_ICH
 	tristate "Intel ICH LPC"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select MFD_CORE
 	help
 	  The LPC bridge function of the Intel ICH provides support for
@@ -220,7 +219,7 @@ config LPC_ICH
 
 config LPC_SCH
 	tristate "Intel SCH LPC"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select MFD_CORE
 	help
 	  LPC bridge function of the Intel SCH provides support for
@@ -238,7 +237,7 @@ config MFD_INTEL_MSIC
 config MFD_JANZ_CMODIO
 	tristate "Janz CMOD-IO PCI MODULbus Carrier Board"
 	select MFD_CORE
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	help
 	  This is the core driver for the Janz CMOD-IO PCI MODULbus
 	  carrier board. This device is a PCI to MODULbus bridge which may
@@ -277,7 +276,7 @@ config MFD_KEMPLD
 
 config MFD_88PM800
 	tristate "Marvell 88PM800"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select MFD_CORE
@@ -289,7 +288,7 @@ config MFD_88PM800
 
 config MFD_88PM805
 	tristate "Marvell 88PM805"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select MFD_CORE
@@ -301,7 +300,7 @@ config MFD_88PM805
 
 config MFD_88PM860X
 	bool "Marvell 88PM8606/88PM8607"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select REGMAP_I2C
 	select MFD_CORE
 	help
@@ -312,7 +311,7 @@ config MFD_88PM860X
 
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686 PMIC Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select IRQ_DOMAIN
@@ -325,7 +324,7 @@ config MFD_MAX77686
 
 config MFD_MAX77693
 	bool "Maxim Semiconductor MAX77693 PMIC Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	help
@@ -339,7 +338,7 @@ config MFD_MAX77693
 config MFD_MAX8907
 	tristate "Maxim Semiconductor MAX8907 PMIC Support"
 	select MFD_CORE
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	help
@@ -350,7 +349,7 @@ config MFD_MAX8907
 
 config MFD_MAX8925
 	bool "Maxim Semiconductor MAX8925 PMIC Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8925. This is
@@ -360,7 +359,7 @@ config MFD_MAX8925
 
 config MFD_MAX8997
 	bool "Maxim Semiconductor MAX8997/8966 PMIC Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select IRQ_DOMAIN
 	help
@@ -373,7 +372,7 @@ config MFD_MAX8997
 
 config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select IRQ_DOMAIN
 	help
@@ -385,7 +384,7 @@ config MFD_MAX8998
 
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
-	depends on GENERIC_HARDIRQS && SPI_MASTER
+	depends on SPI_MASTER
 	help
 	  This enables the PCAP ASIC present on EZX Phones. This is
 	  needed for MMC, TouchScreen, Sound, USB, etc..
@@ -393,7 +392,7 @@ config EZX_PCAP
 config MFD_VIPERBOARD
         tristate "Nano River Technologies Viperboard"
 	select MFD_CORE
-	depends on USB && GENERIC_HARDIRQS
+	depends on USB
 	default n
 	help
 	  Say yes here if you want support for Nano River Technologies
@@ -407,7 +406,7 @@ config MFD_VIPERBOARD
 config MFD_RETU
 	tristate "Nokia Retu and Tahvo multi-function device"
 	select MFD_CORE
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	select REGMAP_IRQ
 	help
 	  Retu and Tahvo are a multi-function devices found on Nokia
@@ -480,7 +479,7 @@ config MFD_PM8XXX_IRQ
 config MFD_RDC321X
 	tristate "RDC R-321x southbridge"
 	select MFD_CORE
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	help
 	  Say yes here if you want to have support for the RDC R-321x SoC
 	  southbridge which provides access to GPIOs and Watchdog using the
@@ -488,7 +487,7 @@ config MFD_RDC321X
 
 config MFD_RTSX_PCI
 	tristate "Realtek PCI-E card reader"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select MFD_CORE
 	help
 	  This supports for Realtek PCI-Express card reader including rts5209,
@@ -498,7 +497,7 @@ config MFD_RTSX_PCI
 
 config MFD_RC5T583
 	bool "Ricoh RC5T583 Power Management system device"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	help
@@ -512,7 +511,7 @@ config MFD_RC5T583
 
 config MFD_SEC_CORE
 	bool "SAMSUNG Electronics PMIC Series Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -555,7 +554,7 @@ config MFD_SM501_GPIO
 
 config MFD_SMSC
        bool "SMSC ECE1099 series chips"
-       depends on I2C=y && GENERIC_HARDIRQS
+       depends on I2C=y
        select MFD_CORE
        select REGMAP_I2C
        help
@@ -577,7 +576,7 @@ config ABX500_CORE
 
 config AB3100_CORE
 	bool "ST-Ericsson AB3100 Mixed Signal Circuit core functions"
-	depends on I2C=y && ABX500_CORE && GENERIC_HARDIRQS
+	depends on I2C=y && ABX500_CORE
 	select MFD_CORE
 	default y if ARCH_U300
 	help
@@ -601,7 +600,7 @@ config AB3100_OTP
 
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
-	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
+	depends on ABX500_CORE && MFD_DB8500_PRCMU
 	select POWER_SUPPLY
 	select MFD_CORE
 	select IRQ_DOMAIN
@@ -639,7 +638,7 @@ config MFD_DB8500_PRCMU
 
 config MFD_STMPE
 	bool "STMicroelectronics STMPE"
-	depends on (I2C=y || SPI_MASTER=y) && GENERIC_HARDIRQS
+	depends on (I2C=y || SPI_MASTER=y)
 	select MFD_CORE
 	help
 	  Support for the STMPE family of I/O Expanders from
@@ -680,7 +679,7 @@ endmenu
 
 config MFD_STA2X11
 	bool "STMicroelectronics STA2X11"
-	depends on STA2X11 && GENERIC_HARDIRQS
+	depends on STA2X11
 	select MFD_CORE
 	select REGMAP_MMIO
 
@@ -700,7 +699,6 @@ config MFD_TI_AM335X_TSCADC
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-	depends on GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for Texas Instruments series
 	  of Touch Screen /ADC chips.
@@ -717,7 +715,7 @@ config MFD_DM355EVM_MSP
 
 config MFD_LP8788
 	bool "TI LP8788 Power Management Unit Driver"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select IRQ_DOMAIN
@@ -739,14 +737,14 @@ config MFD_PALMAS
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  If you say yes here you get support for the Palmas
 	  series of PMIC chips from Texas Instruments.
 
 config MFD_TI_SSP
 	tristate "TI Sequencer Serial Port support"
-	depends on ARCH_DAVINCI_TNETV107X && GENERIC_HARDIRQS
+	depends on ARCH_DAVINCI_TNETV107X
 	select MFD_CORE
 	---help---
 	  Say Y here if you want support for the Sequencer Serial Port
@@ -761,7 +759,6 @@ config TPS6105X
 	select REGULATOR
 	select MFD_CORE
 	select REGULATOR_FIXED_VOLTAGE
-	depends on GENERIC_HARDIRQS
 	help
 	  This option enables a driver for the TP61050/TPS61052
 	  high-power "white LED driver". This boost converter is
@@ -784,7 +781,7 @@ config TPS65010
 config TPS6507X
 	tristate "TI TPS6507x Power Management / Touch Screen chips"
 	select MFD_CORE
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	help
 	  If you say yes here you get support for the TPS6507x series of
 	  Power Management / Touch Screen chips.  These include voltage
@@ -798,7 +795,7 @@ config TPS65911_COMPARATOR
 
 config MFD_TPS65090
 	bool "TI TPS65090 Power Management chips"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -811,7 +808,7 @@ config MFD_TPS65090
 
 config MFD_TPS65217
 	tristate "TI TPS65217 Power Management / White LED chips"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	select MFD_CORE
 	select REGMAP_I2C
 	help
@@ -826,7 +823,7 @@ config MFD_TPS65217
 
 config MFD_TPS6586X
 	bool "TI TPS6586x Power Management chips"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	help
@@ -841,7 +838,7 @@ config MFD_TPS6586X
 
 config MFD_TPS65910
 	bool "TI TPS65910 Power Management chip"
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GPIOLIB
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -862,7 +859,7 @@ config MFD_TPS65912_I2C
 	bool "TI TPS65912 Power Management chip with I2C"
 	select MFD_CORE
 	select MFD_TPS65912
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GPIOLIB
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips with I2C interface.
@@ -871,14 +868,14 @@ config MFD_TPS65912_SPI
 	bool "TI TPS65912 Power Management chip with SPI"
 	select MFD_CORE
 	select MFD_TPS65912
-	depends on SPI_MASTER && GPIOLIB && GENERIC_HARDIRQS
+	depends on SPI_MASTER && GPIOLIB
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips with SPI interface.
 
 config MFD_TPS80031
 	bool "TI TPS80031/TPS80032 Power Management chips"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -892,7 +889,7 @@ config MFD_TPS80031
 
 config TWL4030_CORE
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	help
@@ -931,13 +928,13 @@ config TWL4030_POWER
 
 config MFD_TWL4030_AUDIO
 	bool "TI TWL4030 Audio"
-	depends on TWL4030_CORE && GENERIC_HARDIRQS
+	depends on TWL4030_CORE
 	select MFD_CORE
 	default n
 
 config TWL6040_CORE
 	bool "TI TWL6040 audio codec"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -961,7 +958,7 @@ config MENELAUS
 
 config MFD_WL1273_CORE
 	tristate "TI WL1273 FM radio"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	select MFD_CORE
 	default n
 	help
@@ -974,7 +971,6 @@ config MFD_LM3533
 	depends on I2C
 	select MFD_CORE
 	select REGMAP_I2C
-	depends on GENERIC_HARDIRQS
 	help
 	  Say yes here to enable support for National Semiconductor / TI
 	  LM3533 Lighting Power chips.
@@ -996,7 +992,7 @@ config MFD_TIMBERDALE
 
 config MFD_TC3589X
 	bool "Toshiba TC35892 and variants"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	help
 	  Support for the Toshiba TC35892 and variants I/O Expander.
@@ -1011,7 +1007,7 @@ config MFD_TMIO
 
 config MFD_T7L66XB
 	bool "Toshiba T7L66XB"
-	depends on ARM && HAVE_CLK && GENERIC_HARDIRQS
+	depends on ARM && HAVE_CLK
 	select MFD_CORE
 	select MFD_TMIO
 	help
@@ -1036,7 +1032,7 @@ config MFD_TC6393XB
 
 config MFD_VX855
 	tristate "VIA VX855/VX875 integrated south bridge"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select MFD_CORE
 	help
 	  Say yes here to enable support for various functions of the
@@ -1054,7 +1050,7 @@ config MFD_ARIZONA_I2C
 	select MFD_ARIZONA
 	select MFD_CORE
 	select REGMAP_I2C
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C
 	help
 	  Support for the Wolfson Microelectronics Arizona platform audio SoC
 	  core functionality controlled via I2C.
@@ -1064,7 +1060,7 @@ config MFD_ARIZONA_SPI
 	select MFD_ARIZONA
 	select MFD_CORE
 	select REGMAP_SPI
-	depends on SPI_MASTER && GENERIC_HARDIRQS
+	depends on SPI_MASTER
 	help
 	  Support for the Wolfson Microelectronics Arizona platform audio SoC
 	  core functionality controlled via I2C.
@@ -1090,7 +1086,7 @@ config MFD_WM8997
 config MFD_WM8400
 	bool "Wolfson Microelectronics WM8400"
 	select MFD_CORE
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select REGMAP_I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
@@ -1100,7 +1096,6 @@ config MFD_WM8400
 
 config MFD_WM831X
 	bool
-	depends on GENERIC_HARDIRQS
 
 config MFD_WM831X_I2C
 	bool "Wolfson Microelectronics WM831x/2x PMICs with I2C"
@@ -1108,7 +1103,7 @@ config MFD_WM831X_I2C
 	select MFD_WM831X
 	select REGMAP_I2C
 	select IRQ_DOMAIN
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
 	  when controlled using I2C.  This driver provides common support
@@ -1121,7 +1116,7 @@ config MFD_WM831X_SPI
 	select MFD_WM831X
 	select REGMAP_SPI
 	select IRQ_DOMAIN
-	depends on SPI_MASTER && GENERIC_HARDIRQS
+	depends on SPI_MASTER
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
 	  when controlled using SPI.  This driver provides common support
@@ -1130,12 +1125,11 @@ config MFD_WM831X_SPI
 
 config MFD_WM8350
 	bool
-	depends on GENERIC_HARDIRQS
 
 config MFD_WM8350_I2C
 	bool "Wolfson Microelectronics WM8350 with I2C"
 	select MFD_WM8350
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  The WM8350 is an integrated audio and power management
 	  subsystem with watchdog and RTC functionality for embedded
@@ -1148,7 +1142,7 @@ config MFD_WM8994
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
 	  smartphone applicatiosn.  As well as audio functionality it
diff --git a/drivers/misc/cb710/Kconfig b/drivers/misc/cb710/Kconfig
index 5acb9c5..22429b8 100644
--- a/drivers/misc/cb710/Kconfig
+++ b/drivers/misc/cb710/Kconfig
@@ -1,6 +1,6 @@
 config CB710_CORE
 	tristate "ENE CB710/720 Flash memory card reader support"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	help
 	  This option enables support for PCI ENE CB710/720 Flash memory card
 	  reader found in some laptops (ie. some versions of HP Compaq nx9500).
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index b7fd5ab..7fc5099 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -487,7 +487,7 @@ config MMC_SDHI
 
 config MMC_CB710
 	tristate "ENE CB710 MMC/SD Interface support"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	select CB710_CORE
 	help
 	  This option enables support for MMC/SD part of ENE CB710/720 Flash
diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 8030cc0..751d5c7 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -22,7 +22,7 @@ if NET_CADENCE
 
 config ARM_AT91_ETHER
 	tristate "AT91RM9200 Ethernet support"
-	depends on GENERIC_HARDIRQS && HAS_DMA
+	depends on HAS_DMA
 	select MACB
 	---help---
 	  If you wish to compile a kernel for the AT91RM9200 and enable
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 15ea36b..cdafb8c 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -41,7 +41,7 @@ config P54_PCI
 
 config P54_SPI
 	tristate "Prism54 SPI (stlc45xx) support"
-	depends on P54_COMMON && SPI_MASTER && GENERIC_HARDIRQS
+	depends on P54_COMMON && SPI_MASTER
 	---help---
 	  This driver is for stlc4550 or stlc4560 based wireless chips
 	  such as Nokia's N800/N810 Portable Internet Tablet.
diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
index 8fec4ed..477a206 100644
--- a/drivers/net/wireless/ti/wl1251/Kconfig
+++ b/drivers/net/wireless/ti/wl1251/Kconfig
@@ -1,6 +1,6 @@
 menuconfig WL1251
 	tristate "TI wl1251 driver support"
-	depends on MAC80211 && GENERIC_HARDIRQS
+	depends on MAC80211
 	select FW_LOADER
 	select CRC7
 	---help---
diff --git a/drivers/net/wireless/ti/wlcore/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
index 2b83282..7c09954 100644
--- a/drivers/net/wireless/ti/wlcore/Kconfig
+++ b/drivers/net/wireless/ti/wlcore/Kconfig
@@ -1,6 +1,6 @@
 config WLCORE
 	tristate "TI wlcore support"
-	depends on WL_TI && GENERIC_HARDIRQS && MAC80211
+	depends on WL_TI && MAC80211
 	select FW_LOADER
 	---help---
 	  This module contains the main code for TI WLAN chips.  It abstracts
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b35f93c..d5f90d6 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -30,7 +30,6 @@ static int pci_msi_enable = 1;
 
 /* Arch hooks */
 
-#if defined(CONFIG_GENERIC_HARDIRQS)
 int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
 	struct msi_chip *chip = dev->bus->msi;
@@ -67,21 +66,6 @@ int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 
 	return chip->check_device(chip, dev, nvec, type);
 }
-#else
-int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
-{
-	return -ENOSYS;
-}
-
-void __weak arch_teardown_msi_irq(unsigned int irq)
-{
-}
-
-int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
-{
-	return 0;
-}
-#endif /* CONFIG_GENERIC_HARDIRQS */
 
 int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
@@ -245,8 +229,6 @@ static void msix_mask_irq(struct msi_desc *desc, u32 flag)
 	desc->masked = __msix_mask_irq(desc, flag);
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-
 static void msi_set_mask_bit(struct irq_data *data, u32 flag)
 {
 	struct msi_desc *desc = irq_data_get_msi(data);
@@ -270,8 +252,6 @@ void unmask_msi_irq(struct irq_data *data)
 	msi_set_mask_bit(data, 0);
 }
 
-#endif /* CONFIG_GENERIC_HARDIRQS */
-
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
@@ -382,10 +362,8 @@ static void free_msi_irqs(struct pci_dev *dev)
 			nvec = entry->nvec_used;
 		else
 			nvec = 1 << entry->msi_attrib.multiple;
-#ifdef CONFIG_GENERIC_HARDIRQS
 		for (i = 0; i < nvec; i++)
 			BUG_ON(irq_has_action(entry->irq + i));
-#endif
 	}
 
 	arch_teardown_msi_irqs(dev);
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index bb49ab6..e6f92b4 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -269,7 +269,6 @@ config CHARGER_ISP1704
 
 config CHARGER_MAX8903
 	tristate "MAX8903 Battery DC-DC Charger for USB and Adapter Power"
-	depends on GENERIC_HARDIRQS
 	help
 	  Say Y to enable support for the MAX8903 DC-DC charger and sysfs.
 	  The driver supports controlling charger-enable and current-limit
@@ -370,7 +369,7 @@ config AB8500_BM
 
 config BATTERY_GOLDFISH
 	tristate "Goldfish battery driver"
-	depends on GENERIC_HARDIRQS && (GOLDFISH || COMPILE_TEST)
+	depends on GOLDFISH || COMPILE_TEST
 	help
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 6efd9b6..0c9f280 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -31,7 +31,7 @@ config PPS_CLIENT_PARPORT
 
 config PPS_CLIENT_GPIO
 	tristate "PPS client using GPIO"
-	depends on PPS && GENERIC_HARDIRQS
+	depends on PPS
 	help
 	  If you say yes here you get support for a PPS source using
 	  GPIO. To be useful you must also register a platform device
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 0170d4c..b9c53cc 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -55,7 +55,6 @@ comment "SPI Master Controller Drivers"
 
 config SPI_ALTERA
 	tristate "Altera SPI Controller"
-	depends on GENERIC_HARDIRQS
 	select SPI_BITBANG
 	help
 	  This is the driver for the Altera SPI Controller.
@@ -358,7 +357,7 @@ config SPI_PXA2XX_DMA
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on (ARCH_PXA || PCI || ACPI) && GENERIC_HARDIRQS
+	depends on (ARCH_PXA || PCI || ACPI)
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 47c6e7b..febd45c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -5,7 +5,7 @@
 if TTY
 
 menu "Serial drivers"
-	depends on HAS_IOMEM && GENERIC_HARDIRQS
+	depends on HAS_IOMEM
 
 source "drivers/tty/serial/8250/Kconfig"
 
diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index f969ea2..b870872 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,6 +1,6 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
-	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
+	depends on (USB || USB_GADGET) && HAS_DMA
 	depends on EXTCON
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 30e2dd8..48cddf3 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -313,7 +313,7 @@ config USB_S3C_HSUDC
 
 config USB_MV_UDC
 	tristate "Marvell USB2.0 Device Controller"
-	depends on GENERIC_HARDIRQS && HAS_DMA
+	depends on HAS_DMA
 	help
 	  Marvell Socs (including PXA and MMP series) include a high speed
 	  USB2.0 OTG controller, which can be configured as high speed or
@@ -425,7 +425,7 @@ config USB_GOKU
 
 config USB_EG20T
 	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
-	depends on PCI && GENERIC_HARDIRQS
+	depends on PCI
 	help
 	  This is a USB device driver for EG20T PCH.
 	  EG20T PCH is the platform controller hub that is used in Intel's
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 5be0326..b3f20d7 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -278,7 +278,6 @@ endif # USB_EHCI_HCD
 
 config USB_OXU210HP_HCD
 	tristate "OXU210HP HCD support"
-	depends on GENERIC_HARDIRQS
 	---help---
 	  The OXU210HP is an USB host/OTG/device controller. Enable this
 	  option if your board has this chip. If unsure, say N.
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index c64ee09a7..c258a97 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -71,7 +71,6 @@ config USB_MUSB_DA8XX
 
 config USB_MUSB_TUSB6010
 	tristate "TUSB6010"
-	depends on GENERIC_HARDIRQS
 
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
diff --git a/drivers/usb/renesas_usbhs/Kconfig b/drivers/usb/renesas_usbhs/Kconfig
index 019bf7e..1c4195a 100644
--- a/drivers/usb/renesas_usbhs/Kconfig
+++ b/drivers/usb/renesas_usbhs/Kconfig
@@ -4,7 +4,7 @@
 
 config USB_RENESAS_USBHS
 	tristate 'Renesas USBHS controller'
-	depends on USB_GADGET && GENERIC_HARDIRQS
+	depends on USB_GADGET
 	default n
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 2bd1257..efc7f07 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -42,7 +42,7 @@ config W1_MASTER_MXC
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1 && GENERIC_HARDIRQS
+	depends on W1
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
index 1739510..bdd18ca 100644
--- a/include/linux/cpu_rmap.h
+++ b/include/linux/cpu_rmap.h
@@ -52,8 +52,6 @@ static inline void *cpu_rmap_lookup_obj(struct cpu_rmap *rmap, unsigned int cpu)
 	return rmap->obj[rmap->near[cpu].index];
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-
 /**
  * alloc_irq_cpu_rmap - allocate CPU affinity reverse-map for IRQs
  * @size: Number of objects to be mapped
@@ -68,5 +66,4 @@ extern void free_irq_cpu_rmap(struct cpu_rmap *rmap);
 
 extern int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq);
 
-#endif
 #endif /* __LINUX_CPU_RMAP_H */
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ccfe17c..1e04106 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -7,11 +7,7 @@
 #include <linux/vtime.h>
 
 
-#if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
 extern void synchronize_irq(unsigned int irq);
-#else
-# define synchronize_irq(irq)	barrier()
-#endif
 
 #if defined(CONFIG_TINY_RCU)
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5fa5afe..5e865b5 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -120,7 +120,6 @@ struct irqaction {
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check
 request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		     irq_handler_t thread_fn,
@@ -140,40 +139,6 @@ request_any_context_irq(unsigned int irq, irq_handler_t handler,
 extern int __must_check
 request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		   const char *devname, void __percpu *percpu_dev_id);
-#else
-
-extern int __must_check
-request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
-	    const char *name, void *dev);
-
-/*
- * Special function to avoid ifdeffery in kernel/irq/devres.c which
- * gets magically built by GENERIC_HARDIRQS=n architectures (sparc,
- * m68k). I really love these $@%#!* obvious Makefile references:
- * ../../../kernel/irq/devres.o
- */
-static inline int __must_check
-request_threaded_irq(unsigned int irq, irq_handler_t handler,
-		     irq_handler_t thread_fn,
-		     unsigned long flags, const char *name, void *dev)
-{
-	return request_irq(irq, handler, flags, name, dev);
-}
-
-static inline int __must_check
-request_any_context_irq(unsigned int irq, irq_handler_t handler,
-			unsigned long flags, const char *name, void *dev_id)
-{
-	return request_irq(irq, handler, flags, name, dev_id);
-}
-
-static inline int __must_check
-request_percpu_irq(unsigned int irq, irq_handler_t handler,
-		   const char *devname, void __percpu *percpu_dev_id)
-{
-	return request_irq(irq, handler, 0, devname, percpu_dev_id);
-}
-#endif
 
 extern void free_irq(unsigned int, void *);
 extern void free_percpu_irq(unsigned int, void __percpu *);
@@ -221,7 +186,6 @@ extern void enable_irq(unsigned int irq);
 extern void enable_percpu_irq(unsigned int irq, unsigned int type);
 
 /* The following three functions are for the core kernel use only. */
-#ifdef CONFIG_GENERIC_HARDIRQS
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
 #ifdef CONFIG_PM_SLEEP
@@ -229,13 +193,8 @@ extern int check_wakeup_irqs(void);
 #else
 static inline int check_wakeup_irqs(void) { return 0; }
 #endif
-#else
-static inline void suspend_device_irqs(void) { };
-static inline void resume_device_irqs(void) { };
-static inline int check_wakeup_irqs(void) { return 0; }
-#endif
 
-#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
+#if defined(CONFIG_SMP)
 
 extern cpumask_var_t irq_default_affinity;
 
@@ -287,9 +246,8 @@ static inline int irq_set_affinity_hint(unsigned int irq,
 {
 	return -EINVAL;
 }
-#endif /* CONFIG_SMP && CONFIG_GENERIC_HARDIRQS */
+#endif /* CONFIG_SMP */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 /*
  * Special lockdep variants of irq disabling/enabling.
  * These should be used for locking constructs that
@@ -354,33 +312,6 @@ static inline int disable_irq_wake(unsigned int irq)
 	return irq_set_irq_wake(irq, 0);
 }
 
-#else /* !CONFIG_GENERIC_HARDIRQS */
-/*
- * NOTE: non-genirq architectures, if they want to support the lock
- * validator need to define the methods below in their asm/irq.h
- * files, under an #ifdef CONFIG_LOCKDEP section.
- */
-#ifndef CONFIG_LOCKDEP
-#  define disable_irq_nosync_lockdep(irq)	disable_irq_nosync(irq)
-#  define disable_irq_nosync_lockdep_irqsave(irq, flags) \
-						disable_irq_nosync(irq)
-#  define disable_irq_lockdep(irq)		disable_irq(irq)
-#  define enable_irq_lockdep(irq)		enable_irq(irq)
-#  define enable_irq_lockdep_irqrestore(irq, flags) \
-						enable_irq(irq)
-# endif
-
-static inline int enable_irq_wake(unsigned int irq)
-{
-	return 0;
-}
-
-static inline int disable_irq_wake(unsigned int irq)
-{
-	return 0;
-}
-#endif /* CONFIG_GENERIC_HARDIRQS */
-
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 extern bool force_irqthreads;
@@ -655,7 +586,7 @@ void tasklet_hrtimer_cancel(struct tasklet_hrtimer *ttimer)
  * if more than one irq occurred.
  */
 
-#if defined(CONFIG_GENERIC_HARDIRQS) && !defined(CONFIG_GENERIC_IRQ_PROBE) 
+#if !defined(CONFIG_GENERIC_IRQ_PROBE) 
 static inline unsigned long probe_irq_on(void)
 {
 	return 0;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index f04d3ba..56bb0dc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -382,8 +382,6 @@ extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
 extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void irq_move_irq(struct irq_data *data);
 void irq_move_masked_irq(struct irq_data *data);
@@ -802,11 +800,4 @@ static inline void irq_gc_lock(struct irq_chip_generic *gc) { }
 static inline void irq_gc_unlock(struct irq_chip_generic *gc) { }
 #endif
 
-#else /* !CONFIG_GENERIC_HARDIRQS */
-
-extern struct msi_desc *irq_get_msi_desc(unsigned int irq);
-extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
-
-#endif /* CONFIG_GENERIC_HARDIRQS */
-
 #endif /* _LINUX_IRQ_H */
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 623325e..56fb646 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -76,8 +76,6 @@ struct irq_desc {
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-
 static inline struct irq_data *irq_desc_get_irq_data(struct irq_desc *desc)
 {
 	return &desc->irq_data;
@@ -173,6 +171,5 @@ __irq_set_preflow_handler(unsigned int irq, irq_preflow_handler_t handler)
 	desc->preflow_handler = handler;
 }
 #endif
-#endif
 
 #endif
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 0a2dc46..fdd5cc1 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -4,23 +4,6 @@
 #include <uapi/linux/irqnr.h>
 
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-#include <asm/irq.h>
-
-/*
- * Wrappers for non-genirq architectures:
- */
-#define nr_irqs			NR_IRQS
-#define irq_to_desc(irq)	(&irq_desc[irq])
-
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0; irq < nr_irqs; irq++)
-
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1; irq >= 0; irq--)
-
-#else /* CONFIG_GENERIC_HARDIRQS */
-
 extern int nr_irqs;
 extern struct irq_desc *irq_to_desc(unsigned int irq);
 unsigned int irq_get_next_irq(unsigned int offset);
@@ -50,8 +33,6 @@ unsigned int irq_get_next_irq(unsigned int offset);
 	for (irq = irq_get_next_irq(0); irq < nr_irqs;	\
 	     irq = irq_get_next_irq(irq + 1))
 
-#endif /* CONFIG_GENERIC_HARDIRQS */
-
 #define for_each_irq_nr(irq)                   \
        for (irq = 0; irq < nr_irqs; irq++)
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ed5f6ed..51c72be 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -36,9 +36,6 @@ struct kernel_cpustat {
 };
 
 struct kernel_stat {
-#ifndef CONFIG_GENERIC_HARDIRQS
-       unsigned int irqs[NR_IRQS];
-#endif
 	unsigned long irqs_sum;
 	unsigned int softirqs[NR_SOFTIRQS];
 };
@@ -54,22 +51,6 @@ DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 extern unsigned long long nr_context_switches(void);
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-
-struct irq_desc;
-
-static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
-					    struct irq_desc *desc)
-{
-	__this_cpu_inc(kstat.irqs[irq]);
-	__this_cpu_inc(kstat.irqs_sum);
-}
-
-static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
-{
-       return kstat_cpu(cpu).irqs[irq];
-}
-#else
 #include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 
@@ -79,8 +60,6 @@ do {							\
 	__this_cpu_inc(kstat.irqs_sum);			\
 } while (0)
 
-#endif
-
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
 	__this_cpu_inc(kstat.softirqs[irq]);
@@ -94,20 +73,7 @@ static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
-#ifndef CONFIG_GENERIC_HARDIRQS
-static inline unsigned int kstat_irqs(unsigned int irq)
-{
-	unsigned int sum = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		sum += kstat_irqs_cpu(irq, cpu);
-
-	return sum;
-}
-#else
 extern unsigned int kstat_irqs(unsigned int irq);
-#endif
 
 /*
  * Number of interrupts per cpu, since bootup
diff --git a/kernel/Makefile b/kernel/Makefile
index 35ef118..1ce4755 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -26,6 +26,7 @@ obj-y += sched/
 obj-y += power/
 obj-y += printk/
 obj-y += cpu/
+obj-y += irq/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
@@ -79,7 +80,6 @@ obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
-obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index d1a758b..4a1fef0 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -1,15 +1,4 @@
-# Select this to activate the generic irq options below
-config HAVE_GENERIC_HARDIRQS
-	bool
-
-if HAVE_GENERIC_HARDIRQS
 menu "IRQ subsystem"
-#
-# Interrupt subsystem related configuration options
-#
-config GENERIC_HARDIRQS
-       def_bool y
-
 # Options selectable by the architecture code
 
 # Make sparse irq Kconfig switch below available
@@ -84,4 +73,3 @@ config SPARSE_IRQ
 	  If you don't know what to do here, say N.
 
 endmenu
-endif
diff --git a/kernel/softirq.c b/kernel/softirq.c
index be3d351..53cc09c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -876,7 +876,6 @@ int __init __weak early_irq_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 int __init __weak arch_probe_nr_irqs(void)
 {
 	return NR_IRQS_LEGACY;
@@ -886,4 +885,3 @@ int __init __weak arch_early_irq_init(void)
 {
 	return 0;
 }
-#endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c9eef36..06344d9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -597,7 +597,7 @@ endmenu # "Memory Debugging"
 
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
-	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	depends on DEBUG_KERNEL
 	help
 	  Enable this to generate a spurious interrupt as soon as a shared
 	  interrupt handler is registered, and just before one is deregistered.
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index 5fbed5c..4f134d8 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -8,9 +8,7 @@
  */
 
 #include <linux/cpu_rmap.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/interrupt.h>
-#endif
 #include <linux/export.h>
 
 /*
@@ -213,8 +211,6 @@ int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
 }
 EXPORT_SYMBOL(cpu_rmap_update);
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-
 /* Glue between IRQ affinity notifiers and CPU rmaps */
 
 struct irq_glue {
@@ -309,5 +305,3 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
 	return rc;
 }
 EXPORT_SYMBOL(irq_cpu_rmap_add);
-
-#endif /* CONFIG_GENERIC_HARDIRQS */
diff --git a/net/Kconfig b/net/Kconfig
index ee02136..b50dacc 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -228,7 +228,7 @@ config RPS
 
 config RFS_ACCEL
 	boolean
-	depends on RPS && GENERIC_HARDIRQS
+	depends on RPS
 	select CPU_RMAP
 	default y
 
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 15106c0..b33b45d 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -107,7 +107,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_WM8782
 	select SND_SOC_WM8804 if SND_SOC_I2C_AND_SPI
 	select SND_SOC_WM8900 if I2C
-	select SND_SOC_WM8903 if I2C && GENERIC_HARDIRQS
+	select SND_SOC_WM8903 if I2C
 	select SND_SOC_WM8904 if I2C
 	select SND_SOC_WM8940 if I2C
 	select SND_SOC_WM8955 if I2C
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 9855dfc..2eea184 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -63,7 +63,7 @@ config SND_SOC_SAMSUNG_SMDK_WM8580
 config SND_SOC_SAMSUNG_SMDK_WM8994
 	tristate "SoC I2S Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_I2S
@@ -151,7 +151,7 @@ config SND_SOC_SMARTQ
 config SND_SOC_GONI_AQUILA_WM8994
 	tristate "SoC I2S Audio support for AQUILA/GONI - WM8994"
 	depends on SND_SOC_SAMSUNG && (MACH_GONI || MACH_AQUILA)
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select SND_SAMSUNG_I2S
 	select MFD_WM8994
 	select SND_SOC_WM8994
@@ -177,7 +177,7 @@ config SND_SOC_SMDK_WM8580_PCM
 config SND_SOC_SMDK_WM8994_PCM
 	tristate "SoC PCM Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_PCM

