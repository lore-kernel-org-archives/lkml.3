Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaJHS2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:28:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:38914 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaJHS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:28:04 -0400
Date: Wed, 8 Oct 2014 20:27:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq updates for 3.18
Message-ID: <alpine.DEB.2.11.1410082012190.4292@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

The irq departement delivers:

 - A cleanup series to get rid of mindlessly copied code.

 - Another bunch of new pointlessly different interrupt chip drivers.

   Adding homebrewn irq chips (and timers) to SoCs must provide a value
   add which is beyond the imagination of mere mortals.

 - The usual SoC irq controller updates, IOW my second cat herding
   project.

Thanks,

	tglx

------------------>
Alexandre Belloni (2):
      irqchip: atmel-aic5: The sama5d3 has 48 IRQs
      irqchip: atmel-aic5: Add sama5d4 support

Feng Kan (2):
      irqchip: gic: Replace hex numbers with defines.
      irqchip: gic: Preserve gic V2 bypass bits in cpu ctrl register

Florian Fainelli (2):
      irqchip: bcm7120-l2: Add Broadcom BCM7120-style Level 2 interrupt controller
      Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding

Geert Uytterhoeven (7):
      irqchip: renesas-intc-irqpin: Add suspend-to-RAM wake up support
      MAINTAINERS: Add irqchip DT bindings doc path to IRQCHIP DRIVERS section
      irqchip: renesas-intc-irqpin: Document SoC-specific bindings
      irqchip: renesas-irqc: Add DT binding documentation
      irqchip: renesas-irqc: Add binding docs for new R-Car Gen2 SoCs
      irqchip: renesas-intc-irqpin: Add helper variable dev = &pdev->dev
      irqchip: renesas-intc-irqpin: Add minimal runtime PM support

Grygorii Strashko (2):
      irqchip: keystone: Add irq controller ip driver
      irqchip: keystone: Remove warning unsigned 'kirq->irq' is never less than zero

Haojian Zhuang (1):
      irqchip: hip04: Enable Hisilicon HiP04 interrupt controller

Marc Zyngier (26):
      genirq: Add irq_domain-aware core IRQ handler
      arm64: Convert handle_IRQ to use __handle_domain_irq
      ARM: Convert handle_IRQ to use __handle_domain_irq
      openrisc: Convert handle_IRQ to use __handle_domain_irq
      irqchip: gic: Convert to handle_domain_irq
      irqchip: armada-370-xp: Convert to handle_domain_irq
      irqchip: clps711x: Convert to handle_domain_irq
      irqchip: mmp: Convert to handle_domain_irq
      irqchip: mxs: Convert to handle_domain_irq
      irqchip: orion: Convert to handle_domain_irq
      irqchip: s3c24xx: Convert to handle_domain_irq
      irqchip: sirfsoc: Convert to handle_domain_irq
      irqchip: sun4i: Convert to handle_domain_irq
      irqchip: versatile-fpga: Convert to handle_domain_irq
      irqchip: vic: Convert to handle_domain_irq
      irqchip: vt8500: Convert to handle_domain_irq
      irqchip: zevio: Convert to handle_domain_irq
      irqchip: gic-v3: Convert to handle_domain_irq
      irqchip: atmel-aic: Convert to handle_domain_irq
      irqchip: atmel-aic5: Convert to handle_domain_irq
      irqchip: or1k-pic: Convert to handle_domain_irq
      ARM: imx: avic: Convert to handle_domain_irq
      ARM: imx: tzic: Convert to handle_domain_irq
      ARM: omap2: irq: Convert to handle_domain_irq
      arm64: Get rid of handle_IRQ
      openrisc: Get rid of handle_IRQ

Sudeep Holla (2):
      irqchip: gic-v3: Refactor gic_enable_redist to support both enabling and disabling
      irqchip: gic-v3: Implement CPU PM notifier


 .../bindings/interrupt-controller/atmel,aic.txt    |   2 +-
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  86 +++++
 .../interrupt-controller/renesas,intc-irqpin.txt   |   8 +-
 .../bindings/interrupt-controller/renesas,irqc.txt |  32 ++
 .../interrupt-controller/ti,keystone-irq.txt       |  36 ++
 MAINTAINERS                                        |   1 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/kernel/irq.c                              |  19 +-
 arch/arm/mach-imx/avic.c                           |   2 +-
 arch/arm/mach-imx/tzic.c                           |   3 +-
 arch/arm/mach-omap2/irq.c                          |   3 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/hardirq.h                   |   2 -
 arch/arm64/kernel/irq.c                            |  27 --
 arch/openrisc/Kconfig                              |   1 +
 arch/openrisc/include/asm/irq.h                    |   1 -
 arch/openrisc/kernel/irq.c                         |  12 -
 drivers/irqchip/Kconfig                            |   7 +
 drivers/irqchip/Makefile                           |   5 +-
 drivers/irqchip/irq-armada-370-xp.c                |  19 +-
 drivers/irqchip/irq-atmel-aic.c                    |   4 +-
 drivers/irqchip/irq-atmel-aic5.c                   |  16 +-
 drivers/irqchip/irq-bcm7120-l2.c                   | 219 +++++++++++
 drivers/irqchip/irq-clps711x.c                     |  18 +-
 drivers/irqchip/irq-gic-common.c                   |  15 +-
 drivers/irqchip/irq-gic-v3.c                       | 100 +++--
 drivers/irqchip/irq-gic.c                          |  49 ++-
 drivers/irqchip/irq-hip04.c                        | 424 +++++++++++++++++++++
 drivers/irqchip/irq-keystone.c                     | 232 +++++++++++
 drivers/irqchip/irq-mmp.c                          |  10 +-
 drivers/irqchip/irq-mxs.c                          |   3 +-
 drivers/irqchip/irq-or1k-pic.c                     |   4 +-
 drivers/irqchip/irq-orion.c                        |   5 +-
 drivers/irqchip/irq-renesas-intc-irqpin.c          |  85 +++--
 drivers/irqchip/irq-s3c24xx.c                      |   4 +-
 drivers/irqchip/irq-sirfsoc.c                      |   6 +-
 drivers/irqchip/irq-sun4i.c                        |   5 +-
 drivers/irqchip/irq-versatile-fpga.c               |   2 +-
 drivers/irqchip/irq-vic.c                          |   2 +-
 drivers/irqchip/irq-vt8500.c                       |   5 +-
 drivers/irqchip/irq-zevio.c                        |   3 +-
 include/linux/irqchip/arm-gic.h                    |  16 +
 include/linux/irqdesc.h                            |  19 +
 kernel/irq/Kconfig                                 |   3 +
 kernel/irq/irqdesc.c                               |  42 ++
 45 files changed, 1356 insertions(+), 203 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
 create mode 100644 drivers/irqchip/irq-bcm7120-l2.c
 create mode 100644 drivers/irqchip/irq-hip04.c
 create mode 100644 drivers/irqchip/irq-keystone.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
index 2742e9cfd6b1..f292917fa00d 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
@@ -2,7 +2,7 @@
 
 Required properties:
 - compatible: Should be "atmel,<chip>-aic"
-  <chip> can be "at91rm9200" or "sama5d3"
+  <chip> can be "at91rm9200", "sama5d3" or "sama5d4"
 - interrupt-controller: Identifies the node as an interrupt controller.
 - interrupt-parent: For single AIC system, it is an empty property.
 - #interrupt-cells: The number of cells to define the interrupts. It should be 3.
diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
new file mode 100644
index 000000000000..ff812a8a82bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
@@ -0,0 +1,86 @@
+Broadcom BCM7120-style Level 2 interrupt controller
+
+This interrupt controller hardware is a second level interrupt controller that
+is hooked to a parent interrupt controller: e.g: ARM GIC for ARM-based
+platforms. It can be found on BCM7xxx products starting with BCM7120.
+
+Such an interrupt controller has the following hardware design:
+
+- outputs multiple interrupts signals towards its interrupt controller parent
+
+- controls how some of the interrupts will be flowing, whether they will
+  directly output an interrupt signal towards the interrupt controller parent,
+  or if they will output an interrupt signal at this 2nd level interrupt
+  controller, in particular for UARTs
+
+- not all 32-bits within the interrupt controller actually map to an interrupt
+
+The typical hardware layout for this controller is represented below:
+
+2nd level interrupt line		Outputs for the parent controller (e.g: ARM GIC)
+
+0 -----[ MUX ] ------------|==========> GIC interrupt 75
+          \-----------\
+                       |
+1 -----[ MUX ] --------)---|==========> GIC interrupt 76
+          \------------|
+                       |
+2 -----[ MUX ] --------)---|==========> GIC interrupt 77
+          \------------|
+                       |
+3 ---------------------|
+4 ---------------------|
+5 ---------------------|
+7 ---------------------|---|===========> GIC interrupt 66
+9 ---------------------|
+10 --------------------|
+11 --------------------/
+
+6 ------------------------\
+                           |===========> GIC interrupt 64
+8 ------------------------/
+
+12 ........................ X
+13 ........................ X 		(not connected)
+..
+31 ........................ X
+
+Required properties:
+
+- compatible: should be "brcm,bcm7120-l2-intc"
+- reg: specifies the base physical address and size of the registers
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: specifies the number of cells needed to encode an interrupt
+  source, should be 1.
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+  this one is cascaded from
+- interrupts: specifies the interrupt line(s) in the interrupt-parent controller
+  node, valid values depend on the type of parent interrupt controller
+- brcm,int-map-mask: 32-bits bit mask describing how many and which interrupts
+  are wired to this 2nd level interrupt controller, and how they match their
+  respective interrupt parents. Should match exactly the number of interrupts
+  specified in the 'interrupts' property.
+
+Optional properties:
+
+- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
+  wakeup source for system suspend/resume.
+
+- brcm,int-fwd-mask: if present, a 32-bits bit mask to configure for the
+  interrupts which have a mux gate, typically UARTs. Setting these bits will
+  make their respective interrupts outputs bypass this 2nd level interrupt
+  controller completely, it completely transparent for the interrupt controller
+  parent
+
+Example:
+
+irq0_intc: interrupt-controller@f0406800 {
+	compatible = "brcm,bcm7120-l2-intc";
+	interrupt-parent = <&intc>;
+	#interrupt-cells = <1>;
+	reg = <0xf0406800 0x8>;
+	interrupt-controller;
+	interrupts = <0x0 0x42 0x0>, <0x0 0x40 0x0>;
+	brcm,int-map-mask = <0xeb8>, <0x140>;
+	brcm,int-fwd-mask = <0x7>;
+};
diff --git a/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt b/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
index 1f8b0c507c26..c73acd060093 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
@@ -2,7 +2,13 @@ DT bindings for the R-/SH-Mobile irqpin controller
 
 Required properties:
 
-- compatible: has to be "renesas,intc-irqpin"
+- compatible: has to be "renesas,intc-irqpin-<soctype>", "renesas,intc-irqpin"
+  as fallback.
+  Examples with soctypes are:
+    - "renesas,intc-irqpin-r8a7740" (R-Mobile A1)
+    - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
+    - "renesas,intc-irqpin-r8a7779" (R-Car H1)
+    - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
 - #interrupt-cells: has to be <2>: an interrupt index and flags, as defined in
   interrupts.txt in this directory
 
diff --git a/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt b/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt
new file mode 100644
index 000000000000..1a88e62228e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt
@@ -0,0 +1,32 @@
+DT bindings for the R-Mobile/R-Car interrupt controller
+
+Required properties:
+
+- compatible: has to be "renesas,irqc-<soctype>", "renesas,irqc" as fallback.
+  Examples with soctypes are:
+    - "renesas,irqc-r8a73a4" (R-Mobile AP6)
+    - "renesas,irqc-r8a7790" (R-Car H2)
+    - "renesas,irqc-r8a7791" (R-Car M2-W)
+    - "renesas,irqc-r8a7792" (R-Car V2H)
+    - "renesas,irqc-r8a7793" (R-Car M2-N)
+    - "renesas,irqc-r8a7794" (R-Car E2)
+- #interrupt-cells: has to be <2>: an interrupt index and flags, as defined in
+  interrupts.txt in this directory
+
+Optional properties:
+
+- any properties, listed in interrupts.txt, and any standard resource allocation
+  properties
+
+Example:
+
+	irqc0: interrupt-controller@e61c0000 {
+		compatible = "renesas,irqc-r8a7790", "renesas,irqc";
+		#interrupt-cells = <2>;
+		interrupt-controller;
+		reg = <0 0xe61c0000 0 0x200>;
+		interrupts = <0 0 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 1 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 2 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 3 IRQ_TYPE_LEVEL_HIGH>;
+	};
diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt b/Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
new file mode 100644
index 000000000000..d9bb106bdd16
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
@@ -0,0 +1,36 @@
+Keystone 2 IRQ controller IP
+
+On Keystone SOCs, DSP cores can send interrupts to ARM
+host using the IRQ controller IP. It provides 28 IRQ signals to ARM.
+The IRQ handler running on HOST OS can identify DSP signal source by
+analyzing SRCCx bits in IPCARx registers. This is one of the component
+used by the IPC mechanism used on Keystone SOCs.
+
+Required Properties:
+- compatible: should be "ti,keystone-irq"
+- ti,syscon-dev : phandle and offset pair. The phandle to syscon used to
+			access device control registers and the offset inside
+			device control registers range.
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode interrupt
+					 source should be 1.
+- interrupts: interrupt reference to primary interrupt controller
+
+Please refer to interrupts.txt in this directory for details of the common
+Interrupt Controllers bindings used by client devices.
+
+Example:
+	kirq0: keystone_irq0@026202a0 {
+		compatible = "ti,keystone-irq";
+		ti,syscon-dev = <&devctrl 0x2a0>;
+		interrupts = <GIC_SPI 4 IRQ_TYPE_EDGE_RISING>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	dsp0: dsp0 {
+		compatible = "linux,rproc-user";
+		...
+		interrupt-parent = <&kirq0>;
+		interrupts = <10 2>;
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index aefa94841ff3..71e86afa6820 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4948,6 +4948,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 T:	git git://git.infradead.org/users/jcooper/linux.git irqchip/core
+F:	Documentation/devicetree/bindings/interrupt-controller/
 F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c49a775937db..5918d40bb12e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -24,6 +24,7 @@ config ARM
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 2c4257604513..0509d07c96ab 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -65,24 +65,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
  */
 void handle_IRQ(unsigned int irq, struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	irq_enter();
-
-	/*
-	 * Some hardware gives randomly wrong interrupts.  Rather
-	 * than crashing, do something sensible.
-	 */
-	if (unlikely(irq >= nr_irqs)) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING "Bad IRQ%u\n", irq);
-		ack_bad_irq(irq);
-	} else {
-		generic_handle_irq(irq);
-	}
-
-	irq_exit();
-	set_irq_regs(old_regs);
+	__handle_domain_irq(NULL, irq, false, regs);
 }
 
 /*
diff --git a/arch/arm/mach-imx/avic.c b/arch/arm/mach-imx/avic.c
index 24b103c67f82..1a8932335b21 100644
--- a/arch/arm/mach-imx/avic.c
+++ b/arch/arm/mach-imx/avic.c
@@ -144,7 +144,7 @@ static void __exception_irq_entry avic_handle_irq(struct pt_regs *regs)
 		if (nivector == 0xffff)
 			break;
 
-		handle_IRQ(irq_find_mapping(domain, nivector), regs);
+		handle_domain_irq(domain, nivector, regs);
 	} while (1);
 }
 
diff --git a/arch/arm/mach-imx/tzic.c b/arch/arm/mach-imx/tzic.c
index 1d4f384ca773..4de65eeda1eb 100644
--- a/arch/arm/mach-imx/tzic.c
+++ b/arch/arm/mach-imx/tzic.c
@@ -141,8 +141,7 @@ static void __exception_irq_entry tzic_handle_irq(struct pt_regs *regs)
 			while (stat) {
 				handled = 1;
 				irqofs = fls(stat) - 1;
-				handle_IRQ(irq_find_mapping(domain,
-						irqofs + i * 32), regs);
+				handle_domain_irq(domain, irqofs + i * 32, regs);
 				stat &= ~(1 << irqofs);
 			}
 		}
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 35b8590c322e..a62ba5aebe63 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -248,8 +248,7 @@ out:
 		irqnr &= ACTIVEIRQ_MASK;
 
 		if (irqnr) {
-			irqnr = irq_find_mapping(domain, irqnr);
-			handle_IRQ(irqnr, regs);
+			handle_domain_irq(domain, irqnr, regs);
 			handled_irq = 1;
 		}
 	} while (irqnr);
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a4e1ce..1f16ed96f3f6 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -30,6 +30,7 @@ config ARM64
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select GENERIC_TIME_VSYSCALL
+	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index 0be67821f9ce..e8a3268a891c 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -47,8 +47,6 @@ static inline void ack_bad_irq(unsigned int irq)
 	irq_err_count++;
 }
 
-extern void handle_IRQ(unsigned int, struct pt_regs *);
-
 /*
  * No arch-specific IRQ flags.
  */
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 0f08dfd69ebc..67ca197277ee 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -40,33 +40,6 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	return 0;
 }
 
-/*
- * handle_IRQ handles all hardware IRQ's.  Decoded IRQs should
- * not come via this function.  Instead, they should provide their
- * own 'handler'.  Used by platform code implementing C-based 1st
- * level decoding.
- */
-void handle_IRQ(unsigned int irq, struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	irq_enter();
-
-	/*
-	 * Some hardware gives randomly wrong interrupts.  Rather
-	 * than crashing, do something sensible.
-	 */
-	if (unlikely(irq >= nr_irqs)) {
-		pr_warn_ratelimited("Bad IRQ%u\n", irq);
-		ack_bad_irq(irq);
-	} else {
-		generic_handle_irq(irq);
-	}
-
-	irq_exit();
-	set_irq_regs(old_regs);
-}
-
 void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 {
 	if (handle_arch_irq)
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 88e83368bbf5..e5a693b16da2 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -8,6 +8,7 @@ config OPENRISC
 	select OF
 	select OF_EARLY_FLATTREE
 	select IRQ_DOMAIN
+	select HANDLE_DOMAIN_IRQ
 	select HAVE_MEMBLOCK
 	select ARCH_REQUIRE_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
diff --git a/arch/openrisc/include/asm/irq.h b/arch/openrisc/include/asm/irq.h
index b84634cc95eb..d9eee0a2b7b4 100644
--- a/arch/openrisc/include/asm/irq.h
+++ b/arch/openrisc/include/asm/irq.h
@@ -24,7 +24,6 @@
 
 #define NO_IRQ		(-1)
 
-void handle_IRQ(unsigned int, struct pt_regs *);
 extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
 
 #endif /* __ASM_OPENRISC_IRQ_H__ */
diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 967eb1430203..35e478a93116 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -48,18 +48,6 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 	handle_arch_irq = handle_irq;
 }
 
-void handle_IRQ(unsigned int irq, struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	irq_enter();
-
-	generic_handle_irq(irq);
-
-	irq_exit();
-	set_irq_regs(old_regs);
-}
-
 void __irq_entry do_IRQ(struct pt_regs *regs)
 {
 	handle_arch_irq(regs);
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b8632bf9a7f3..c88896478e70 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -113,3 +113,10 @@ config IRQ_CROSSBAR
 	  The primary irqchip invokes the crossbar's callback which inturn allocates
 	  a free irq and configures the IP. Thus the peripheral interrupts are
 	  routed to one of the free irqchip interrupt lines.
+
+config KEYSTONE_IRQ
+	tristate "Keystone 2 IRQ controller IP"
+	depends on ARCH_KEYSTONE
+	help
+		Support for Texas Instruments Keystone 2 IRQ controller IP which
+		is part of the Keystone 2 IPC mechanism
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 73052ba9ca62..bec790678016 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
+obj-$(CONFIG_ARCH_HIP04)		+= irq-hip04.o
 obj-$(CONFIG_ARCH_MMP)			+= irq-mmp.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
 obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
@@ -33,4 +34,6 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
-obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
+obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
+					   irq-bcm7120-l2.o
+obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 574aba0eba4e..fa75a29a0408 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -393,13 +393,15 @@ static void armada_370_xp_handle_msi_irq(struct pt_regs *regs, bool is_chained)
 		if (!(msimask & BIT(msinr)))
 			continue;
 
-		irq = irq_find_mapping(armada_370_xp_msi_domain,
-				       msinr - 16);
-
-		if (is_chained)
+		if (is_chained) {
+			irq = irq_find_mapping(armada_370_xp_msi_domain,
+					       msinr - 16);
 			generic_handle_irq(irq);
-		else
-			handle_IRQ(irq, regs);
+		} else {
+			irq = msinr - 16;
+			handle_domain_irq(armada_370_xp_msi_domain,
+					  irq, regs);
+		}
 	}
 }
 #else
@@ -444,9 +446,8 @@ armada_370_xp_handle_irq(struct pt_regs *regs)
 			break;
 
 		if (irqnr > 1) {
-			irqnr =	irq_find_mapping(armada_370_xp_mpic_domain,
-					irqnr);
-			handle_IRQ(irqnr, regs);
+			handle_domain_irq(armada_370_xp_mpic_domain,
+					  irqnr, regs);
 			continue;
 		}
 
diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index a82869e9fb26..9a2cf3c1a3a5 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -68,12 +68,10 @@ aic_handle(struct pt_regs *regs)
 	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC_IVR);
 	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC_ISR);
 
-	irqnr = irq_find_mapping(aic_domain, irqnr);
-
 	if (!irqstat)
 		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
 	else
-		handle_IRQ(irqnr, regs);
+		handle_domain_irq(aic_domain, irqnr, regs);
 }
 
 static int aic_retrigger(struct irq_data *d)
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index edb227081524..a11aae8fb006 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -78,12 +78,10 @@ aic5_handle(struct pt_regs *regs)
 	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC5_IVR);
 	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC5_ISR);
 
-	irqnr = irq_find_mapping(aic5_domain, irqnr);
-
 	if (!irqstat)
 		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
 	else
-		handle_IRQ(irqnr, regs);
+		handle_domain_irq(aic5_domain, irqnr, regs);
 }
 
 static void aic5_mask(struct irq_data *d)
@@ -297,6 +295,7 @@ static void __init sama5d3_aic_irq_fixup(struct device_node *root)
 
 static const struct of_device_id __initdata aic5_irq_fixups[] = {
 	{ .compatible = "atmel,sama5d3", .data = sama5d3_aic_irq_fixup },
+	{ .compatible = "atmel,sama5d4", .data = sama5d3_aic_irq_fixup },
 	{ /* sentinel */ },
 };
 
@@ -343,7 +342,7 @@ static int __init aic5_of_init(struct device_node *node,
 	return 0;
 }
 
-#define NR_SAMA5D3_IRQS		50
+#define NR_SAMA5D3_IRQS		48
 
 static int __init sama5d3_aic5_of_init(struct device_node *node,
 				       struct device_node *parent)
@@ -351,3 +350,12 @@ static int __init sama5d3_aic5_of_init(struct device_node *node,
 	return aic5_of_init(node, parent, NR_SAMA5D3_IRQS);
 }
 IRQCHIP_DECLARE(sama5d3_aic5, "atmel,sama5d3-aic", sama5d3_aic5_of_init);
+
+#define NR_SAMA5D4_IRQS		68
+
+static int __init sama5d4_aic5_of_init(struct device_node *node,
+				       struct device_node *parent)
+{
+	return aic5_of_init(node, parent, NR_SAMA5D4_IRQS);
+}
+IRQCHIP_DECLARE(sama5d4_aic5, "atmel,sama5d4-aic", sama5d4_aic5_of_init);
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
new file mode 100644
index 000000000000..b9f4fb808e49
--- /dev/null
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -0,0 +1,219 @@
+/*
+ * Broadcom BCM7120 style Level 2 interrupt controller driver
+ *
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME	": " fmt
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/irqdomain.h>
+#include <linux/reboot.h>
+#include <linux/irqchip/chained_irq.h>
+
+#include "irqchip.h"
+
+#include <asm/mach/irq.h>
+
+/* Register offset in the L2 interrupt controller */
+#define IRQEN		0x00
+#define IRQSTAT		0x04
+
+struct bcm7120_l2_intc_data {
+	void __iomem *base;
+	struct irq_domain *domain;
+	bool can_wake;
+	u32 irq_fwd_mask;
+	u32 irq_map_mask;
+	u32 saved_mask;
+};
+
+static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
+{
+	struct bcm7120_l2_intc_data *b = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	u32 status;
+
+	chained_irq_enter(chip, desc);
+
+	status = __raw_readl(b->base + IRQSTAT);
+
+	if (status == 0) {
+		do_bad_IRQ(irq, desc);
+		goto out;
+	}
+
+	do {
+		irq = ffs(status) - 1;
+		status &= ~(1 << irq);
+		generic_handle_irq(irq_find_mapping(b->domain, irq));
+	} while (status);
+
+out:
+	chained_irq_exit(chip, desc);
+}
+
+static void bcm7120_l2_intc_suspend(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct bcm7120_l2_intc_data *b = gc->private;
+	u32 reg;
+
+	irq_gc_lock(gc);
+	/* Save the current mask and the interrupt forward mask */
+	b->saved_mask = __raw_readl(b->base) | b->irq_fwd_mask;
+	if (b->can_wake) {
+		reg = b->saved_mask | gc->wake_active;
+		__raw_writel(reg, b->base);
+	}
+	irq_gc_unlock(gc);
+}
+
+static void bcm7120_l2_intc_resume(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct bcm7120_l2_intc_data *b = gc->private;
+
+	/* Restore the saved mask */
+	irq_gc_lock(gc);
+	__raw_writel(b->saved_mask, b->base);
+	irq_gc_unlock(gc);
+}
+
+static int bcm7120_l2_intc_init_one(struct device_node *dn,
+					struct bcm7120_l2_intc_data *data,
+					int irq, const __be32 *map_mask)
+{
+	int parent_irq;
+
+	parent_irq = irq_of_parse_and_map(dn, irq);
+	if (parent_irq < 0) {
+		pr_err("failed to map interrupt %d\n", irq);
+		return parent_irq;
+	}
+
+	data->irq_map_mask |= be32_to_cpup(map_mask + irq);
+
+	irq_set_handler_data(parent_irq, data);
+	irq_set_chained_handler(parent_irq, bcm7120_l2_intc_irq_handle);
+
+	return 0;
+}
+
+int __init bcm7120_l2_intc_of_init(struct device_node *dn,
+					struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct bcm7120_l2_intc_data *data;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+	const __be32 *map_mask;
+	int num_parent_irqs;
+	int ret = 0, len, irq;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->base = of_iomap(dn, 0);
+	if (!data->base) {
+		pr_err("failed to remap intc L2 registers\n");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	if (of_property_read_u32(dn, "brcm,int-fwd-mask", &data->irq_fwd_mask))
+		data->irq_fwd_mask = 0;
+
+	/* Enable all interrupt specified in the interrupt forward mask and have
+	 * the other disabled
+	 */
+	__raw_writel(data->irq_fwd_mask, data->base + IRQEN);
+
+	num_parent_irqs = of_irq_count(dn);
+	if (num_parent_irqs <= 0) {
+		pr_err("invalid number of parent interrupts\n");
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	map_mask = of_get_property(dn, "brcm,int-map-mask", &len);
+	if (!map_mask || (len != (sizeof(*map_mask) * num_parent_irqs))) {
+		pr_err("invalid brcm,int-map-mask property\n");
+		ret = -EINVAL;
+		goto out_unmap;
+	}
+
+	for (irq = 0; irq < num_parent_irqs; irq++) {
+		ret = bcm7120_l2_intc_init_one(dn, data, irq, map_mask);
+		if (ret)
+			goto out_unmap;
+	}
+
+	data->domain = irq_domain_add_linear(dn, 32,
+					&irq_generic_chip_ops, NULL);
+	if (!data->domain) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
+				dn->full_name, handle_level_irq, clr, 0,
+				IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("failed to allocate generic irq chip\n");
+		goto out_free_domain;
+	}
+
+	gc = irq_get_domain_generic_chip(data->domain, 0);
+	gc->unused = 0xfffffff & ~data->irq_map_mask;
+	gc->reg_base = data->base;
+	gc->private = data;
+	ct = gc->chip_types;
+
+	ct->regs.mask = IRQEN;
+	ct->chip.irq_mask = irq_gc_mask_clr_bit;
+	ct->chip.irq_unmask = irq_gc_mask_set_bit;
+	ct->chip.irq_ack = irq_gc_noop;
+	ct->chip.irq_suspend = bcm7120_l2_intc_suspend;
+	ct->chip.irq_resume = bcm7120_l2_intc_resume;
+
+	if (of_property_read_bool(dn, "brcm,irq-can-wake")) {
+		data->can_wake = true;
+		/* This IRQ chip can wake the system, set all relevant child
+		 * interupts in wake_enabled mask
+		 */
+		gc->wake_enabled = 0xffffffff;
+		gc->wake_enabled &= ~gc->unused;
+		ct->chip.irq_set_wake = irq_gc_set_wake;
+	}
+
+	pr_info("registered BCM7120 L2 intc (mem: 0x%p, parent IRQ(s): %d)\n",
+			data->base, num_parent_irqs);
+
+	return 0;
+
+out_free_domain:
+	irq_domain_remove(data->domain);
+out_unmap:
+	iounmap(data->base);
+out_free:
+	kfree(data);
+	return ret;
+}
+IRQCHIP_DECLARE(brcmstb_l2_intc, "brcm,bcm7120-l2-intc",
+		bcm7120_l2_intc_of_init);
diff --git a/drivers/irqchip/irq-clps711x.c b/drivers/irqchip/irq-clps711x.c
index 33340dc97d1d..33127f131d78 100644
--- a/drivers/irqchip/irq-clps711x.c
+++ b/drivers/irqchip/irq-clps711x.c
@@ -76,24 +76,20 @@ static struct {
 
 static asmlinkage void __exception_irq_entry clps711x_irqh(struct pt_regs *regs)
 {
-	u32 irqnr, irqstat;
+	u32 irqstat;
 
 	do {
 		irqstat = readw_relaxed(clps711x_intc->intmr[0]) &
 			  readw_relaxed(clps711x_intc->intsr[0]);
-		if (irqstat) {
-			irqnr =	irq_find_mapping(clps711x_intc->domain,
-						 fls(irqstat) - 1);
-			handle_IRQ(irqnr, regs);
-		}
+		if (irqstat)
+			handle_domain_irq(clps711x_intc->domain,
+					  fls(irqstat) - 1, regs);
 
 		irqstat = readw_relaxed(clps711x_intc->intmr[1]) &
 			  readw_relaxed(clps711x_intc->intsr[1]);
-		if (irqstat) {
-			irqnr =	irq_find_mapping(clps711x_intc->domain,
-						 fls(irqstat) - 1 + 16);
-			handle_IRQ(irqnr, regs);
-		}
+		if (irqstat)
+			handle_domain_irq(clps711x_intc->domain,
+					  fls(irqstat) - 1 + 16, regs);
 	} while (irqstat);
 }
 
diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
index 60ac704d2090..61541ff24397 100644
--- a/drivers/irqchip/irq-gic-common.c
+++ b/drivers/irqchip/irq-gic-common.c
@@ -74,20 +74,22 @@ void __init gic_dist_config(void __iomem *base, int gic_irqs,
 	 * Set all global interrupts to be level triggered, active low.
 	 */
 	for (i = 32; i < gic_irqs; i += 16)
-		writel_relaxed(0, base + GIC_DIST_CONFIG + i / 4);
+		writel_relaxed(GICD_INT_ACTLOW_LVLTRIG,
+					base + GIC_DIST_CONFIG + i / 4);
 
 	/*
 	 * Set priority on all global interrupts.
 	 */
 	for (i = 32; i < gic_irqs; i += 4)
-		writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i);
+		writel_relaxed(GICD_INT_DEF_PRI_X4, base + GIC_DIST_PRI + i);
 
 	/*
 	 * Disable all interrupts.  Leave the PPI and SGIs alone
 	 * as they are enabled by redistributor registers.
 	 */
 	for (i = 32; i < gic_irqs; i += 32)
-		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i / 8);
+		writel_relaxed(GICD_INT_EN_CLR_X32,
+					base + GIC_DIST_ENABLE_CLEAR + i / 8);
 
 	if (sync_access)
 		sync_access();
@@ -101,14 +103,15 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void))
 	 * Deal with the banked PPI and SGI interrupts - disable all
 	 * PPI interrupts, ensure all SGI interrupts are enabled.
 	 */
-	writel_relaxed(0xffff0000, base + GIC_DIST_ENABLE_CLEAR);
-	writel_relaxed(0x0000ffff, base + GIC_DIST_ENABLE_SET);
+	writel_relaxed(GICD_INT_EN_CLR_PPI, base + GIC_DIST_ENABLE_CLEAR);
+	writel_relaxed(GICD_INT_EN_SET_SGI, base + GIC_DIST_ENABLE_SET);
 
 	/*
 	 * Set priority on PPI and SGI interrupts
 	 */
 	for (i = 0; i < 32; i += 4)
-		writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i * 4 / 4);
+		writel_relaxed(GICD_INT_DEF_PRI_X4,
+					base + GIC_DIST_PRI + i * 4 / 4);
 
 	if (sync_access)
 		sync_access();
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 57eaa5a0b1e3..7247a3cc7ba1 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/cpu.h>
+#include <linux/cpu_pm.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
@@ -155,7 +156,7 @@ static void gic_enable_sre(void)
 		pr_err("GIC: unable to set SRE (disabled at EL2), panic ahead\n");
 }
 
-static void gic_enable_redist(void)
+static void gic_enable_redist(bool enable)
 {
 	void __iomem *rbase;
 	u32 count = 1000000;	/* 1s! */
@@ -163,20 +164,30 @@ static void gic_enable_redist(void)
 
 	rbase = gic_data_rdist_rd_base();
 
-	/* Wake up this CPU redistributor */
 	val = readl_relaxed(rbase + GICR_WAKER);
-	val &= ~GICR_WAKER_ProcessorSleep;
+	if (enable)
+		/* Wake up this CPU redistributor */
+		val &= ~GICR_WAKER_ProcessorSleep;
+	else
+		val |= GICR_WAKER_ProcessorSleep;
 	writel_relaxed(val, rbase + GICR_WAKER);
 
-	while (readl_relaxed(rbase + GICR_WAKER) & GICR_WAKER_ChildrenAsleep) {
-		count--;
-		if (!count) {
-			pr_err_ratelimited("redist didn't wake up...\n");
-			return;
-		}
+	if (!enable) {		/* Check that GICR_WAKER is writeable */
+		val = readl_relaxed(rbase + GICR_WAKER);
+		if (!(val & GICR_WAKER_ProcessorSleep))
+			return;	/* No PM support in this redistributor */
+	}
+
+	while (count--) {
+		val = readl_relaxed(rbase + GICR_WAKER);
+		if (enable ^ (val & GICR_WAKER_ChildrenAsleep))
+			break;
 		cpu_relax();
 		udelay(1);
 	};
+	if (!count)
+		pr_err_ratelimited("redistributor failed to %s...\n",
+				   enable ? "wakeup" : "sleep");
 }
 
 /*
@@ -274,14 +285,13 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		irqnr = gic_read_iar();
 
 		if (likely(irqnr > 15 && irqnr < 1020)) {
-			u64 irq = irq_find_mapping(gic_data.domain, irqnr);
-			if (likely(irq)) {
-				handle_IRQ(irq, regs);
-				continue;
+			int err;
+			err = handle_domain_irq(gic_data.domain, irqnr, regs);
+			if (err) {
+				WARN_ONCE(true, "Unexpected SPI received!\n");
+				gic_write_eoir(irqnr);
 			}
-
-			WARN_ONCE(true, "Unexpected SPI received!\n");
-			gic_write_eoir(irqnr);
+			continue;
 		}
 		if (irqnr < 16) {
 			gic_write_eoir(irqnr);
@@ -373,6 +383,21 @@ static int gic_populate_rdist(void)
 	return -ENODEV;
 }
 
+static void gic_cpu_sys_reg_init(void)
+{
+	/* Enable system registers */
+	gic_enable_sre();
+
+	/* Set priority mask register */
+	gic_write_pmr(DEFAULT_PMR_VALUE);
+
+	/* EOI deactivates interrupt too (mode 0) */
+	gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+
+	/* ... and let's hit the road... */
+	gic_write_grpen1(1);
+}
+
 static void gic_cpu_init(void)
 {
 	void __iomem *rbase;
@@ -381,23 +406,14 @@ static void gic_cpu_init(void)
 	if (gic_populate_rdist())
 		return;
 
-	gic_enable_redist();
+	gic_enable_redist(true);
 
 	rbase = gic_data_rdist_sgi_base();
 
 	gic_cpu_config(rbase, gic_redist_wait_for_rwp);
 
-	/* Enable system registers */
-	gic_enable_sre();
-
-	/* Set priority mask register */
-	gic_write_pmr(DEFAULT_PMR_VALUE);
-
-	/* EOI deactivates interrupt too (mode 0) */
-	gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
-
-	/* ... and let's hit the road... */
-	gic_write_grpen1(1);
+	/* initialise system registers */
+	gic_cpu_sys_reg_init();
 }
 
 #ifdef CONFIG_SMP
@@ -533,6 +549,33 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 #define gic_smp_init()		do { } while(0)
 #endif
 
+#ifdef CONFIG_CPU_PM
+static int gic_cpu_pm_notifier(struct notifier_block *self,
+			       unsigned long cmd, void *v)
+{
+	if (cmd == CPU_PM_EXIT) {
+		gic_enable_redist(true);
+		gic_cpu_sys_reg_init();
+	} else if (cmd == CPU_PM_ENTER) {
+		gic_write_grpen1(0);
+		gic_enable_redist(false);
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gic_cpu_pm_notifier_block = {
+	.notifier_call = gic_cpu_pm_notifier,
+};
+
+static void gic_cpu_pm_init(void)
+{
+	cpu_pm_register_notifier(&gic_cpu_pm_notifier_block);
+}
+
+#else
+static inline void gic_cpu_pm_init(void) { }
+#endif /* CONFIG_CPU_PM */
+
 static struct irq_chip gic_chip = {
 	.name			= "GICv3",
 	.irq_mask		= gic_mask_irq,
@@ -672,6 +715,7 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 	gic_smp_init();
 	gic_dist_init();
 	gic_cpu_init();
+	gic_cpu_pm_init();
 
 	return 0;
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4b959e606fe8..55aa6f62c77c 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -270,8 +270,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
 
 		if (likely(irqnr > 15 && irqnr < 1021)) {
-			irqnr = irq_find_mapping(gic->domain, irqnr);
-			handle_IRQ(irqnr, regs);
+			handle_domain_irq(gic->domain, irqnr, regs);
 			continue;
 		}
 		if (irqnr < 16) {
@@ -298,8 +297,8 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	status = readl_relaxed(gic_data_cpu_base(chip_data) + GIC_CPU_INTACK);
 	raw_spin_unlock(&irq_controller_lock);
 
-	gic_irq = (status & 0x3ff);
-	if (gic_irq == 1023)
+	gic_irq = (status & GICC_IAR_INT_ID_MASK);
+	if (gic_irq == GICC_INT_SPURIOUS)
 		goto out;
 
 	cascade_irq = irq_find_mapping(chip_data->domain, gic_irq);
@@ -353,6 +352,21 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 	return mask;
 }
 
+static void gic_cpu_if_up(void)
+{
+	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
+	u32 bypass = 0;
+
+	/*
+	* Preserve bypass disable bits to be written back later
+	*/
+	bypass = readl(cpu_base + GIC_CPU_CTRL);
+	bypass &= GICC_DIS_BYPASS_MASK;
+
+	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+}
+
+
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
 	unsigned int i;
@@ -360,7 +374,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	unsigned int gic_irqs = gic->gic_irqs;
 	void __iomem *base = gic_data_dist_base(gic);
 
-	writel_relaxed(0, base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_DISABLE, base + GIC_DIST_CTRL);
 
 	/*
 	 * Set all global interrupts to this CPU only.
@@ -373,7 +387,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 
 	gic_dist_config(base, gic_irqs, NULL);
 
-	writel_relaxed(1, base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_ENABLE, base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_init(struct gic_chip_data *gic)
@@ -400,14 +414,18 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 
 	gic_cpu_config(dist_base, NULL);
 
-	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+	writel_relaxed(GICC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
+	gic_cpu_if_up();
 }
 
 void gic_cpu_if_down(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+	u32 val = 0;
+
+	val = readl(cpu_base + GIC_CPU_CTRL);
+	val &= ~GICC_ENABLE;
+	writel_relaxed(val, cpu_base + GIC_CPU_CTRL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -467,14 +485,14 @@ static void gic_dist_restore(unsigned int gic_nr)
 	if (!dist_base)
 		return;
 
-	writel_relaxed(0, dist_base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_DISABLE, dist_base + GIC_DIST_CTRL);
 
 	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
 		writel_relaxed(gic_data[gic_nr].saved_spi_conf[i],
 			dist_base + GIC_DIST_CONFIG + i * 4);
 
 	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
-		writel_relaxed(0xa0a0a0a0,
+		writel_relaxed(GICD_INT_DEF_PRI_X4,
 			dist_base + GIC_DIST_PRI + i * 4);
 
 	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
@@ -485,7 +503,7 @@ static void gic_dist_restore(unsigned int gic_nr)
 		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
 			dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_ENABLE, dist_base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_save(unsigned int gic_nr)
@@ -539,10 +557,11 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
 
 	for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
-		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
+		writel_relaxed(GICD_INT_DEF_PRI_X4,
+					dist_base + GIC_DIST_PRI + i * 4);
 
-	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
+	gic_cpu_if_up();
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
new file mode 100644
index 000000000000..9c8f833522e6
--- /dev/null
+++ b/drivers/irqchip/irq-hip04.c
@@ -0,0 +1,424 @@
+/*
+ * Hisilicon HiP04 INTC
+ *
+ * Copyright (C) 2002-2014 ARM Limited.
+ * Copyright (c) 2013-2014 Hisilicon Ltd.
+ * Copyright (c) 2013-2014 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Interrupt architecture for the HIP04 INTC:
+ *
+ * o There is one Interrupt Distributor, which receives interrupts
+ *   from system devices and sends them to the Interrupt Controllers.
+ *
+ * o There is one CPU Interface per CPU, which sends interrupts sent
+ *   by the Distributor, and interrupts generated locally, to the
+ *   associated CPU. The base address of the CPU interface is usually
+ *   aliased so that the same address points to different chips depending
+ *   on the CPU it is accessed from.
+ *
+ * Note that IRQs 0-31 are special - they are local to each CPU.
+ * As such, the enable set/clear, pending set/clear and active bit
+ * registers are banked per-cpu for these sources.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/smp.h>
+#include <linux/cpu.h>
+#include <linux/cpu_pm.h>
+#include <linux/cpumask.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/irqchip/arm-gic.h>
+
+#include <asm/irq.h>
+#include <asm/exception.h>
+#include <asm/smp_plat.h>
+
+#include "irq-gic-common.h"
+#include "irqchip.h"
+
+#define HIP04_MAX_IRQS		510
+
+struct hip04_irq_data {
+	void __iomem *dist_base;
+	void __iomem *cpu_base;
+	struct irq_domain *domain;
+	unsigned int nr_irqs;
+};
+
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+
+/*
+ * The GIC mapping of CPU interfaces does not necessarily match
+ * the logical CPU numbering.  Let's use a mapping as returned
+ * by the GIC itself.
+ */
+#define NR_HIP04_CPU_IF 16
+static u16 hip04_cpu_map[NR_HIP04_CPU_IF] __read_mostly;
+
+static struct hip04_irq_data hip04_data __read_mostly;
+
+static inline void __iomem *hip04_dist_base(struct irq_data *d)
+{
+	struct hip04_irq_data *hip04_data = irq_data_get_irq_chip_data(d);
+	return hip04_data->dist_base;
+}
+
+static inline void __iomem *hip04_cpu_base(struct irq_data *d)
+{
+	struct hip04_irq_data *hip04_data = irq_data_get_irq_chip_data(d);
+	return hip04_data->cpu_base;
+}
+
+static inline unsigned int hip04_irq(struct irq_data *d)
+{
+	return d->hwirq;
+}
+
+/*
+ * Routines to acknowledge, disable and enable interrupts
+ */
+static void hip04_mask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (hip04_irq(d) % 32);
+
+	raw_spin_lock(&irq_controller_lock);
+	writel_relaxed(mask, hip04_dist_base(d) + GIC_DIST_ENABLE_CLEAR +
+		       (hip04_irq(d) / 32) * 4);
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+static void hip04_unmask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (hip04_irq(d) % 32);
+
+	raw_spin_lock(&irq_controller_lock);
+	writel_relaxed(mask, hip04_dist_base(d) + GIC_DIST_ENABLE_SET +
+		       (hip04_irq(d) / 32) * 4);
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+static void hip04_eoi_irq(struct irq_data *d)
+{
+	writel_relaxed(hip04_irq(d), hip04_cpu_base(d) + GIC_CPU_EOI);
+}
+
+static int hip04_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	void __iomem *base = hip04_dist_base(d);
+	unsigned int irq = hip04_irq(d);
+
+	/* Interrupt configuration for SGIs can't be changed */
+	if (irq < 16)
+		return -EINVAL;
+
+	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
+		return -EINVAL;
+
+	raw_spin_lock(&irq_controller_lock);
+
+	gic_configure_irq(irq, type, base, NULL);
+
+	raw_spin_unlock(&irq_controller_lock);
+
+	return 0;
+}
+
+#ifdef CONFIG_SMP
+static int hip04_irq_set_affinity(struct irq_data *d,
+				  const struct cpumask *mask_val,
+				  bool force)
+{
+	void __iomem *reg;
+	unsigned int cpu, shift = (hip04_irq(d) % 2) * 16;
+	u32 val, mask, bit;
+
+	if (!force)
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	else
+		cpu = cpumask_first(mask_val);
+
+	if (cpu >= NR_HIP04_CPU_IF || cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	raw_spin_lock(&irq_controller_lock);
+	reg = hip04_dist_base(d) + GIC_DIST_TARGET + ((hip04_irq(d) * 2) & ~3);
+	mask = 0xffff << shift;
+	bit = hip04_cpu_map[cpu] << shift;
+	val = readl_relaxed(reg) & ~mask;
+	writel_relaxed(val | bit, reg);
+	raw_spin_unlock(&irq_controller_lock);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
+static void __exception_irq_entry hip04_handle_irq(struct pt_regs *regs)
+{
+	u32 irqstat, irqnr;
+	void __iomem *cpu_base = hip04_data.cpu_base;
+
+	do {
+		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
+		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+
+		if (likely(irqnr > 15 && irqnr <= HIP04_MAX_IRQS)) {
+			irqnr = irq_find_mapping(hip04_data.domain, irqnr);
+			handle_IRQ(irqnr, regs);
+			continue;
+		}
+		if (irqnr < 16) {
+			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+#ifdef CONFIG_SMP
+			handle_IPI(irqnr, regs);
+#endif
+			continue;
+		}
+		break;
+	} while (1);
+}
+
+static struct irq_chip hip04_irq_chip = {
+	.name			= "HIP04 INTC",
+	.irq_mask		= hip04_mask_irq,
+	.irq_unmask		= hip04_unmask_irq,
+	.irq_eoi		= hip04_eoi_irq,
+	.irq_set_type		= hip04_irq_set_type,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= hip04_irq_set_affinity,
+#endif
+};
+
+static u16 hip04_get_cpumask(struct hip04_irq_data *intc)
+{
+	void __iomem *base = intc->dist_base;
+	u32 mask, i;
+
+	for (i = mask = 0; i < 32; i += 2) {
+		mask = readl_relaxed(base + GIC_DIST_TARGET + i * 2);
+		mask |= mask >> 16;
+		if (mask)
+			break;
+	}
+
+	if (!mask)
+		pr_crit("GIC CPU mask not found - kernel will fail to boot.\n");
+
+	return mask;
+}
+
+static void __init hip04_irq_dist_init(struct hip04_irq_data *intc)
+{
+	unsigned int i;
+	u32 cpumask;
+	unsigned int nr_irqs = intc->nr_irqs;
+	void __iomem *base = intc->dist_base;
+
+	writel_relaxed(0, base + GIC_DIST_CTRL);
+
+	/*
+	 * Set all global interrupts to this CPU only.
+	 */
+	cpumask = hip04_get_cpumask(intc);
+	cpumask |= cpumask << 16;
+	for (i = 32; i < nr_irqs; i += 2)
+		writel_relaxed(cpumask, base + GIC_DIST_TARGET + ((i * 2) & ~3));
+
+	gic_dist_config(base, nr_irqs, NULL);
+
+	writel_relaxed(1, base + GIC_DIST_CTRL);
+}
+
+static void hip04_irq_cpu_init(struct hip04_irq_data *intc)
+{
+	void __iomem *dist_base = intc->dist_base;
+	void __iomem *base = intc->cpu_base;
+	unsigned int cpu_mask, cpu = smp_processor_id();
+	int i;
+
+	/*
+	 * Get what the GIC says our CPU mask is.
+	 */
+	BUG_ON(cpu >= NR_HIP04_CPU_IF);
+	cpu_mask = hip04_get_cpumask(intc);
+	hip04_cpu_map[cpu] = cpu_mask;
+
+	/*
+	 * Clear our mask from the other map entries in case they're
+	 * still undefined.
+	 */
+	for (i = 0; i < NR_HIP04_CPU_IF; i++)
+		if (i != cpu)
+			hip04_cpu_map[i] &= ~cpu_mask;
+
+	gic_cpu_config(dist_base, NULL);
+
+	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
+	writel_relaxed(1, base + GIC_CPU_CTRL);
+}
+
+#ifdef CONFIG_SMP
+static void hip04_raise_softirq(const struct cpumask *mask, unsigned int irq)
+{
+	int cpu;
+	unsigned long flags, map = 0;
+
+	raw_spin_lock_irqsave(&irq_controller_lock, flags);
+
+	/* Convert our logical CPU mask into a physical one. */
+	for_each_cpu(cpu, mask)
+		map |= hip04_cpu_map[cpu];
+
+	/*
+	 * Ensure that stores to Normal memory are visible to the
+	 * other CPUs before they observe us issuing the IPI.
+	 */
+	dmb(ishst);
+
+	/* this always happens on GIC0 */
+	writel_relaxed(map << 8 | irq, hip04_data.dist_base + GIC_DIST_SOFTINT);
+
+	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
+}
+#endif
+
+static int hip04_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	if (hw < 32) {
+		irq_set_percpu_devid(irq);
+		irq_set_chip_and_handler(irq, &hip04_irq_chip,
+					 handle_percpu_devid_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
+	} else {
+		irq_set_chip_and_handler(irq, &hip04_irq_chip,
+					 handle_fasteoi_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+	irq_set_chip_data(irq, d->host_data);
+	return 0;
+}
+
+static int hip04_irq_domain_xlate(struct irq_domain *d,
+				  struct device_node *controller,
+				  const u32 *intspec, unsigned int intsize,
+				  unsigned long *out_hwirq,
+				  unsigned int *out_type)
+{
+	unsigned long ret = 0;
+
+	if (d->of_node != controller)
+		return -EINVAL;
+	if (intsize < 3)
+		return -EINVAL;
+
+	/* Get the interrupt number and add 16 to skip over SGIs */
+	*out_hwirq = intspec[1] + 16;
+
+	/* For SPIs, we need to add 16 more to get the irq ID number */
+	if (!intspec[0])
+		*out_hwirq += 16;
+
+	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
+
+	return ret;
+}
+
+#ifdef CONFIG_SMP
+static int hip04_irq_secondary_init(struct notifier_block *nfb,
+				    unsigned long action,
+				    void *hcpu)
+{
+	if (action == CPU_STARTING || action == CPU_STARTING_FROZEN)
+		hip04_irq_cpu_init(&hip04_data);
+	return NOTIFY_OK;
+}
+
+/*
+ * Notifier for enabling the INTC CPU interface. Set an arbitrarily high
+ * priority because the GIC needs to be up before the ARM generic timers.
+ */
+static struct notifier_block hip04_irq_cpu_notifier = {
+	.notifier_call	= hip04_irq_secondary_init,
+	.priority	= 100,
+};
+#endif
+
+static const struct irq_domain_ops hip04_irq_domain_ops = {
+	.map	= hip04_irq_domain_map,
+	.xlate	= hip04_irq_domain_xlate,
+};
+
+static int __init
+hip04_of_init(struct device_node *node, struct device_node *parent)
+{
+	irq_hw_number_t hwirq_base = 16;
+	int nr_irqs, irq_base, i;
+
+	if (WARN_ON(!node))
+		return -ENODEV;
+
+	hip04_data.dist_base = of_iomap(node, 0);
+	WARN(!hip04_data.dist_base, "fail to map hip04 intc dist registers\n");
+
+	hip04_data.cpu_base = of_iomap(node, 1);
+	WARN(!hip04_data.cpu_base, "unable to map hip04 intc cpu registers\n");
+
+	/*
+	 * Initialize the CPU interface map to all CPUs.
+	 * It will be refined as each CPU probes its ID.
+	 */
+	for (i = 0; i < NR_HIP04_CPU_IF; i++)
+		hip04_cpu_map[i] = 0xff;
+
+	/*
+	 * Find out how many interrupts are supported.
+	 * The HIP04 INTC only supports up to 510 interrupt sources.
+	 */
+	nr_irqs = readl_relaxed(hip04_data.dist_base + GIC_DIST_CTR) & 0x1f;
+	nr_irqs = (nr_irqs + 1) * 32;
+	if (nr_irqs > HIP04_MAX_IRQS)
+		nr_irqs = HIP04_MAX_IRQS;
+	hip04_data.nr_irqs = nr_irqs;
+
+	nr_irqs -= hwirq_base; /* calculate # of irqs to allocate */
+
+	irq_base = irq_alloc_descs(-1, hwirq_base, nr_irqs, numa_node_id());
+	if (IS_ERR_VALUE(irq_base)) {
+		pr_err("failed to allocate IRQ numbers\n");
+		return -EINVAL;
+	}
+
+	hip04_data.domain = irq_domain_add_legacy(node, nr_irqs, irq_base,
+						  hwirq_base,
+						  &hip04_irq_domain_ops,
+						  &hip04_data);
+
+	if (WARN_ON(!hip04_data.domain))
+		return -EINVAL;
+
+#ifdef CONFIG_SMP
+	set_smp_cross_call(hip04_raise_softirq);
+	register_cpu_notifier(&hip04_irq_cpu_notifier);
+#endif
+	set_handle_irq(hip04_handle_irq);
+
+	hip04_irq_dist_init(&hip04_data);
+	hip04_irq_cpu_init(&hip04_data);
+
+	return 0;
+}
+IRQCHIP_DECLARE(hip04_intc, "hisilicon,hip04-intc", hip04_of_init);
diff --git a/drivers/irqchip/irq-keystone.c b/drivers/irqchip/irq-keystone.c
new file mode 100644
index 000000000000..608abf9c9283
--- /dev/null
+++ b/drivers/irqchip/irq-keystone.c
@@ -0,0 +1,232 @@
+/*
+ * Texas Instruments Keystone IRQ controller IP driver
+ *
+ * Copyright (C) 2014 Texas Instruments, Inc.
+ * Author: Sajesh Kumar Saran <sajesh@ti.com>
+ *	   Grygorii Strashko <grygorii.strashko@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/irq.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include "irqchip.h"
+
+
+/* The source ID bits start from 4 to 31 (total 28 bits)*/
+#define BIT_OFS			4
+#define KEYSTONE_N_IRQ		(32 - BIT_OFS)
+
+struct keystone_irq_device {
+	struct device		*dev;
+	struct irq_chip		 chip;
+	u32			 mask;
+	int			 irq;
+	struct irq_domain	*irqd;
+	struct regmap		*devctrl_regs;
+	u32			devctrl_offset;
+};
+
+static inline u32 keystone_irq_readl(struct keystone_irq_device *kirq)
+{
+	int ret;
+	u32 val = 0;
+
+	ret = regmap_read(kirq->devctrl_regs, kirq->devctrl_offset, &val);
+	if (ret < 0)
+		dev_dbg(kirq->dev, "irq read failed ret(%d)\n", ret);
+	return val;
+}
+
+static inline void
+keystone_irq_writel(struct keystone_irq_device *kirq, u32 value)
+{
+	int ret;
+
+	ret = regmap_write(kirq->devctrl_regs, kirq->devctrl_offset, value);
+	if (ret < 0)
+		dev_dbg(kirq->dev, "irq write failed ret(%d)\n", ret);
+}
+
+static void keystone_irq_setmask(struct irq_data *d)
+{
+	struct keystone_irq_device *kirq = irq_data_get_irq_chip_data(d);
+
+	kirq->mask |= BIT(d->hwirq);
+	dev_dbg(kirq->dev, "mask %lu [%x]\n", d->hwirq, kirq->mask);
+}
+
+static void keystone_irq_unmask(struct irq_data *d)
+{
+	struct keystone_irq_device *kirq = irq_data_get_irq_chip_data(d);
+
+	kirq->mask &= ~BIT(d->hwirq);
+	dev_dbg(kirq->dev, "unmask %lu [%x]\n", d->hwirq, kirq->mask);
+}
+
+static void keystone_irq_ack(struct irq_data *d)
+{
+	/* nothing to do here */
+}
+
+static void keystone_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct keystone_irq_device *kirq = irq_desc_get_handler_data(desc);
+	unsigned long pending;
+	int src, virq;
+
+	dev_dbg(kirq->dev, "start irq %d\n", irq);
+
+	chained_irq_enter(irq_desc_get_chip(desc), desc);
+
+	pending = keystone_irq_readl(kirq);
+	keystone_irq_writel(kirq, pending);
+
+	dev_dbg(kirq->dev, "pending 0x%lx, mask 0x%x\n", pending, kirq->mask);
+
+	pending = (pending >> BIT_OFS) & ~kirq->mask;
+
+	dev_dbg(kirq->dev, "pending after mask 0x%lx\n", pending);
+
+	for (src = 0; src < KEYSTONE_N_IRQ; src++) {
+		if (BIT(src) & pending) {
+			virq = irq_find_mapping(kirq->irqd, src);
+			dev_dbg(kirq->dev, "dispatch bit %d, virq %d\n",
+				src, virq);
+			if (!virq)
+				dev_warn(kirq->dev, "sporious irq detected hwirq %d, virq %d\n",
+					 src, virq);
+			generic_handle_irq(virq);
+		}
+	}
+
+	chained_irq_exit(irq_desc_get_chip(desc), desc);
+
+	dev_dbg(kirq->dev, "end irq %d\n", irq);
+}
+
+static int keystone_irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw)
+{
+	struct keystone_irq_device *kirq = h->host_data;
+
+	irq_set_chip_data(virq, kirq);
+	irq_set_chip_and_handler(virq, &kirq->chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+	return 0;
+}
+
+static struct irq_domain_ops keystone_irq_ops = {
+	.map	= keystone_irq_map,
+	.xlate	= irq_domain_xlate_onecell,
+};
+
+static int keystone_irq_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct keystone_irq_device *kirq;
+	int ret;
+
+	if (np == NULL)
+		return -EINVAL;
+
+	kirq = devm_kzalloc(dev, sizeof(*kirq), GFP_KERNEL);
+	if (!kirq)
+		return -ENOMEM;
+
+	kirq->devctrl_regs =
+		syscon_regmap_lookup_by_phandle(np, "ti,syscon-dev");
+	if (IS_ERR(kirq->devctrl_regs))
+		return PTR_ERR(kirq->devctrl_regs);
+
+	ret = of_property_read_u32_index(np, "ti,syscon-dev", 1,
+					 &kirq->devctrl_offset);
+	if (ret) {
+		dev_err(dev, "couldn't read the devctrl_offset offset!\n");
+		return ret;
+	}
+
+	kirq->irq = platform_get_irq(pdev, 0);
+	if (kirq->irq < 0) {
+		dev_err(dev, "no irq resource %d\n", kirq->irq);
+		return kirq->irq;
+	}
+
+	kirq->dev = dev;
+	kirq->mask = ~0x0;
+	kirq->chip.name		= "keystone-irq";
+	kirq->chip.irq_ack	= keystone_irq_ack;
+	kirq->chip.irq_mask	= keystone_irq_setmask;
+	kirq->chip.irq_unmask	= keystone_irq_unmask;
+
+	kirq->irqd = irq_domain_add_linear(np, KEYSTONE_N_IRQ,
+					   &keystone_irq_ops, kirq);
+	if (!kirq->irqd) {
+		dev_err(dev, "IRQ domain registration failed\n");
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, kirq);
+
+	irq_set_chained_handler(kirq->irq, keystone_irq_handler);
+	irq_set_handler_data(kirq->irq, kirq);
+
+	/* clear all source bits */
+	keystone_irq_writel(kirq, ~0x0);
+
+	dev_info(dev, "irqchip registered, nr_irqs %u\n", KEYSTONE_N_IRQ);
+
+	return 0;
+}
+
+static int keystone_irq_remove(struct platform_device *pdev)
+{
+	struct keystone_irq_device *kirq = platform_get_drvdata(pdev);
+	int hwirq;
+
+	for (hwirq = 0; hwirq < KEYSTONE_N_IRQ; hwirq++)
+		irq_dispose_mapping(irq_find_mapping(kirq->irqd, hwirq));
+
+	irq_domain_remove(kirq->irqd);
+	return 0;
+}
+
+static const struct of_device_id keystone_irq_dt_ids[] = {
+	{ .compatible = "ti,keystone-irq", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, keystone_irq_dt_ids);
+
+static struct platform_driver keystone_irq_device_driver = {
+	.probe		= keystone_irq_probe,
+	.remove		= keystone_irq_remove,
+	.driver		= {
+		.name	= "keystone_irq",
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(keystone_irq_dt_ids),
+	}
+};
+
+module_platform_driver(keystone_irq_device_driver);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_AUTHOR("Sajesh Kumar Saran");
+MODULE_AUTHOR("Grygorii Strashko");
+MODULE_DESCRIPTION("Keystone IRQ chip");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 1c3e2c9b46ba..c0da57bdb89d 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -196,26 +196,24 @@ static struct mmp_intc_conf mmp2_conf = {
 
 static void __exception_irq_entry mmp_handle_irq(struct pt_regs *regs)
 {
-	int irq, hwirq;
+	int hwirq;
 
 	hwirq = readl_relaxed(mmp_icu_base + PJ1_INT_SEL);
 	if (!(hwirq & SEL_INT_PENDING))
 		return;
 	hwirq &= SEL_INT_NUM_MASK;
-	irq = irq_find_mapping(icu_data[0].domain, hwirq);
-	handle_IRQ(irq, regs);
+	handle_domain_irq(icu_data[0].domain, hwirq, regs);
 }
 
 static void __exception_irq_entry mmp2_handle_irq(struct pt_regs *regs)
 {
-	int irq, hwirq;
+	int hwirq;
 
 	hwirq = readl_relaxed(mmp_icu_base + PJ4_INT_SEL);
 	if (!(hwirq & SEL_INT_PENDING))
 		return;
 	hwirq &= SEL_INT_NUM_MASK;
-	irq = irq_find_mapping(icu_data[0].domain, hwirq);
-	handle_IRQ(irq, regs);
+	handle_domain_irq(icu_data[0].domain, hwirq, regs);
 }
 
 /* MMP (ARMv5) */
diff --git a/drivers/irqchip/irq-mxs.c b/drivers/irqchip/irq-mxs.c
index 4044ff287663..e4acf1e3f8e3 100644
--- a/drivers/irqchip/irq-mxs.c
+++ b/drivers/irqchip/irq-mxs.c
@@ -78,8 +78,7 @@ asmlinkage void __exception_irq_entry icoll_handle_irq(struct pt_regs *regs)
 
 	irqnr = __raw_readl(icoll_base + HW_ICOLL_STAT_OFFSET);
 	__raw_writel(irqnr, icoll_base + HW_ICOLL_VECTOR);
-	irqnr = irq_find_mapping(icoll_domain, irqnr);
-	handle_IRQ(irqnr, regs);
+	handle_domain_irq(icoll_domain, irqnr, regs);
 }
 
 static int icoll_irq_domain_map(struct irq_domain *d, unsigned int virq,
diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
index 17ff033d9925..e93d079fe069 100644
--- a/drivers/irqchip/irq-or1k-pic.c
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -113,7 +113,7 @@ static inline int pic_get_irq(int first)
 	else
 		hwirq = hwirq + first - 1;
 
-	return irq_find_mapping(root_domain, hwirq);
+	return hwirq;
 }
 
 static void or1k_pic_handle_irq(struct pt_regs *regs)
@@ -121,7 +121,7 @@ static void or1k_pic_handle_irq(struct pt_regs *regs)
 	int irq = -1;
 
 	while ((irq = pic_get_irq(irq + 1)) != NO_IRQ)
-		handle_IRQ(irq, regs);
+		handle_domain_irq(root_domain, irq, regs);
 }
 
 static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 34d18b48bb78..ad0c0f6f1d65 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -43,9 +43,8 @@ __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
 			gc->mask_cache;
 		while (stat) {
 			u32 hwirq = __fls(stat);
-			u32 irq = irq_find_mapping(orion_irq_domain,
-						   gc->irq_base + hwirq);
-			handle_IRQ(irq, regs);
+			handle_domain_irq(orion_irq_domain,
+					  gc->irq_base + hwirq, regs);
 			stat &= ~(1 << hwirq);
 		}
 	}
diff --git a/drivers/irqchip/irq-renesas-intc-irqpin.c b/drivers/irqchip/irq-renesas-intc-irqpin.c
index 3ee78f02e5d7..542e850f4946 100644
--- a/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ b/drivers/irqchip/irq-renesas-intc-irqpin.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -30,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_data/irq-renesas-intc-irqpin.h>
+#include <linux/pm_runtime.h>
 
 #define INTC_IRQPIN_MAX 8 /* maximum 8 interrupts per driver instance */
 
@@ -75,6 +77,7 @@ struct intc_irqpin_priv {
 	struct platform_device *pdev;
 	struct irq_chip irq_chip;
 	struct irq_domain *irq_domain;
+	struct clk *clk;
 	bool shared_irqs;
 	u8 shared_irq_mask;
 };
@@ -270,6 +273,21 @@ static int intc_irqpin_irq_set_type(struct irq_data *d, unsigned int type)
 				     value ^ INTC_IRQ_SENSE_VALID);
 }
 
+static int intc_irqpin_irq_set_wake(struct irq_data *d, unsigned int on)
+{
+	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
+
+	if (!p->clk)
+		return 0;
+
+	if (on)
+		clk_enable(p->clk);
+	else
+		clk_disable(p->clk);
+
+	return 0;
+}
+
 static irqreturn_t intc_irqpin_irq_handler(int irq, void *dev_id)
 {
 	struct intc_irqpin_irq *i = dev_id;
@@ -329,7 +347,8 @@ static struct irq_domain_ops intc_irqpin_irq_domain_ops = {
 
 static int intc_irqpin_probe(struct platform_device *pdev)
 {
-	struct renesas_intc_irqpin_config *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct renesas_intc_irqpin_config *pdata = dev->platform_data;
 	struct intc_irqpin_priv *p;
 	struct intc_irqpin_iomem *i;
 	struct resource *io[INTC_IRQPIN_REG_NR];
@@ -337,25 +356,24 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	struct irq_chip *irq_chip;
 	void (*enable_fn)(struct irq_data *d);
 	void (*disable_fn)(struct irq_data *d);
-	const char *name = dev_name(&pdev->dev);
+	const char *name = dev_name(dev);
 	int ref_irq;
 	int ret;
 	int k;
 
-	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
-		ret = -ENOMEM;
-		goto err0;
+		dev_err(dev, "failed to allocate driver data\n");
+		return -ENOMEM;
 	}
 
 	/* deal with driver instance configuration */
 	if (pdata) {
 		memcpy(&p->config, pdata, sizeof(*pdata));
 	} else {
-		of_property_read_u32(pdev->dev.of_node, "sense-bitfield-width",
+		of_property_read_u32(dev->of_node, "sense-bitfield-width",
 				     &p->config.sense_bitfield_width);
-		p->config.control_parent = of_property_read_bool(pdev->dev.of_node,
+		p->config.control_parent = of_property_read_bool(dev->of_node,
 								 "control-parent");
 	}
 	if (!p->config.sense_bitfield_width)
@@ -364,11 +382,20 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
 
+	p->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(p->clk)) {
+		dev_warn(dev, "unable to get clock\n");
+		p->clk = NULL;
+	}
+
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+
 	/* get hold of manadatory IOMEM */
 	for (k = 0; k < INTC_IRQPIN_REG_NR; k++) {
 		io[k] = platform_get_resource(pdev, IORESOURCE_MEM, k);
 		if (!io[k]) {
-			dev_err(&pdev->dev, "not enough IOMEM resources\n");
+			dev_err(dev, "not enough IOMEM resources\n");
 			ret = -EINVAL;
 			goto err0;
 		}
@@ -386,7 +413,7 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 
 	p->number_of_irqs = k;
 	if (p->number_of_irqs < 1) {
-		dev_err(&pdev->dev, "not enough IRQ resources\n");
+		dev_err(dev, "not enough IRQ resources\n");
 		ret = -EINVAL;
 		goto err0;
 	}
@@ -407,15 +434,15 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 			i->write = intc_irqpin_write32;
 			break;
 		default:
-			dev_err(&pdev->dev, "IOMEM size mismatch\n");
+			dev_err(dev, "IOMEM size mismatch\n");
 			ret = -EINVAL;
 			goto err0;
 		}
 
-		i->iomem = devm_ioremap_nocache(&pdev->dev, io[k]->start,
+		i->iomem = devm_ioremap_nocache(dev, io[k]->start,
 						resource_size(io[k]));
 		if (!i->iomem) {
-			dev_err(&pdev->dev, "failed to remap IOMEM\n");
+			dev_err(dev, "failed to remap IOMEM\n");
 			ret = -ENXIO;
 			goto err0;
 		}
@@ -454,39 +481,36 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	irq_chip->name = name;
 	irq_chip->irq_mask = disable_fn;
 	irq_chip->irq_unmask = enable_fn;
-	irq_chip->irq_enable = enable_fn;
-	irq_chip->irq_disable = disable_fn;
 	irq_chip->irq_set_type = intc_irqpin_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->irq_set_wake = intc_irqpin_irq_set_wake;
+	irq_chip->flags	= IRQCHIP_MASK_ON_SUSPEND;
 
-	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
+	p->irq_domain = irq_domain_add_simple(dev->of_node,
 					      p->number_of_irqs,
 					      p->config.irq_base,
 					      &intc_irqpin_irq_domain_ops, p);
 	if (!p->irq_domain) {
 		ret = -ENXIO;
-		dev_err(&pdev->dev, "cannot initialize irq domain\n");
+		dev_err(dev, "cannot initialize irq domain\n");
 		goto err0;
 	}
 
 	if (p->shared_irqs) {
 		/* request one shared interrupt */
-		if (devm_request_irq(&pdev->dev, p->irq[0].requested_irq,
+		if (devm_request_irq(dev, p->irq[0].requested_irq,
 				intc_irqpin_shared_irq_handler,
 				IRQF_SHARED, name, p)) {
-			dev_err(&pdev->dev, "failed to request low IRQ\n");
+			dev_err(dev, "failed to request low IRQ\n");
 			ret = -ENOENT;
 			goto err1;
 		}
 	} else {
 		/* request interrupts one by one */
 		for (k = 0; k < p->number_of_irqs; k++) {
-			if (devm_request_irq(&pdev->dev,
-					p->irq[k].requested_irq,
-					intc_irqpin_irq_handler,
-					0, name, &p->irq[k])) {
-				dev_err(&pdev->dev,
-					"failed to request low IRQ\n");
+			if (devm_request_irq(dev, p->irq[k].requested_irq,
+					     intc_irqpin_irq_handler, 0, name,
+					     &p->irq[k])) {
+				dev_err(dev, "failed to request low IRQ\n");
 				ret = -ENOENT;
 				goto err1;
 			}
@@ -497,12 +521,12 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	for (k = 0; k < p->number_of_irqs; k++)
 		intc_irqpin_mask_unmask_prio(p, k, 0);
 
-	dev_info(&pdev->dev, "driving %d irqs\n", p->number_of_irqs);
+	dev_info(dev, "driving %d irqs\n", p->number_of_irqs);
 
 	/* warn in case of mismatch if irq base is specified */
 	if (p->config.irq_base) {
 		if (p->config.irq_base != p->irq[0].domain_irq)
-			dev_warn(&pdev->dev, "irq base mismatch (%d/%d)\n",
+			dev_warn(dev, "irq base mismatch (%d/%d)\n",
 				 p->config.irq_base, p->irq[0].domain_irq);
 	}
 
@@ -511,6 +535,8 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 err1:
 	irq_domain_remove(p->irq_domain);
 err0:
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
 	return ret;
 }
 
@@ -519,7 +545,8 @@ static int intc_irqpin_remove(struct platform_device *pdev)
 	struct intc_irqpin_priv *p = platform_get_drvdata(pdev);
 
 	irq_domain_remove(p->irq_domain);
-
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
 
diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
index 78a6accd205f..c8d373fcd823 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -339,7 +339,6 @@ static inline int s3c24xx_handle_intc(struct s3c_irq_intc *intc,
 {
 	int pnd;
 	int offset;
-	int irq;
 
 	pnd = __raw_readl(intc->reg_intpnd);
 	if (!pnd)
@@ -365,8 +364,7 @@ static inline int s3c24xx_handle_intc(struct s3c_irq_intc *intc,
 	if (!(pnd & (1 << offset)))
 		offset =  __ffs(pnd);
 
-	irq = irq_find_mapping(intc->domain, intc_offset + offset);
-	handle_IRQ(irq, regs);
+	handle_domain_irq(intc->domain, intc_offset + offset, regs);
 	return true;
 }
 
diff --git a/drivers/irqchip/irq-sirfsoc.c b/drivers/irqchip/irq-sirfsoc.c
index 5e54f6d71e77..a469355df352 100644
--- a/drivers/irqchip/irq-sirfsoc.c
+++ b/drivers/irqchip/irq-sirfsoc.c
@@ -50,12 +50,10 @@ sirfsoc_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 static void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs)
 {
 	void __iomem *base = sirfsoc_irqdomain->host_data;
-	u32 irqstat, irqnr;
+	u32 irqstat;
 
 	irqstat = readl_relaxed(base + SIRFSOC_INIT_IRQ_ID);
-	irqnr = irq_find_mapping(sirfsoc_irqdomain, irqstat & 0xff);
-
-	handle_IRQ(irqnr, regs);
+	handle_domain_irq(sirfsoc_irqdomain, irqstat & 0xff, regs);
 }
 
 static int __init sirfsoc_irq_init(struct device_node *np,
diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 6fcef4a95a18..64155b686081 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -136,7 +136,7 @@ IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-a10-ic", sun4i_of_init);
 
 static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 {
-	u32 irq, hwirq;
+	u32 hwirq;
 
 	/*
 	 * hwirq == 0 can mean one of 3 things:
@@ -154,8 +154,7 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 		return;
 
 	do {
-		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
-		handle_IRQ(irq, regs);
+		handle_domain_irq(sun4i_irq_domain, hwirq, regs);
 		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
 	} while (hwirq != 0);
 }
diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
index ccf58548b161..1ab451729a5c 100644
--- a/drivers/irqchip/irq-versatile-fpga.c
+++ b/drivers/irqchip/irq-versatile-fpga.c
@@ -96,7 +96,7 @@ static int handle_one_fpga(struct fpga_irq_data *f, struct pt_regs *regs)
 
 	while ((status  = readl(f->base + IRQ_STATUS))) {
 		irq = ffs(status) - 1;
-		handle_IRQ(irq_find_mapping(f->domain, irq), regs);
+		handle_domain_irq(f->domain, irq, regs);
 		handled = 1;
 	}
 
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 7d35287f9e90..54089debf2dc 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -219,7 +219,7 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 
 	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
 		irq = ffs(stat) - 1;
-		handle_IRQ(irq_find_mapping(vic->domain, irq), regs);
+		handle_domain_irq(vic->domain, irq, regs);
 		handled = 1;
 	}
 
diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index eb6e91efdec8..b7af816f2769 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -181,7 +181,7 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 static void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
-	int irqnr, virq;
+	int irqnr;
 	void __iomem *base;
 
 	/* Loop through each active controller */
@@ -198,8 +198,7 @@ static void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 				continue;
 		}
 
-		virq = irq_find_mapping(intc[i].domain, irqnr);
-		handle_IRQ(virq, regs);
+		handle_domain_irq(intc[i].domain, irqnr, regs);
 	}
 }
 
diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
index ceb3a4318f73..e4ef74ed454a 100644
--- a/drivers/irqchip/irq-zevio.c
+++ b/drivers/irqchip/irq-zevio.c
@@ -56,8 +56,7 @@ static void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
 
 	while (readl(zevio_irq_io + IO_STATUS)) {
 		irqnr = readl(zevio_irq_io + IO_CURRENT);
-		irqnr = irq_find_mapping(zevio_irq_domain, irqnr);
-		handle_IRQ(irqnr, regs);
+		handle_domain_irq(zevio_irq_domain, irqnr, regs);
 	};
 }
 
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 45e2d8c15bd2..13eed92c7d24 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -21,7 +21,11 @@
 #define GIC_CPU_ACTIVEPRIO		0xd0
 #define GIC_CPU_IDENT			0xfc
 
+#define GICC_ENABLE			0x1
+#define GICC_INT_PRI_THRESHOLD		0xf0
 #define GICC_IAR_INT_ID_MASK		0x3ff
+#define GICC_INT_SPURIOUS		1023
+#define GICC_DIS_BYPASS_MASK		0x1e0
 
 #define GIC_DIST_CTRL			0x000
 #define GIC_DIST_CTR			0x004
@@ -39,6 +43,18 @@
 #define GIC_DIST_SGI_PENDING_CLEAR	0xf10
 #define GIC_DIST_SGI_PENDING_SET	0xf20
 
+#define GICD_ENABLE			0x1
+#define GICD_DISABLE			0x0
+#define GICD_INT_ACTLOW_LVLTRIG		0x0
+#define GICD_INT_EN_CLR_X32		0xffffffff
+#define GICD_INT_EN_SET_SGI		0x0000ffff
+#define GICD_INT_EN_CLR_PPI		0xffff0000
+#define GICD_INT_DEF_PRI		0xa0
+#define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
+					(GICD_INT_DEF_PRI << 16) |\
+					(GICD_INT_DEF_PRI << 8) |\
+					GICD_INT_DEF_PRI)
+
 #define GICH_HCR			0x0
 #define GICH_VTR			0x4
 #define GICH_VMCR			0x8
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 472c021a2d4f..ff24667cd86c 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -12,6 +12,8 @@ struct irq_affinity_notify;
 struct proc_dir_entry;
 struct module;
 struct irq_desc;
+struct irq_domain;
+struct pt_regs;
 
 /**
  * struct irq_desc - interrupt descriptor
@@ -118,6 +120,23 @@ static inline void generic_handle_irq_desc(unsigned int irq, struct irq_desc *de
 
 int generic_handle_irq(unsigned int irq);
 
+#ifdef CONFIG_HANDLE_DOMAIN_IRQ
+/*
+ * Convert a HW interrupt number to a logical one using a IRQ domain,
+ * and handle the result interrupt number. Return -EINVAL if
+ * conversion failed. Providing a NULL domain indicates that the
+ * conversion has already been done.
+ */
+int __handle_domain_irq(struct irq_domain *domain, unsigned int hwirq,
+			bool lookup, struct pt_regs *regs);
+
+static inline int handle_domain_irq(struct irq_domain *domain,
+				    unsigned int hwirq, struct pt_regs *regs)
+{
+	return __handle_domain_irq(domain, hwirq, true, regs);
+}
+#endif
+
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index d269cecdfbf0..225086b2652e 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -55,6 +55,9 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+config HANDLE_DOMAIN_IRQ
+	bool
+
 config IRQ_DOMAIN_DEBUG
 	bool "Expose hardware/virtual IRQ mapping via debugfs"
 	depends on IRQ_DOMAIN && DEBUG_FS
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 1487a123db5c..a1782f88f0af 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -14,6 +14,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/radix-tree.h>
 #include <linux/bitmap.h>
+#include <linux/irqdomain.h>
 
 #include "internals.h"
 
@@ -336,6 +337,47 @@ int generic_handle_irq(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(generic_handle_irq);
 
+#ifdef CONFIG_HANDLE_DOMAIN_IRQ
+/**
+ * __handle_domain_irq - Invoke the handler for a HW irq belonging to a domain
+ * @domain:	The domain where to perform the lookup
+ * @hwirq:	The HW irq number to convert to a logical one
+ * @lookup:	Whether to perform the domain lookup or not
+ * @regs:	Register file coming from the low-level handling code
+ *
+ * Returns:	0 on success, or -EINVAL if conversion has failed
+ */
+int __handle_domain_irq(struct irq_domain *domain, unsigned int hwirq,
+			bool lookup, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	unsigned int irq = hwirq;
+	int ret = 0;
+
+	irq_enter();
+
+#ifdef CONFIG_IRQ_DOMAIN
+	if (lookup)
+		irq = irq_find_mapping(domain, hwirq);
+#endif
+
+	/*
+	 * Some hardware gives randomly wrong interrupts.  Rather
+	 * than crashing, do something sensible.
+	 */
+	if (unlikely(!irq || irq >= nr_irqs)) {
+		ack_bad_irq(irq);
+		ret = -EINVAL;
+	} else {
+		generic_handle_irq(irq);
+	}
+
+	irq_exit();
+	set_irq_regs(old_regs);
+	return ret;
+}
+#endif
+
 /* Dynamic interrupt handling */
 
 /**
