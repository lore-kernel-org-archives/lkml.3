Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaBYVkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:40:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaBYVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:40:38 -0500
Date: Tue, 25 Feb 2014 13:40:03 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-10f032c61d12fc4df9c9632ee08e71f1152e1691@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pazke@donpac.ru, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, pazke@donpac.ru,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <530CFD6C.7040705@zytor.com>
References: <530CFD6C.7040705@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke-platforms] x86, platforms:
  Remove SGI Visual Workstation
Git-Commit-ID: 10f032c61d12fc4df9c9632ee08e71f1152e1691
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10f032c61d12fc4df9c9632ee08e71f1152e1691
Gitweb:     http://git.kernel.org/tip/10f032c61d12fc4df9c9632ee08e71f1152e1691
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 25 Feb 2014 12:05:34 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Feb 2014 13:38:27 -0800

x86, platforms: Remove SGI Visual Workstation

The SGI Visual Workstation seems to be dead; remove support so we
don't have to continue maintaining it.

Cc: Andrey Panin <pazke@donpac.ru>
Link: http://lkml.kernel.org/r/530CFD6C.7040705@zytor.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/sgi-visws.txt            |  13 -
 MAINTAINERS                            |   7 -
 arch/x86/Kconfig                       |  13 -
 arch/x86/include/asm/visws/cobalt.h    | 127 -------
 arch/x86/include/asm/visws/lithium.h   |  53 ---
 arch/x86/include/asm/visws/piix4.h     | 107 ------
 arch/x86/include/asm/visws/sgivw.h     |   5 -
 arch/x86/pci/Makefile                  |   2 -
 arch/x86/pci/visws.c                   |  87 -----
 arch/x86/platform/Makefile             |   1 -
 arch/x86/platform/visws/Makefile       |   1 -
 arch/x86/platform/visws/visws_quirks.c | 608 ---------------------------------
 12 files changed, 1024 deletions(-)

diff --git a/Documentation/sgi-visws.txt b/Documentation/sgi-visws.txt
deleted file mode 100644
index 7ff0811..0000000
--- a/Documentation/sgi-visws.txt
+++ /dev/null
@@ -1,13 +0,0 @@
-
-The SGI Visual Workstations (models 320 and 540) are based around
-the Cobalt, Lithium, and Arsenic ASICs.  The Cobalt ASIC is the
-main system ASIC which interfaces the 1-4 IA32 cpus, the memory
-system, and the I/O system in the Lithium ASIC.  The Cobalt ASIC
-also contains the 3D gfx rendering engine which renders to main
-system memory -- part of which is used as the frame buffer which
-is DMA'ed to a video connector using the Arsenic ASIC.  A PIIX4
-chip and NS87307 are used to provide legacy device support (IDE,
-serial, floppy, and parallel).
-
-The Visual Workstation chipset largely conforms to the PC architecture
-with some notable exceptions such as interrupt handling.
diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..7f9bc84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7757,13 +7757,6 @@ F:	Documentation/ia64/serial.txt
 F:	drivers/tty/serial/ioc?_serial.c
 F:	include/linux/ioc?.h
 
-SGI VISUAL WORKSTATION 320 AND 540
-M:	Andrey Panin <pazke@donpac.ru>
-L:	linux-visws-devel@lists.sf.net
-W:	http://linux-visws.sf.net
-S:	Maintained for 2.6.
-F:	Documentation/sgi-visws.txt
-
 SGI XP/XPC/XPNET DRIVER
 M:	Cliff Whickman <cpw@sgi.com>
 M:	Robin Holt <robinmholt@gmail.com>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4c33fc2..2aa5d42 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -517,19 +517,6 @@ config X86_SUPPORTS_MEMORY_FAILURE
 	depends on X86_64 || !SPARSEMEM
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 
-config X86_VISWS
-	bool "SGI 320/540 (Visual Workstation)"
-	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
-	depends on X86_32_NON_STANDARD
-	---help---
-	  The SGI Visual Workstation series is an IA32-based workstation
-	  based on SGI systems chips with some legacy PC hardware attached.
-
-	  Say Y here to create a kernel to run on the SGI 320 or 540.
-
-	  A kernel compiled for the Visual Workstation will run on general
-	  PCs as well. See <file:Documentation/sgi-visws.txt> for details.
-
 config STA2X11
 	bool "STA2X11 Companion Chip Support"
 	depends on X86_32_NON_STANDARD && PCI
diff --git a/arch/x86/include/asm/visws/cobalt.h b/arch/x86/include/asm/visws/cobalt.h
deleted file mode 100644
index 2edb376..0000000
--- a/arch/x86/include/asm/visws/cobalt.h
+++ /dev/null
@@ -1,127 +0,0 @@
-#ifndef _ASM_X86_VISWS_COBALT_H
-#define _ASM_X86_VISWS_COBALT_H
-
-#include <asm/fixmap.h>
-
-/*
- * Cobalt SGI Visual Workstation system ASIC
- */ 
-
-#define CO_CPU_NUM_PHYS 0x1e00
-#define CO_CPU_TAB_PHYS (CO_CPU_NUM_PHYS + 2)
-
-#define CO_CPU_MAX 4
-
-#define	CO_CPU_PHYS		0xc2000000
-#define	CO_APIC_PHYS		0xc4000000
-
-/* see set_fixmap() and asm/fixmap.h */
-#define	CO_CPU_VADDR		(fix_to_virt(FIX_CO_CPU))
-#define	CO_APIC_VADDR		(fix_to_virt(FIX_CO_APIC))
-
-/* Cobalt CPU registers -- relative to CO_CPU_VADDR, use co_cpu_*() */
-#define	CO_CPU_REV		0x08
-#define	CO_CPU_CTRL		0x10
-#define	CO_CPU_STAT		0x20
-#define	CO_CPU_TIMEVAL		0x30
-
-/* CO_CPU_CTRL bits */
-#define	CO_CTRL_TIMERUN		0x04		/* 0 == disabled */
-#define	CO_CTRL_TIMEMASK	0x08		/* 0 == unmasked */
-
-/* CO_CPU_STATUS bits */
-#define	CO_STAT_TIMEINTR	0x02	/* (r) 1 == int pend, (w) 0 == clear */
-
-/* CO_CPU_TIMEVAL value */
-#define	CO_TIME_HZ		100000000	/* Cobalt core rate */
-
-/* Cobalt APIC registers -- relative to CO_APIC_VADDR, use co_apic_*() */
-#define	CO_APIC_HI(n)		(((n) * 0x10) + 4)
-#define	CO_APIC_LO(n)		((n) * 0x10)
-#define	CO_APIC_ID		0x0ffc
-
-/* CO_APIC_ID bits */
-#define	CO_APIC_ENABLE		0x00000100
-
-/* CO_APIC_LO bits */
-#define	CO_APIC_MASK		0x00010000	/* 0 = enabled */
-#define	CO_APIC_LEVEL		0x00008000	/* 0 = edge */
-
-/*
- * Where things are physically wired to Cobalt
- * #defines with no board _<type>_<rev>_ are common to all (thus far)
- */
-#define	CO_APIC_IDE0		4
-#define CO_APIC_IDE1		2		/* Only on 320 */
-
-#define	CO_APIC_8259		12		/* serial, floppy, par-l-l */
-
-/* Lithium PCI Bridge A -- "the one with 82557 Ethernet" */
-#define	CO_APIC_PCIA_BASE0	0 /* and 1 */	/* slot 0, line 0 */
-#define	CO_APIC_PCIA_BASE123	5 /* and 6 */	/* slot 0, line 1 */
-
-#define	CO_APIC_PIIX4_USB	7		/* this one is weird */
-
-/* Lithium PCI Bridge B -- "the one with PIIX4" */
-#define	CO_APIC_PCIB_BASE0	8 /* and 9-12 *//* slot 0, line 0 */
-#define	CO_APIC_PCIB_BASE123	13 /* 14.15 */	/* slot 0, line 1 */
-
-#define	CO_APIC_VIDOUT0		16
-#define	CO_APIC_VIDOUT1		17
-#define	CO_APIC_VIDIN0		18
-#define	CO_APIC_VIDIN1		19
-
-#define	CO_APIC_LI_AUDIO	22
-
-#define	CO_APIC_AS		24
-#define	CO_APIC_RE		25
-
-#define CO_APIC_CPU		28		/* Timer and Cache interrupt */
-#define	CO_APIC_NMI		29
-#define	CO_APIC_LAST		CO_APIC_NMI
-
-/*
- * This is how irqs are assigned on the Visual Workstation.
- * Legacy devices get irq's 1-15 (system clock is 0 and is CO_APIC_CPU).
- * All other devices (including PCI) go to Cobalt and are irq's 16 on up.
- */
-#define	CO_IRQ_APIC0	16			/* irq of apic entry 0 */
-#define	IS_CO_APIC(irq)	((irq) >= CO_IRQ_APIC0)
-#define	CO_IRQ(apic)	(CO_IRQ_APIC0 + (apic))	/* apic ent to irq */
-#define	CO_APIC(irq)	((irq) - CO_IRQ_APIC0)	/* irq to apic ent */
-#define CO_IRQ_IDE0	14			/* knowledge of... */
-#define CO_IRQ_IDE1	15			/* ... ide driver defaults! */
-#define	CO_IRQ_8259	CO_IRQ(CO_APIC_8259)
-
-#ifdef CONFIG_X86_VISWS_APIC
-static inline void co_cpu_write(unsigned long reg, unsigned long v)
-{
-	*((volatile unsigned long *)(CO_CPU_VADDR+reg))=v;
-}
-
-static inline unsigned long co_cpu_read(unsigned long reg)
-{
-	return *((volatile unsigned long *)(CO_CPU_VADDR+reg));
-}            
-             
-static inline void co_apic_write(unsigned long reg, unsigned long v)
-{
-	*((volatile unsigned long *)(CO_APIC_VADDR+reg))=v;
-}            
-             
-static inline unsigned long co_apic_read(unsigned long reg)
-{
-	return *((volatile unsigned long *)(CO_APIC_VADDR+reg));
-}
-#endif
-
-extern char visws_board_type;
-
-#define	VISWS_320	0
-#define	VISWS_540	1
-
-extern char visws_board_rev;
-
-extern int pci_visws_init(void);
-
-#endif /* _ASM_X86_VISWS_COBALT_H */
diff --git a/arch/x86/include/asm/visws/lithium.h b/arch/x86/include/asm/visws/lithium.h
deleted file mode 100644
index a10d89b..0000000
--- a/arch/x86/include/asm/visws/lithium.h
+++ /dev/null
@@ -1,53 +0,0 @@
-#ifndef _ASM_X86_VISWS_LITHIUM_H
-#define _ASM_X86_VISWS_LITHIUM_H
-
-#include <asm/fixmap.h>
-
-/*
- * Lithium is the SGI Visual Workstation I/O ASIC
- */
-
-#define	LI_PCI_A_PHYS		0xfc000000	/* Enet is dev 3 */
-#define	LI_PCI_B_PHYS		0xfd000000	/* PIIX4 is here */
-
-/* see set_fixmap() and asm/fixmap.h */
-#define LI_PCIA_VADDR   (fix_to_virt(FIX_LI_PCIA))
-#define LI_PCIB_VADDR   (fix_to_virt(FIX_LI_PCIB))
-
-/* Not a standard PCI? (not in linux/pci.h) */
-#define	LI_PCI_BUSNUM	0x44			/* lo8: primary, hi8: sub */
-#define LI_PCI_INTEN    0x46
-
-/* LI_PCI_INTENT bits */
-#define	LI_INTA_0	0x0001
-#define	LI_INTA_1	0x0002
-#define	LI_INTA_2	0x0004
-#define	LI_INTA_3	0x0008
-#define	LI_INTA_4	0x0010
-#define	LI_INTB		0x0020
-#define	LI_INTC		0x0040
-#define	LI_INTD		0x0080
-
-/* More special purpose macros... */
-static inline void li_pcia_write16(unsigned long reg, unsigned short v)
-{
-	*((volatile unsigned short *)(LI_PCIA_VADDR+reg))=v;
-}
-
-static inline unsigned short li_pcia_read16(unsigned long reg)
-{
-	 return *((volatile unsigned short *)(LI_PCIA_VADDR+reg));
-}
-
-static inline void li_pcib_write16(unsigned long reg, unsigned short v)
-{
-	*((volatile unsigned short *)(LI_PCIB_VADDR+reg))=v;
-}
-
-static inline unsigned short li_pcib_read16(unsigned long reg)
-{
-	return *((volatile unsigned short *)(LI_PCIB_VADDR+reg));
-}
-
-#endif /* _ASM_X86_VISWS_LITHIUM_H */
-
diff --git a/arch/x86/include/asm/visws/piix4.h b/arch/x86/include/asm/visws/piix4.h
deleted file mode 100644
index d0af4d3..0000000
--- a/arch/x86/include/asm/visws/piix4.h
+++ /dev/null
@@ -1,107 +0,0 @@
-#ifndef _ASM_X86_VISWS_PIIX4_H
-#define _ASM_X86_VISWS_PIIX4_H
-
-/*
- * PIIX4 as used on SGI Visual Workstations
- */
-
-#define	PIIX_PM_START		0x0F80
-
-#define	SIO_GPIO_START		0x0FC0
-
-#define	SIO_PM_START		0x0FC8
-
-#define	PMBASE			PIIX_PM_START
-#define	GPIREG0			(PMBASE+0x30)
-#define	GPIREG(x)		(GPIREG0+((x)/8))
-#define	GPIBIT(x)		(1 << ((x)%8))
-
-#define	PIIX_GPI_BD_ID1		18
-#define	PIIX_GPI_BD_ID2		19
-#define	PIIX_GPI_BD_ID3		20
-#define	PIIX_GPI_BD_ID4		21
-#define	PIIX_GPI_BD_REG		GPIREG(PIIX_GPI_BD_ID1)
-#define	PIIX_GPI_BD_MASK	(GPIBIT(PIIX_GPI_BD_ID1) | \
-				GPIBIT(PIIX_GPI_BD_ID2) | \
-				GPIBIT(PIIX_GPI_BD_ID3) | \
-				GPIBIT(PIIX_GPI_BD_ID4) )
-
-#define	PIIX_GPI_BD_SHIFT	(PIIX_GPI_BD_ID1 % 8)
-
-#define	SIO_INDEX		0x2e
-#define	SIO_DATA		0x2f
-
-#define	SIO_DEV_SEL		0x7
-#define	SIO_DEV_ENB		0x30
-#define	SIO_DEV_MSB		0x60
-#define	SIO_DEV_LSB		0x61
-
-#define	SIO_GP_DEV		0x7
-
-#define	SIO_GP_BASE		SIO_GPIO_START
-#define	SIO_GP_MSB		(SIO_GP_BASE>>8)
-#define	SIO_GP_LSB		(SIO_GP_BASE&0xff)
-
-#define	SIO_GP_DATA1		(SIO_GP_BASE+0)
-
-#define	SIO_PM_DEV		0x8
-
-#define	SIO_PM_BASE		SIO_PM_START
-#define	SIO_PM_MSB		(SIO_PM_BASE>>8)
-#define	SIO_PM_LSB		(SIO_PM_BASE&0xff)
-#define	SIO_PM_INDEX		(SIO_PM_BASE+0)
-#define	SIO_PM_DATA		(SIO_PM_BASE+1)
-
-#define	SIO_PM_FER2		0x1
-
-#define	SIO_PM_GP_EN		0x80
-
-
-
-/*
- * This is the dev/reg where generating a config cycle will
- * result in a PCI special cycle.
- */
-#define SPECIAL_DEV		0xff
-#define SPECIAL_REG		0x00
-
-/*
- * PIIX4 needs to see a special cycle with the following data
- * to be convinced the processor has gone into the stop grant
- * state.  PIIX4 insists on seeing this before it will power
- * down a system.
- */
-#define PIIX_SPECIAL_STOP		0x00120002
-
-#define PIIX4_RESET_PORT	0xcf9
-#define PIIX4_RESET_VAL		0x6
-
-#define PMSTS_PORT		0xf80	// 2 bytes	PM Status
-#define PMEN_PORT		0xf82	// 2 bytes	PM Enable
-#define	PMCNTRL_PORT		0xf84	// 2 bytes	PM Control
-
-#define PM_SUSPEND_ENABLE	0x2000	// start sequence to suspend state
-
-/*
- * PMSTS and PMEN I/O bit definitions.
- * (Bits are the same in both registers)
- */
-#define PM_STS_RSM		(1<<15)	// Resume Status
-#define PM_STS_PWRBTNOR		(1<<11)	// Power Button Override
-#define PM_STS_RTC		(1<<10)	// RTC status
-#define PM_STS_PWRBTN		(1<<8)	// Power Button Pressed?
-#define PM_STS_GBL		(1<<5)	// Global Status
-#define PM_STS_BM		(1<<4)	// Bus Master Status
-#define PM_STS_TMROF		(1<<0)	// Timer Overflow Status.
-
-/*
- * Stop clock GPI register
- */
-#define PIIX_GPIREG0			(0xf80 + 0x30)
-
-/*
- * Stop clock GPI bit in GPIREG0
- */
-#define	PIIX_GPI_STPCLK		0x4	// STPCLK signal routed back in
-
-#endif /* _ASM_X86_VISWS_PIIX4_H */
diff --git a/arch/x86/include/asm/visws/sgivw.h b/arch/x86/include/asm/visws/sgivw.h
deleted file mode 100644
index 5fbf63e..0000000
--- a/arch/x86/include/asm/visws/sgivw.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/*
- * Frame buffer position and size:
- */
-extern unsigned long sgivwfb_mem_phys;
-extern unsigned long sgivwfb_mem_size;
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index e063eed..758b827 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -13,8 +13,6 @@ obj-y				+= legacy.o irq.o
 
 obj-$(CONFIG_STA2X11)           += sta2x11-fixup.o
 
-obj-$(CONFIG_X86_VISWS)		+= visws.o
-
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_NUMACHIP)	+= numachip.o
 
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
deleted file mode 100644
index 3e6d2a6..0000000
--- a/arch/x86/pci/visws.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- *	Low-Level PCI Support for SGI Visual Workstation
- *
- *	(c) 1999--2000 Martin Mares <mj@ucw.cz>
- */
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/init.h>
-
-#include <asm/setup.h>
-#include <asm/pci_x86.h>
-#include <asm/visws/cobalt.h>
-#include <asm/visws/lithium.h>
-
-static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
-static void pci_visws_disable_irq(struct pci_dev *dev) { }
-
-/* int (*pcibios_enable_irq)(struct pci_dev *dev) = &pci_visws_enable_irq; */
-/* void (*pcibios_disable_irq)(struct pci_dev *dev) = &pci_visws_disable_irq; */
-
-/* void __init pcibios_penalize_isa_irq(int irq, int active) {} */
-
-
-unsigned int pci_bus0, pci_bus1;
-
-static int __init visws_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
-{
-	int irq, bus = dev->bus->number;
-
-	pin--;
-
-	/* Nothing useful at PIIX4 pin 1 */
-	if (bus == pci_bus0 && slot == 4 && pin == 0)
-		return -1;
-
-	/* PIIX4 USB is on Bus 0, Slot 4, Line 3 */
-	if (bus == pci_bus0 && slot == 4 && pin == 3) {
-		irq = CO_IRQ(CO_APIC_PIIX4_USB);
-		goto out;
-	}
-
-	/* First pin spread down 1 APIC entry per slot */
-	if (pin == 0) {
-		irq = CO_IRQ((bus == pci_bus0 ? CO_APIC_PCIB_BASE0 :
-						CO_APIC_PCIA_BASE0) + slot);
-		goto out;
-	}
-
-	/* lines 1,2,3 from any slot is shared in this twirly pattern */
-	if (bus == pci_bus1) {
-		/* lines 1-3 from devices 0 1 rotate over 2 apic entries */
-		irq = CO_IRQ(CO_APIC_PCIA_BASE123 + ((slot + (pin - 1)) % 2));
-	} else { /* bus == pci_bus0 */
-		/* lines 1-3 from devices 0-3 rotate over 3 apic entries */
-		if (slot == 0)
-			slot = 3; /* same pattern */
-		irq = CO_IRQ(CO_APIC_PCIA_BASE123 + ((3 - slot) + (pin - 1) % 3));
-	}
-out:
-	printk(KERN_DEBUG "PCI: Bus %d Slot %d Line %d -> IRQ %d\n", bus, slot, pin, irq);
-	return irq;
-}
-
-int __init pci_visws_init(void)
-{
-	pcibios_enable_irq = &pci_visws_enable_irq;
-	pcibios_disable_irq = &pci_visws_disable_irq;
-
-	/* The VISWS supports configuration access type 1 only */
-	pci_probe = (pci_probe | PCI_PROBE_CONF1) &
-		    ~(PCI_PROBE_BIOS | PCI_PROBE_CONF2);
-
-	pci_bus0 = li_pcib_read16(LI_PCI_BUSNUM) & 0xff;
-	pci_bus1 = li_pcia_read16(LI_PCI_BUSNUM) & 0xff;
-
-	printk(KERN_INFO "PCI: Lithium bridge A bus: %u, "
-		"bridge B (PIIX4) bus: %u\n", pci_bus1, pci_bus0);
-
-	raw_pci_ops = &pci_direct_conf1;
-	pci_scan_bus_with_sysdata(pci_bus0);
-	pci_scan_bus_with_sysdata(pci_bus1);
-	pci_fixup_irqs(pci_common_swizzle, visws_map_irq);
-	pcibios_resource_survey();
-	/* Request bus scan */
-	return 1;
-}
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 20342d4..85afde1 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -9,5 +9,4 @@ obj-y	+= olpc/
 obj-y	+= scx200/
 obj-y	+= sfi/
 obj-y	+= ts5500/
-obj-y	+= visws/
 obj-y	+= uv/
diff --git a/arch/x86/platform/visws/Makefile b/arch/x86/platform/visws/Makefile
deleted file mode 100644
index 91bc17a..0000000
--- a/arch/x86/platform/visws/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
deleted file mode 100644
index 94d8a39..0000000
--- a/arch/x86/platform/visws/visws_quirks.c
+++ /dev/null
@@ -1,608 +0,0 @@
-/*
- *  SGI Visual Workstation support and quirks, unmaintained.
- *
- *  Split out from setup.c by davej@suse.de
- *
- *	Copyright (C) 1999 Bent Hagemark, Ingo Molnar
- *
- *  SGI Visual Workstation interrupt controller
- *
- *  The Cobalt system ASIC in the Visual Workstation contains a "Cobalt" APIC
- *  which serves as the main interrupt controller in the system.  Non-legacy
- *  hardware in the system uses this controller directly.  Legacy devices
- *  are connected to the PIIX4 which in turn has its 8259(s) connected to
- *  a of the Cobalt APIC entry.
- *
- *  09/02/2000 - Updated for 2.4 by jbarnes@sgi.com
- *
- *  25/11/2002 - Updated for 2.5 by Andrey Panin <pazke@orbita1.ru>
- */
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/visws/cobalt.h>
-#include <asm/visws/piix4.h>
-#include <asm/io_apic.h>
-#include <asm/fixmap.h>
-#include <asm/reboot.h>
-#include <asm/setup.h>
-#include <asm/apic.h>
-#include <asm/e820.h>
-#include <asm/time.h>
-#include <asm/io.h>
-
-#include <linux/kernel_stat.h>
-
-#include <asm/i8259.h>
-#include <asm/irq_vectors.h>
-#include <asm/visws/lithium.h>
-
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
-
-extern int no_broadcast;
-
-char visws_board_type	= -1;
-char visws_board_rev	= -1;
-
-static void __init visws_time_init(void)
-{
-	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
-
-	/* Set the countdown value */
-	co_cpu_write(CO_CPU_TIMEVAL, CO_TIME_HZ/HZ);
-
-	/* Start the timer */
-	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) | CO_CTRL_TIMERUN);
-
-	/* Enable (unmask) the timer interrupt */
-	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) & ~CO_CTRL_TIMEMASK);
-
-	setup_default_timer_irq();
-}
-
-/* Replaces the default init_ISA_irqs in the generic setup */
-static void __init visws_pre_intr_init(void);
-
-/* Quirk for machine specific memory setup. */
-
-#define MB (1024 * 1024)
-
-unsigned long sgivwfb_mem_phys;
-unsigned long sgivwfb_mem_size;
-EXPORT_SYMBOL(sgivwfb_mem_phys);
-EXPORT_SYMBOL(sgivwfb_mem_size);
-
-long long mem_size __initdata = 0;
-
-static char * __init visws_memory_setup(void)
-{
-	long long gfx_mem_size = 8 * MB;
-
-	mem_size = boot_params.alt_mem_k;
-
-	if (!mem_size) {
-		printk(KERN_WARNING "Bootloader didn't set memory size, upgrade it !\n");
-		mem_size = 128 * MB;
-	}
-
-	/*
-	 * this hardcodes the graphics memory to 8 MB
-	 * it really should be sized dynamically (or at least
-	 * set as a boot param)
-	 */
-	if (!sgivwfb_mem_size) {
-		printk(KERN_WARNING "Defaulting to 8 MB framebuffer size\n");
-		sgivwfb_mem_size = 8 * MB;
-	}
-
-	/*
-	 * Trim to nearest MB
-	 */
-	sgivwfb_mem_size &= ~((1 << 20) - 1);
-	sgivwfb_mem_phys = mem_size - gfx_mem_size;
-
-	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-	e820_add_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_RAM);
-	e820_add_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_RESERVED);
-
-	return "PROM";
-}
-
-static void visws_machine_emergency_restart(void)
-{
-	/*
-	 * Visual Workstations restart after this
-	 * register is poked on the PIIX4
-	 */
-	outb(PIIX4_RESET_VAL, PIIX4_RESET_PORT);
-}
-
-static void visws_machine_power_off(void)
-{
-	unsigned short pm_status;
-/*	extern unsigned int pci_bus0; */
-
-	while ((pm_status = inw(PMSTS_PORT)) & 0x100)
-		outw(pm_status, PMSTS_PORT);
-
-	outw(PM_SUSPEND_ENABLE, PMCNTRL_PORT);
-
-	mdelay(10);
-
-#define PCI_CONF1_ADDRESS(bus, devfn, reg) \
-	(0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
-
-/*	outl(PCI_CONF1_ADDRESS(pci_bus0, SPECIAL_DEV, SPECIAL_REG), 0xCF8); */
-	outl(PIIX_SPECIAL_STOP, 0xCFC);
-}
-
-static void __init visws_get_smp_config(unsigned int early)
-{
-}
-
-/*
- * The Visual Workstation is Intel MP compliant in the hardware
- * sense, but it doesn't have a BIOS(-configuration table).
- * No problem for Linux.
- */
-
-static void __init MP_processor_info(struct mpc_cpu *m)
-{
-	int ver, logical_apicid;
-	physid_mask_t apic_cpus;
-
-	if (!(m->cpuflag & CPU_ENABLED))
-		return;
-
-	logical_apicid = m->apicid;
-	printk(KERN_INFO "%sCPU #%d %u:%u APIC version %d\n",
-	       m->cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
-	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->cpufeature & CPU_MODEL_MASK) >> 4, m->apicver);
-
-	if (m->cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->apicid;
-
-	ver = m->apicver;
-	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {
-		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
-			m->apicid, MAX_LOCAL_APIC);
-		return;
-	}
-
-	apic->apicid_to_cpu_present(m->apicid, &apic_cpus);
-	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
-	/*
-	 * Validate version
-	 */
-	if (ver == 0x0) {
-		printk(KERN_ERR "BIOS bug, APIC version is 0 for CPU#%d! "
-			"fixing up to 0x10. (tell your hw vendor)\n",
-			m->apicid);
-		ver = 0x10;
-	}
-	apic_version[m->apicid] = ver;
-}
-
-static void __init visws_find_smp_config(void)
-{
-	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
-	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
-
-	if (ncpus > CO_CPU_MAX) {
-		printk(KERN_WARNING "find_visws_smp: got cpu count of %d at %p\n",
-			ncpus, mp);
-
-		ncpus = CO_CPU_MAX;
-	}
-
-	if (ncpus > setup_max_cpus)
-		ncpus = setup_max_cpus;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	smp_found_config = 1;
-#endif
-	while (ncpus--)
-		MP_processor_info(mp++);
-
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-}
-
-static void visws_trap_init(void);
-
-void __init visws_early_detect(void)
-{
-	int raw;
-
-	visws_board_type = (char)(inb_p(PIIX_GPI_BD_REG) & PIIX_GPI_BD_REG)
-							 >> PIIX_GPI_BD_SHIFT;
-
-	if (visws_board_type < 0)
-		return;
-
-	/*
-	 * Override the default platform setup functions
-	 */
-	x86_init.resources.memory_setup = visws_memory_setup;
-	x86_init.mpparse.get_smp_config = visws_get_smp_config;
-	x86_init.mpparse.find_smp_config = visws_find_smp_config;
-	x86_init.irqs.pre_vector_init = visws_pre_intr_init;
-	x86_init.irqs.trap_init = visws_trap_init;
-	x86_init.timers.timer_init = visws_time_init;
-	x86_init.pci.init = pci_visws_init;
-	x86_init.pci.init_irq = x86_init_noop;
-
-	/*
-	 * Install reboot quirks:
-	 */
-	pm_power_off			= visws_machine_power_off;
-	machine_ops.emergency_restart	= visws_machine_emergency_restart;
-
-	/*
-	 * Do not use broadcast IPIs:
-	 */
-	no_broadcast = 0;
-
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * Turn off IO-APIC detection and initialization:
-	 */
-	skip_ioapic_setup		= 1;
-#endif
-
-	/*
-	 * Get Board rev.
-	 * First, we have to initialize the 307 part to allow us access
-	 * to the GPIO registers.  Let's map them at 0x0fc0 which is right
-	 * after the PIIX4 PM section.
-	 */
-	outb_p(SIO_DEV_SEL, SIO_INDEX);
-	outb_p(SIO_GP_DEV, SIO_DATA);	/* Talk to GPIO regs. */
-
-	outb_p(SIO_DEV_MSB, SIO_INDEX);
-	outb_p(SIO_GP_MSB, SIO_DATA);	/* MSB of GPIO base address */
-
-	outb_p(SIO_DEV_LSB, SIO_INDEX);
-	outb_p(SIO_GP_LSB, SIO_DATA);	/* LSB of GPIO base address */
-
-	outb_p(SIO_DEV_ENB, SIO_INDEX);
-	outb_p(1, SIO_DATA);		/* Enable GPIO registers. */
-
-	/*
-	 * Now, we have to map the power management section to write
-	 * a bit which enables access to the GPIO registers.
-	 * What lunatic came up with this shit?
-	 */
-	outb_p(SIO_DEV_SEL, SIO_INDEX);
-	outb_p(SIO_PM_DEV, SIO_DATA);	/* Talk to GPIO regs. */
-
-	outb_p(SIO_DEV_MSB, SIO_INDEX);
-	outb_p(SIO_PM_MSB, SIO_DATA);	/* MSB of PM base address */
-
-	outb_p(SIO_DEV_LSB, SIO_INDEX);
-	outb_p(SIO_PM_LSB, SIO_DATA);	/* LSB of PM base address */
-
-	outb_p(SIO_DEV_ENB, SIO_INDEX);
-	outb_p(1, SIO_DATA);		/* Enable PM registers. */
-
-	/*
-	 * Now, write the PM register which enables the GPIO registers.
-	 */
-	outb_p(SIO_PM_FER2, SIO_PM_INDEX);
-	outb_p(SIO_PM_GP_EN, SIO_PM_DATA);
-
-	/*
-	 * Now, initialize the GPIO registers.
-	 * We want them all to be inputs which is the
-	 * power on default, so let's leave them alone.
-	 * So, let's just read the board rev!
-	 */
-	raw = inb_p(SIO_GP_DATA1);
-	raw &= 0x7f;	/* 7 bits of valid board revision ID. */
-
-	if (visws_board_type == VISWS_320) {
-		if (raw < 0x6) {
-			visws_board_rev = 4;
-		} else if (raw < 0xc) {
-			visws_board_rev = 5;
-		} else {
-			visws_board_rev = 6;
-		}
-	} else if (visws_board_type == VISWS_540) {
-			visws_board_rev = 2;
-		} else {
-			visws_board_rev = raw;
-		}
-
-	printk(KERN_INFO "Silicon Graphics Visual Workstation %s (rev %d) detected\n",
-	       (visws_board_type == VISWS_320 ? "320" :
-	       (visws_board_type == VISWS_540 ? "540" :
-		"unknown")), visws_board_rev);
-}
-
-#define A01234 (LI_INTA_0 | LI_INTA_1 | LI_INTA_2 | LI_INTA_3 | LI_INTA_4)
-#define BCD (LI_INTB | LI_INTC | LI_INTD)
-#define ALLDEVS (A01234 | BCD)
-
-static __init void lithium_init(void)
-{
-	set_fixmap(FIX_LI_PCIA, LI_PCI_A_PHYS);
-	set_fixmap(FIX_LI_PCIB, LI_PCI_B_PHYS);
-
-	if ((li_pcia_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
-	    (li_pcia_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
-		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'A');
-/*		panic("This machine is not SGI Visual Workstation 320/540"); */
-	}
-
-	if ((li_pcib_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
-	    (li_pcib_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
-		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'B');
-/*		panic("This machine is not SGI Visual Workstation 320/540"); */
-	}
-
-	li_pcia_write16(LI_PCI_INTEN, ALLDEVS);
-	li_pcib_write16(LI_PCI_INTEN, ALLDEVS);
-}
-
-static __init void cobalt_init(void)
-{
-	/*
-	 * On normal SMP PC this is used only with SMP, but we have to
-	 * use it and set it up here to start the Cobalt clock
-	 */
-	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
-	setup_local_APIC();
-	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
-		(unsigned int)apic_read(APIC_LVR),
-		(unsigned int)apic_read(APIC_ID));
-
-	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
-	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);
-	printk(KERN_INFO "Cobalt Revision %#lx, APIC ID %#lx\n",
-		co_cpu_read(CO_CPU_REV), co_apic_read(CO_APIC_ID));
-
-	/* Enable Cobalt APIC being careful to NOT change the ID! */
-	co_apic_write(CO_APIC_ID, co_apic_read(CO_APIC_ID) | CO_APIC_ENABLE);
-
-	printk(KERN_INFO "Cobalt APIC enabled: ID reg %#lx\n",
-		co_apic_read(CO_APIC_ID));
-}
-
-static void __init visws_trap_init(void)
-{
-	lithium_init();
-	cobalt_init();
-}
-
-/*
- * IRQ controller / APIC support:
- */
-
-static DEFINE_SPINLOCK(cobalt_lock);
-
-/*
- * Set the given Cobalt APIC Redirection Table entry to point
- * to the given IDT vector/index.
- */
-static inline void co_apic_set(int entry, int irq)
-{
-	co_apic_write(CO_APIC_LO(entry), CO_APIC_LEVEL | (irq + FIRST_EXTERNAL_VECTOR));
-	co_apic_write(CO_APIC_HI(entry), 0);
-}
-
-/*
- * Cobalt (IO)-APIC functions to handle PCI devices.
- */
-static inline int co_apic_ide0_hack(void)
-{
-	extern char visws_board_type;
-	extern char visws_board_rev;
-
-	if (visws_board_type == VISWS_320 && visws_board_rev == 5)
-		return 5;
-	return CO_APIC_IDE0;
-}
-
-static int is_co_apic(unsigned int irq)
-{
-	if (IS_CO_APIC(irq))
-		return CO_APIC(irq);
-
-	switch (irq) {
-		case 0: return CO_APIC_CPU;
-		case CO_IRQ_IDE0: return co_apic_ide0_hack();
-		case CO_IRQ_IDE1: return CO_APIC_IDE1;
-		default: return -1;
-	}
-}
-
-
-/*
- * This is the SGI Cobalt (IO-)APIC:
- */
-static void enable_cobalt_irq(struct irq_data *data)
-{
-	co_apic_set(is_co_apic(data->irq), data->irq);
-}
-
-static void disable_cobalt_irq(struct irq_data *data)
-{
-	int entry = is_co_apic(data->irq);
-
-	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
-	co_apic_read(CO_APIC_LO(entry));
-}
-
-static void ack_cobalt_irq(struct irq_data *data)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(data);
-	apic_write(APIC_EOI, APIC_EOI_ACK);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-}
-
-static struct irq_chip cobalt_irq_type = {
-	.name		= "Cobalt-APIC",
-	.irq_enable	= enable_cobalt_irq,
-	.irq_disable	= disable_cobalt_irq,
-	.irq_ack	= ack_cobalt_irq,
-};
-
-
-/*
- * This is the PIIX4-based 8259 that is wired up indirectly to Cobalt
- * -- not the manner expected by the code in i8259.c.
- *
- * there is a 'master' physical interrupt source that gets sent to
- * the CPU. But in the chipset there are various 'virtual' interrupts
- * waiting to be handled. We represent this to Linux through a 'master'
- * interrupt controller type, and through a special virtual interrupt-
- * controller. Device drivers only see the virtual interrupt sources.
- */
-static unsigned int startup_piix4_master_irq(struct irq_data *data)
-{
-	legacy_pic->init(0);
-	enable_cobalt_irq(data);
-	return 0;
-}
-
-static struct irq_chip piix4_master_irq_type = {
-	.name		= "PIIX4-master",
-	.irq_startup	= startup_piix4_master_irq,
-	.irq_ack	= ack_cobalt_irq,
-};
-
-static void pii4_mask(struct irq_data *data) { }
-
-static struct irq_chip piix4_virtual_irq_type = {
-	.name		= "PIIX4-virtual",
-	.irq_mask	= pii4_mask,
-};
-
-/*
- * PIIX4-8259 master/virtual functions to handle interrupt requests
- * from legacy devices: floppy, parallel, serial, rtc.
- *
- * None of these get Cobalt APIC entries, neither do they have IDT
- * entries. These interrupts are purely virtual and distributed from
- * the 'master' interrupt source: CO_IRQ_8259.
- *
- * When the 8259 interrupts its handler figures out which of these
- * devices is interrupting and dispatches to its handler.
- *
- * CAREFUL: devices see the 'virtual' interrupt only. Thus disable/
- * enable_irq gets the right irq. This 'master' irq is never directly
- * manipulated by any driver.
- */
-static irqreturn_t piix4_master_intr(int irq, void *dev_id)
-{
-	unsigned long flags;
-	int realirq;
-
-	raw_spin_lock_irqsave(&i8259A_lock, flags);
-
-	/* Find out what's interrupting in the PIIX4 master 8259 */
-	outb(0x0c, 0x20);		/* OCW3 Poll command */
-	realirq = inb(0x20);
-
-	/*
-	 * Bit 7 == 0 means invalid/spurious
-	 */
-	if (unlikely(!(realirq & 0x80)))
-		goto out_unlock;
-
-	realirq &= 7;
-
-	if (unlikely(realirq == 2)) {
-		outb(0x0c, 0xa0);
-		realirq = inb(0xa0);
-
-		if (unlikely(!(realirq & 0x80)))
-			goto out_unlock;
-
-		realirq = (realirq & 7) + 8;
-	}
-
-	/* mask and ack interrupt */
-	cached_irq_mask |= 1 << realirq;
-	if (unlikely(realirq > 7)) {
-		inb(0xa1);
-		outb(cached_slave_mask, 0xa1);
-		outb(0x60 + (realirq & 7), 0xa0);
-		outb(0x60 + 2, 0x20);
-	} else {
-		inb(0x21);
-		outb(cached_master_mask, 0x21);
-		outb(0x60 + realirq, 0x20);
-	}
-
-	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
-
-	/*
-	 * handle this 'virtual interrupt' as a Cobalt one now.
-	 */
-	generic_handle_irq(realirq);
-
-	return IRQ_HANDLED;
-
-out_unlock:
-	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
-	return IRQ_NONE;
-}
-
-static struct irqaction master_action = {
-	.handler =	piix4_master_intr,
-	.name =		"PIIX4-8259",
-	.flags =	IRQF_NO_THREAD,
-};
-
-static struct irqaction cascade_action = {
-	.handler = 	no_action,
-	.name =		"cascade",
-	.flags =	IRQF_NO_THREAD,
-};
-
-static inline void set_piix4_virtual_irq_type(void)
-{
-	piix4_virtual_irq_type.irq_enable = i8259A_chip.irq_unmask;
-	piix4_virtual_irq_type.irq_disable = i8259A_chip.irq_mask;
-	piix4_virtual_irq_type.irq_unmask = i8259A_chip.irq_unmask;
-}
-
-static void __init visws_pre_intr_init(void)
-{
-	int i;
-
-	set_piix4_virtual_irq_type();
-
-	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		struct irq_chip *chip = NULL;
-
-		if (i == 0)
-			chip = &cobalt_irq_type;
-		else if (i == CO_IRQ_IDE0)
-			chip = &cobalt_irq_type;
-		else if (i == CO_IRQ_IDE1)
-			chip = &cobalt_irq_type;
-		else if (i == CO_IRQ_8259)
-			chip = &piix4_master_irq_type;
-		else if (i < CO_IRQ_APIC0)
-			chip = &piix4_virtual_irq_type;
-		else if (IS_CO_APIC(i))
-			chip = &cobalt_irq_type;
-
-		if (chip)
-			irq_set_chip(i, chip);
-	}
-
-	setup_irq(CO_IRQ_8259, &master_action);
-	setup_irq(2, &cascade_action);
-}
