Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaDAKHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:07:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:42731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAKHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:07:51 -0400
Date: Tue, 1 Apr 2014 12:07:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq updates for 3.15
Message-ID: <alpine.DEB.2.02.1404011132330.14882@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
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

The irq department proudly presents:

    * Another tree wide sweep of irq infrastructure abuse. Clear
      winner of the trainwreck engineering contest was:
      #include "../../../kernel/irq/settings.h"

    * Tree wide update of irq_set_affinity() callbacks which miss a
      cpu online check when picking a single cpu out of the affinity
      mask.

    * Tree wide consolidation of interrupt statistics.

    * Updates to the threaded interrupt infrastructure to allow
      explicit wakeup of the interrupt thread and a variant of
      synchronize_irq() which synchronizes only the hard interrupt
      handler. Both are needed to replace the homebrewn thread
      handling in the mmc/sdhci code.

    * New irq chip callbacks to allow proper support for GPIO based
      irqs. The GPIO based interrupts need to request/release GPIO
      resources from request/free_irq.

    * A few new ARM interrupt chips. No revolutionary new hardware,
      just differently wreckaged variations of the scheme.

    * Small improvments, cleanups and updates all over the place

Thanks,

	tglx

------------------>
Alexander Shiyan (1):
      genirq: Export symbol no_action()

Andrew Lunn (1):
      irqchip: irq-dove: Add PMU interrupt controller.

Carlo Caione (3):
      ARM: sun7i/sun6i: irqchip: Add irqchip driver for NMI controller
      ARM: sun7i/sun6i: dts: Add NMI irqchip support
      ARM: sun7i/sun6i: irqchip: Update the documentation

Chema Gonzalez (1):
      genirq: procfs: Make smp_affinity values go+r

Chuansheng Liu (1):
      genirq: Update the a comment typo

Ezequiel Garcia (2):
      irqchip: armada-370-xp: Add helper for the MSI IRQ handling
      irqchip: armada-370-xp: Setup a chained handler for the MPIC

Hans de Goede (7):
      irqchip: sun4i: Fix irq 0 not working
      irqchip: sun4i: Fix a comment about mask register initialization
      irqchip: sun4i: Don't ack IRQs > 0, fix acking of IRQ 0
      irqchip: sun4i: Use handle_fasteoi_irq for all interrupts
      irqchip: sun4i: Simplify sun4i_irq_ack
      ARM: sun7i/sun6i: dts: Fix IRQ number for sun6i NMI controller
      irqchip: sun7i/sun6i: Disable NMI before registering the handler

Jason Cooper (1):
      Revert irqchip: irq-dove: Add PMU interrupt controller

Maxime Ripard (2):
      irqchip: sunxi: Change compatibles
      ARM: sunxi: dt: Convert to the new irq controller compatibles

Michael Opdenacker (3):
      ia64: Remove deprecated IRQF_DISABLED
      mn10300: Remove deprecated IRQF_DISABLED
      x86: Remove deprecated IRQF_DISABLED

Stephen Boyd (4):
      irqchip: Silence sparse warning
      irqchip: gic: Silence sparse warnings
      irqchip: Remove asmlinkage from static functions
      irqchip: Remove unused include

Thomas Gleixner (42):
      genirq: Provide synchronize_hardirq()
      genirq: Provide irq_wake_thread()
      powerpc:eVh_pic: Kill irq_desc abuse
      powerpc: Irq: Use generic_handle_irq
      powerpc: Eeh: Kill another abuse of irq_desc
      pci: pcie-designware: Remove irq_desc abuse
      arm: Replace various irq_desc accesses
      arm: mmp: Remove pointless fiddling with irq internals
      xen: Use the proper irq functions
      xen: Get rid of the last irq_desc abuse
      genirq: Add a kstat helper to increment irq stats
      mips: Use the core irq stats function
      sparc: Use the core irq stats function
      x86: Xen: Use the core irq stats function
      mn10300: Use the core irq stats function
      s390: Cio: Use the core irq stats function
      ia64: Use the core irq stats function
      x86: Add proper vector accounting for HYPERVISOR_CALLBACK_VECTOR
      xen: Add proper irq accounting for HYPERCALL vector
      x86: Hyperv: Cleanup the irq mess
      genirq: Move kstat_incr_irqs_this_cpu() to core
      sh: Use irq_set_affinity instead of homebrewn code
      irqchip: xtensa: Select only an online cpu
      xtensa: Use irq_set_affinity instead of homebrewn code
      x86: hyperv: Make it build with CONFIG_HYPERV=m again
      x86: hyperv: Fix brown paperbag typos reported by Fenguangs build robot
      s390: Do not rely on magic indirect includes
      powerpc: eeh: Fixup the brown paperbag fallout of the "cleanup"
      m68k: Do not rely on magic indirect includes
      x86: hyperv: Fixup the (brain) damage caused by the irq cleanup
      x86: hardirq: Make irq_hv_callback_count available for CONFIG_HYPERV=m  as well
      ia64: Validate online cpus in irq_set_affinity() callbacks
      mips: Validate online cpus in irq_set_affinity() callbacks
      xen: Validate online cpus in set_affinity
      parisc: Validate online cpus in irq_set_affinity() callbacks
      genirq: Provide irq_request/release_resources chip callbacks
      genirq: Document IRQCHIP_ONESHOT_SAFE flag
      genirq: Add a new IRQCHIP_EOI_THREADED flag
      m68k: amiga: Add linux/irq.h to make it compile again
      softirq: Add linux/irq.h to make it compile again
      m68k: atari: Fix the last kernel_stat.h fallout
      arm: omap: Fix typo in ams-delta-fiq.c


 .../devicetree/bindings/arm/armada-370-xp-mpic.txt |    8 +-
 .../interrupt-controller/allwinner,sun4i-ic.txt    |    4 +-
 .../allwinner,sun67i-sc-nmi.txt                    |   27 +++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |    2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |    2 +-
 arch/arm/boot/dts/sun6i-a31.dtsi                   |    8 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |    8 +
 arch/arm/mach-imx/pm-imx6q.c                       |    7 +-
 arch/arm/mach-mmp/pm-mmp2.c                        |   16 +-
 arch/arm/mach-mmp/pm-pxa910.c                      |   20 +-
 arch/arm/mach-omap1/ams-delta-fiq.c                |    7 +-
 arch/ia64/kernel/irq_ia64.c                        |   14 +-
 arch/ia64/kernel/mca.c                             |    6 -
 arch/ia64/kernel/msi_ia64.c                        |   10 +-
 arch/ia64/kernel/perfmon.c                         |    1 -
 arch/ia64/kernel/time.c                            |    2 +-
 arch/ia64/sn/kernel/irq.c                          |    4 +-
 arch/ia64/sn/kernel/msi_sn.c                       |    2 +-
 arch/m68k/amiga/cia.c                              |    1 +
 arch/m68k/atari/ataints.c                          |    1 +
 arch/m68k/kernel/ints.c                            |    2 +-
 arch/mips/kernel/smtc.c                            |    2 +-
 arch/mips/sgi-ip22/ip22-int.c                      |    2 +-
 arch/mips/sgi-ip22/ip22-time.c                     |    2 +-
 arch/mips/sibyte/bcm1480/irq.c                     |    2 +-
 arch/mips/sibyte/bcm1480/smp.c                     |    2 +-
 arch/mips/sibyte/sb1250/irq.c                      |    2 +-
 arch/mips/sibyte/sb1250/smp.c                      |    2 +-
 arch/mn10300/kernel/cevt-mn10300.c                 |    2 +-
 arch/mn10300/kernel/mn10300-serial.c               |    6 +-
 arch/mn10300/kernel/mn10300-watchdog.c             |    2 +-
 arch/mn10300/kernel/smp.c                          |    2 +-
 arch/mn10300/unit-asb2364/irq-fpga.c               |    2 +-
 arch/parisc/kernel/irq.c                           |    2 +-
 arch/powerpc/kernel/eeh_driver.c                   |   25 ++-
 arch/powerpc/kernel/irq.c                          |    8 +-
 arch/powerpc/sysdev/ehv_pic.c                      |   10 +-
 arch/s390/kernel/irq.c                             |    1 +
 arch/sh/kernel/irq.c                               |   18 +-
 arch/sparc/kernel/time_64.c                        |    2 +-
 arch/x86/include/asm/floppy.h                      |    4 +-
 arch/x86/include/asm/hardirq.h                     |    3 +
 arch/x86/include/asm/mshyperv.h                    |    4 +-
 arch/x86/kernel/cpu/mshyperv.c                     |   78 ++++----
 arch/x86/kernel/hpet.c                             |    2 +-
 arch/x86/kernel/irq.c                              |    6 +
 arch/x86/kernel/time.c                             |    2 +-
 arch/x86/xen/spinlock.c                            |    2 +-
 arch/xtensa/kernel/irq.c                           |   22 +--
 drivers/hv/vmbus_drv.c                             |   57 +-----
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-armada-370-xp.c                |   98 ++++++---
 drivers/irqchip/irq-bcm2835.c                      |    4 +-
 drivers/irqchip/irq-gic.c                          |   11 +-
 drivers/irqchip/irq-mmp.c                          |    6 +-
 drivers/irqchip/irq-moxart.c                       |    2 +-
 drivers/irqchip/irq-orion.c                        |    2 +-
 drivers/irqchip/irq-sirfsoc.c                      |    2 +-
 drivers/irqchip/irq-sun4i.c                        |   42 ++--
 drivers/irqchip/irq-sunxi-nmi.c                    |  208 ++++++++++++++++++++
 drivers/irqchip/irq-vic.c                          |    2 +-
 drivers/irqchip/irq-vt8500.c                       |    3 +-
 drivers/irqchip/irq-xtensa-mx.c                    |    2 +-
 drivers/irqchip/irq-zevio.c                        |    2 +-
 drivers/irqchip/irqchip.c                          |    3 +-
 drivers/pci/host/pcie-designware.c                 |    4 +-
 drivers/s390/cio/cio.c                             |    6 +-
 drivers/xen/events/events_2l.c                     |   15 +-
 drivers/xen/events/events_base.c                   |   25 +--
 drivers/xen/events/events_fifo.c                   |    8 +-
 include/linux/hardirq.h                            |    1 +
 include/linux/interrupt.h                          |    1 +
 include/linux/irq.h                                |    9 +
 include/linux/kernel_stat.h                        |    8 +-
 kernel/irq/chip.c                                  |   48 ++++-
 kernel/irq/handle.c                                |    5 +-
 kernel/irq/internals.h                             |    9 +
 kernel/irq/irqdesc.c                               |    5 +
 kernel/irq/manage.c                                |  129 +++++++++---
 kernel/irq/proc.c                                  |    8 +-
 kernel/softirq.c                                   |    1 +
 82 files changed, 705 insertions(+), 393 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt
 create mode 100644 drivers/irqchip/irq-sunxi-nmi.c

diff --git a/Documentation/devicetree/bindings/arm/armada-370-xp-mpic.txt b/Documentation/devicetree/bindings/arm/armada-370-xp-mpic.txt
index d74091a..5fc0313 100644
--- a/Documentation/devicetree/bindings/arm/armada-370-xp-mpic.txt
+++ b/Documentation/devicetree/bindings/arm/armada-370-xp-mpic.txt
@@ -1,4 +1,4 @@
-Marvell Armada 370 and Armada XP Interrupt Controller
+Marvell Armada 370, 375, 38x, XP Interrupt Controller
 -----------------------------------------------------
 
 Required properties:
@@ -16,7 +16,13 @@ Required properties:
   automatically map to the interrupt controller registers of the
   current CPU)
 
+Optional properties:
 
+- interrupts: If defined, then it indicates that this MPIC is
+  connected as a slave to another interrupt controller. This is
+  typically the case on Armada 375 and Armada 38x, where the MPIC is
+  connected as a slave to the Cortex-A9 GIC. The provided interrupt
+  indicate to which GIC interrupt the MPIC output is connected.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt
index 32cec4b..b290ca1 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt
@@ -2,7 +2,7 @@ Allwinner Sunxi Interrupt Controller
 
 Required properties:
 
-- compatible : should be "allwinner,sun4i-ic"
+- compatible : should be "allwinner,sun4i-a10-ic"
 - reg : Specifies base physical address and size of the registers.
 - interrupt-controller : Identifies the node as an interrupt controller
 - #interrupt-cells : Specifies the number of cells needed to encode an
@@ -11,7 +11,7 @@ Required properties:
 Example:
 
 intc: interrupt-controller {
-	compatible = "allwinner,sun4i-ic";
+	compatible = "allwinner,sun4i-a10-ic";
 	reg = <0x01c20400 0x400>;
 	interrupt-controller;
 	#interrupt-cells = <1>;
diff --git a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt
new file mode 100644
index 0000000..d1c5cda
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt
@@ -0,0 +1,27 @@
+Allwinner Sunxi NMI Controller
+==============================
+
+Required properties:
+
+- compatible : should be "allwinner,sun7i-a20-sc-nmi" or
+  "allwinner,sun6i-a31-sc-nmi"
+- reg : Specifies base physical address and size of the registers.
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 2. The first cell is the IRQ number, the
+  second cell the trigger type as defined in interrupt.txt in this directory.
+- interrupt-parent: Specifies the parent interrupt controller.
+- interrupts: Specifies the interrupt line (NMI) which is handled by
+  the interrupt controller in the parent controller's notation. This value
+  shall be the NMI.
+
+Example:
+
+sc-nmi-intc@01c00030 {
+	compatible = "allwinner,sun7i-a20-sc-nmi";
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	reg = <0x01c00030 0x0c>;
+	interrupt-parent = <&gic>;
+	interrupts = <0 0 4>;
+};
diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index d4d2763..491ce8f 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -331,7 +331,7 @@
 		};
 
 		intc: interrupt-controller@01c20400 {
-			compatible = "allwinner,sun4i-ic";
+			compatible = "allwinner,sun4i-a10-ic";
 			reg = <0x01c20400 0x400>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 79fd412..a005a565 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -294,7 +294,7 @@
 		};
 
 		intc: interrupt-controller@01c20400 {
-			compatible = "allwinner,sun4i-ic";
+			compatible = "allwinner,sun4i-a10-ic";
 			reg = <0x01c20400 0x400>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index c463fd7..49f2f1b 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -275,7 +275,7 @@
 		ranges;
 
 		intc: interrupt-controller@01c20400 {
-			compatible = "allwinner,sun4i-ic";
+			compatible = "allwinner,sun4i-a10-ic";
 			reg = <0x01c20400 0x400>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 5256ad9..fbdf88f 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -190,6 +190,14 @@
 		#size-cells = <1>;
 		ranges;
 
+		nmi_intc: interrupt-controller@01f00c0c {
+			compatible = "allwinner,sun6i-a31-sc-nmi";
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			reg = <0x01f00c0c 0x38>;
+			interrupts = <0 32 4>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun6i-a31-pinctrl";
 			reg = <0x01c20800 0x400>;
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 6f25cf5..7637f12 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -339,6 +339,14 @@
 		#size-cells = <1>;
 		ranges;
 
+		nmi_intc: interrupt-controller@01c00030 {
+			compatible = "allwinner,sun7i-a20-sc-nmi";
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			reg = <0x01c00030 0x0c>;
+			interrupts = <0 0 4>;
+		};
+
 		emac: ethernet@01c0b000 {
 			compatible = "allwinner,sun4i-a10-emac";
 			reg = <0x01c0b000 0x1000>;
diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
index 7a9b985..29e3fe6 100644
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -120,7 +120,7 @@ static void imx6q_enable_wb(bool enable)
 
 int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 {
-	struct irq_desc *iomuxc_irq_desc;
+	struct irq_data *iomuxc_irq_data = irq_get_irq_data(32);
 	u32 val = readl_relaxed(ccm_base + CLPCR);
 
 	val &= ~BM_CLPCR_LPM;
@@ -167,10 +167,9 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 	 * 3) Software should mask IRQ #32 right after CCM Low-Power mode
 	 *    is set (set bits 0-1 of CCM_CLPCR).
 	 */
-	iomuxc_irq_desc = irq_to_desc(32);
-	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_unmask(iomuxc_irq_data);
 	writel_relaxed(val, ccm_base + CLPCR);
-	imx_gpc_irq_mask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_mask(iomuxc_irq_data);
 
 	return 0;
 }
diff --git a/arch/arm/mach-mmp/pm-mmp2.c b/arch/arm/mach-mmp/pm-mmp2.c
index 461a191..43b1a51 100644
--- a/arch/arm/mach-mmp/pm-mmp2.c
+++ b/arch/arm/mach-mmp/pm-mmp2.c
@@ -27,22 +27,8 @@
 
 int mmp2_set_wake(struct irq_data *d, unsigned int on)
 {
-	int irq = d->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long data = 0;
-
-	if (unlikely(irq >= nr_irqs)) {
-		pr_err("IRQ nubmers are out of boundary!\n");
-		return -EINVAL;
-	}
-
-	if (on) {
-		if (desc->action)
-			desc->action->flags |= IRQF_NO_SUSPEND;
-	} else {
-		if (desc->action)
-			desc->action->flags &= ~IRQF_NO_SUSPEND;
-	}
+	int irq = d->irq;
 
 	/* enable wakeup sources */
 	switch (irq) {
diff --git a/arch/arm/mach-mmp/pm-pxa910.c b/arch/arm/mach-mmp/pm-pxa910.c
index 48981ca..04c9daf 100644
--- a/arch/arm/mach-mmp/pm-pxa910.c
+++ b/arch/arm/mach-mmp/pm-pxa910.c
@@ -27,22 +27,8 @@
 
 int pxa910_set_wake(struct irq_data *data, unsigned int on)
 {
-	int irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(data->irq);
 	uint32_t awucrm = 0, apcr = 0;
-
-	if (unlikely(irq >= nr_irqs)) {
-		pr_err("IRQ nubmers are out of boundary!\n");
-		return -EINVAL;
-	}
-
-	if (on) {
-		if (desc->action)
-			desc->action->flags |= IRQF_NO_SUSPEND;
-	} else {
-		if (desc->action)
-			desc->action->flags &= ~IRQF_NO_SUSPEND;
-	}
+	int irq = data->irq;
 
 	/* setting wakeup sources */
 	switch (irq) {
@@ -115,9 +101,11 @@ int pxa910_set_wake(struct irq_data *data, unsigned int on)
 		if (irq >= IRQ_GPIO_START && irq < IRQ_BOARD_START) {
 			awucrm = MPMU_AWUCRM_WAKEUP(2);
 			apcr |= MPMU_APCR_SLPWP2;
-		} else
+		} else {
+			/* FIXME: This should return a proper error code ! */
 			printk(KERN_ERR "Error: no defined wake up source irq: %d\n",
 				irq);
+		}
 	}
 
 	if (on) {
diff --git a/arch/arm/mach-omap1/ams-delta-fiq.c b/arch/arm/mach-omap1/ams-delta-fiq.c
index f12a12a..d1f1209 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq.c
+++ b/arch/arm/mach-omap1/ams-delta-fiq.c
@@ -44,13 +44,10 @@ static unsigned int irq_counter[16];
 
 static irqreturn_t deferred_fiq(int irq, void *dev_id)
 {
-	struct irq_desc *irq_desc;
-	struct irq_chip *irq_chip = NULL;
 	int gpio, irq_num, fiq_count;
+	struct irq_chip *irq_chip;
 
-	irq_desc = irq_to_desc(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
-	if (irq_desc)
-		irq_chip = irq_desc->irq_data.chip;
+	irq_chip = irq_get_chip(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
 
 	/*
 	 * For each handled GPIO interrupt, keep calling its interrupt handler
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 1034884..0884f5e 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -364,7 +364,6 @@ static irqreturn_t smp_irq_move_cleanup_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq_move_irqaction = {
 	.handler =	smp_irq_move_cleanup_interrupt,
-	.flags =	IRQF_DISABLED,
 	.name =		"irq_move"
 };
 
@@ -489,14 +488,13 @@ ia64_handle_irq (ia64_vector vector, struct pt_regs *regs)
 	ia64_srlz_d();
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		int irq = local_vector_to_irq(vector);
-		struct irq_desc *desc = irq_to_desc(irq);
 
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else if (unlikely(IS_RESCHEDULE(vector))) {
 			scheduler_ipi();
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else {
 			ia64_setreg(_IA64_REG_CR_TPR, vector);
 			ia64_srlz_d();
@@ -549,13 +547,12 @@ void ia64_process_pending_intr(void)
 	  */
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		int irq = local_vector_to_irq(vector);
-		struct irq_desc *desc = irq_to_desc(irq);
 
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else if (unlikely(IS_RESCHEDULE(vector))) {
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 
@@ -602,7 +599,6 @@ static irqreturn_t dummy_handler (int irq, void *dev_id)
 
 static struct irqaction ipi_irqaction = {
 	.handler =	handle_IPI,
-	.flags =	IRQF_DISABLED,
 	.name =		"IPI"
 };
 
@@ -611,13 +607,11 @@ static struct irqaction ipi_irqaction = {
  */
 static struct irqaction resched_irqaction = {
 	.handler =	dummy_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"resched"
 };
 
 static struct irqaction tlb_irqaction = {
 	.handler =	dummy_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"tlb_flush"
 };
 
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index b8edfa7..33f1462 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1772,38 +1772,32 @@ __setup("disable_cpe_poll", ia64_mca_disable_cpe_polling);
 
 static struct irqaction cmci_irqaction = {
 	.handler =	ia64_mca_cmc_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"cmc_hndlr"
 };
 
 static struct irqaction cmcp_irqaction = {
 	.handler =	ia64_mca_cmc_int_caller,
-	.flags =	IRQF_DISABLED,
 	.name =		"cmc_poll"
 };
 
 static struct irqaction mca_rdzv_irqaction = {
 	.handler =	ia64_mca_rendez_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"mca_rdzv"
 };
 
 static struct irqaction mca_wkup_irqaction = {
 	.handler =	ia64_mca_wakeup_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"mca_wkup"
 };
 
 #ifdef CONFIG_ACPI
 static struct irqaction mca_cpe_irqaction = {
 	.handler =	ia64_mca_cpe_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"cpe_hndlr"
 };
 
 static struct irqaction mca_cpep_irqaction = {
 	.handler =	ia64_mca_cpe_int_caller,
-	.flags =	IRQF_DISABLED,
 	.name =		"cpe_poll"
 };
 #endif /* CONFIG_ACPI */
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index fb2f1e6..c430f91 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -17,12 +17,9 @@ static int ia64_set_msi_irq_affinity(struct irq_data *idata,
 {
 	struct msi_msg msg;
 	u32 addr, data;
-	int cpu = first_cpu(*cpu_mask);
+	int cpu = cpumask_first_and(cpu_mask, cpu_online_mask);
 	unsigned int irq = idata->irq;
 
-	if (!cpu_online(cpu))
-		return -1;
-
 	if (irq_prepare_move(irq, cpu))
 		return -1;
 
@@ -139,10 +136,7 @@ static int dmar_msi_set_affinity(struct irq_data *data,
 	unsigned int irq = data->irq;
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
-	int cpu = cpumask_first(mask);
-
-	if (!cpu_online(cpu))
-		return -1;
+	int cpu = cpumask_first_and(mask, cpu_online_mask);
 
 	if (irq_prepare_move(irq, cpu))
 		return -1;
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index cb59277..d841c4b 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -6387,7 +6387,6 @@ pfm_flush_pmds(struct task_struct *task, pfm_context_t *ctx)
 
 static struct irqaction perfmon_irqaction = {
 	.handler = pfm_interrupt_handler,
-	.flags   = IRQF_DISABLED,
 	.name    = "perfmon"
 };
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index fbaac1a..71c52bc 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -380,7 +380,7 @@ static cycle_t itc_get_cycles(struct clocksource *cs)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags =	IRQF_IRQPOLL,
 	.name =		"timer"
 };
 
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 62cf4dd..85d0951 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -209,8 +209,8 @@ static int sn_set_affinity_irq(struct irq_data *data,
 	nasid_t nasid;
 	int slice;
 
-	nasid = cpuid_to_nasid(cpumask_first(mask));
-	slice = cpuid_to_slice(cpumask_first(mask));
+	nasid = cpuid_to_nasid(cpumask_first_and(mask, cpu_online_mask));
+	slice = cpuid_to_slice(cpumask_first_and(mask, cpu_online_mask));
 
 	list_for_each_entry_safe(sn_irq_info, sn_irq_info_safe,
 				 sn_irq_lh[irq], list)
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 2b98b9e..afc58d2 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -166,7 +166,7 @@ static int sn_set_msi_irq_affinity(struct irq_data *data,
 	struct sn_pcibus_provider *provider;
 	unsigned int cpu, irq = data->irq;
 
-	cpu = cpumask_first(cpu_mask);
+	cpu = cpumask_first_and(cpu_mask, cpu_online_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
 	if (sn_irq_info == NULL || sn_irq_info->irq_int_bit >= 0)
 		return -1;
diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index 18c0e29..2081b8c 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/irq.h>
 #include <asm/amigahw.h>
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 3e73a63..3d2b63b 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
+#include <linux/irq.h>
 
 #include <asm/traps.h>
 
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 077d3a7..5b8d66f 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -10,9 +10,9 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/kernel_stat.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/irq.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index dfc1b91..c1681d6 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -1007,7 +1007,7 @@ static void __irq_entry smtc_clock_tick_interrupt(void)
 	int irq = MIPS_CPU_IRQ_BASE + 1;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	cd = &per_cpu(mips_clockevent_device, cpu);
 	cd->event_handler(cd);
 	irq_exit();
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index 3db64d5..58b40ae 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -148,7 +148,7 @@ static void __irq_entry indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 6071924..045aa89 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -123,7 +123,7 @@ void __irq_entry indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 09d6e16..59cfe26 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -95,7 +95,7 @@ static int bcm1480_set_affinity(struct irq_data *d, const struct cpumask *mask,
 	u64 cur_ints;
 	unsigned long flags;
 
-	i = cpumask_first(mask);
+	i = cpumask_first_and(mask, cpu_online_mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index 54e2c4d..70d9182 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -182,7 +182,7 @@ void bcm1480_mailbox_interrupt(void)
 	int irq = K_BCM1480_INT_MBOX_0_0;
 	unsigned int action;
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index fca0cdb..6d8dba5 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -88,7 +88,7 @@ static int sb1250_set_affinity(struct irq_data *d, const struct cpumask *mask,
 	u64 cur_ints;
 	unsigned long flags;
 
-	i = cpumask_first(mask);
+	i = cpumask_first_and(mask, cpu_online_mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index d7b942d..db97611 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -170,7 +170,7 @@ void sb1250_mailbox_interrupt(void)
 	int irq = K_INT_MBOX_0;
 	unsigned int action;
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mn10300/kernel/cevt-mn10300.c b/arch/mn10300/kernel/cevt-mn10300.c
index ccce35e..60f64ca 100644
--- a/arch/mn10300/kernel/cevt-mn10300.c
+++ b/arch/mn10300/kernel/cevt-mn10300.c
@@ -113,7 +113,7 @@ int __init init_clockevents(void)
 	cd->set_next_event	= next_event;
 
 	iact = &per_cpu(timer_irq, cpu);
-	iact->flags = IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER;
+	iact->flags = IRQF_SHARED | IRQF_TIMER;
 	iact->handler = timer_interrupt;
 
 	clockevents_register_device(cd);
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index bf6e949..7ecf698 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -985,17 +985,17 @@ static int mn10300_serial_startup(struct uart_port *_port)
 	irq_set_chip(port->tm_irq, &mn10300_serial_pic);
 
 	if (request_irq(port->rx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_NOBALANCING,
 			port->rx_name, port) < 0)
 		goto error;
 
 	if (request_irq(port->tx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_NOBALANCING,
 			port->tx_name, port) < 0)
 		goto error2;
 
 	if (request_irq(port->tm_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_NOBALANCING,
 			port->tm_name, port) < 0)
 		goto error3;
 	mn10300_serial_mask_ack(port->tm_irq);
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index db64a71..a2d8e69 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -142,7 +142,7 @@ void watchdog_interrupt(struct pt_regs *regs, enum exception_code excep)
 	NMICR = NMICR_WDIF;
 
 	nmi_count(smp_processor_id())++;
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 
 	for_each_online_cpu(cpu) {
 
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index a17f9c9..f984193 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -143,7 +143,7 @@ static struct irqaction call_function_ipi = {
 static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id);
 static struct irqaction local_timer_ipi = {
 	.handler	= smp_ipi_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags		= IRQF_NOBALANCING,
 	.name		= "smp local timer IPI"
 };
 #endif
diff --git a/arch/mn10300/unit-asb2364/irq-fpga.c b/arch/mn10300/unit-asb2364/irq-fpga.c
index e16c216..073e2cc 100644
--- a/arch/mn10300/unit-asb2364/irq-fpga.c
+++ b/arch/mn10300/unit-asb2364/irq-fpga.c
@@ -76,7 +76,7 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga",
 	},
 };
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 8ceac47..cfe056f 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(struct irq_data *d, const struct cpumask *dest)
 		return -EINVAL;
 
 	/* whatever mask they set, we just allow one CPU */
-	cpu_dest = first_cpu(*dest);
+	cpu_dest = cpumask_first_and(dest, cpu_online_mask);
 
 	return cpu_dest;
 }
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index fdc679d..bb61ca5 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -143,13 +143,30 @@ static void eeh_disable_irq(struct pci_dev *dev)
 static void eeh_enable_irq(struct pci_dev *dev)
 {
 	struct eeh_dev *edev = pci_dev_to_eeh_dev(dev);
-	struct irq_desc *desc;
 
 	if ((edev->mode) & EEH_DEV_IRQ_DISABLED) {
 		edev->mode &= ~EEH_DEV_IRQ_DISABLED;
-
-		desc = irq_to_desc(dev->irq);
-		if (desc && desc->depth > 0)
+		/*
+		 * FIXME !!!!!
+		 *
+		 * This is just ass backwards. This maze has
+		 * unbalanced irq_enable/disable calls. So instead of
+		 * finding the root cause it works around the warning
+		 * in the irq_enable code by conditionally calling
+		 * into it.
+		 *
+		 * That's just wrong.The warning in the core code is
+		 * there to tell people to fix their assymetries in
+		 * their own code, not by abusing the core information
+		 * to avoid it.
+		 *
+		 * I so wish that the assymetry would be the other way
+		 * round and a few more irq_disable calls render that
+		 * shit unusable forever.
+		 *
+		 *	tglx
+		 */
+		if (irqd_irq_disabled(irq_get_irq_data(dev->irq)))
 			enable_irq(dev->irq);
 	}
 }
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 1d0848b..ca1cd74 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -465,7 +465,6 @@ static inline void check_stack_overflow(void)
 
 void __do_irq(struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	unsigned int irq;
 
 	irq_enter();
@@ -487,11 +486,8 @@ void __do_irq(struct pt_regs *regs)
 	/* And finally process it */
 	if (unlikely(irq == NO_IRQ))
 		__get_cpu_var(irq_stat).spurious_irqs++;
-	else {
-		desc = irq_to_desc(irq);
-		if (likely(desc))
-			desc->handle_irq(irq, desc);
-	}
+	else
+		generic_handle_irq(irq);
 
 	trace_irq_exit(regs);
 
diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index b74085c..2d20f10 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -28,8 +28,6 @@
 #include <asm/ehv_pic.h>
 #include <asm/fsl_hcalls.h>
 
-#include "../../../kernel/irq/settings.h"
-
 static struct ehv_pic *global_ehv_pic;
 static DEFINE_SPINLOCK(ehv_pic_lock);
 
@@ -113,17 +111,13 @@ static unsigned int ehv_pic_type_to_vecpri(unsigned int type)
 int ehv_pic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	unsigned int src = virq_to_hw(d->irq);
-	struct irq_desc *desc = irq_to_desc(d->irq);
 	unsigned int vecpri, vold, vnew, prio, cpu_dest;
 	unsigned long flags;
 
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	irq_settings_clr_level(desc);
-	irq_settings_set_trigger_mask(desc, flow_type);
-	if (flow_type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
-		irq_settings_set_level(desc);
+	irqd_set_trigger_type(d, flow_type);
 
 	vecpri = ehv_pic_type_to_vecpri(flow_type);
 
@@ -144,7 +138,7 @@ int ehv_pic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 	ev_int_set_config(src, vecpri, prio, cpu_dest);
 
 	spin_unlock_irqrestore(&ehv_pic_lock, flags);
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 static struct irq_chip ehv_pic_irq_chip = {
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index bb27a26..a770be9 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/cputime.h>
 #include <asm/lowcore.h>
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 0833736..65a1ecd 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -217,19 +217,6 @@ void __init init_IRQ(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = irq_data_get_irq_chip(data);
-
-	printk(KERN_INFO "IRQ%u: moving from cpu%u to cpu%u\n",
-	       irq, data->node, cpu);
-
-	raw_spin_lock_irq(&desc->lock);
-	chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irq(&desc->lock);
-}
-
 /*
  * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
  * the affinity settings do not allow other CPUs, force them onto any
@@ -250,11 +237,8 @@ void migrate_irqs(void)
 						    irq, cpu);
 
 				cpumask_setall(data->affinity);
-				newcpu = cpumask_any_and(data->affinity,
-							 cpu_online_mask);
 			}
-
-			route_irq(data, irq, newcpu);
+			irq_set_affinity(irq, data->affinity);
 		}
 	}
 }
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index c3d82b5..24e8b87 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -733,7 +733,7 @@ void __irq_entry timer_interrupt(int irq, struct pt_regs *regs)
 	irq_enter();
 
 	local_cpu_data().irq0_irqs++;
-	kstat_incr_irqs_this_cpu(0, irq_to_desc(0));
+	kstat_incr_irq_this_cpu(0);
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
diff --git a/arch/x86/include/asm/floppy.h b/arch/x86/include/asm/floppy.h
index d3d7469..1c7eefe 100644
--- a/arch/x86/include/asm/floppy.h
+++ b/arch/x86/include/asm/floppy.h
@@ -145,10 +145,10 @@ static int fd_request_irq(void)
 {
 	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static unsigned long dma_mem_alloc(unsigned long size)
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index ab0ae1a..230853d 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -33,6 +33,9 @@ typedef struct {
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	unsigned int irq_threshold_count;
 #endif
+#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
+	unsigned int irq_hv_callback_count;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index cd9c419..c163215 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_MSHYPER_H
 
 #include <linux/types.h>
+#include <linux/interrupt.h>
 #include <asm/hyperv.h>
 
 struct ms_hyperv_info {
@@ -16,6 +17,7 @@ void hyperv_callback_vector(void);
 #define trace_hyperv_callback_vector hyperv_callback_vector
 #endif
 void hyperv_vector_handler(struct pt_regs *regs);
-void hv_register_vmbus_handler(int irq, irq_handler_t handler);
+void hv_setup_vmbus_irq(void (*handler)(void));
+void hv_remove_vmbus_irq(void);
 
 #endif
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 9f7ca26..b4dcca1 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/efi.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
@@ -30,6 +31,45 @@
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static void (*vmbus_handler)(void);
+
+void hyperv_vector_handler(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	exit_idle();
+
+	inc_irq_stat(irq_hv_callback_count);
+	if (vmbus_handler)
+		vmbus_handler();
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+void hv_setup_vmbus_irq(void (*handler)(void))
+{
+	vmbus_handler = handler;
+	/*
+	 * Setup the IDT for hypervisor callback. Prevent reallocation
+	 * at module reload.
+	 */
+	if (!test_bit(HYPERVISOR_CALLBACK_VECTOR, used_vectors))
+		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
+				hyperv_callback_vector);
+}
+
+void hv_remove_vmbus_irq(void)
+{
+	/* We have no way to deallocate the interrupt gate */
+	vmbus_handler = NULL;
+}
+EXPORT_SYMBOL_GPL(hv_setup_vmbus_irq);
+EXPORT_SYMBOL_GPL(hv_remove_vmbus_irq);
+#endif
+
 static uint32_t  __init ms_hyperv_platform(void)
 {
 	u32 eax;
@@ -113,41 +153,3 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.init_platform		= ms_hyperv_init_platform,
 };
 EXPORT_SYMBOL(x86_hyper_ms_hyperv);
-
-#if IS_ENABLED(CONFIG_HYPERV)
-static int vmbus_irq = -1;
-static irq_handler_t vmbus_isr;
-
-void hv_register_vmbus_handler(int irq, irq_handler_t handler)
-{
-	/*
-	 * Setup the IDT for hypervisor callback.
-	 */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
-
-	vmbus_irq = irq;
-	vmbus_isr = handler;
-}
-
-void hyperv_vector_handler(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc;
-
-	irq_enter();
-	exit_idle();
-
-	desc = irq_to_desc(vmbus_irq);
-
-	if (desc)
-		generic_handle_irq_desc(vmbus_irq, desc);
-
-	irq_exit();
-	set_irq_regs(old_regs);
-}
-#else
-void hv_register_vmbus_handler(int irq, irq_handler_t handler)
-{
-}
-#endif
-EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..45d2ded 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -521,7 +521,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_TIMER | IRQF_NOBALANCING,
 			dev->name, dev))
 		return -1;
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d99f31d..42805fa 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -125,6 +125,12 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_printf(p, "  Machine check polls\n");
 #endif
+#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
+	seq_printf(p, "%*s: ", prec, "THR");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
+	seq_printf(p, "  Hypervisor callback interrupts\n");
+#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 24d3c91..36b2cee 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -62,7 +62,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.flags = IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
 	.name = "timer"
 };
 
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 581521c..4d3acc3 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -183,7 +183,7 @@ __visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 
 	local_irq_save(flags);
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 out:
 	cpumask_clear_cpu(cpu, &waiting_cpus);
 	w->lock = NULL;
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 482868a..3eee94f 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -155,18 +155,6 @@ void __init init_IRQ(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = irq_data_get_irq_chip(data);
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	if (chip->irq_set_affinity)
-		chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 /*
  * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
  * the affinity settings do not allow other CPUs, force them onto any
@@ -175,10 +163,9 @@ static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
 void migrate_irqs(void)
 {
 	unsigned int i, cpu = smp_processor_id();
-	struct irq_desc *desc;
 
-	for_each_irq_desc(i, desc) {
-		struct irq_data *data = irq_desc_get_irq_data(desc);
+	for_each_active_irq(i) {
+		struct irq_data *data = irq_get_irq_data(i);
 		unsigned int newcpu;
 
 		if (irqd_is_per_cpu(data))
@@ -194,11 +181,8 @@ void migrate_irqs(void)
 					    i, cpu);
 
 			cpumask_setall(data->affinity);
-			newcpu = cpumask_any_and(data->affinity,
-						 cpu_online_mask);
 		}
-
-		route_irq(data, i, newcpu);
+		irq_set_affinity(i, data->affinity);
 	}
 }
 #endif /* CONFIG_HOTPLUG_CPU */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 077bb1b..3f0a952 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
 #include <linux/slab.h>
@@ -558,9 +557,6 @@ static struct bus_type  hv_bus = {
 	.dev_groups =		vmbus_groups,
 };
 
-static const char *driver_name = "hyperv";
-
-
 struct onmessage_work_context {
 	struct work_struct work;
 	struct hv_message msg;
@@ -619,7 +615,7 @@ static void vmbus_on_msg_dpc(unsigned long data)
 	}
 }
 
-static irqreturn_t vmbus_isr(int irq, void *dev_id)
+static void vmbus_isr(void)
 {
 	int cpu = smp_processor_id();
 	void *page_addr;
@@ -629,7 +625,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 
 	page_addr = hv_context.synic_event_page[cpu];
 	if (page_addr == NULL)
-		return IRQ_NONE;
+		return;
 
 	event = (union hv_synic_event_flags *)page_addr +
 					 VMBUS_MESSAGE_SINT;
@@ -665,28 +661,8 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be processed */
-	if (msg->header.message_type != HVMSG_NONE) {
-		handled = true;
+	if (msg->header.message_type != HVMSG_NONE)
 		tasklet_schedule(&msg_dpc);
-	}
-
-	if (handled)
-		return IRQ_HANDLED;
-	else
-		return IRQ_NONE;
-}
-
-/*
- * vmbus interrupt flow handler:
- * vmbus interrupts can concurrently occur on multiple CPUs and
- * can be handled concurrently.
- */
-
-static void vmbus_flow_handler(unsigned int irq, struct irq_desc *desc)
-{
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	desc->action->handler(irq, desc->action->dev_id);
 }
 
 /*
@@ -715,25 +691,7 @@ static int vmbus_bus_init(int irq)
 	if (ret)
 		goto err_cleanup;
 
-	ret = request_irq(irq, vmbus_isr, 0, driver_name, hv_acpi_dev);
-
-	if (ret != 0) {
-		pr_err("Unable to request IRQ %d\n",
-			   irq);
-		goto err_unregister;
-	}
-
-	/*
-	 * Vmbus interrupts can be handled concurrently on
-	 * different CPUs. Establish an appropriate interrupt flow
-	 * handler that can support this model.
-	 */
-	irq_set_handler(irq, vmbus_flow_handler);
-
-	/*
-	 * Register our interrupt handler.
-	 */
-	hv_register_vmbus_handler(irq, vmbus_isr);
+	hv_setup_vmbus_irq(vmbus_isr);
 
 	ret = hv_synic_alloc();
 	if (ret)
@@ -753,9 +711,8 @@ static int vmbus_bus_init(int irq)
 
 err_alloc:
 	hv_synic_free();
-	free_irq(irq, hv_acpi_dev);
+	hv_remove_vmbus_irq();
 
-err_unregister:
 	bus_unregister(&hv_bus);
 
 err_cleanup:
@@ -947,7 +904,6 @@ static int __init hv_acpi_init(void)
 	/*
 	 * Get irq resources first.
 	 */
-
 	ret = acpi_bus_register_driver(&vmbus_acpi_driver);
 
 	if (ret)
@@ -978,8 +934,7 @@ cleanup:
 
 static void __exit vmbus_exit(void)
 {
-
-	free_irq(irq, hv_acpi_dev);
+	hv_remove_vmbus_irq();
 	vmbus_free_channels();
 	bus_unregister(&hv_bus);
 	hv_cleanup();
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 5194afb..1c0c151 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
 obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
+obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 5409564..41be897 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -42,6 +43,7 @@
 #define ARMADA_370_XP_INT_SOURCE_CTL(irq)	(0x100 + irq*4)
 
 #define ARMADA_370_XP_CPU_INTACK_OFFS		(0x44)
+#define ARMADA_375_PPI_CAUSE			(0x10)
 
 #define ARMADA_370_XP_SW_TRIG_INT_OFFS           (0x4)
 #define ARMADA_370_XP_IN_DRBEL_MSK_OFFS          (0xc)
@@ -352,7 +354,63 @@ static struct irq_domain_ops armada_370_xp_mpic_irq_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static asmlinkage void __exception_irq_entry
+#ifdef CONFIG_PCI_MSI
+static void armada_370_xp_handle_msi_irq(struct pt_regs *regs, bool is_chained)
+{
+	u32 msimask, msinr;
+
+	msimask = readl_relaxed(per_cpu_int_base +
+				ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
+		& PCI_MSI_DOORBELL_MASK;
+
+	writel(~msimask, per_cpu_int_base +
+	       ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
+
+	for (msinr = PCI_MSI_DOORBELL_START;
+	     msinr < PCI_MSI_DOORBELL_END; msinr++) {
+		int irq;
+
+		if (!(msimask & BIT(msinr)))
+			continue;
+
+		irq = irq_find_mapping(armada_370_xp_msi_domain,
+				       msinr - 16);
+
+		if (is_chained)
+			generic_handle_irq(irq);
+		else
+			handle_IRQ(irq, regs);
+	}
+}
+#else
+static void armada_370_xp_handle_msi_irq(struct pt_regs *r, bool b) {}
+#endif
+
+static void armada_370_xp_mpic_handle_cascade_irq(unsigned int irq,
+						  struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_get_chip(irq);
+	unsigned long irqmap, irqn;
+	unsigned int cascade_irq;
+
+	chained_irq_enter(chip, desc);
+
+	irqmap = readl_relaxed(per_cpu_int_base + ARMADA_375_PPI_CAUSE);
+
+	if (irqmap & BIT(0)) {
+		armada_370_xp_handle_msi_irq(NULL, true);
+		irqmap &= ~BIT(0);
+	}
+
+	for_each_set_bit(irqn, &irqmap, BITS_PER_LONG) {
+		cascade_irq = irq_find_mapping(armada_370_xp_mpic_domain, irqn);
+		generic_handle_irq(cascade_irq);
+	}
+
+	chained_irq_exit(chip, desc);
+}
+
+static void __exception_irq_entry
 armada_370_xp_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
@@ -372,31 +430,9 @@ armada_370_xp_handle_irq(struct pt_regs *regs)
 			continue;
 		}
 
-#ifdef CONFIG_PCI_MSI
 		/* MSI handling */
-		if (irqnr == 1) {
-			u32 msimask, msinr;
-
-			msimask = readl_relaxed(per_cpu_int_base +
-						ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
-				& PCI_MSI_DOORBELL_MASK;
-
-			writel(~msimask, per_cpu_int_base +
-			       ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
-
-			for (msinr = PCI_MSI_DOORBELL_START;
-			     msinr < PCI_MSI_DOORBELL_END; msinr++) {
-				int irq;
-
-				if (!(msimask & BIT(msinr)))
-					continue;
-
-				irq = irq_find_mapping(armada_370_xp_msi_domain,
-						       msinr - 16);
-				handle_IRQ(irq, regs);
-			}
-		}
-#endif
+		if (irqnr == 1)
+			armada_370_xp_handle_msi_irq(regs, false);
 
 #ifdef CONFIG_SMP
 		/* IPI Handling */
@@ -427,6 +463,7 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 					     struct device_node *parent)
 {
 	struct resource main_int_res, per_cpu_int_res;
+	int parent_irq;
 	u32 control;
 
 	BUG_ON(of_address_to_resource(node, 0, &main_int_res));
@@ -455,8 +492,6 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 
 	BUG_ON(!armada_370_xp_mpic_domain);
 
-	irq_set_default_host(armada_370_xp_mpic_domain);
-
 #ifdef CONFIG_SMP
 	armada_xp_mpic_smp_cpu_init();
 
@@ -472,7 +507,14 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 
 	armada_370_xp_msi_init(node, main_int_res.start);
 
-	set_handle_irq(armada_370_xp_handle_irq);
+	parent_irq = irq_of_parse_and_map(node, 0);
+	if (parent_irq <= 0) {
+		irq_set_default_host(armada_370_xp_mpic_domain);
+		set_handle_irq(armada_370_xp_handle_irq);
+	} else {
+		irq_set_chained_handler(parent_irq,
+					armada_370_xp_mpic_handle_cascade_irq);
+	}
 
 	return 0;
 }
diff --git a/drivers/irqchip/irq-bcm2835.c b/drivers/irqchip/irq-bcm2835.c
index 1693b8e..5916d6c 100644
--- a/drivers/irqchip/irq-bcm2835.c
+++ b/drivers/irqchip/irq-bcm2835.c
@@ -95,7 +95,7 @@ struct armctrl_ic {
 };
 
 static struct armctrl_ic intc __read_mostly;
-static asmlinkage void __exception_irq_entry bcm2835_handle_irq(
+static void __exception_irq_entry bcm2835_handle_irq(
 	struct pt_regs *regs);
 
 static void armctrl_mask_irq(struct irq_data *d)
@@ -196,7 +196,7 @@ static void armctrl_handle_shortcut(int bank, struct pt_regs *regs,
 	handle_IRQ(irq_linear_revmap(intc.domain, irq), regs);
 }
 
-static asmlinkage void __exception_irq_entry bcm2835_handle_irq(
+static void __exception_irq_entry bcm2835_handle_irq(
 	struct pt_regs *regs)
 {
 	u32 stat, irq;
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 341c601..531769b 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -50,7 +50,7 @@
 
 union gic_base {
 	void __iomem *common_base;
-	void __percpu __iomem **percpu_base;
+	void __percpu * __iomem *percpu_base;
 };
 
 struct gic_chip_data {
@@ -279,7 +279,7 @@ static int gic_set_wake(struct irq_data *d, unsigned int on)
 #define gic_set_wake	NULL
 #endif
 
-static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
 	struct gic_chip_data *gic = &gic_data[0];
@@ -648,7 +648,7 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 #endif
 
 #ifdef CONFIG_SMP
-void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
+static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
 	int cpu;
 	unsigned long flags, map = 0;
@@ -869,7 +869,7 @@ static struct notifier_block gic_cpu_notifier = {
 };
 #endif
 
-const struct irq_domain_ops gic_irq_domain_ops = {
+static const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
 };
@@ -974,7 +974,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
 
-int __init gic_of_init(struct device_node *node, struct device_node *parent)
+static int __init
+gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 2cb7cd0..3c8827f 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -194,8 +194,7 @@ static struct mmp_intc_conf mmp2_conf = {
 	.conf_mask	= 0x7f,
 };
 
-static asmlinkage void __exception_irq_entry
-mmp_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry mmp_handle_irq(struct pt_regs *regs)
 {
 	int irq, hwirq;
 
@@ -207,8 +206,7 @@ mmp_handle_irq(struct pt_regs *regs)
 	handle_IRQ(irq, regs);
 }
 
-static asmlinkage void __exception_irq_entry
-mmp2_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry mmp2_handle_irq(struct pt_regs *regs)
 {
 	int irq, hwirq;
 
diff --git a/drivers/irqchip/irq-moxart.c b/drivers/irqchip/irq-moxart.c
index 5552fc2..00b3cc9 100644
--- a/drivers/irqchip/irq-moxart.c
+++ b/drivers/irqchip/irq-moxart.c
@@ -44,7 +44,7 @@ struct moxart_irq_data {
 
 static struct moxart_irq_data intc;
 
-static asmlinkage void __exception_irq_entry handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat;
 	int hwirq;
diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 8e41be6..e25f246 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -30,7 +30,7 @@
 
 static struct irq_domain *orion_irq_domain;
 
-static asmlinkage void
+static void
 __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
 {
 	struct irq_domain_chip_generic *dgc = orion_irq_domain->gc;
diff --git a/drivers/irqchip/irq-sirfsoc.c b/drivers/irqchip/irq-sirfsoc.c
index 3a070c5..581eefe 100644
--- a/drivers/irqchip/irq-sirfsoc.c
+++ b/drivers/irqchip/irq-sirfsoc.c
@@ -47,7 +47,7 @@ sirfsoc_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 	ct->regs.mask = SIRFSOC_INT_RISC_MASK0;
 }
 
-static asmlinkage void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs)
 {
 	void __iomem *base = sirfsoc_irqdomain->host_data;
 	u32 irqstat, irqnr;
diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index a5438d8..6fcef4a 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -36,18 +36,16 @@
 static void __iomem *sun4i_irq_base;
 static struct irq_domain *sun4i_irq_domain;
 
-static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
+static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
 static void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
 
-	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-	writel(val | (1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
+	if (irq != 0)
+		return; /* Only IRQ 0 / the ENMI needs to be acked */
+
+	writel(BIT(0), sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
 }
 
 static void sun4i_irq_mask(struct irq_data *irqd)
@@ -76,16 +74,16 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
 
 static struct irq_chip sun4i_irq_chip = {
 	.name		= "sun4i_irq",
-	.irq_ack	= sun4i_irq_ack,
+	.irq_eoi	= sun4i_irq_ack,
 	.irq_mask	= sun4i_irq_mask,
 	.irq_unmask	= sun4i_irq_unmask,
+	.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED,
 };
 
 static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
-				 handle_level_irq);
+	irq_set_chip_and_handler(virq, &sun4i_irq_chip, handle_fasteoi_irq);
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
@@ -109,7 +107,7 @@ static int __init sun4i_of_init(struct device_node *node,
 	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(2));
 
-	/* Mask all the interrupts */
+	/* Unmask all the interrupts, ENABLE_REG(x) is used for masking */
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(0));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
@@ -134,16 +132,30 @@ static int __init sun4i_of_init(struct device_node *node,
 
 	return 0;
 }
-IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-ic", sun4i_of_init);
+IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-a10-ic", sun4i_of_init);
 
-static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 {
 	u32 irq, hwirq;
 
+	/*
+	 * hwirq == 0 can mean one of 3 things:
+	 * 1) no more irqs pending
+	 * 2) irq 0 pending
+	 * 3) spurious irq
+	 * So if we immediately get a reading of 0, check the irq-pending reg
+	 * to differentiate between 2 and 3. We only do this once to avoid
+	 * the extra check in the common case of 1 hapening after having
+	 * read the vector-reg once.
+	 */
 	hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
-	while (hwirq != 0) {
+	if (hwirq == 0 &&
+		  !(readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0)) & BIT(0)))
+		return;
+
+	do {
 		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
 		handle_IRQ(irq, regs);
 		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
-	}
+	} while (hwirq != 0);
 }
diff --git a/drivers/irqchip/irq-sunxi-nmi.c b/drivers/irqchip/irq-sunxi-nmi.c
new file mode 100644
index 0000000..12f547a
--- /dev/null
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -0,0 +1,208 @@
+/*
+ * Allwinner A20/A31 SoCs NMI IRQ chip driver.
+ *
+ * Carlo Caione <carlo.caione@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/irqchip/chained_irq.h>
+#include "irqchip.h"
+
+#define SUNXI_NMI_SRC_TYPE_MASK	0x00000003
+
+enum {
+	SUNXI_SRC_TYPE_LEVEL_LOW = 0,
+	SUNXI_SRC_TYPE_EDGE_FALLING,
+	SUNXI_SRC_TYPE_LEVEL_HIGH,
+	SUNXI_SRC_TYPE_EDGE_RISING,
+};
+
+struct sunxi_sc_nmi_reg_offs {
+	u32 ctrl;
+	u32 pend;
+	u32 enable;
+};
+
+static struct sunxi_sc_nmi_reg_offs sun7i_reg_offs = {
+	.ctrl	= 0x00,
+	.pend	= 0x04,
+	.enable	= 0x08,
+};
+
+static struct sunxi_sc_nmi_reg_offs sun6i_reg_offs = {
+	.ctrl	= 0x00,
+	.pend	= 0x04,
+	.enable	= 0x34,
+};
+
+static inline void sunxi_sc_nmi_write(struct irq_chip_generic *gc, u32 off,
+				      u32 val)
+{
+	irq_reg_writel(val, gc->reg_base + off);
+}
+
+static inline u32 sunxi_sc_nmi_read(struct irq_chip_generic *gc, u32 off)
+{
+	return irq_reg_readl(gc->reg_base + off);
+}
+
+static void sunxi_sc_nmi_handle_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_domain *domain = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_get_chip(irq);
+	unsigned int virq = irq_find_mapping(domain, 0);
+
+	chained_irq_enter(chip, desc);
+	generic_handle_irq(virq);
+	chained_irq_exit(chip, desc);
+}
+
+static int sunxi_sc_nmi_set_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	struct irq_chip_type *ct = gc->chip_types;
+	u32 src_type_reg;
+	u32 ctrl_off = ct->regs.type;
+	unsigned int src_type;
+	unsigned int i;
+
+	irq_gc_lock(gc);
+
+	switch (flow_type & IRQF_TRIGGER_MASK) {
+	case IRQ_TYPE_EDGE_FALLING:
+		src_type = SUNXI_SRC_TYPE_EDGE_FALLING;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		src_type = SUNXI_SRC_TYPE_EDGE_RISING;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		src_type = SUNXI_SRC_TYPE_LEVEL_HIGH;
+		break;
+	case IRQ_TYPE_NONE:
+	case IRQ_TYPE_LEVEL_LOW:
+		src_type = SUNXI_SRC_TYPE_LEVEL_LOW;
+		break;
+	default:
+		irq_gc_unlock(gc);
+		pr_err("%s: Cannot assign multiple trigger modes to IRQ %d.\n",
+			__func__, data->irq);
+		return -EBADR;
+	}
+
+	irqd_set_trigger_type(data, flow_type);
+	irq_setup_alt_chip(data, flow_type);
+
+	for (i = 0; i <= gc->num_ct; i++, ct++)
+		if (ct->type & flow_type)
+			ctrl_off = ct->regs.type;
+
+	src_type_reg = sunxi_sc_nmi_read(gc, ctrl_off);
+	src_type_reg &= ~SUNXI_NMI_SRC_TYPE_MASK;
+	src_type_reg |= src_type;
+	sunxi_sc_nmi_write(gc, ctrl_off, src_type_reg);
+
+	irq_gc_unlock(gc);
+
+	return IRQ_SET_MASK_OK;
+}
+
+static int __init sunxi_sc_nmi_irq_init(struct device_node *node,
+					struct sunxi_sc_nmi_reg_offs *reg_offs)
+{
+	struct irq_domain *domain;
+	struct irq_chip_generic *gc;
+	unsigned int irq;
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	int ret;
+
+
+	domain = irq_domain_add_linear(node, 1, &irq_generic_chip_ops, NULL);
+	if (!domain) {
+		pr_err("%s: Could not register interrupt domain.\n", node->name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, 1, 2, node->name,
+					     handle_fasteoi_irq, clr, 0,
+					     IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		 pr_err("%s: Could not allocate generic interrupt chip.\n",
+			 node->name);
+		 goto fail_irqd_remove;
+	}
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0) {
+		pr_err("%s: unable to parse irq\n", node->name);
+		ret = -EINVAL;
+		goto fail_irqd_remove;
+	}
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+	gc->reg_base = of_iomap(node, 0);
+	if (!gc->reg_base) {
+		pr_err("%s: unable to map resource\n", node->name);
+		ret = -ENOMEM;
+		goto fail_irqd_remove;
+	}
+
+	gc->chip_types[0].type			= IRQ_TYPE_LEVEL_MASK;
+	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_eoi		= irq_gc_ack_set_bit;
+	gc->chip_types[0].chip.irq_set_type	= sunxi_sc_nmi_set_type;
+	gc->chip_types[0].chip.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED;
+	gc->chip_types[0].regs.ack		= reg_offs->pend;
+	gc->chip_types[0].regs.mask		= reg_offs->enable;
+	gc->chip_types[0].regs.type		= reg_offs->ctrl;
+
+	gc->chip_types[1].type			= IRQ_TYPE_EDGE_BOTH;
+	gc->chip_types[1].chip.name		= gc->chip_types[0].chip.name;
+	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_set_bit;
+	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit;
+	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit;
+	gc->chip_types[1].chip.irq_set_type	= sunxi_sc_nmi_set_type;
+	gc->chip_types[1].regs.ack		= reg_offs->pend;
+	gc->chip_types[1].regs.mask		= reg_offs->enable;
+	gc->chip_types[1].regs.type		= reg_offs->ctrl;
+	gc->chip_types[1].handler		= handle_edge_irq;
+
+	sunxi_sc_nmi_write(gc, reg_offs->enable, 0);
+	sunxi_sc_nmi_write(gc, reg_offs->pend, 0x1);
+
+	irq_set_handler_data(irq, domain);
+	irq_set_chained_handler(irq, sunxi_sc_nmi_handle_irq);
+
+	return 0;
+
+fail_irqd_remove:
+	irq_domain_remove(domain);
+
+	return ret;
+}
+
+static int __init sun6i_sc_nmi_irq_init(struct device_node *node,
+					struct device_node *parent)
+{
+	return sunxi_sc_nmi_irq_init(node, &sun6i_reg_offs);
+}
+IRQCHIP_DECLARE(sun6i_sc_nmi, "allwinner,sun6i-a31-sc-nmi", sun6i_sc_nmi_irq_init);
+
+static int __init sun7i_sc_nmi_irq_init(struct device_node *node,
+					struct device_node *parent)
+{
+	return sunxi_sc_nmi_irq_init(node, &sun7i_reg_offs);
+}
+IRQCHIP_DECLARE(sun7i_sc_nmi, "allwinner,sun7i-a20-sc-nmi", sun7i_sc_nmi_irq_init);
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 8e21ae0..473f09a 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -228,7 +228,7 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
  * Keep iterating over all registered VIC's until there are no pending
  * interrupts.
  */
-static asmlinkage void __exception_irq_entry vic_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry vic_handle_irq(struct pt_regs *regs)
 {
 	int i, handled;
 
diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index 1846e7d..eb6e91e 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -178,8 +178,7 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static asmlinkage
-void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
 	int irqnr, virq;
diff --git a/drivers/irqchip/irq-xtensa-mx.c b/drivers/irqchip/irq-xtensa-mx.c
index f693f1b..e1c2f96 100644
--- a/drivers/irqchip/irq-xtensa-mx.c
+++ b/drivers/irqchip/irq-xtensa-mx.c
@@ -122,7 +122,7 @@ static int xtensa_mx_irq_retrigger(struct irq_data *d)
 static int xtensa_mx_irq_set_affinity(struct irq_data *d,
 		const struct cpumask *dest, bool force)
 {
-	unsigned mask = 1u << cpumask_any(dest);
+	unsigned mask = 1u << cpumask_any_and(dest, cpu_online_mask);
 
 	set_er(mask, MIROUT(d->hwirq - HW_IRQ_MX_BASE));
 	return 0;
diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
index 8ed04c4..ceb3a43 100644
--- a/drivers/irqchip/irq-zevio.c
+++ b/drivers/irqchip/irq-zevio.c
@@ -50,7 +50,7 @@ static void zevio_irq_ack(struct irq_data *irqd)
 	readl(gc->reg_base + regs->ack);
 }
 
-static asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
 {
 	int irqnr;
 
diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index f496afc..cad3e24 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -10,8 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/of_irq.h>
-
-#include "irqchip.h"
+#include <linux/irqchip.h>
 
 /*
  * This special of_device_id is the sentinel at the end of the
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 17ce88f..2e48ecf 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -294,14 +294,12 @@ no_valid_irq:
 static void clear_irq(unsigned int irq)
 {
 	unsigned int pos, nvec;
-	struct irq_desc *desc;
 	struct msi_desc *msi;
 	struct pcie_port *pp;
 	struct irq_data *data = irq_get_irq_data(irq);
 
 	/* get the port structure */
-	desc = irq_to_desc(irq);
-	msi = irq_desc_get_msi_desc(desc);
+	msi = irq_data_get_msi(data);
 	pp = sys_to_pcie(msi->dev->bus->sysdata);
 	if (!pp) {
 		BUG();
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 8ee88c4..5829ddc 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -18,6 +18,7 @@
 #include <linux/device.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/cio.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
@@ -584,8 +585,6 @@ static irqreturn_t do_cio_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-static struct irq_desc *irq_desc_io;
-
 static struct irqaction io_interrupt = {
 	.name	 = "IO",
 	.handler = do_cio_interrupt,
@@ -596,7 +595,6 @@ void __init init_cio_interrupts(void)
 	irq_set_chip_and_handler(IO_INTERRUPT,
 				 &dummy_irq_chip, handle_percpu_irq);
 	setup_irq(IO_INTERRUPT, &io_interrupt);
-	irq_desc_io = irq_to_desc(IO_INTERRUPT);
 }
 
 #ifdef CONFIG_CCW_CONSOLE
@@ -623,7 +621,7 @@ void cio_tsch(struct subchannel *sch)
 		local_bh_disable();
 		irq_enter();
 	}
-	kstat_incr_irqs_this_cpu(IO_INTERRUPT, irq_desc_io);
+	kstat_incr_irq_this_cpu(IO_INTERRUPT);
 	if (sch->driver && sch->driver->irq)
 		sch->driver->irq(sch);
 	else
diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index d7ff917..5db43fc 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -166,7 +166,6 @@ static void evtchn_2l_handle_events(unsigned cpu)
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
 	int i;
-	struct irq_desc *desc;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 
@@ -176,11 +175,8 @@ static void evtchn_2l_handle_events(unsigned cpu)
 		unsigned int evtchn = evtchn_from_irq(irq);
 		word_idx = evtchn / BITS_PER_LONG;
 		bit_idx = evtchn % BITS_PER_LONG;
-		if (active_evtchns(cpu, s, word_idx) & (1ULL << bit_idx)) {
-			desc = irq_to_desc(irq);
-			if (desc)
-				generic_handle_irq_desc(irq, desc);
-		}
+		if (active_evtchns(cpu, s, word_idx) & (1ULL << bit_idx))
+			generic_handle_irq(irq);
 	}
 
 	/*
@@ -245,11 +241,8 @@ static void evtchn_2l_handle_events(unsigned cpu)
 			port = (word_idx * BITS_PER_EVTCHN_WORD) + bit_idx;
 			irq = get_evtchn_to_irq(port);
 
-			if (irq != -1) {
-				desc = irq_to_desc(irq);
-				if (desc)
-					generic_handle_irq_desc(irq, desc);
-			}
+			if (irq != -1)
+				generic_handle_irq(irq);
 
 			bit_idx = (bit_idx + 1) % BITS_PER_EVTCHN_WORD;
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index f4a9e33..c3458f5 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -336,9 +336,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	cpumask_copy(irq_to_desc(irq)->irq_data.affinity, cpumask_of(cpu));
+	cpumask_copy(irq_get_irq_data(irq)->affinity, cpumask_of(cpu));
 #endif
-
 	xen_evtchn_port_bind_to_cpu(info, cpu);
 
 	info->cpu = cpu;
@@ -373,10 +372,8 @@ static void xen_irq_init(unsigned irq)
 {
 	struct irq_info *info;
 #ifdef CONFIG_SMP
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	/* By default all event channels notify CPU#0. */
-	cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
+	cpumask_copy(irq_get_irq_data(irq)->affinity, cpumask_of(0));
 #endif
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -490,13 +487,6 @@ static void pirq_query_unmask(int irq)
 		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
 }
 
-static bool probing_irq(int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	return desc && desc->action == NULL;
-}
-
 static void eoi_pirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
@@ -538,8 +528,7 @@ static unsigned int __startup_pirq(unsigned int irq)
 					BIND_PIRQ__WILL_SHARE : 0;
 	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
 	if (rc != 0) {
-		if (!probing_irq(irq))
-			pr_info("Failed to obtain physical IRQ %d\n", irq);
+		pr_warn("Failed to obtain physical IRQ %d\n", irq);
 		return 0;
 	}
 	evtchn = bind_pirq.port;
@@ -772,17 +761,12 @@ error_irq:
 
 int xen_destroy_irq(int irq)
 {
-	struct irq_desc *desc;
 	struct physdev_unmap_pirq unmap_irq;
 	struct irq_info *info = info_for_irq(irq);
 	int rc = -ENOENT;
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	desc = irq_to_desc(irq);
-	if (!desc)
-		goto out;
-
 	if (xen_initial_domain()) {
 		unmap_irq.pirq = info->u.pirq.pirq;
 		unmap_irq.domid = info->u.pirq.domid;
@@ -1251,6 +1235,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 #ifdef CONFIG_X86
 	exit_idle();
 #endif
+	inc_irq_stat(irq_hv_callback_count);
 
 	__xen_evtchn_do_upcall();
 
@@ -1339,7 +1324,7 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
 			    bool force)
 {
-	unsigned tcpu = cpumask_first(dest);
+	unsigned tcpu = cpumask_first_and(dest, cpu_online_mask);
 
 	return rebind_irq_to_cpu(data->irq, tcpu);
 }
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 1de2a19..96109a9 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -235,14 +235,10 @@ static uint32_t clear_linked(volatile event_word_t *word)
 static void handle_irq_for_port(unsigned port)
 {
 	int irq;
-	struct irq_desc *desc;
 
 	irq = get_evtchn_to_irq(port);
-	if (irq != -1) {
-		desc = irq_to_desc(irq);
-		if (desc)
-			generic_handle_irq_desc(irq, desc);
-	}
+	if (irq != -1)
+		generic_handle_irq(irq);
 }
 
 static void consume_one_event(unsigned cpu,
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 12d5f97..cba442e 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -9,6 +9,7 @@
 
 
 extern void synchronize_irq(unsigned int irq);
+extern void synchronize_hardirq(unsigned int irq);
 
 #if defined(CONFIG_TINY_RCU)
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a2678d3..c7bfac1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -188,6 +188,7 @@ extern void disable_irq(unsigned int irq);
 extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 extern void enable_percpu_irq(unsigned int irq, unsigned int type);
+extern void irq_wake_thread(unsigned int irq, void *dev_id);
 
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..d278838 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -303,6 +303,10 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_pm_shutdown:	function called from core code on shutdown once per chip
  * @irq_calc_mask:	Optional function to set irq_data.mask for special cases
  * @irq_print_chip:	optional to print special chip info in show_interrupts
+ * @irq_request_resources:	optional to request resources before calling
+ *				any other callback related to this irq
+ * @irq_release_resources:	optional to release resources acquired with
+ *				irq_request_resources
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -336,6 +340,8 @@ struct irq_chip {
 	void		(*irq_calc_mask)(struct irq_data *data);
 
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
+	int		(*irq_request_resources)(struct irq_data *data);
+	void		(*irq_release_resources)(struct irq_data *data);
 
 	unsigned long	flags;
 };
@@ -349,6 +355,8 @@ struct irq_chip {
  * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
  *				when irq enabled
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
+ * IRQCHIP_ONESHOT_SAFE:	One shot does not require mask/unmask
+ * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -357,6 +365,7 @@ enum {
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
+	IRQCHIP_EOI_THREADED		= (1 <<  6),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 51c72be..c3fbda7 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -51,14 +51,8 @@ DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 extern unsigned long long nr_context_switches(void);
 
-#include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
-
-#define kstat_incr_irqs_this_cpu(irqno, DESC)		\
-do {							\
-	__this_cpu_inc(*(DESC)->kstat_irqs);		\
-	__this_cpu_inc(kstat.irqs_sum);			\
-} while (0)
+extern void kstat_incr_irq_this_cpu(unsigned int irq);
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..6397df2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -281,6 +281,19 @@ void unmask_irq(struct irq_desc *desc)
 	}
 }
 
+void unmask_threaded_irq(struct irq_desc *desc)
+{
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	if (chip->flags & IRQCHIP_EOI_THREADED)
+		chip->irq_eoi(&desc->irq_data);
+
+	if (chip->irq_unmask) {
+		chip->irq_unmask(&desc->irq_data);
+		irq_state_clr_masked(desc);
+	}
+}
+
 /*
  *	handle_nested_irq - Handle a nested irq from a irq thread
  *	@irq:	the interrupt number
@@ -435,6 +448,27 @@ static inline void preflow_handler(struct irq_desc *desc)
 static inline void preflow_handler(struct irq_desc *desc) { }
 #endif
 
+static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
+{
+	if (!(desc->istate & IRQS_ONESHOT)) {
+		chip->irq_eoi(&desc->irq_data);
+		return;
+	}
+	/*
+	 * We need to unmask in the following cases:
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
+		chip->irq_eoi(&desc->irq_data);
+		unmask_irq(desc);
+	} else if (!(chip->flags & IRQCHIP_EOI_THREADED)) {
+		chip->irq_eoi(&desc->irq_data);
+	}
+}
+
 /**
  *	handle_fasteoi_irq - irq handler for transparent controllers
  *	@irq:	the interrupt number
@@ -448,6 +482,8 @@ static inline void preflow_handler(struct irq_desc *desc) { }
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = desc->irq_data.chip;
+
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
@@ -473,18 +509,14 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	preflow_handler(desc);
 	handle_irq_event(desc);
 
-	if (desc->istate & IRQS_ONESHOT)
-		cond_unmask_irq(desc);
+	cond_unmask_eoi_irq(desc, chip);
 
-out_eoi:
-	desc->irq_data.chip->irq_eoi(&desc->irq_data);
-out_unlock:
 	raw_spin_unlock(&desc->lock);
 	return;
 out:
-	if (!(desc->irq_data.chip->flags & IRQCHIP_EOI_IF_HANDLED))
-		goto out_eoi;
-	goto out_unlock;
+	if (!(chip->flags & IRQCHIP_EOI_IF_HANDLED))
+		chip->irq_eoi(&desc->irq_data);
+	raw_spin_unlock(&desc->lock);
 }
 
 /**
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..6354802 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -41,6 +41,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
 {
 	return IRQ_NONE;
 }
+EXPORT_SYMBOL_GPL(no_action);
 
 static void warn_no_thread(unsigned int irq, struct irqaction *action)
 {
@@ -51,7 +52,7 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 	       "but no thread function available.", irq, action->name);
 }
 
-static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
 	 * In case the thread crashed and was killed we just pretend that
@@ -157,7 +158,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 				break;
 			}
 
-			irq_wake_thread(desc, action);
+			__irq_wake_thread(desc, action);
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..ddf1ffe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -6,6 +6,7 @@
  * of this file for your non core code.
  */
 #include <linux/irqdesc.h>
+#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_SPARSE_IRQ
 # define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
@@ -73,6 +74,7 @@ extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
 extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
+extern void unmask_threaded_irq(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
@@ -82,6 +84,7 @@ irqreturn_t handle_irq_event(struct irq_desc *desc);
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
 bool irq_wait_for_poll(struct irq_desc *desc);
+void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action);
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
@@ -179,3 +182,9 @@ static inline bool irqd_has_set(struct irq_data *d, unsigned int mask)
 {
 	return d->state_use_accessors & mask;
 }
+
+static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
+{
+	__this_cpu_inc(*desc->kstat_irqs);
+	__this_cpu_inc(kstat.irqs_sum);
+}
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 8ab8e93..a7174617 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -489,6 +489,11 @@ void dynamic_irq_cleanup(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+void kstat_incr_irq_this_cpu(unsigned int irq)
+{
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+}
+
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d3bf660..2486a4c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -32,24 +32,10 @@ static int __init setup_forced_irqthreads(char *arg)
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
-/**
- *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
- *	@irq: interrupt number to wait for
- *
- *	This function waits for any pending IRQ handlers for this interrupt
- *	to complete before returning. If you use this function while
- *	holding a resource the IRQ handler may need you will deadlock.
- *
- *	This function may be called - with care - from IRQ context.
- */
-void synchronize_irq(unsigned int irq)
+static void __synchronize_hardirq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	bool inprogress;
 
-	if (!desc)
-		return;
-
 	do {
 		unsigned long flags;
 
@@ -67,12 +53,56 @@ void synchronize_irq(unsigned int irq)
 
 		/* Oops, that failed? */
 	} while (inprogress);
+}
 
-	/*
-	 * We made sure that no hardirq handler is running. Now verify
-	 * that no threaded handlers are active.
-	 */
-	wait_event(desc->wait_for_threads, !atomic_read(&desc->threads_active));
+/**
+ *	synchronize_hardirq - wait for pending hard IRQ handlers (on other CPUs)
+ *	@irq: interrupt number to wait for
+ *
+ *	This function waits for any pending hard IRQ handlers for this
+ *	interrupt to complete before returning. If you use this
+ *	function while holding a resource the IRQ handler may need you
+ *	will deadlock. It does not take associated threaded handlers
+ *	into account.
+ *
+ *	Do not use this for shutdown scenarios where you must be sure
+ *	that all parts (hardirq and threaded handler) have completed.
+ *
+ *	This function may be called - with care - from IRQ context.
+ */
+void synchronize_hardirq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc)
+		__synchronize_hardirq(desc);
+}
+EXPORT_SYMBOL(synchronize_hardirq);
+
+/**
+ *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
+ *	@irq: interrupt number to wait for
+ *
+ *	This function waits for any pending IRQ handlers for this interrupt
+ *	to complete before returning. If you use this function while
+ *	holding a resource the IRQ handler may need you will deadlock.
+ *
+ *	This function may be called - with care - from IRQ context.
+ */
+void synchronize_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc) {
+		__synchronize_hardirq(desc);
+		/*
+		 * We made sure that no hardirq handler is
+		 * running. Now verify that no threaded handlers are
+		 * active.
+		 */
+		wait_event(desc->wait_for_threads,
+			   !atomic_read(&desc->threads_active));
+	}
 }
 EXPORT_SYMBOL(synchronize_irq);
 
@@ -718,7 +748,7 @@ again:
 
 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data))
-		unmask_irq(desc);
+		unmask_threaded_irq(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
@@ -727,7 +757,7 @@ out_unlock:
 
 #ifdef CONFIG_SMP
 /*
- * Check whether we need to chasnge the affinity of the interrupt thread.
+ * Check whether we need to change the affinity of the interrupt thread.
  */
 static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
@@ -880,6 +910,33 @@ static int irq_thread(void *data)
 	return 0;
 }
 
+/**
+ *	irq_wake_thread - wake the irq thread for the action identified by dev_id
+ *	@irq:		Interrupt line
+ *	@dev_id:	Device identity for which the thread should be woken
+ *
+ */
+void irq_wake_thread(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (!desc || WARN_ON(irq_settings_is_per_cpu_devid(desc)))
+		return;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	for (action = desc->action; action; action = action->next) {
+		if (action->dev_id == dev_id) {
+			if (action->thread)
+				__irq_wake_thread(desc, action);
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+EXPORT_SYMBOL_GPL(irq_wake_thread);
+
 static void irq_setup_forced_threading(struct irqaction *new)
 {
 	if (!force_irqthreads)
@@ -896,6 +953,23 @@ static void irq_setup_forced_threading(struct irqaction *new)
 	}
 }
 
+static int irq_request_resources(struct irq_desc *desc)
+{
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *c = d->chip;
+
+	return c->irq_request_resources ? c->irq_request_resources(d) : 0;
+}
+
+static void irq_release_resources(struct irq_desc *desc)
+{
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *c = d->chip;
+
+	if (c->irq_release_resources)
+		c->irq_release_resources(d);
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -1091,6 +1165,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	}
 
 	if (!shared) {
+		ret = irq_request_resources(desc);
+		if (ret) {
+			pr_err("Failed to request resources for %s (irq %d) on irqchip %s\n",
+			       new->name, irq, desc->irq_data.chip->name);
+			goto out_mask;
+		}
+
 		init_waitqueue_head(&desc->wait_for_threads);
 
 		/* Setup the type (level, edge polarity) if configured: */
@@ -1261,8 +1342,10 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	*action_ptr = action->next;
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action)
+	if (!desc->action) {
 		irq_shutdown(desc);
+		irq_release_resources(desc);
+	}
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 36f6ee1..ac1ba2f 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -324,15 +324,15 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
-	proc_create_data("smp_affinity", 0600, desc->dir,
+	proc_create_data("smp_affinity", 0644, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 
 	/* create /proc/irq/<irq>/affinity_hint */
-	proc_create_data("affinity_hint", 0400, desc->dir,
+	proc_create_data("affinity_hint", 0444, desc->dir,
 			 &irq_affinity_hint_proc_fops, (void *)(long)irq);
 
 	/* create /proc/irq/<irq>/smp_affinity_list */
-	proc_create_data("smp_affinity_list", 0600, desc->dir,
+	proc_create_data("smp_affinity_list", 0644, desc->dir,
 			 &irq_affinity_list_proc_fops, (void *)(long)irq);
 
 	proc_create_data("node", 0444, desc->dir,
@@ -372,7 +372,7 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 static void register_default_affinity_proc(void)
 {
 #ifdef CONFIG_SMP
-	proc_create("irq/default_smp_affinity", 0600, NULL,
+	proc_create("irq/default_smp_affinity", 0644, NULL,
 		    &default_affinity_proc_fops);
 #endif
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 490fcbb..b50990a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/smpboot.h>
 #include <linux/tick.h>
+#include <linux/irq.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
