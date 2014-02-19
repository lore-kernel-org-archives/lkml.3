Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaBSX4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:56:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44177 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBSX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:56:37 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] rename HAS_IOPORT to HAS_IOPORT_MAP
Date: Thu, 20 Feb 2014 00:56:30 +0100
Message-Id: <1392854190-29596-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the renamed symbol is defined lib/iomap.c implements ioport_map and
ioport_unmap and currently (nearly) all platforms define the port
accessor functions outb/inb and friend unconditionally. So
HAS_IOPORT_MAP is the better name for this. Consequently NO_IOPORT is
renamed to NO_IOPORT_MAP.

The motivation for this change is to reintroduce a symbol HAS_IOPORT
that signals if outb/int et al are available. I will address that
at least one merge window later though to keep surprises to a minimum
and catch new introductions of (HAS|NO)_IOPORT.

The changes in this commit were done using:

	$ git grep -l -E '(NO|HAS)_IOPORT' | xargs perl -p -i -e 's/\b((?:CONFIG_)?(?:NO|HAS)_IOPORT)\b/$1_MAP/'

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

the patch was created on top of e95003c3f9cc (which is current Linus'
master). When applying it to next-20140219 there is a simple conflict in
arch/arm/mach-shmobile/Kconfig. There are no relevant changes in
next-20140219, so all occurrences are fixed there, too.

Best regards
Uwe

 arch/arc/Kconfig                    |  2 +-
 arch/arm/Kconfig                    | 12 ++++++------
 arch/arm/mach-picoxcell/Kconfig     |  2 +-
 arch/arm/mach-prima2/Kconfig        |  2 +-
 arch/arm/mach-s3c24xx/Kconfig       |  2 +-
 arch/arm/mach-shmobile/Kconfig      |  2 +-
 arch/arm/mach-vexpress/Kconfig      |  2 +-
 arch/arm/plat-samsung/Kconfig       |  4 ++--
 arch/arm64/Kconfig                  |  2 +-
 arch/cris/Kconfig                   |  2 +-
 arch/hexagon/Kconfig                |  2 +-
 arch/m32r/Kconfig                   |  2 +-
 arch/m68k/Kconfig                   |  2 +-
 arch/metag/Kconfig                  |  2 +-
 arch/mips/Kconfig                   |  4 ++--
 arch/openrisc/Kconfig               |  2 +-
 arch/s390/Kconfig                   |  2 +-
 arch/sh/Kconfig                     |  4 ++--
 arch/sh/boards/Kconfig              |  8 ++++----
 arch/sh/include/asm/io.h            |  4 ++--
 arch/sh/include/asm/io_trapped.h    |  2 +-
 arch/sh/include/asm/machvec.h       |  2 +-
 arch/sh/kernel/Makefile             |  2 +-
 arch/sh/kernel/io_trapped.c         |  4 ++--
 arch/tile/Kconfig                   |  2 +-
 arch/unicore32/Kconfig              |  2 +-
 arch/xtensa/Kconfig                 |  4 ++--
 arch/xtensa/configs/iss_defconfig   |  2 +-
 arch/xtensa/configs/s6105_defconfig |  2 +-
 drivers/char/tpm/Kconfig            |  2 +-
 drivers/i2c/busses/Kconfig          |  2 +-
 drivers/net/can/sja1000/Kconfig     |  2 +-
 drivers/net/ethernet/3com/Kconfig   |  2 +-
 include/asm-generic/io.h            |  4 ++--
 include/asm-generic/iomap.h         |  2 +-
 include/linux/io.h                  |  2 +-
 lib/Kconfig                         |  4 ++--
 lib/devres.c                        |  4 ++--
 lib/iomap.c                         |  4 ++--
 sound/isa/Kconfig                   |  2 +-
 sound/pci/Kconfig                   |  2 +-
 41 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 9be30c8cb0c2..0434a89e05f8 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -57,7 +57,7 @@ config ARCH_FLATMEM_ENABLE
 config MMU
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config GENERIC_CALIBRATE_DELAY
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e25419817791..4f01ae12f2b2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -129,7 +129,7 @@ config HAVE_TCM
 config HAVE_PROC_CPU
 	bool
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	bool
 
 config EISA
@@ -409,7 +409,7 @@ config ARCH_EBSA110
 	select ISA
 	select NEED_MACH_IO_H
 	select NEED_MACH_MEMORY_H
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -429,7 +429,7 @@ config ARCH_EFM32
 	select CPU_V7M
 	select GENERIC_CLOCKEVENTS
 	select NO_DMA
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select SPARSE_IRQ
 	select USE_OF
 	help
@@ -682,7 +682,7 @@ config ARCH_SHMOBILE_LEGACY
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	select MULTI_IRQ_HANDLER
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PINCTRL
 	select PM_GENERIC_DOMAINS if PM
 	select SPARSE_IRQ
@@ -703,7 +703,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NEED_MACH_IO_H
 	select NEED_MACH_MEMORY_H
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select VIRT_TO_BUS
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
@@ -762,7 +762,7 @@ config ARCH_S3C64XX
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_TCM
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PLAT_SAMSUNG
 	select PM_GENERIC_DOMAINS
 	select S3C_DEV_NAND
diff --git a/arch/arm/mach-picoxcell/Kconfig b/arch/arm/mach-picoxcell/Kconfig
index b1022f4315f7..c03cd6ffb429 100644
--- a/arch/arm/mach-picoxcell/Kconfig
+++ b/arch/arm/mach-picoxcell/Kconfig
@@ -7,6 +7,6 @@ config ARCH_PICOXCELL
 	select DW_APB_TIMER_OF
 	select GENERIC_CLOCKEVENTS
 	select HAVE_TCM
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select SPARSE_IRQ
 	select USE_OF
diff --git a/arch/arm/mach-prima2/Kconfig b/arch/arm/mach-prima2/Kconfig
index 6988b117fc17..850ff5500821 100644
--- a/arch/arm/mach-prima2/Kconfig
+++ b/arch/arm/mach-prima2/Kconfig
@@ -4,7 +4,7 @@ config ARCH_SIRF
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
 	select MIGHT_HAVE_CACHE_L2X0
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PINCTRL
 	select PINCTRL_SIRF
 	help
diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index d876431d64c0..de2529d892d2 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -12,7 +12,7 @@ if ARCH_S3C24XX
 config PLAT_S3C24XX
 	def_bool y
 	select ARCH_REQUIRE_GPIOLIB
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select S3C_DEV_NAND
 	select IRQ_DOMAIN
 	help
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 05fa505df585..dac2941fa383 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -13,7 +13,7 @@ config ARCH_SHMOBILE_MULTI
 	select ARM_GIC
 	select MIGHT_HAVE_CACHE_L2X0
 	select MIGHT_HAVE_PCI
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PINCTRL
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 4a70be485ff8..02930d69f381 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -15,7 +15,7 @@ config ARCH_VEXPRESS
 	select HAVE_SMP
 	select ICST
 	select MIGHT_HAVE_CACHE_L2X0
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PLAT_VERSATILE
 	select PLAT_VERSATILE_CLCD
 	select POWER_RESET
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 58645a58d0d8..ac0366858e94 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -9,7 +9,7 @@ config PLAT_SAMSUNG
 	depends on PLAT_S3C24XX || ARCH_S3C64XX || PLAT_S5P || ARCH_EXYNOS
 	default y
 	select GENERIC_IRQ_CHIP
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	help
 	  Base platform code for all Samsung SoC based systems
 
@@ -19,7 +19,7 @@ config PLAT_S5P
 	default y
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_VIC
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PLAT_SAMSUNG
 	select S3C_GPIO_TRACK
 	select S5P_GPIO_DRVSTR
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 27bbcfc7202a..3a9b1e755a7b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -61,7 +61,7 @@ config ARCH_PHYS_ADDR_T_64BIT
 config MMU
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config STACKTRACE_SUPPORT
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index ed0fcdf7e990..4a60aa362990 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -29,7 +29,7 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config FORCE_MAX_ZONEORDER
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 09df2608f40a..9bb54b95eb89 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -19,7 +19,7 @@ config HEXAGON
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select STACKTRACE_SUPPORT
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ca4504424dae..9e44bbd8051e 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -28,7 +28,7 @@ config ZONE_DMA
 	bool
 	default y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config NO_DMA
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index dbdd2231c75d..a1aebe524a67 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -51,7 +51,7 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config NO_DMA
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index e56abd2c1b4f..4e53a6de1a4e 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -52,7 +52,7 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 source "init/Kconfig"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dcae3a7035db..21511c9f886d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -175,7 +175,7 @@ config MACH_DECSTATION
 	select CPU_R4000_WORKAROUNDS if 64BIT
 	select CPU_R4400_WORKAROUNDS if 64BIT
 	select DMA_NONCOHERENT
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select IRQ_CPU
 	select SYS_HAS_CPU_R3000
 	select SYS_HAS_CPU_R4X00
@@ -949,7 +949,7 @@ config SYNC_R4K
 config MIPS_MACHINE
 	def_bool n
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool n
 
 config GENERIC_ISA_DMA
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 9488209a5253..e71d712afb79 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -41,7 +41,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config TRACE_IRQFLAGS_SUPPORT
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a07750f4f9..64999de81472 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -52,7 +52,7 @@ config KEXEC
 config AUDIT_ARCH
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config PCI_QUIRKS
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 6357710753d5..eb00e1afcde8 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -3,7 +3,7 @@ config SUPERH
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select EXPERT
 	select CLKDEV_LOOKUP
-	select HAVE_IDE if HAS_IOPORT
+	select HAVE_IDE if HAS_IOPORT_MAP
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
@@ -147,7 +147,7 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN && \
 		   !SH_HP6XX && !SH_SOLUTION_ENGINE
diff --git a/arch/sh/boards/Kconfig b/arch/sh/boards/Kconfig
index eb1cf84231a2..e331e5373b8e 100644
--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -158,7 +158,7 @@ config SH_SDK7786
 	bool "SDK7786"
 	depends on CPU_SUBTYPE_SH7786
 	select SYS_SUPPORTS_PCI
-	select NO_IOPORT if !PCI
+	select NO_IOPORT_MAP if !PCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_SRAM_POOL
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
@@ -204,7 +204,7 @@ config SH_URQUELL
 	depends on CPU_SUBTYPE_SH7786
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_SUPPORTS_PCI
-	select NO_IOPORT if !PCI
+	select NO_IOPORT_MAP if !PCI
 
 config SH_MIGOR
 	bool "Migo-R"
@@ -306,7 +306,7 @@ config SH_LBOX_RE2
 config SH_X3PROTO
 	bool "SH-X3 Prototype board"
 	depends on CPU_SUBTYPE_SHX3
-	select NO_IOPORT if !PCI
+	select NO_IOPORT_MAP if !PCI
 	select IRQ_DOMAIN
 
 config SH_MAGIC_PANEL_R2
@@ -333,7 +333,7 @@ config SH_POLARIS
 
 config SH_SH2007
 	bool "SH-2007 board"
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	depends on CPU_SUBTYPE_SH7780
 	help
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 629db2ad7916..728c4c571f40 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -122,7 +122,7 @@ __BUILD_MEMORY_STRING(__raw_, l, u32)
 
 __BUILD_MEMORY_STRING(__raw_, q, u64)
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 
 /*
  * Slowdown I/O port space accesses for antique hardware.
@@ -218,7 +218,7 @@ __BUILD_IOPORT_STRING(w, u16)
 __BUILD_IOPORT_STRING(l, u32)
 __BUILD_IOPORT_STRING(q, u64)
 
-#else /* !CONFIG_HAS_IOPORT */
+#else /* !CONFIG_HAS_IOPORT_MAP */
 
 #include <asm/io_noioport.h>
 
diff --git a/arch/sh/include/asm/io_trapped.h b/arch/sh/include/asm/io_trapped.h
index f1251d4f0ba9..4ab94ef51071 100644
--- a/arch/sh/include/asm/io_trapped.h
+++ b/arch/sh/include/asm/io_trapped.h
@@ -36,7 +36,7 @@ __ioremap_trapped(unsigned long offset, unsigned long size)
 #define __ioremap_trapped(offset, size) NULL
 #endif
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 extern struct list_head trapped_io;
 
 static inline void __iomem *
diff --git a/arch/sh/include/asm/machvec.h b/arch/sh/include/asm/machvec.h
index eb9c20d971dd..d3324e4f372e 100644
--- a/arch/sh/include/asm/machvec.h
+++ b/arch/sh/include/asm/machvec.h
@@ -21,7 +21,7 @@ struct sh_machine_vector {
 	int (*mv_irq_demux)(int irq);
 	void (*mv_init_irq)(void);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 	void __iomem *(*mv_ioport_map)(unsigned long port, unsigned int size);
 	void (*mv_ioport_unmap)(void __iomem *);
 #endif
diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
index 261c8bfd75ce..2ccf36c824c6 100644
--- a/arch/sh/kernel/Makefile
+++ b/arch/sh/kernel/Makefile
@@ -22,7 +22,7 @@ obj-y	:= debugtraps.o dma-nommu.o dumpstack.o 		\
 
 ifndef CONFIG_GENERIC_IOMAP
 obj-y				+= iomap.o
-obj-$(CONFIG_HAS_IOPORT)	+= ioport.o
+obj-$(CONFIG_HAS_IOPORT_MAP)	+= ioport.o
 endif
 
 obj-$(CONFIG_SUPERH32)		+= sys_sh32.o
diff --git a/arch/sh/kernel/io_trapped.c b/arch/sh/kernel/io_trapped.c
index c0a9761f2f8a..f8ce36286cea 100644
--- a/arch/sh/kernel/io_trapped.c
+++ b/arch/sh/kernel/io_trapped.c
@@ -22,7 +22,7 @@
 
 #define TRAPPED_PAGES_MAX 16
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 LIST_HEAD(trapped_io);
 EXPORT_SYMBOL_GPL(trapped_io);
 #endif
@@ -90,7 +90,7 @@ int register_trapped_io(struct trapped_io *tiop)
 	tiop->magic = IO_TRAPPED_MAGIC;
 	INIT_LIST_HEAD(&tiop->list);
 	spin_lock_irq(&trapped_lock);
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 	if (flags & IORESOURCE_IO)
 		list_add(&tiop->list, &trapped_io);
 #endif
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index b3692ce78f90..0b0290eeb629 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -405,7 +405,7 @@ config PCI_DOMAINS
 config NO_IOMEM
 	def_bool !PCI
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool !PCI
 
 config TILE_PCI_IO
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 25c0dba508cc..aafad6fa1667 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -27,7 +27,7 @@ config UNICORE32
 config GENERIC_CSUM
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	bool
 
 config STACKTRACE_SUPPORT
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ba56e11cbf77..a954db201d04 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -40,7 +40,7 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool n
 
 config HZ
@@ -240,7 +240,7 @@ config XTENSA_PLATFORM_XT2000
 config XTENSA_PLATFORM_S6105
 	bool "S6105"
 	select SERIAL_CONSOLE
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 
 config XTENSA_PLATFORM_XTFPGA
 	bool "XTFPGA"
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 4f233204faf9..d57d917ff240 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -11,7 +11,7 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_NO_IOPORT=y
+CONFIG_NO_IOPORT_MAP=y
 CONFIG_HZ=100
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 CONFIG_CONSTRUCTORS=y
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index d929f77a0360..583c2b0974ca 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -11,7 +11,7 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_NO_IOPORT=y
+CONFIG_NO_IOPORT_MAP=y
 CONFIG_HZ=100
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 1a65838888cd..c54cac3f8bc8 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -74,7 +74,7 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on PPC64 || HAS_IOPORT
+	depends on PPC64 || HAS_IOPORT_MAP
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index f5ed03164d86..75c3c0bd6ffa 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -936,7 +936,7 @@ config I2C_ACORN
 
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
-	depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
+	depends on ISA && HAS_IOPORT_MAP && BROKEN_ON_SMP
 	select I2C_ALGOPCF
 	help
 	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index ff2ba86cd4a4..833ee8c9168e 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -46,7 +46,7 @@ config CAN_EMS_PCI
 config CAN_PEAK_PCMCIA
 	tristate "PEAK PCAN-PC Card"
 	depends on PCMCIA
-	depends on HAS_IOPORT
+	depends on HAS_IOPORT_MAP
 	---help---
 	  This driver is for the PCAN-PC Card PCMCIA adapter (1 or 2 channels)
 	  from PEAK-System (http://www.peak-system.com). To compile this
diff --git a/drivers/net/ethernet/3com/Kconfig b/drivers/net/ethernet/3com/Kconfig
index 65b735d4a6ad..afaab4b2333f 100644
--- a/drivers/net/ethernet/3com/Kconfig
+++ b/drivers/net/ethernet/3com/Kconfig
@@ -66,7 +66,7 @@ config PCMCIA_3C589
 
 config VORTEX
 	tristate "3c590/3c900 series (592/595/597) \"Vortex/Boomerang\" support"
-	depends on (PCI || EISA) && HAS_IOPORT
+	depends on (PCI || EISA) && HAS_IOPORT_MAP
 	select MII
 	---help---
 	  This option enables driver support for a large number of 10Mbps and
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d5afe96adba6..975e1cc75edb 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -327,7 +327,7 @@ static inline void iounmap(void __iomem *addr)
 }
 #endif /* CONFIG_MMU */
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -341,7 +341,7 @@ static inline void ioport_unmap(void __iomem *p)
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
-#endif /* CONFIG_HAS_IOPORT */
+#endif /* CONFIG_HAS_IOPORT_MAP */
 
 #ifndef xlate_dev_kmem_ptr
 #define xlate_dev_kmem_ptr(p)	p
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 6afd7d6a9899..1b41011643a5 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -56,7 +56,7 @@ extern void iowrite8_rep(void __iomem *port, const void *buf, unsigned long coun
 extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
 extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
diff --git a/include/linux/io.h b/include/linux/io.h
index f4f42faec686..3e35c183dca4 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -41,7 +41,7 @@ static inline int ioremap_page_range(unsigned long addr, unsigned long end,
 /*
  * Managed iomap interface
  */
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr);
 void devm_ioport_unmap(struct device *dev, void __iomem *addr);
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98bc4a3f..5d4984c505f8 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -342,9 +342,9 @@ config HAS_IOMEM
 	select GENERIC_IO
 	default y
 
-config HAS_IOPORT
+config HAS_IOPORT_MAP
 	boolean
-	depends on HAS_IOMEM && !NO_IOPORT
+	depends on HAS_IOMEM && !NO_IOPORT_MAP
 	default y
 
 config HAS_DMA
diff --git a/lib/devres.c b/lib/devres.c
index 823533138fa0..10231287fbcc 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -168,7 +168,7 @@ void __iomem *devm_request_and_ioremap(struct device *device,
 }
 EXPORT_SYMBOL(devm_request_and_ioremap);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 /*
  * Generic iomap devres
  */
@@ -227,7 +227,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
-#endif /* CONFIG_HAS_IOPORT */
+#endif /* CONFIG_HAS_IOPORT_MAP */
 
 #ifdef CONFIG_PCI
 /*
diff --git a/lib/iomap.c b/lib/iomap.c
index 2c08f36862eb..fc3dcb4b238e 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -224,7 +224,7 @@ EXPORT_SYMBOL(iowrite8_rep);
 EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 /* Create a virtual mapping cookie for an IO port range */
 void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -239,7 +239,7 @@ void ioport_unmap(void __iomem *addr)
 }
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
-#endif /* CONFIG_HAS_IOPORT */
+#endif /* CONFIG_HAS_IOPORT_MAP */
 
 #ifdef CONFIG_PCI
 /* Hide the details if this is a MMIO or PIO address space and just do what
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index affa13480659..0216475fc759 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -191,7 +191,7 @@ config SND_ES18XX
 
 config SND_SC6000
 	tristate "Gallant SC-6000/6600/7000 and Audio Excel DSP 16"
-	depends on HAS_IOPORT
+	depends on HAS_IOPORT_MAP
 	select SND_WSS_LIB
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 8756c8e32922..81135d7a50cf 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -689,7 +689,7 @@ config SND_LOLA
 
 config SND_LX6464ES
 	tristate "Digigram LX6464ES"
-	depends on HAS_IOPORT
+	depends on HAS_IOPORT_MAP
 	select SND_PCM
 	help
 	  Say Y here to include support for Digigram LX6464ES boards.
-- 
1.8.5.3

