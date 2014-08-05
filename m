Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaHEVXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:23:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:38369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaHEVXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:23:19 -0400
Date: Tue, 5 Aug 2014 23:23:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq updates for 3.17
Message-ID: <alpine.DEB.2.10.1408052302570.3323@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

Nothing spectacular from the irq department this time:
 * Overhaul of the crossbar chip driver
 * Overhaul of the spear shirq chip driver
 * Support for the atmel-aic chip
 * Code move from arch to drivers
 * The usual tiny fixlets
 * Two reverts worth to mention which undo the too simple attempt
   of supporting wakeup interrupts on shared interrupt lines.

Thanks,

	tglx

------------------>
Boris BREZILLON (6):
      genirq: generic chip: Export irq_map_generic_chip function
      irqchip: atmel-aic: Move binding doc to interrupt-controller directory
      irqchip: atmel-aic: Add atmel AIC/AIC5 drivers
      irqchip: atmel-aic: Add irq fixup infrastructure
      irqchip: atmel-aic: Implement RTC irq fixup
      irqchip: atmel-aic: Define irq fixups for atmel SoCs

Daniel Thompson (1):
      irqchip: nvic: Use the generic noop function

Jiang Liu (1):
      genirq: Export irq_domain_disassociate() to architecture interrupt drivers

Nishanth Menon (14):
      irqchip: crossbar: Dont use '0' to mark reserved interrupts
      irqchip: crossbar: Check for premapped crossbar before allocating
      irqchip: crossbar: Introduce ti, irqs-skip to skip irqs that bypass crossbar
      irqchip: crossbar: Initialise the crossbar with a safe value
      irqchip: crossbar: Change allocation logic by reversing search for free irqs
      irqchip: crossbar: Remove IS_ERR_VALUE check
      irqchip: crossbar: Fix sparse and checkpatch warnings
      irqchip: crossbar: Fix kerneldoc warning
      irqchip: crossbar: Return proper error value
      irqchip: crossbar: Change the goto naming
      irqchip: crossbar: Introduce ti, max-crossbar-sources to identify valid crossbar mapping
      irqchip: crossbar: Introduce centralized check for crossbar write
      documentation: dt: omap: crossbar: Add description for interrupt consumer
      irqchip: crossbar: Allow for quirky hardware with direct hardwiring of GIC

Peter Zijlstra (1):
      irq: Warn when shared interrupts do not match on NO_SUSPEND

Rafael J. Wysocki (1):
      PM / sleep / irq: Do not suspend wakeup interrupts

Sricharan R (2):
      irqchip: crossbar: Set cb pointer to null in case of error
      irqchip: crossbar: Add kerneldoc for crossbar_domain_unmap callback

Stefan Kristiansson (1):
      irqchip: or1k-pic: Migrate from arch/openrisc/

Thomas Gleixner (14):
      irqchip: spear_shirq: Kill pointless static
      irqchip: spear_shirq: Move private structs to source
      irqchip: spear_shirq: No point in storing the parent irq
      irqchip: spear_shirq: Namespace cleanup
      irqchip: spear_shirq: Reorder the spear320 ras blocks
      irqchip: spear_shirq: Use the proper interfaces
      irqchip: spear_shirq: Precalculate status mask
      irqchip: spear_shirq: Kill the clear_reg nonsense
      irqchip: spear_shirq: Simplify chained handler
      irqchip: spear_shirq: Remove the parent irq "ack"/unmask
      irqchip: spear_shirq: Use proper irq chips for the different SoCs
      irqchip: spear_shirq: Simplify register access code
      Revert "PM / sleep / irq: Do not suspend wakeup interrupts"
      Revert "irq: Warn when shared interrupts do not match on NO_SUSPEND"

 .../atmel-aic.txt                        |   42 -
 .../crossbar.txt                         |   36 +
 .../atmel,aic.txt		          |   42 +
 .../opencores,or1k-pic.txt               |   23 
 arch/openrisc/Kconfig                    |    1 
 arch/openrisc/include/asm/irq.h          |    3 
 arch/openrisc/kernel/irq.c               |  146 ----
 drivers/irqchip/Kconfig                  |   18 
 drivers/irqchip/Makefile                 |    3 
 drivers/irqchip/irq-atmel-aic-common.c   |  254 +++++++
 drivers/irqchip/irq-atmel-aic-common.h   |   39 +
 drivers/irqchip/irq-atmel-aic.c          |  262 +++++++
 drivers/irqchip/irq-atmel-aic5.c         |  353 ++++++++++
 drivers/irqchip/irq-crossbar.c           |  168 ++++
 drivers/irqchip/irq-nvic.c               |   13 
 drivers/irqchip/irq-or1k-pic.c           |  182 +++++
 drivers/irqchip/spear-shirq.c            |  304 +++-----
 include/linux/irq.h                      |    2 
 include/linux/irqdomain.h                |    2 
 kernel/irq/generic-chip.c                |    5 
 kernel/irq/irqdomain.c                   |    2 
 include/linux/irqchip/spear-shirq.h      |   64 -
 22 files changed, 1521 insertions(+), 443 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
deleted file mode 100644
index 2742e9c..0000000
--- a/Documentation/devicetree/bindings/arm/atmel-aic.txt
+++ /dev/null
@@ -1,42 +0,0 @@
-* Advanced Interrupt Controller (AIC)
-
-Required properties:
-- compatible: Should be "atmel,<chip>-aic"
-  <chip> can be "at91rm9200" or "sama5d3"
-- interrupt-controller: Identifies the node as an interrupt controller.
-- interrupt-parent: For single AIC system, it is an empty property.
-- #interrupt-cells: The number of cells to define the interrupts. It should be 3.
-  The first cell is the IRQ number (aka "Peripheral IDentifier" on datasheet).
-  The second cell is used to specify flags:
-    bits[3:0] trigger type and level flags:
-      1 = low-to-high edge triggered.
-      2 = high-to-low edge triggered.
-      4 = active high level-sensitive.
-      8 = active low level-sensitive.
-      Valid combinations are 1, 2, 3, 4, 8.
-      Default flag for internal sources should be set to 4 (active high).
-  The third cell is used to specify the irq priority from 0 (lowest) to 7
-  (highest).
-- reg: Should contain AIC registers location and length
-- atmel,external-irqs: u32 array of external irqs.
-
-Examples:
-	/*
-	 * AIC
-	 */
-	aic: interrupt-controller@fffff000 {
-		compatible = "atmel,at91rm9200-aic";
-		interrupt-controller;
-		interrupt-parent;
-		#interrupt-cells = <3>;
-		reg = <0xfffff000 0x200>;
-	};
-
-	/*
-	 * An interrupt generating device that is wired to an AIC.
-	 */
-	dma: dma-controller@ffffec00 {
-		compatible = "atmel,at91sam9g45-dma";
-		reg = <0xffffec00 0x200>;
-		interrupts = <21 4 5>;
-	};
diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
index fb88585..4139db3 100644
--- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
+++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
@@ -10,6 +10,7 @@ Required properties:
 - compatible : Should be "ti,irq-crossbar"
 - reg: Base address and the size of the crossbar registers.
 - ti,max-irqs: Total number of irqs available at the interrupt controller.
+- ti,max-crossbar-sources: Maximum number of crossbar sources that can be routed.
 - ti,reg-size: Size of a individual register in bytes. Every individual
 	    register is assumed to be of same size. Valid sizes are 1, 2, 4.
 - ti,irqs-reserved: List of the reserved irq lines that are not muxed using
@@ -17,11 +18,46 @@ Required properties:
 		 so crossbar bar driver should not consider them as free
 		 lines.
 
+Optional properties:
+- ti,irqs-skip: This is similar to "ti,irqs-reserved", but these are for
+  SOC-specific hard-wiring of those irqs which unexpectedly bypasses the
+  crossbar. These irqs have a crossbar register, but still cannot be used.
+
+- ti,irqs-safe-map: integer which maps to a safe configuration to use
+  when the interrupt controller irq is unused (when not provided, default is 0)
+
 Examples:
 		crossbar_mpu: @4a020000 {
 			compatible = "ti,irq-crossbar";
 			reg = <0x4a002a48 0x130>;
 			ti,max-irqs = <160>;
+			ti,max-crossbar-sources = <400>;
 			ti,reg-size = <2>;
 			ti,irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
+			ti,irqs-skip = <10 133 139 140>;
 		};
+
+Consumer:
+========
+See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt and
+Documentation/devicetree/bindings/arm/gic.txt for further details.
+
+An interrupt consumer on an SoC using crossbar will use:
+	interrupts = <GIC_SPI request_number interrupt_level>
+When the request number is between 0 to that described by
+"ti,max-crossbar-sources", it is assumed to be a crossbar mapping. If the
+request_number is greater than "ti,max-crossbar-sources", then it is mapped as a
+quirky hardware mapping direct to GIC.
+
+Example:
+	device_x@0x4a023000 {
+		/* Crossbar 8 used */
+		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
+		...
+	};
+
+	device_y@0x4a033000 {
+		/* Direct mapped GIC SPI 1 used */
+		interrupts = <GIC_SPI DIRECT_IRQ(1) IRQ_TYPE_LEVEL_HIGH>;
+		...
+	};
diff --git a/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
new file mode 100644
index 0000000..2742e9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
@@ -0,0 +1,42 @@
+* Advanced Interrupt Controller (AIC)
+
+Required properties:
+- compatible: Should be "atmel,<chip>-aic"
+  <chip> can be "at91rm9200" or "sama5d3"
+- interrupt-controller: Identifies the node as an interrupt controller.
+- interrupt-parent: For single AIC system, it is an empty property.
+- #interrupt-cells: The number of cells to define the interrupts. It should be 3.
+  The first cell is the IRQ number (aka "Peripheral IDentifier" on datasheet).
+  The second cell is used to specify flags:
+    bits[3:0] trigger type and level flags:
+      1 = low-to-high edge triggered.
+      2 = high-to-low edge triggered.
+      4 = active high level-sensitive.
+      8 = active low level-sensitive.
+      Valid combinations are 1, 2, 3, 4, 8.
+      Default flag for internal sources should be set to 4 (active high).
+  The third cell is used to specify the irq priority from 0 (lowest) to 7
+  (highest).
+- reg: Should contain AIC registers location and length
+- atmel,external-irqs: u32 array of external irqs.
+
+Examples:
+	/*
+	 * AIC
+	 */
+	aic: interrupt-controller@fffff000 {
+		compatible = "atmel,at91rm9200-aic";
+		interrupt-controller;
+		interrupt-parent;
+		#interrupt-cells = <3>;
+		reg = <0xfffff000 0x200>;
+	};
+
+	/*
+	 * An interrupt generating device that is wired to an AIC.
+	 */
+	dma: dma-controller@ffffec00 {
+		compatible = "atmel,at91sam9g45-dma";
+		reg = <0xffffec00 0x200>;
+		interrupts = <21 4 5>;
+	};
diff --git a/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
new file mode 100644
index 0000000..55c04fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
@@ -0,0 +1,23 @@
+OpenRISC 1000 Programmable Interrupt Controller
+
+Required properties:
+
+- compatible : should be "opencores,or1k-pic-level" for variants with
+  level triggered interrupt lines, "opencores,or1k-pic-edge" for variants with
+  edge triggered interrupt lines or "opencores,or1200-pic" for machines
+  with the non-spec compliant or1200 type implementation.
+
+  "opencores,or1k-pic" is also provided as an alias to "opencores,or1200-pic",
+  but this is only for backwards compatibility.
+
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 1.
+
+Example:
+
+intc: interrupt-controller {
+	compatible = "opencores,or1k-pic-level";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+};
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index e71d712..88e8336 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -22,6 +22,7 @@ config OPENRISC
 	select GENERIC_STRNLEN_USER
 	select MODULES_USE_ELF_RELA
 	select HAVE_DEBUG_STACKOVERFLOW
+	select OR1K_PIC
 
 config MMU
 	def_bool y
diff --git a/arch/openrisc/include/asm/irq.h b/arch/openrisc/include/asm/irq.h
index eb612b1..b84634c 100644
--- a/arch/openrisc/include/asm/irq.h
+++ b/arch/openrisc/include/asm/irq.h
@@ -24,4 +24,7 @@
 
 #define NO_IRQ		(-1)
 
+void handle_IRQ(unsigned int, struct pt_regs *);
+extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
+
 #endif /* __ASM_OPENRISC_IRQ_H__ */
diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 8ec77bc..967eb14 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -16,11 +16,10 @@
 
 #include <linux/interrupt.h>
 #include <linux/init.h>
-#include <linux/of.h>
 #include <linux/ftrace.h>
 #include <linux/irq.h>
+#include <linux/irqchip.h>
 #include <linux/export.h>
-#include <linux/irqdomain.h>
 #include <linux/irqflags.h>
 
 /* read interrupt enabled status */
@@ -37,150 +36,31 @@ void arch_local_irq_restore(unsigned long flags)
 }
 EXPORT_SYMBOL(arch_local_irq_restore);
 
-
-/* OR1K PIC implementation */
-
-/* We're a couple of cycles faster than the generic implementations with
- * these 'fast' versions.
- */
-
-static void or1k_pic_mask(struct irq_data *data)
-{
-	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
-}
-
-static void or1k_pic_unmask(struct irq_data *data)
-{
-	mtspr(SPR_PICMR, mfspr(SPR_PICMR) | (1UL << data->hwirq));
-}
-
-static void or1k_pic_ack(struct irq_data *data)
-{
-	/* EDGE-triggered interrupts need to be ack'ed in order to clear
-	 * the latch.
-	 * LEVEL-triggered interrupts do not need to be ack'ed; however,
-	 * ack'ing the interrupt has no ill-effect and is quicker than
-	 * trying to figure out what type it is...
-	 */
-
-	/* The OpenRISC 1000 spec says to write a 1 to the bit to ack the
-	 * interrupt, but the OR1200 does this backwards and requires a 0
-	 * to be written...
-	 */
-
-#ifdef CONFIG_OR1K_1200
-	/* There are two oddities with the OR1200 PIC implementation:
-	 * i)  LEVEL-triggered interrupts are latched and need to be cleared
-	 * ii) the interrupt latch is cleared by writing a 0 to the bit,
-	 *     as opposed to a 1 as mandated by the spec
-	 */
-
-	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
-#else
-	WARN(1, "Interrupt handling possibly broken\n");
-	mtspr(SPR_PICSR, (1UL << data->hwirq));
-#endif
-}
-
-static void or1k_pic_mask_ack(struct irq_data *data)
-{
-	/* Comments for pic_ack apply here, too */
-
-#ifdef CONFIG_OR1K_1200
-	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
-	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
-#else
-	WARN(1, "Interrupt handling possibly broken\n");
-	mtspr(SPR_PICMR, (1UL << data->hwirq));
-	mtspr(SPR_PICSR, (1UL << data->hwirq));
-#endif
-}
-
-#if 0
-static int or1k_pic_set_type(struct irq_data *data, unsigned int flow_type)
-{
-	/* There's nothing to do in the PIC configuration when changing
-	 * flow type.  Level and edge-triggered interrupts are both
-	 * supported, but it's PIC-implementation specific which type
-	 * is handled. */
-
-	return irq_setup_alt_chip(data, flow_type);
-}
-#endif
-
-static struct irq_chip or1k_dev = {
-	.name = "or1k-PIC",
-	.irq_unmask = or1k_pic_unmask,
-	.irq_mask = or1k_pic_mask,
-	.irq_ack = or1k_pic_ack,
-	.irq_mask_ack = or1k_pic_mask_ack,
-};
-
-static struct irq_domain *root_domain;
-
-static inline int pic_get_irq(int first)
-{
-	int hwirq;
-
-	hwirq = ffs(mfspr(SPR_PICSR) >> first);
-	if (!hwirq)
-		return NO_IRQ;
-	else
-		hwirq = hwirq + first -1;
-
-	return irq_find_mapping(root_domain, hwirq);
-}
-
-
-static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
+void __init init_IRQ(void)
 {
-	irq_set_chip_and_handler_name(irq, &or1k_dev,
-				      handle_level_irq, "level");
-	irq_set_status_flags(irq, IRQ_LEVEL | IRQ_NOPROBE);
-
-	return 0;
+	irqchip_init();
 }
 
-static const struct irq_domain_ops or1k_irq_domain_ops = {
-	.xlate = irq_domain_xlate_onecell,
-	.map = or1k_map,
-};
-
-/*
- * This sets up the IRQ domain for the PIC built in to the OpenRISC
- * 1000 CPU.  This is the "root" domain as these are the interrupts
- * that directly trigger an exception in the CPU.
- */
-static void __init or1k_irq_init(void)
-{
-	struct device_node *intc = NULL;
-
-	/* The interrupt controller device node is mandatory */
-	intc = of_find_compatible_node(NULL, NULL, "opencores,or1k-pic");
-	BUG_ON(!intc);
-
-	/* Disable all interrupts until explicitly requested */
-	mtspr(SPR_PICMR, (0UL));
-
-	root_domain = irq_domain_add_linear(intc, 32,
-					    &or1k_irq_domain_ops, NULL);
-}
+static void (*handle_arch_irq)(struct pt_regs *);
 
-void __init init_IRQ(void)
+void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 {
-	or1k_irq_init();
+	handle_arch_irq = handle_irq;
 }
 
-void __irq_entry do_IRQ(struct pt_regs *regs)
+void handle_IRQ(unsigned int irq, struct pt_regs *regs)
 {
-	int irq = -1;
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	irq_enter();
 
-	while ((irq = pic_get_irq(irq + 1)) != NO_IRQ)
-		generic_handle_irq(irq);
+	generic_handle_irq(irq);
 
 	irq_exit();
 	set_irq_regs(old_regs);
 }
+
+void __irq_entry do_IRQ(struct pt_regs *regs)
+{
+	handle_arch_irq(regs);
+}
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 7f0c2a3..4e230e7 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -35,6 +35,20 @@ config ARM_VIC_NR
 	  The maximum number of VICs available in the system, for
 	  power management.
 
+config ATMEL_AIC_IRQ
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+
+config ATMEL_AIC5_IRQ
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+
 config BRCMSTB_L2_IRQ
 	bool
 	depends on ARM
@@ -58,6 +72,10 @@ config CLPS711X_IRQCHIP
 	select SPARSE_IRQ
 	default y
 
+config OR1K_PIC
+	bool
+	select IRQ_DOMAIN
+
 config ORION_IRQCHIP
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index c57e642..73052ba 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
 obj-$(CONFIG_CLPS711X_IRQCHIP)		+= irq-clps711x.o
+obj-$(CONFIG_OR1K_PIC)			+= irq-or1k-pic.o
 obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
@@ -19,6 +20,8 @@ obj-$(CONFIG_ARM_GIC)			+= irq-gic.o irq-gic-common.o
 obj-$(CONFIG_ARM_GIC_V3)		+= irq-gic-v3.o irq-gic-common.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
+obj-$(CONFIG_ATMEL_AIC_IRQ)		+= irq-atmel-aic-common.o irq-atmel-aic.o
+obj-$(CONFIG_ATMEL_AIC5_IRQ)	+= irq-atmel-aic-common.o irq-atmel-aic5.o
 obj-$(CONFIG_IMGPDC_IRQ)		+= irq-imgpdc.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
new file mode 100644
index 0000000..6ae3cdee
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -0,0 +1,254 @@
+/*
+ * Atmel AT91 common AIC (Advanced Interrupt Controller) code shared by
+ * irq-atmel-aic and irq-atmel-aic5 drivers
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "irq-atmel-aic-common.h"
+
+#define AT91_AIC_PRIOR			GENMASK(2, 0)
+#define AT91_AIC_IRQ_MIN_PRIORITY	0
+#define AT91_AIC_IRQ_MAX_PRIORITY	7
+
+#define AT91_AIC_SRCTYPE		GENMASK(7, 6)
+#define AT91_AIC_SRCTYPE_LOW		(0 << 5)
+#define AT91_AIC_SRCTYPE_FALLING	(1 << 5)
+#define AT91_AIC_SRCTYPE_HIGH		(2 << 5)
+#define AT91_AIC_SRCTYPE_RISING		(3 << 5)
+
+struct aic_chip_data {
+	u32 ext_irqs;
+};
+
+static void aic_common_shutdown(struct irq_data *d)
+{
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	ct->chip.irq_mask(d);
+}
+
+int aic_common_set_type(struct irq_data *d, unsigned type, unsigned *val)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct aic_chip_data *aic = gc->private;
+	unsigned aic_type;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		aic_type = AT91_AIC_SRCTYPE_HIGH;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		aic_type = AT91_AIC_SRCTYPE_RISING;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		if (!(d->mask & aic->ext_irqs))
+			return -EINVAL;
+
+		aic_type = AT91_AIC_SRCTYPE_LOW;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		if (!(d->mask & aic->ext_irqs))
+			return -EINVAL;
+
+		aic_type = AT91_AIC_SRCTYPE_FALLING;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*val &= AT91_AIC_SRCTYPE;
+	*val |= aic_type;
+
+	return 0;
+}
+
+int aic_common_set_priority(int priority, unsigned *val)
+{
+	if (priority < AT91_AIC_IRQ_MIN_PRIORITY ||
+	    priority > AT91_AIC_IRQ_MAX_PRIORITY)
+		return -EINVAL;
+
+	*val &= AT91_AIC_PRIOR;
+	*val |= priority;
+
+	return 0;
+}
+
+int aic_common_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec,
+				unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type)
+{
+	if (WARN_ON(intsize < 3))
+		return -EINVAL;
+
+	if (WARN_ON((intspec[2] < AT91_AIC_IRQ_MIN_PRIORITY) ||
+		    (intspec[2] > AT91_AIC_IRQ_MAX_PRIORITY)))
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
+
+	return 0;
+}
+
+static void __init aic_common_ext_irq_of_init(struct irq_domain *domain)
+{
+	struct device_node *node = domain->of_node;
+	struct irq_chip_generic *gc;
+	struct aic_chip_data *aic;
+	struct property *prop;
+	const __be32 *p;
+	u32 hwirq;
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+
+	aic = gc->private;
+	aic->ext_irqs |= 1;
+
+	of_property_for_each_u32(node, "atmel,external-irqs", prop, p, hwirq) {
+		gc = irq_get_domain_generic_chip(domain, hwirq);
+		if (!gc) {
+			pr_warn("AIC: external irq %d >= %d skip it\n",
+				hwirq, domain->revmap_size);
+			continue;
+		}
+
+		aic = gc->private;
+		aic->ext_irqs |= (1 << (hwirq % 32));
+	}
+}
+
+#define AT91_RTC_IDR           0x24
+#define AT91_RTC_IMR           0x28
+#define AT91_RTC_IRQ_MASK      0x1f
+
+void __init aic_common_rtc_irq_fixup(struct device_node *root)
+{
+	struct device_node *np;
+	void __iomem *regs;
+
+	np = of_find_compatible_node(root, NULL, "atmel,at91rm9200-rtc");
+	if (!np)
+		np = of_find_compatible_node(root, NULL,
+					     "atmel,at91sam9x5-rtc");
+
+	if (!np)
+		return;
+
+	regs = of_iomap(np, 0);
+	of_node_put(np);
+
+	if (!regs)
+		return;
+
+	writel(AT91_RTC_IRQ_MASK, regs + AT91_RTC_IDR);
+
+	iounmap(regs);
+}
+
+void __init aic_common_irq_fixup(const struct of_device_id *matches)
+{
+	struct device_node *root = of_find_node_by_path("/");
+	const struct of_device_id *match;
+
+	if (!root)
+		return;
+
+	match = of_match_node(matches, root);
+	of_node_put(root);
+
+	if (match) {
+		void (*fixup)(struct device_node *) = match->data;
+		fixup(root);
+	}
+
+	of_node_put(root);
+}
+
+struct irq_domain *__init aic_common_of_init(struct device_node *node,
+					     const struct irq_domain_ops *ops,
+					     const char *name, int nirqs)
+{
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+	struct aic_chip_data *aic;
+	void __iomem *reg_base;
+	int nchips;
+	int ret;
+	int i;
+
+	nchips = DIV_ROUND_UP(nirqs, 32);
+
+	reg_base = of_iomap(node, 0);
+	if (!reg_base)
+		return ERR_PTR(-ENOMEM);
+
+	aic = kcalloc(nchips, sizeof(*aic), GFP_KERNEL);
+	if (!aic) {
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	domain = irq_domain_add_linear(node, nchips * 32, ops, aic);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto err_free_aic;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, 32, 1, name,
+					     handle_level_irq, 0, 0,
+					     IRQCHIP_SKIP_SET_WAKE);
+	if (ret)
+		goto err_domain_remove;
+
+	for (i = 0; i < nchips; i++) {
+		gc = irq_get_domain_generic_chip(domain, i * 32);
+
+		gc->reg_base = reg_base;
+
+		gc->unused = 0;
+		gc->wake_enabled = ~0;
+		gc->chip_types[0].type = IRQ_TYPE_SENSE_MASK;
+		gc->chip_types[0].handler = handle_fasteoi_irq;
+		gc->chip_types[0].chip.irq_eoi = irq_gc_eoi;
+		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
+		gc->chip_types[0].chip.irq_shutdown = aic_common_shutdown;
+		gc->private = &aic[i];
+	}
+
+	aic_common_ext_irq_of_init(domain);
+
+	return domain;
+
+err_domain_remove:
+	irq_domain_remove(domain);
+
+err_free_aic:
+	kfree(aic);
+
+err_iounmap:
+	iounmap(reg_base);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/irqchip/irq-atmel-aic-common.h b/drivers/irqchip/irq-atmel-aic-common.h
new file mode 100644
index 0000000..90aa00e
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic-common.h
@@ -0,0 +1,39 @@
+/*
+ * Atmel AT91 common AIC (Advanced Interrupt Controller) header file
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __IRQ_ATMEL_AIC_COMMON_H
+#define __IRQ_ATMEL_AIC_COMMON_H
+
+
+int aic_common_set_type(struct irq_data *d, unsigned type, unsigned *val);
+
+int aic_common_set_priority(int priority, unsigned *val);
+
+int aic_common_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec,
+				unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type);
+
+struct irq_domain *__init aic_common_of_init(struct device_node *node,
+					     const struct irq_domain_ops *ops,
+					     const char *name, int nirqs);
+
+void __init aic_common_rtc_irq_fixup(struct device_node *root);
+
+void __init aic_common_irq_fixup(const struct of_device_id *matches);
+
+#endif /* __IRQ_ATMEL_AIC_COMMON_H */
diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
new file mode 100644
index 0000000..a82869e
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -0,0 +1,262 @@
+/*
+ * Atmel AT91 AIC (Advanced Interrupt Controller) driver
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/bitmap.h>
+#include <linux/types.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irq-atmel-aic-common.h"
+#include "irqchip.h"
+
+/* Number of irq lines managed by AIC */
+#define NR_AIC_IRQS	32
+
+#define AT91_AIC_SMR(n)			((n) * 4)
+
+#define AT91_AIC_SVR(n)			(0x80 + ((n) * 4))
+#define AT91_AIC_IVR			0x100
+#define AT91_AIC_FVR			0x104
+#define AT91_AIC_ISR			0x108
+
+#define AT91_AIC_IPR			0x10c
+#define AT91_AIC_IMR			0x110
+#define AT91_AIC_CISR			0x114
+
+#define AT91_AIC_IECR			0x120
+#define AT91_AIC_IDCR			0x124
+#define AT91_AIC_ICCR			0x128
+#define AT91_AIC_ISCR			0x12c
+#define AT91_AIC_EOICR			0x130
+#define AT91_AIC_SPU			0x134
+#define AT91_AIC_DCR			0x138
+
+static struct irq_domain *aic_domain;
+
+static asmlinkage void __exception_irq_entry
+aic_handle(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = aic_domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	u32 irqnr;
+	u32 irqstat;
+
+	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC_IVR);
+	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC_ISR);
+
+	irqnr = irq_find_mapping(aic_domain, irqnr);
+
+	if (!irqstat)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+	else
+		handle_IRQ(irqnr, regs);
+}
+
+static int aic_retrigger(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	/* Enable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->mask, gc->reg_base + AT91_AIC_ISCR);
+	irq_gc_unlock(gc);
+
+	return 0;
+}
+
+static int aic_set_type(struct irq_data *d, unsigned type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	unsigned int smr;
+	int ret;
+
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(d->hwirq));
+	ret = aic_common_set_type(d, type, &smr);
+	if (ret)
+		return ret;
+
+	irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(d->hwirq));
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static void aic_suspend(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	irq_gc_lock(gc);
+	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IECR);
+	irq_gc_unlock(gc);
+}
+
+static void aic_resume(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	irq_gc_lock(gc);
+	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IECR);
+	irq_gc_unlock(gc);
+}
+
+static void aic_pm_shutdown(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+
+	irq_gc_lock(gc);
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+	irq_gc_unlock(gc);
+}
+#else
+#define aic_suspend		NULL
+#define aic_resume		NULL
+#define aic_pm_shutdown		NULL
+#endif /* CONFIG_PM */
+
+static void __init aic_hw_init(struct irq_domain *domain)
+{
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(domain, 0);
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_SPU);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	irq_reg_writel(0, gc->reg_base + AT91_AIC_DCR);
+
+	/* Disable and clear all interrupts initially */
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+
+	for (i = 0; i < 32; i++)
+		irq_reg_writel(i, gc->reg_base + AT91_AIC_SVR(i));
+}
+
+static int aic_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec, unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	struct irq_chip_generic *gc;
+	unsigned smr;
+	int idx;
+	int ret;
+
+	if (!dgc)
+		return -EINVAL;
+
+	ret = aic_common_irq_domain_xlate(d, ctrlr, intspec, intsize,
+					  out_hwirq, out_type);
+	if (ret)
+		return ret;
+
+	idx = intspec[0] / dgc->irqs_per_chip;
+	if (idx >= dgc->num_chips)
+		return -EINVAL;
+
+	gc = dgc->gc[idx];
+
+	irq_gc_lock(gc);
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+	ret = aic_common_set_priority(intspec[2], &smr);
+	if (!ret)
+		irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+	irq_gc_unlock(gc);
+
+	return ret;
+}
+
+static const struct irq_domain_ops aic_irq_ops = {
+	.map	= irq_map_generic_chip,
+	.xlate	= aic_irq_domain_xlate,
+};
+
+static void __init at91sam9_aic_irq_fixup(struct device_node *root)
+{
+	aic_common_rtc_irq_fixup(root);
+}
+
+static const struct of_device_id __initdata aic_irq_fixups[] = {
+	{ .compatible = "atmel,at91sam9g45", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9n12", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9rl", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9x5", .data = at91sam9_aic_irq_fixup },
+	{ /* sentinel */ },
+};
+
+static int __init aic_of_init(struct device_node *node,
+			      struct device_node *parent)
+{
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+
+	if (aic_domain)
+		return -EEXIST;
+
+	domain = aic_common_of_init(node, &aic_irq_ops, "atmel-aic",
+				    NR_AIC_IRQS);
+	if (IS_ERR(domain))
+		return PTR_ERR(domain);
+
+	aic_common_irq_fixup(aic_irq_fixups);
+
+	aic_domain = domain;
+	gc = irq_get_domain_generic_chip(domain, 0);
+
+	gc->chip_types[0].regs.eoi = AT91_AIC_EOICR;
+	gc->chip_types[0].regs.enable = AT91_AIC_IECR;
+	gc->chip_types[0].regs.disable = AT91_AIC_IDCR;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
+	gc->chip_types[0].chip.irq_retrigger = aic_retrigger;
+	gc->chip_types[0].chip.irq_set_type = aic_set_type;
+	gc->chip_types[0].chip.irq_suspend = aic_suspend;
+	gc->chip_types[0].chip.irq_resume = aic_resume;
+	gc->chip_types[0].chip.irq_pm_shutdown = aic_pm_shutdown;
+
+	aic_hw_init(domain);
+	set_handle_irq(aic_handle);
+
+	return 0;
+}
+IRQCHIP_DECLARE(at91rm9200_aic, "atmel,at91rm9200-aic", aic_of_init);
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
new file mode 100644
index 0000000..edb2270
--- /dev/null
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -0,0 +1,353 @@
+/*
+ * Atmel AT91 AIC5 (Advanced Interrupt Controller) driver
+ *
+ *  Copyright (C) 2004 SAN People
+ *  Copyright (C) 2004 ATMEL
+ *  Copyright (C) Rick Bronson
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/bitmap.h>
+#include <linux/types.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irq-atmel-aic-common.h"
+#include "irqchip.h"
+
+/* Number of irq lines managed by AIC */
+#define NR_AIC5_IRQS	128
+
+#define AT91_AIC5_SSR		0x0
+#define AT91_AIC5_INTSEL_MSK	(0x7f << 0)
+
+#define AT91_AIC5_SMR			0x4
+
+#define AT91_AIC5_SVR			0x8
+#define AT91_AIC5_IVR			0x10
+#define AT91_AIC5_FVR			0x14
+#define AT91_AIC5_ISR			0x18
+
+#define AT91_AIC5_IPR0			0x20
+#define AT91_AIC5_IPR1			0x24
+#define AT91_AIC5_IPR2			0x28
+#define AT91_AIC5_IPR3			0x2c
+#define AT91_AIC5_IMR			0x30
+#define AT91_AIC5_CISR			0x34
+
+#define AT91_AIC5_IECR			0x40
+#define AT91_AIC5_IDCR			0x44
+#define AT91_AIC5_ICCR			0x48
+#define AT91_AIC5_ISCR			0x4c
+#define AT91_AIC5_EOICR			0x38
+#define AT91_AIC5_SPU			0x3c
+#define AT91_AIC5_DCR			0x6c
+
+#define AT91_AIC5_FFER			0x50
+#define AT91_AIC5_FFDR			0x54
+#define AT91_AIC5_FFSR			0x58
+
+static struct irq_domain *aic5_domain;
+
+static asmlinkage void __exception_irq_entry
+aic5_handle(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = aic5_domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	u32 irqnr;
+	u32 irqstat;
+
+	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC5_IVR);
+	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC5_ISR);
+
+	irqnr = irq_find_mapping(aic5_domain, irqnr);
+
+	if (!irqstat)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+	else
+		handle_IRQ(irqnr, regs);
+}
+
+static void aic5_mask(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+
+	/* Disable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
+	gc->mask_cache &= ~d->mask;
+	irq_gc_unlock(gc);
+}
+
+static void aic5_unmask(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+
+	/* Enable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IECR);
+	gc->mask_cache |= d->mask;
+	irq_gc_unlock(gc);
+}
+
+static int aic5_retrigger(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+
+	/* Enable interrupt on AIC5 */
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	irq_reg_writel(1, gc->reg_base + AT91_AIC5_ISCR);
+	irq_gc_unlock(gc);
+
+	return 0;
+}
+
+static int aic5_set_type(struct irq_data *d, unsigned type)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	unsigned int smr;
+	int ret;
+
+	irq_gc_lock(gc);
+	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	ret = aic_common_set_type(d, type, &smr);
+	if (!ret)
+		irq_reg_writel(smr, gc->reg_base + AT91_AIC5_SMR);
+	irq_gc_unlock(gc);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static void aic5_suspend(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *bgc = dgc->gc[0];
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	int i;
+	u32 mask;
+
+	irq_gc_lock(bgc);
+	for (i = 0; i < dgc->irqs_per_chip; i++) {
+		mask = 1 << i;
+		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
+			continue;
+
+		irq_reg_writel(i + gc->irq_base,
+			       bgc->reg_base + AT91_AIC5_SSR);
+		if (mask & gc->wake_active)
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+		else
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+	}
+	irq_gc_unlock(bgc);
+}
+
+static void aic5_resume(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *bgc = dgc->gc[0];
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	int i;
+	u32 mask;
+
+	irq_gc_lock(bgc);
+	for (i = 0; i < dgc->irqs_per_chip; i++) {
+		mask = 1 << i;
+		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
+			continue;
+
+		irq_reg_writel(i + gc->irq_base,
+			       bgc->reg_base + AT91_AIC5_SSR);
+		if (mask & gc->mask_cache)
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+		else
+			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+	}
+	irq_gc_unlock(bgc);
+}
+
+static void aic5_pm_shutdown(struct irq_data *d)
+{
+	struct irq_domain *domain = d->domain;
+	struct irq_domain_chip_generic *dgc = domain->gc;
+	struct irq_chip_generic *bgc = dgc->gc[0];
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	int i;
+
+	irq_gc_lock(bgc);
+	for (i = 0; i < dgc->irqs_per_chip; i++) {
+		irq_reg_writel(i + gc->irq_base,
+			       bgc->reg_base + AT91_AIC5_SSR);
+		irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+		irq_reg_writel(1, bgc->reg_base + AT91_AIC5_ICCR);
+	}
+	irq_gc_unlock(bgc);
+}
+#else
+#define aic5_suspend		NULL
+#define aic5_resume		NULL
+#define aic5_pm_shutdown	NULL
+#endif /* CONFIG_PM */
+
+static void __init aic5_hw_init(struct irq_domain *domain)
+{
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(domain, 0);
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC5_SPU);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	irq_reg_writel(0, gc->reg_base + AT91_AIC5_DCR);
+
+	/* Disable and clear all interrupts initially */
+	for (i = 0; i < domain->revmap_size; i++) {
+		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SSR);
+		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SVR);
+		irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
+		irq_reg_writel(1, gc->reg_base + AT91_AIC5_ICCR);
+	}
+}
+
+static int aic5_irq_domain_xlate(struct irq_domain *d,
+				 struct device_node *ctrlr,
+				 const u32 *intspec, unsigned int intsize,
+				 irq_hw_number_t *out_hwirq,
+				 unsigned int *out_type)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	struct irq_chip_generic *gc;
+	unsigned smr;
+	int ret;
+
+	if (!dgc)
+		return -EINVAL;
+
+	ret = aic_common_irq_domain_xlate(d, ctrlr, intspec, intsize,
+					  out_hwirq, out_type);
+	if (ret)
+		return ret;
+
+	gc = dgc->gc[0];
+
+	irq_gc_lock(gc);
+	irq_reg_writel(*out_hwirq, gc->reg_base + AT91_AIC5_SSR);
+	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	ret = aic_common_set_priority(intspec[2], &smr);
+	if (!ret)
+		irq_reg_writel(intspec[2] | smr, gc->reg_base + AT91_AIC5_SMR);
+	irq_gc_unlock(gc);
+
+	return ret;
+}
+
+static const struct irq_domain_ops aic5_irq_ops = {
+	.map	= irq_map_generic_chip,
+	.xlate	= aic5_irq_domain_xlate,
+};
+
+static void __init sama5d3_aic_irq_fixup(struct device_node *root)
+{
+	aic_common_rtc_irq_fixup(root);
+}
+
+static const struct of_device_id __initdata aic5_irq_fixups[] = {
+	{ .compatible = "atmel,sama5d3", .data = sama5d3_aic_irq_fixup },
+	{ /* sentinel */ },
+};
+
+static int __init aic5_of_init(struct device_node *node,
+			       struct device_node *parent,
+			       int nirqs)
+{
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+	int nchips;
+	int i;
+
+	if (nirqs > NR_AIC5_IRQS)
+		return -EINVAL;
+
+	if (aic5_domain)
+		return -EEXIST;
+
+	domain = aic_common_of_init(node, &aic5_irq_ops, "atmel-aic5",
+				    nirqs);
+	if (IS_ERR(domain))
+		return PTR_ERR(domain);
+
+	aic_common_irq_fixup(aic5_irq_fixups);
+
+	aic5_domain = domain;
+	nchips = aic5_domain->revmap_size / 32;
+	for (i = 0; i < nchips; i++) {
+		gc = irq_get_domain_generic_chip(domain, i * 32);
+
+		gc->chip_types[0].regs.eoi = AT91_AIC5_EOICR;
+		gc->chip_types[0].chip.irq_mask = aic5_mask;
+		gc->chip_types[0].chip.irq_unmask = aic5_unmask;
+		gc->chip_types[0].chip.irq_retrigger = aic5_retrigger;
+		gc->chip_types[0].chip.irq_set_type = aic5_set_type;
+		gc->chip_types[0].chip.irq_suspend = aic5_suspend;
+		gc->chip_types[0].chip.irq_resume = aic5_resume;
+		gc->chip_types[0].chip.irq_pm_shutdown = aic5_pm_shutdown;
+	}
+
+	aic5_hw_init(domain);
+	set_handle_irq(aic5_handle);
+
+	return 0;
+}
+
+#define NR_SAMA5D3_IRQS		50
+
+static int __init sama5d3_aic5_of_init(struct device_node *node,
+				       struct device_node *parent)
+{
+	return aic5_of_init(node, parent, NR_SAMA5D3_IRQS);
+}
+IRQCHIP_DECLARE(sama5d3_aic5, "atmel,sama5d3-aic", sama5d3_aic5_of_init);
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 3d15d16..85c2985 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -15,22 +15,31 @@
 #include <linux/of_irq.h>
 #include <linux/slab.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/irq-crossbar.h>
 
 #define IRQ_FREE	-1
+#define IRQ_RESERVED	-2
+#define IRQ_SKIP	-3
 #define GIC_IRQ_START	32
 
-/*
+/**
+ * struct crossbar_device - crossbar device description
  * @int_max: maximum number of supported interrupts
+ * @safe_map: safe default value to initialize the crossbar
+ * @max_crossbar_sources: Maximum number of crossbar sources
  * @irq_map: array of interrupts to crossbar number mapping
  * @crossbar_base: crossbar base address
  * @register_offsets: offsets for each irq number
+ * @write: register write function pointer
  */
 struct crossbar_device {
 	uint int_max;
+	uint safe_map;
+	uint max_crossbar_sources;
 	uint *irq_map;
 	void __iomem *crossbar_base;
 	int *register_offsets;
-	void (*write) (int, int);
+	void (*write)(int, int);
 };
 
 static struct crossbar_device *cb;
@@ -50,11 +59,22 @@ static inline void crossbar_writeb(int irq_no, int cb_no)
 	writeb(cb_no, cb->crossbar_base + cb->register_offsets[irq_no]);
 }
 
+static inline int get_prev_map_irq(int cb_no)
+{
+	int i;
+
+	for (i = cb->int_max - 1; i >= 0; i--)
+		if (cb->irq_map[i] == cb_no)
+			return i;
+
+	return -ENODEV;
+}
+
 static inline int allocate_free_irq(int cb_no)
 {
 	int i;
 
-	for (i = 0; i < cb->int_max; i++) {
+	for (i = cb->int_max - 1; i >= 0; i--) {
 		if (cb->irq_map[i] == IRQ_FREE) {
 			cb->irq_map[i] = cb_no;
 			return i;
@@ -64,19 +84,47 @@ static inline int allocate_free_irq(int cb_no)
 	return -ENODEV;
 }
 
+static inline bool needs_crossbar_write(irq_hw_number_t hw)
+{
+	int cb_no;
+
+	if (hw > GIC_IRQ_START) {
+		cb_no = cb->irq_map[hw - GIC_IRQ_START];
+		if (cb_no != IRQ_RESERVED && cb_no != IRQ_SKIP)
+			return true;
+	}
+
+	return false;
+}
+
 static int crossbar_domain_map(struct irq_domain *d, unsigned int irq,
 			       irq_hw_number_t hw)
 {
-	cb->write(hw - GIC_IRQ_START, cb->irq_map[hw - GIC_IRQ_START]);
+	if (needs_crossbar_write(hw))
+		cb->write(hw - GIC_IRQ_START, cb->irq_map[hw - GIC_IRQ_START]);
+
 	return 0;
 }
 
+/**
+ * crossbar_domain_unmap - unmap a crossbar<->irq connection
+ * @d: domain of irq to unmap
+ * @irq: virq number
+ *
+ * We do not maintain a use count of total number of map/unmap
+ * calls for a particular irq to find out if a irq can be really
+ * unmapped. This is because unmap is called during irq_dispose_mapping(irq),
+ * after which irq is anyways unusable. So an explicit map has to be called
+ * after that.
+ */
 static void crossbar_domain_unmap(struct irq_domain *d, unsigned int irq)
 {
 	irq_hw_number_t hw = irq_get_irq_data(irq)->hwirq;
 
-	if (hw > GIC_IRQ_START)
+	if (needs_crossbar_write(hw)) {
 		cb->irq_map[hw - GIC_IRQ_START] = IRQ_FREE;
+		cb->write(hw - GIC_IRQ_START, cb->safe_map);
+	}
 }
 
 static int crossbar_domain_xlate(struct irq_domain *d,
@@ -85,18 +133,41 @@ static int crossbar_domain_xlate(struct irq_domain *d,
 				 unsigned long *out_hwirq,
 				 unsigned int *out_type)
 {
-	unsigned long ret;
+	int ret;
+	int req_num = intspec[1];
+	int direct_map_num;
+
+	if (req_num >= cb->max_crossbar_sources) {
+		direct_map_num = req_num - cb->max_crossbar_sources;
+		if (direct_map_num < cb->int_max) {
+			ret = cb->irq_map[direct_map_num];
+			if (ret == IRQ_RESERVED || ret == IRQ_SKIP) {
+				/* We use the interrupt num as h/w irq num */
+				ret = direct_map_num;
+				goto found;
+			}
+		}
+
+		pr_err("%s: requested crossbar number %d > max %d\n",
+		       __func__, req_num, cb->max_crossbar_sources);
+		return -EINVAL;
+	}
 
-	ret = allocate_free_irq(intspec[1]);
+	ret = get_prev_map_irq(req_num);
+	if (ret >= 0)
+		goto found;
 
-	if (IS_ERR_VALUE(ret))
+	ret = allocate_free_irq(req_num);
+
+	if (ret < 0)
 		return ret;
 
+found:
 	*out_hwirq = ret + GIC_IRQ_START;
 	return 0;
 }
 
-const struct irq_domain_ops routable_irq_domain_ops = {
+static const struct irq_domain_ops routable_irq_domain_ops = {
 	.map = crossbar_domain_map,
 	.unmap = crossbar_domain_unmap,
 	.xlate = crossbar_domain_xlate
@@ -104,22 +175,36 @@ const struct irq_domain_ops routable_irq_domain_ops = {
 
 static int __init crossbar_of_init(struct device_node *node)
 {
-	int i, size, max, reserved = 0, entry;
+	int i, size, max = 0, reserved = 0, entry;
 	const __be32 *irqsr;
+	int ret = -ENOMEM;
 
 	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
 
 	if (!cb)
-		return -ENOMEM;
+		return ret;
 
 	cb->crossbar_base = of_iomap(node, 0);
 	if (!cb->crossbar_base)
-		goto err1;
+		goto err_cb;
+
+	of_property_read_u32(node, "ti,max-crossbar-sources",
+			     &cb->max_crossbar_sources);
+	if (!cb->max_crossbar_sources) {
+		pr_err("missing 'ti,max-crossbar-sources' property\n");
+		ret = -EINVAL;
+		goto err_base;
+	}
 
 	of_property_read_u32(node, "ti,max-irqs", &max);
-	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
+	if (!max) {
+		pr_err("missing 'ti,max-irqs' property\n");
+		ret = -EINVAL;
+		goto err_base;
+	}
+	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->irq_map)
-		goto err2;
+		goto err_base;
 
 	cb->int_max = max;
 
@@ -137,15 +222,35 @@ static int __init crossbar_of_init(struct device_node *node)
 						   i, &entry);
 			if (entry > max) {
 				pr_err("Invalid reserved entry\n");
-				goto err3;
+				ret = -EINVAL;
+				goto err_irq_map;
+			}
+			cb->irq_map[entry] = IRQ_RESERVED;
+		}
+	}
+
+	/* Skip irqs hardwired to bypass the crossbar */
+	irqsr = of_get_property(node, "ti,irqs-skip", &size);
+	if (irqsr) {
+		size /= sizeof(__be32);
+
+		for (i = 0; i < size; i++) {
+			of_property_read_u32_index(node,
+						   "ti,irqs-skip",
+						   i, &entry);
+			if (entry > max) {
+				pr_err("Invalid skip entry\n");
+				ret = -EINVAL;
+				goto err_irq_map;
 			}
-			cb->irq_map[entry] = 0;
+			cb->irq_map[entry] = IRQ_SKIP;
 		}
 	}
 
-	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
+
+	cb->register_offsets = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->register_offsets)
-		goto err3;
+		goto err_irq_map;
 
 	of_property_read_u32(node, "ti,reg-size", &size);
 
@@ -161,7 +266,8 @@ static int __init crossbar_of_init(struct device_node *node)
 		break;
 	default:
 		pr_err("Invalid reg-size property\n");
-		goto err4;
+		ret = -EINVAL;
+		goto err_reg_offset;
 		break;
 	}
 
@@ -170,25 +276,37 @@ static int __init crossbar_of_init(struct device_node *node)
 	 * reserved irqs. so find and store the offsets once.
 	 */
 	for (i = 0; i < max; i++) {
-		if (!cb->irq_map[i])
+		if (cb->irq_map[i] == IRQ_RESERVED)
 			continue;
 
 		cb->register_offsets[i] = reserved;
 		reserved += size;
 	}
 
+	of_property_read_u32(node, "ti,irqs-safe-map", &cb->safe_map);
+	/* Initialize the crossbar with safe map to start with */
+	for (i = 0; i < max; i++) {
+		if (cb->irq_map[i] == IRQ_RESERVED ||
+		    cb->irq_map[i] == IRQ_SKIP)
+			continue;
+
+		cb->write(i, cb->safe_map);
+	}
+
 	register_routable_domain_ops(&routable_irq_domain_ops);
 	return 0;
 
-err4:
+err_reg_offset:
 	kfree(cb->register_offsets);
-err3:
+err_irq_map:
 	kfree(cb->irq_map);
-err2:
+err_base:
 	iounmap(cb->crossbar_base);
-err1:
+err_cb:
 	kfree(cb);
-	return -ENOMEM;
+
+	cb = NULL;
+	return ret;
 }
 
 static const struct of_device_id crossbar_match[] __initconst = {
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 70bdf6e..4ff0805 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -49,14 +49,6 @@ nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
 	handle_IRQ(irq, regs);
 }
 
-static void nvic_eoi(struct irq_data *d)
-{
-	/*
-	 * This is a no-op as end of interrupt is signaled by the exception
-	 * return sequence.
-	 */
-}
-
 static int __init nvic_of_init(struct device_node *node,
 			       struct device_node *parent)
 {
@@ -102,7 +94,10 @@ static int __init nvic_of_init(struct device_node *node,
 		gc->chip_types[0].regs.disable = NVIC_ICER;
 		gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
 		gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
-		gc->chip_types[0].chip.irq_eoi = nvic_eoi;
+		/* This is a no-op as end of interrupt is signaled by the
+		 * exception return sequence.
+		 */
+		gc->chip_types[0].chip.irq_eoi = irq_gc_noop;
 
 		/* disable interrupts */
 		writel_relaxed(~0, gc->reg_base + NVIC_ICER);
diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
new file mode 100644
index 0000000..17ff033
--- /dev/null
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * Copyright (C) 2014 Stefan Kristansson <stefan.kristiansson@saunalahti.fi>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+
+#include "irqchip.h"
+
+/* OR1K PIC implementation */
+
+struct or1k_pic_dev {
+	struct irq_chip chip;
+	irq_flow_handler_t handle;
+	unsigned long flags;
+};
+
+/*
+ * We're a couple of cycles faster than the generic implementations with
+ * these 'fast' versions.
+ */
+
+static void or1k_pic_mask(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
+}
+
+static void or1k_pic_unmask(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) | (1UL << data->hwirq));
+}
+
+static void or1k_pic_ack(struct irq_data *data)
+{
+	mtspr(SPR_PICSR, (1UL << data->hwirq));
+}
+
+static void or1k_pic_mask_ack(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
+	mtspr(SPR_PICSR, (1UL << data->hwirq));
+}
+
+/*
+ * There are two oddities with the OR1200 PIC implementation:
+ * i)  LEVEL-triggered interrupts are latched and need to be cleared
+ * ii) the interrupt latch is cleared by writing a 0 to the bit,
+ *     as opposed to a 1 as mandated by the spec
+ */
+static void or1k_pic_or1200_ack(struct irq_data *data)
+{
+	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
+}
+
+static void or1k_pic_or1200_mask_ack(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
+	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
+}
+
+static struct or1k_pic_dev or1k_pic_level = {
+	.chip = {
+		.name = "or1k-PIC-level",
+		.irq_unmask = or1k_pic_unmask,
+		.irq_mask = or1k_pic_mask,
+		.irq_mask_ack = or1k_pic_mask,
+	},
+	.handle = handle_level_irq,
+	.flags = IRQ_LEVEL | IRQ_NOPROBE,
+};
+
+static struct or1k_pic_dev or1k_pic_edge = {
+	.chip = {
+		.name = "or1k-PIC-edge",
+		.irq_unmask = or1k_pic_unmask,
+		.irq_mask = or1k_pic_mask,
+		.irq_ack = or1k_pic_ack,
+		.irq_mask_ack = or1k_pic_mask_ack,
+	},
+	.handle = handle_edge_irq,
+	.flags = IRQ_LEVEL | IRQ_NOPROBE,
+};
+
+static struct or1k_pic_dev or1k_pic_or1200 = {
+	.chip = {
+		.name = "or1200-PIC",
+		.irq_unmask = or1k_pic_unmask,
+		.irq_mask = or1k_pic_mask,
+		.irq_ack = or1k_pic_or1200_ack,
+		.irq_mask_ack = or1k_pic_or1200_mask_ack,
+	},
+	.handle = handle_level_irq,
+	.flags = IRQ_LEVEL | IRQ_NOPROBE,
+};
+
+static struct irq_domain *root_domain;
+
+static inline int pic_get_irq(int first)
+{
+	int hwirq;
+
+	hwirq = ffs(mfspr(SPR_PICSR) >> first);
+	if (!hwirq)
+		return NO_IRQ;
+	else
+		hwirq = hwirq + first - 1;
+
+	return irq_find_mapping(root_domain, hwirq);
+}
+
+static void or1k_pic_handle_irq(struct pt_regs *regs)
+{
+	int irq = -1;
+
+	while ((irq = pic_get_irq(irq + 1)) != NO_IRQ)
+		handle_IRQ(irq, regs);
+}
+
+static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
+{
+	struct or1k_pic_dev *pic = d->host_data;
+
+	irq_set_chip_and_handler(irq, &pic->chip, pic->handle);
+	irq_set_status_flags(irq, pic->flags);
+
+	return 0;
+}
+
+static const struct irq_domain_ops or1k_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onecell,
+	.map = or1k_map,
+};
+
+/*
+ * This sets up the IRQ domain for the PIC built in to the OpenRISC
+ * 1000 CPU.  This is the "root" domain as these are the interrupts
+ * that directly trigger an exception in the CPU.
+ */
+static int __init or1k_pic_init(struct device_node *node,
+				 struct or1k_pic_dev *pic)
+{
+	/* Disable all interrupts until explicitly requested */
+	mtspr(SPR_PICMR, (0UL));
+
+	root_domain = irq_domain_add_linear(node, 32, &or1k_irq_domain_ops,
+					    pic);
+
+	set_handle_irq(or1k_pic_handle_irq);
+
+	return 0;
+}
+
+static int __init or1k_pic_or1200_init(struct device_node *node,
+				       struct device_node *parent)
+{
+	return or1k_pic_init(node, &or1k_pic_or1200);
+}
+IRQCHIP_DECLARE(or1k_pic_or1200, "opencores,or1200-pic", or1k_pic_or1200_init);
+IRQCHIP_DECLARE(or1k_pic, "opencores,or1k-pic", or1k_pic_or1200_init);
+
+static int __init or1k_pic_level_init(struct device_node *node,
+				      struct device_node *parent)
+{
+	return or1k_pic_init(node, &or1k_pic_level);
+}
+IRQCHIP_DECLARE(or1k_pic_level, "opencores,or1k-pic-level",
+		or1k_pic_level_init);
+
+static int __init or1k_pic_edge_init(struct device_node *node,
+				     struct device_node *parent)
+{
+	return or1k_pic_init(node, &or1k_pic_edge);
+}
+IRQCHIP_DECLARE(or1k_pic_edge, "opencores,or1k-pic-edge", or1k_pic_edge_init);
diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
index 6ce6bd3..9c145a7 100644
--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -19,7 +19,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
-#include <linux/irqchip/spear-shirq.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -27,20 +26,73 @@
 
 #include "irqchip.h"
 
-static DEFINE_SPINLOCK(lock);
+/*
+ * struct spear_shirq: shared irq structure
+ *
+ * base:	Base register address
+ * status_reg:	Status register offset for chained interrupt handler
+ * mask_reg:	Mask register offset for irq chip
+ * mask:	Mask to apply to the status register
+ * virq_base:	Base virtual interrupt number
+ * nr_irqs:	Number of interrupts handled by this block
+ * offset:	Bit offset of the first interrupt
+ * irq_chip:	Interrupt controller chip used for this instance,
+ *		if NULL group is disabled, but accounted
+ */
+struct spear_shirq {
+	void __iomem		*base;
+	u32			status_reg;
+	u32			mask_reg;
+	u32			mask;
+	u32			virq_base;
+	u32			nr_irqs;
+	u32			offset;
+	struct irq_chip		*irq_chip;
+};
 
 /* spear300 shared irq registers offsets and masks */
 #define SPEAR300_INT_ENB_MASK_REG	0x54
 #define SPEAR300_INT_STS_MASK_REG	0x58
 
+static DEFINE_RAW_SPINLOCK(shirq_lock);
+
+static void shirq_irq_mask(struct irq_data *d)
+{
+	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
+	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
+	u32 __iomem *reg = shirq->base + shirq->mask_reg;
+
+	raw_spin_lock(&shirq_lock);
+	val = readl(reg) & ~(0x1 << shift);
+	writel(val, reg);
+	raw_spin_unlock(&shirq_lock);
+}
+
+static void shirq_irq_unmask(struct irq_data *d)
+{
+	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
+	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
+	u32 __iomem *reg = shirq->base + shirq->mask_reg;
+
+	raw_spin_lock(&shirq_lock);
+	val = readl(reg) | (0x1 << shift);
+	writel(val, reg);
+	raw_spin_unlock(&shirq_lock);
+}
+
+static struct irq_chip shirq_chip = {
+	.name		= "spear-shirq",
+	.irq_mask	= shirq_irq_mask,
+	.irq_unmask	= shirq_irq_unmask,
+};
+
 static struct spear_shirq spear300_shirq_ras1 = {
-	.irq_nr = 9,
-	.irq_bit_off = 0,
-	.regs = {
-		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
-		.status_reg = SPEAR300_INT_STS_MASK_REG,
-		.clear_reg = -1,
-	},
+	.offset		= 0,
+	.nr_irqs	= 9,
+	.mask		= ((0x1 << 9) - 1) << 0,
+	.irq_chip	= &shirq_chip,
+	.status_reg	= SPEAR300_INT_STS_MASK_REG,
+	.mask_reg	= SPEAR300_INT_ENB_MASK_REG,
 };
 
 static struct spear_shirq *spear300_shirq_blocks[] = {
@@ -51,43 +103,35 @@ static struct spear_shirq *spear300_shirq_blocks[] = {
 #define SPEAR310_INT_STS_MASK_REG	0x04
 
 static struct spear_shirq spear310_shirq_ras1 = {
-	.irq_nr = 8,
-	.irq_bit_off = 0,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
-	},
+	.offset		= 0,
+	.nr_irqs	= 8,
+	.mask		= ((0x1 << 8) - 1) << 0,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear310_shirq_ras2 = {
-	.irq_nr = 5,
-	.irq_bit_off = 8,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
-	},
+	.offset		= 8,
+	.nr_irqs	= 5,
+	.mask		= ((0x1 << 5) - 1) << 8,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear310_shirq_ras3 = {
-	.irq_nr = 1,
-	.irq_bit_off = 13,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
-	},
+	.offset		= 13,
+	.nr_irqs	= 1,
+	.mask		= ((0x1 << 1) - 1) << 13,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear310_shirq_intrcomm_ras = {
-	.irq_nr = 3,
-	.irq_bit_off = 14,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR310_INT_STS_MASK_REG,
-		.clear_reg = -1,
-	},
+	.offset		= 14,
+	.nr_irqs	= 3,
+	.mask		= ((0x1 << 3) - 1) << 14,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR310_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq *spear310_shirq_blocks[] = {
@@ -102,50 +146,34 @@ static struct spear_shirq *spear310_shirq_blocks[] = {
 #define SPEAR320_INT_CLR_MASK_REG		0x04
 #define SPEAR320_INT_ENB_MASK_REG		0x08
 
-static struct spear_shirq spear320_shirq_ras1 = {
-	.irq_nr = 3,
-	.irq_bit_off = 7,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
-	},
+static struct spear_shirq spear320_shirq_ras3 = {
+	.offset		= 0,
+	.nr_irqs	= 7,
+	.mask		= ((0x1 << 7) - 1) << 0,
 };
 
-static struct spear_shirq spear320_shirq_ras2 = {
-	.irq_nr = 1,
-	.irq_bit_off = 10,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
-	},
+static struct spear_shirq spear320_shirq_ras1 = {
+	.offset		= 7,
+	.nr_irqs	= 3,
+	.mask		= ((0x1 << 3) - 1) << 7,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR320_INT_STS_MASK_REG,
 };
 
-static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 7,
-	.irq_bit_off = 0,
-	.invalid_irq = 1,
-	.regs = {
-		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
-		.reset_to_enb = 1,
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
-	},
+static struct spear_shirq spear320_shirq_ras2 = {
+	.offset		= 10,
+	.nr_irqs	= 1,
+	.mask		= ((0x1 << 1) - 1) << 10,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR320_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq spear320_shirq_intrcomm_ras = {
-	.irq_nr = 11,
-	.irq_bit_off = 11,
-	.regs = {
-		.enb_reg = -1,
-		.status_reg = SPEAR320_INT_STS_MASK_REG,
-		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
-		.reset_to_clear = 1,
-	},
+	.offset		= 11,
+	.nr_irqs	= 11,
+	.mask		= ((0x1 << 11) - 1) << 11,
+	.irq_chip	= &dummy_irq_chip,
+	.status_reg	= SPEAR320_INT_STS_MASK_REG,
 };
 
 static struct spear_shirq *spear320_shirq_blocks[] = {
@@ -155,104 +183,46 @@ static struct spear_shirq *spear320_shirq_blocks[] = {
 	&spear320_shirq_intrcomm_ras,
 };
 
-static void shirq_irq_mask_unmask(struct irq_data *d, bool mask)
-{
-	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
-	u32 val, offset = d->irq - shirq->irq_base;
-	unsigned long flags;
-
-	if (shirq->regs.enb_reg == -1)
-		return;
-
-	spin_lock_irqsave(&lock, flags);
-	val = readl(shirq->base + shirq->regs.enb_reg);
-
-	if (mask ^ shirq->regs.reset_to_enb)
-		val &= ~(0x1 << shirq->irq_bit_off << offset);
-	else
-		val |= 0x1 << shirq->irq_bit_off << offset;
-
-	writel(val, shirq->base + shirq->regs.enb_reg);
-	spin_unlock_irqrestore(&lock, flags);
-
-}
-
-static void shirq_irq_mask(struct irq_data *d)
-{
-	shirq_irq_mask_unmask(d, 1);
-}
-
-static void shirq_irq_unmask(struct irq_data *d)
-{
-	shirq_irq_mask_unmask(d, 0);
-}
-
-static struct irq_chip shirq_chip = {
-	.name		= "spear-shirq",
-	.irq_ack	= shirq_irq_mask,
-	.irq_mask	= shirq_irq_mask,
-	.irq_unmask	= shirq_irq_unmask,
-};
-
 static void shirq_handler(unsigned irq, struct irq_desc *desc)
 {
-	u32 i, j, val, mask, tmp;
-	struct irq_chip *chip;
 	struct spear_shirq *shirq = irq_get_handler_data(irq);
+	u32 pend;
 
-	chip = irq_get_chip(irq);
-	chip->irq_ack(&desc->irq_data);
-
-	mask = ((0x1 << shirq->irq_nr) - 1) << shirq->irq_bit_off;
-	while ((val = readl(shirq->base + shirq->regs.status_reg) &
-				mask)) {
-
-		val >>= shirq->irq_bit_off;
-		for (i = 0, j = 1; i < shirq->irq_nr; i++, j <<= 1) {
-
-			if (!(j & val))
-				continue;
+	pend = readl(shirq->base + shirq->status_reg) & shirq->mask;
+	pend >>= shirq->offset;
 
-			generic_handle_irq(shirq->irq_base + i);
+	while (pend) {
+		int irq = __ffs(pend);
 
-			/* clear interrupt */
-			if (shirq->regs.clear_reg == -1)
-				continue;
-
-			tmp = readl(shirq->base + shirq->regs.clear_reg);
-			if (shirq->regs.reset_to_clear)
-				tmp &= ~(j << shirq->irq_bit_off);
-			else
-				tmp |= (j << shirq->irq_bit_off);
-			writel(tmp, shirq->base + shirq->regs.clear_reg);
-		}
+		pend &= ~(0x1 << irq);
+		generic_handle_irq(shirq->virq_base + irq);
 	}
-	chip->irq_unmask(&desc->irq_data);
 }
 
-static void __init spear_shirq_register(struct spear_shirq *shirq)
+static void __init spear_shirq_register(struct spear_shirq *shirq,
+					int parent_irq)
 {
 	int i;
 
-	if (shirq->invalid_irq)
+	if (!shirq->irq_chip)
 		return;
 
-	irq_set_chained_handler(shirq->irq, shirq_handler);
-	for (i = 0; i < shirq->irq_nr; i++) {
-		irq_set_chip_and_handler(shirq->irq_base + i,
-					 &shirq_chip, handle_simple_irq);
-		set_irq_flags(shirq->irq_base + i, IRQF_VALID);
-		irq_set_chip_data(shirq->irq_base + i, shirq);
-	}
+	irq_set_chained_handler(parent_irq, shirq_handler);
+	irq_set_handler_data(parent_irq, shirq);
 
-	irq_set_handler_data(shirq->irq, shirq);
+	for (i = 0; i < shirq->nr_irqs; i++) {
+		irq_set_chip_and_handler(shirq->virq_base + i,
+					 shirq->irq_chip, handle_simple_irq);
+		set_irq_flags(shirq->virq_base + i, IRQF_VALID);
+		irq_set_chip_data(shirq->virq_base + i, shirq);
+	}
 }
 
 static int __init shirq_init(struct spear_shirq **shirq_blocks, int block_nr,
 		struct device_node *np)
 {
-	int i, irq_base, hwirq = 0, irq_nr = 0;
-	static struct irq_domain *shirq_domain;
+	int i, parent_irq, virq_base, hwirq = 0, nr_irqs = 0;
+	struct irq_domain *shirq_domain;
 	void __iomem *base;
 
 	base = of_iomap(np, 0);
@@ -262,15 +232,15 @@ static int __init shirq_init(struct spear_shirq **shirq_blocks, int block_nr,
 	}
 
 	for (i = 0; i < block_nr; i++)
-		irq_nr += shirq_blocks[i]->irq_nr;
+		nr_irqs += shirq_blocks[i]->nr_irqs;
 
-	irq_base = irq_alloc_descs(-1, 0, irq_nr, 0);
-	if (IS_ERR_VALUE(irq_base)) {
+	virq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
+	if (IS_ERR_VALUE(virq_base)) {
 		pr_err("%s: irq desc alloc failed\n", __func__);
 		goto err_unmap;
 	}
 
-	shirq_domain = irq_domain_add_legacy(np, irq_nr, irq_base, 0,
+	shirq_domain = irq_domain_add_legacy(np, nr_irqs, virq_base, 0,
 			&irq_domain_simple_ops, NULL);
 	if (WARN_ON(!shirq_domain)) {
 		pr_warn("%s: irq domain init failed\n", __func__);
@@ -279,41 +249,41 @@ static int __init shirq_init(struct spear_shirq **shirq_blocks, int block_nr,
 
 	for (i = 0; i < block_nr; i++) {
 		shirq_blocks[i]->base = base;
-		shirq_blocks[i]->irq_base = irq_find_mapping(shirq_domain,
+		shirq_blocks[i]->virq_base = irq_find_mapping(shirq_domain,
 				hwirq);
-		shirq_blocks[i]->irq = irq_of_parse_and_map(np, i);
 
-		spear_shirq_register(shirq_blocks[i]);
-		hwirq += shirq_blocks[i]->irq_nr;
+		parent_irq = irq_of_parse_and_map(np, i);
+		spear_shirq_register(shirq_blocks[i], parent_irq);
+		hwirq += shirq_blocks[i]->nr_irqs;
 	}
 
 	return 0;
 
 err_free_desc:
-	irq_free_descs(irq_base, irq_nr);
+	irq_free_descs(virq_base, nr_irqs);
 err_unmap:
 	iounmap(base);
 	return -ENXIO;
 }
 
-int __init spear300_shirq_of_init(struct device_node *np,
-		struct device_node *parent)
+static int __init spear300_shirq_of_init(struct device_node *np,
+					 struct device_node *parent)
 {
 	return shirq_init(spear300_shirq_blocks,
 			ARRAY_SIZE(spear300_shirq_blocks), np);
 }
 IRQCHIP_DECLARE(spear300_shirq, "st,spear300-shirq", spear300_shirq_of_init);
 
-int __init spear310_shirq_of_init(struct device_node *np,
-		struct device_node *parent)
+static int __init spear310_shirq_of_init(struct device_node *np,
+					 struct device_node *parent)
 {
 	return shirq_init(spear310_shirq_blocks,
 			ARRAY_SIZE(spear310_shirq_blocks), np);
 }
 IRQCHIP_DECLARE(spear310_shirq, "st,spear310-shirq", spear310_shirq_of_init);
 
-int __init spear320_shirq_of_init(struct device_node *np,
-		struct device_node *parent)
+static int __init spear320_shirq_of_init(struct device_node *np,
+					 struct device_node *parent)
 {
 	return shirq_init(spear320_shirq_blocks,
 			ARRAY_SIZE(spear320_shirq_blocks), np);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0d998d8..62af592 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -771,6 +771,8 @@ void irq_gc_eoi(struct irq_data *d);
 int irq_gc_set_wake(struct irq_data *d, unsigned int on);
 
 /* Setup functions for irq_chip_generic */
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq);
 struct irq_chip_generic *
 irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
 		       void __iomem *reg_base, irq_flow_handler_t handler);
diff --git a/include/linux/irqchip/spear-shirq.h b/include/linux/irqchip/spear-shirq.h
deleted file mode 100644
index c8be16d..0000000
--- a/include/linux/irqchip/spear-shirq.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * SPEAr platform shared irq layer header file
- *
- * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#ifndef __SPEAR_SHIRQ_H
-#define __SPEAR_SHIRQ_H
-
-#include <linux/irq.h>
-#include <linux/types.h>
-
-/*
- * struct shirq_regs: shared irq register configuration
- *
- * enb_reg: enable register offset
- * reset_to_enb: val 1 indicates, we need to clear bit for enabling interrupt
- * status_reg: status register offset
- * status_reg_mask: status register valid mask
- * clear_reg: clear register offset
- * reset_to_clear: val 1 indicates, we need to clear bit for clearing interrupt
- */
-struct shirq_regs {
-	u32 enb_reg;
-	u32 reset_to_enb;
-	u32 status_reg;
-	u32 clear_reg;
-	u32 reset_to_clear;
-};
-
-/*
- * struct spear_shirq: shared irq structure
- *
- * irq: hardware irq number
- * irq_base: base irq in linux domain
- * irq_nr: no. of shared interrupts in a particular block
- * irq_bit_off: starting bit offset in the status register
- * invalid_irq: irq group is currently disabled
- * base: base address of shared irq register
- * regs: register configuration for shared irq block
- */
-struct spear_shirq {
-	u32 irq;
-	u32 irq_base;
-	u32 irq_nr;
-	u32 irq_bit_off;
-	int invalid_irq;
-	void __iomem *base;
-	struct shirq_regs regs;
-};
-
-int __init spear300_shirq_of_init(struct device_node *np,
-		struct device_node *parent);
-int __init spear310_shirq_of_init(struct device_node *np,
-		struct device_node *parent);
-int __init spear320_shirq_of_init(struct device_node *np,
-		struct device_node *parent);
-
-#endif /* __SPEAR_SHIRQ_H */
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed1..b0f9d16 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -172,6 +172,8 @@ extern int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
 extern void irq_domain_associate_many(struct irq_domain *domain,
 				      unsigned int irq_base,
 				      irq_hw_number_t hwirq_base, int count);
+extern void irq_domain_disassociate(struct irq_domain *domain,
+				    unsigned int irq);
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 452d6f2..cf80e7b 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -341,8 +341,8 @@ static struct lock_class_key irq_nested_lock_class;
 /*
  * irq_map_generic_chip - Map a generic chip for an irq domain
  */
-static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
-				irq_hw_number_t hw_irq)
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq)
 {
 	struct irq_data *data = irq_get_irq_data(virq);
 	struct irq_domain_chip_generic *dgc = d->gc;
@@ -394,6 +394,7 @@ static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_map_generic_chip);
 
 struct irq_domain_ops irq_generic_chip_ops = {
 	.map	= irq_map_generic_chip,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index eb5e10e..6534ff6 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -231,7 +231,7 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
+void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(irq);
 	irq_hw_number_t hwirq;
