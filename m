Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaB0QYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:24:32 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:50500 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaB0QY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:24:29 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: tglx@linutronix.de
Cc: linus.walleij@linaro.org, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] irq: Changed the return type of irq_chip.irq_startup() from unsigned int to int
Date: Thu, 27 Feb 2014 18:21:19 +0100
Message-Id: <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com>
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the return type of the irq_startup() callback in irq_chip
from unsigned int to int, and modify the IRQ drivers providing this feature.
This allows the callback to return negative error codes.
This patch prepares the way for another patch that'll make request_irq() fail
when irq_startup() fails.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-omap2/gpmc.c                | 2 +-
 arch/blackfin/mach-common/ints-priority.c | 2 +-
 arch/ia64/hp/sim/hpsim_irq.c              | 2 +-
 arch/ia64/kernel/iosapic.c                | 4 ++--
 arch/ia64/kernel/irq_lsapic.c             | 2 +-
 arch/ia64/sn/kernel/irq.c                 | 2 +-
 arch/m68k/apollo/dn_ints.c                | 2 +-
 arch/m68k/atari/ataints.c                 | 4 ++--
 arch/m68k/include/asm/irq.h               | 4 ++--
 arch/m68k/kernel/ints.c                   | 4 ++--
 arch/m68k/mac/macints.c                   | 4 ++--
 arch/m68k/platform/coldfire/intc-2.c      | 2 +-
 arch/m68k/platform/coldfire/intc-simr.c   | 2 +-
 arch/m68k/q40/q40ints.c                   | 2 +-
 arch/metag/kernel/irq.c                   | 2 +-
 arch/mips/jz4740/gpio.c                   | 2 +-
 arch/mips/kernel/irq_cpu.c                | 2 +-
 arch/mips/lantiq/irq.c                    | 2 +-
 arch/mips/sgi-ip27/ip27-irq-pci.c         | 2 +-
 arch/powerpc/platforms/powermac/pic.c     | 2 +-
 arch/powerpc/platforms/wsp/ics.c          | 4 ++--
 arch/powerpc/sysdev/mpic.c                | 2 +-
 arch/powerpc/sysdev/xics/ics-opal.c       | 2 +-
 arch/powerpc/sysdev/xics/ics-rtas.c       | 2 +-
 arch/sparc/kernel/leon_kernel.c           | 2 +-
 arch/sparc/kernel/leon_pci_grpci1.c       | 2 +-
 arch/sparc/kernel/leon_pci_grpci2.c       | 2 +-
 arch/sparc/kernel/pcic.c                  | 2 +-
 arch/sparc/kernel/sun4d_irq.c             | 2 +-
 arch/sparc/kernel/sun4m_irq.c             | 2 +-
 arch/tile/kernel/pci_gx.c                 | 2 +-
 arch/x86/kernel/apic/io_apic.c            | 2 +-
 arch/x86/platform/visws/visws_quirks.c    | 2 +-
 drivers/gpio/gpio-adnp.c                  | 2 +-
 drivers/gpio/gpio-bcm-kona.c              | 2 +-
 drivers/gpio/gpio-em.c                    | 2 +-
 drivers/gpio/gpio-intel-mid.c             | 2 +-
 drivers/gpio/gpio-lynxpoint.c             | 2 +-
 drivers/gpio/gpio-mcp23s08.c              | 2 +-
 drivers/gpio/gpio-tz1090.c                | 2 +-
 drivers/irqchip/irq-metag.c               | 4 ++--
 drivers/pinctrl/pinctrl-adi2.c            | 2 +-
 drivers/pinctrl/pinctrl-baytrail.c        | 2 +-
 drivers/pinctrl/pinctrl-msm.c             | 2 +-
 drivers/pinctrl/pinctrl-nomadik.c         | 2 +-
 drivers/pinctrl/sirf/pinctrl-sirf.c       | 2 +-
 drivers/xen/events/events_base.c          | 4 ++--
 include/linux/irq.h                       | 2 +-
 kernel/irq/dummychip.c                    | 2 +-
 49 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index ab43755..1c905e4 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -714,7 +714,7 @@ static void gpmc_irq_enable(struct irq_data *p)
 
 static void gpmc_irq_noop(struct irq_data *data) { }
 
-static unsigned int gpmc_irq_noop_ret(struct irq_data *data) { return 0; }
+static int gpmc_irq_noop_ret(struct irq_data *data) { return 0; }
 
 static int gpmc_setup_irq(void)
 {
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 867b7ce..9a25b64 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -734,7 +734,7 @@ static void bfin_gpio_unmask_irq(struct irq_data *d)
 	set_gpio_maska(irq_to_gpio(d->irq), 1);
 }
 
-static unsigned int bfin_gpio_irq_startup(struct irq_data *d)
+static int bfin_gpio_irq_startup(struct irq_data *d)
 {
 	u32 gpionr = irq_to_gpio(d->irq);
 
diff --git a/arch/ia64/hp/sim/hpsim_irq.c b/arch/ia64/hp/sim/hpsim_irq.c
index 0aa70eb..8bd8452 100644
--- a/arch/ia64/hp/sim/hpsim_irq.c
+++ b/arch/ia64/hp/sim/hpsim_irq.c
@@ -12,7 +12,7 @@
 
 #include "hpsim_ssc.h"
 
-static unsigned int
+static int
 hpsim_irq_startup(struct irq_data *data)
 {
 	return 0;
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 19f107b..d475ce6 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -381,7 +381,7 @@ iosapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
  * Handlers for level-triggered interrupts.
  */
 
-static unsigned int
+static int
 iosapic_startup_level_irq (struct irq_data *data)
 {
 	unmask_irq(data);
@@ -433,7 +433,7 @@ static struct irq_chip irq_type_iosapic_level = {
  * Handlers for edge-triggered interrupts.
  */
 
-static unsigned int
+static int
 iosapic_startup_edge_irq (struct irq_data *data)
 {
 	unmask_irq(data);
diff --git a/arch/ia64/kernel/irq_lsapic.c b/arch/ia64/kernel/irq_lsapic.c
index 1b3a776..0734a85 100644
--- a/arch/ia64/kernel/irq_lsapic.c
+++ b/arch/ia64/kernel/irq_lsapic.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/irq.h>
 
-static unsigned int
+static int
 lsapic_noop_startup (struct irq_data *data)
 {
 	return 0;
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 62cf4dd..1e8f972 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -76,7 +76,7 @@ u64 sn_intr_redirect(nasid_t local_nasid, int local_widget,
 	return ret_stuff.status;
 }
 
-static unsigned int sn_startup_irq(struct irq_data *data)
+static int sn_startup_irq(struct irq_data *data)
 {
 	return 0;
 }
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 17be1e7..0465259 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -4,7 +4,7 @@
 #include <asm/traps.h>
 #include <asm/apollohw.h>
 
-unsigned int apollo_irq_startup(struct irq_data *data)
+int apollo_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
 
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 3e73a63..b784a76 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -82,7 +82,7 @@ __ALIGN_STR "\n\t"
 
 extern void atari_microwire_cmd(int cmd);
 
-static unsigned int atari_irq_startup(struct irq_data *data)
+static int atari_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
 
@@ -190,7 +190,7 @@ static struct irq_chip atari_mfptimer_chip = {
 
 static unsigned char *enat_cpld;
 
-static unsigned int atari_ethernat_startup(struct irq_data *data)
+static int atari_ethernat_startup(struct irq_data *data)
 {
 	int enat_num = 140 - data->irq + 1;
 
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 81ca118..ac0a036 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -57,8 +57,8 @@
 struct irq_data;
 struct irq_chip;
 struct irq_desc;
-extern unsigned int m68k_irq_startup(struct irq_data *data);
-extern unsigned int m68k_irq_startup_irq(unsigned int irq);
+extern int m68k_irq_startup(struct irq_data *data);
+extern int m68k_irq_startup_irq(unsigned int irq);
 extern void m68k_irq_shutdown(struct irq_data *data);
 extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int,
 						      struct pt_regs *));
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 077d3a7..ecdd6ce 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -125,7 +125,7 @@ void m68k_setup_irq_controller(struct irq_chip *chip,
 	}
 }
 
-unsigned int m68k_irq_startup_irq(unsigned int irq)
+int m68k_irq_startup_irq(unsigned int irq)
 {
 	if (irq <= IRQ_AUTO_7)
 		vectors[VEC_SPUR + irq] = auto_inthandler;
@@ -134,7 +134,7 @@ unsigned int m68k_irq_startup_irq(unsigned int irq)
 	return 0;
 }
 
-unsigned int m68k_irq_startup(struct irq_data *data)
+int m68k_irq_startup(struct irq_data *data)
 {
 	return m68k_irq_startup_irq(data->irq);
 }
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 5c1a6b2..7ca3a02 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -136,7 +136,7 @@ irqreturn_t mac_debug_handler(int, void *);
 
 /* #define DEBUG_MACINTS */
 
-static unsigned int mac_irq_startup(struct irq_data *);
+static int mac_irq_startup(struct irq_data *);
 static void mac_irq_shutdown(struct irq_data *);
 
 static struct irq_chip mac_irq_chip = {
@@ -254,7 +254,7 @@ void mac_irq_disable(struct irq_data *data)
 	}
 }
 
-static unsigned int mac_irq_startup(struct irq_data *data)
+static int mac_irq_startup(struct irq_data *data)
 {
 	int irq = data->irq;
 
diff --git a/arch/m68k/platform/coldfire/intc-2.c b/arch/m68k/platform/coldfire/intc-2.c
index 9950933..820cbb6 100644
--- a/arch/m68k/platform/coldfire/intc-2.c
+++ b/arch/m68k/platform/coldfire/intc-2.c
@@ -109,7 +109,7 @@ static void intc_irq_ack(struct irq_data *d)
  */
 static u8 intc_intpri = MCFSIM_ICR_LEVEL(6) | MCFSIM_ICR_PRI(6);
 
-static unsigned int intc_irq_startup(struct irq_data *d)
+static int intc_irq_startup(struct irq_data *d)
 {
 	unsigned int irq = d->irq - MCFINT_VECBASE;
 	unsigned long icraddr;
diff --git a/arch/m68k/platform/coldfire/intc-simr.c b/arch/m68k/platform/coldfire/intc-simr.c
index 7cf2c15..a063489 100644
--- a/arch/m68k/platform/coldfire/intc-simr.c
+++ b/arch/m68k/platform/coldfire/intc-simr.c
@@ -95,7 +95,7 @@ static void intc_irq_ack(struct irq_data *d)
 	__raw_writeb(0x1 << ebit, MCFEPORT_EPFR);
 }
 
-static unsigned int intc_irq_startup(struct irq_data *d)
+static int intc_irq_startup(struct irq_data *d)
 {
 	unsigned int irq = d->irq;
 
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 513f9bb..dc87a51 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -40,7 +40,7 @@ static void q40_irq_disable(struct irq_data *data);
 unsigned short q40_ablecount[35];
 unsigned short q40_state[35];
 
-static unsigned int q40_irq_startup(struct irq_data *data)
+static int q40_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
 
diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
index 3b4b7f6..47f6976 100644
--- a/arch/metag/kernel/irq.c
+++ b/arch/metag/kernel/irq.c
@@ -27,7 +27,7 @@ static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
 
 static struct irq_domain *root_domain;
 
-static unsigned int startup_meta_irq(struct irq_data *data)
+static int startup_meta_irq(struct irq_data *data)
 {
 	tbi_startup_interrupt(data->hwirq);
 	return 0;
diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index 00b798d..13bc81d 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -329,7 +329,7 @@ static void jz_gpio_irq_unmask(struct irq_data *data)
 };
 
 /* TODO: Check if function is gpio */
-static unsigned int jz_gpio_irq_startup(struct irq_data *data)
+static int jz_gpio_irq_startup(struct irq_data *data)
 {
 	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_SELECT_SET);
 	jz_gpio_irq_unmask(data);
diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index e498f2b..6b623df 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -62,7 +62,7 @@ static struct irq_chip mips_cpu_irq_controller = {
  * Basically the same as above but taking care of all the MT stuff
  */
 
-static unsigned int mips_mt_cpu_irq_startup(struct irq_data *d)
+static int mips_mt_cpu_irq_startup(struct irq_data *d)
 {
 	unsigned int vpflags = dvpe();
 
diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index 85685e1..ccd2554 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -167,7 +167,7 @@ static int ltq_eiu_settype(struct irq_data *d, unsigned int type)
 	return 0;
 }
 
-static unsigned int ltq_startup_eiu_irq(struct irq_data *d)
+static int ltq_startup_eiu_irq(struct irq_data *d)
 {
 	int i;
 
diff --git a/arch/mips/sgi-ip27/ip27-irq-pci.c b/arch/mips/sgi-ip27/ip27-irq-pci.c
index 2a1c407..89cf754 100644
--- a/arch/mips/sgi-ip27/ip27-irq-pci.c
+++ b/arch/mips/sgi-ip27/ip27-irq-pci.c
@@ -132,7 +132,7 @@ static int intr_disconnect_level(int cpu, int bit)
 }
 
 /* Startup one of the (PCI ...) IRQs routes over a bridge.  */
-static unsigned int startup_bridge_irq(struct irq_data *d)
+static int startup_bridge_irq(struct irq_data *d)
 {
 	struct bridge_controller *bc;
 	bridgereg_t device;
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 4c24bf6..9824afe 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -143,7 +143,7 @@ static void __pmac_set_irq_mask(unsigned int irq_nr, int nokicklost)
 /* When an irq gets requested for the first client, if it's an
  * edge interrupt, we clear any previous one on the controller
  */
-static unsigned int pmac_startup_irq(struct irq_data *d)
+static int pmac_startup_irq(struct irq_data *d)
 {
 	unsigned long flags;
 	unsigned int src = irqd_to_hwirq(d);
diff --git a/arch/powerpc/platforms/wsp/ics.c b/arch/powerpc/platforms/wsp/ics.c
index 9cd92e6..6f839f0 100644
--- a/arch/powerpc/platforms/wsp/ics.c
+++ b/arch/powerpc/platforms/wsp/ics.c
@@ -295,7 +295,7 @@ static void wsp_chip_unmask_irq(struct irq_data *d)
 	wsp_ics_set_xive(ics, hw_irq, xive);
 }
 
-static unsigned int wsp_chip_startup(struct irq_data *d)
+static int wsp_chip_startup(struct irq_data *d)
 {
 	/* unmask it */
 	wsp_chip_unmask_irq(d);
@@ -720,7 +720,7 @@ static void wsp_ics_msi_unmask_irq(struct irq_data *d)
 	unmask_msi_irq(d);
 }
 
-static unsigned int wsp_ics_msi_startup(struct irq_data *d)
+static int wsp_ics_msi_startup(struct irq_data *d)
 {
 	wsp_ics_msi_unmask_irq(d);
 	return 0;
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 8209744..c0fe5a7 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -735,7 +735,7 @@ static void mpic_unmask_ht_irq(struct irq_data *d)
 		mpic_ht_end_irq(mpic, src);
 }
 
-static unsigned int mpic_startup_ht_irq(struct irq_data *d)
+static int mpic_startup_ht_irq(struct irq_data *d)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
 	unsigned int src = irqd_to_hwirq(d);
diff --git a/arch/powerpc/sysdev/xics/ics-opal.c b/arch/powerpc/sysdev/xics/ics-opal.c
index 3c6ee1b..bd90843 100644
--- a/arch/powerpc/sysdev/xics/ics-opal.c
+++ b/arch/powerpc/sysdev/xics/ics-opal.c
@@ -64,7 +64,7 @@ static void ics_opal_unmask_irq(struct irq_data *d)
 		       __func__, d->irq, hw_irq, server, rc);
 }
 
-static unsigned int ics_opal_startup(struct irq_data *d)
+static int ics_opal_startup(struct irq_data *d)
 {
 #ifdef CONFIG_PCI_MSI
 	/*
diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-rtas.c
index 936575d..2f656e8 100644
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -67,7 +67,7 @@ static void ics_rtas_unmask_irq(struct irq_data *d)
 	}
 }
 
-static unsigned int ics_rtas_startup(struct irq_data *d)
+static int ics_rtas_startup(struct irq_data *d)
 {
 #ifdef CONFIG_PCI_MSI
 	/*
diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
index b7c6897..690c425 100644
--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
@@ -168,7 +168,7 @@ static void leon_mask_irq(struct irq_data *data)
 	spin_unlock_irqrestore(&leon_irq_lock, flags);
 }
 
-static unsigned int leon_startup_irq(struct irq_data *data)
+static int leon_startup_irq(struct irq_data *data)
 {
 	irq_link(data->irq);
 	leon_unmask_irq(data);
diff --git a/arch/sparc/kernel/leon_pci_grpci1.c b/arch/sparc/kernel/leon_pci_grpci1.c
index 6df26e3..e4e9423 100644
--- a/arch/sparc/kernel/leon_pci_grpci1.c
+++ b/arch/sparc/kernel/leon_pci_grpci1.c
@@ -337,7 +337,7 @@ static void grpci1_unmask_irq(struct irq_data *data)
 	REGSTORE(priv->regs->irq, REGLOAD(priv->regs->irq) | (1 << irqidx));
 }
 
-static unsigned int grpci1_startup_irq(struct irq_data *data)
+static int grpci1_startup_irq(struct irq_data *data)
 {
 	grpci1_unmask_irq(data);
 	return 0;
diff --git a/arch/sparc/kernel/leon_pci_grpci2.c b/arch/sparc/kernel/leon_pci_grpci2.c
index 5f0402a..5ac51ed 100644
--- a/arch/sparc/kernel/leon_pci_grpci2.c
+++ b/arch/sparc/kernel/leon_pci_grpci2.c
@@ -477,7 +477,7 @@ static void grpci2_unmask_irq(struct irq_data *data)
 	spin_unlock_irqrestore(&grpci2_dev_lock, flags);
 }
 
-static unsigned int grpci2_startup_irq(struct irq_data *data)
+static int grpci2_startup_irq(struct irq_data *data)
 {
 	grpci2_unmask_irq(data);
 	return 0;
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 09f4fdd..7abafc2 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -825,7 +825,7 @@ static void pcic_unmask_irq(struct irq_data *data)
 	local_irq_restore(flags);
 }
 
-static unsigned int pcic_startup_irq(struct irq_data *data)
+static int pcic_startup_irq(struct irq_data *data)
 {
 	irq_link(data->irq);
 	pcic_unmask_irq(data);
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index f8933be..e779239 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -223,7 +223,7 @@ static void sun4d_unmask_irq(struct irq_data *data)
 #endif
 }
 
-static unsigned int sun4d_startup_irq(struct irq_data *data)
+static int sun4d_startup_irq(struct irq_data *data)
 {
 	irq_link(data->irq);
 	sun4d_unmask_irq(data);
diff --git a/arch/sparc/kernel/sun4m_irq.c b/arch/sparc/kernel/sun4m_irq.c
index c5ade9d..6312a7f 100644
--- a/arch/sparc/kernel/sun4m_irq.c
+++ b/arch/sparc/kernel/sun4m_irq.c
@@ -220,7 +220,7 @@ static void sun4m_unmask_irq(struct irq_data *data)
 	}
 }
 
-static unsigned int sun4m_startup_irq(struct irq_data *data)
+static int sun4m_startup_irq(struct irq_data *data)
 {
 	irq_link(data->irq);
 	sun4m_unmask_irq(data);
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index a97a645..a38ec35 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1463,7 +1463,7 @@ static struct pci_ops tile_cfg_ops = {
 
 
 /* MSI support starts here. */
-static unsigned int tilegx_msi_startup(struct irq_data *d)
+static int tilegx_msi_startup(struct irq_data *d)
 {
 	if (d->msi_desc)
 		unmask_msi_irq(d);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..685a344 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2132,7 +2132,7 @@ static int __init timer_irq_works(void)
  * an edge even if it isn't on the 8259A...
  */
 
-static unsigned int startup_ioapic_irq(struct irq_data *data)
+static int startup_ioapic_irq(struct irq_data *data)
 {
 	int was_pending = 0, irq = data->irq;
 	unsigned long flags;
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 94d8a39..7d537e6 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -467,7 +467,7 @@ static struct irq_chip cobalt_irq_type = {
  * interrupt controller type, and through a special virtual interrupt-
  * controller. Device drivers only see the virtual interrupt sources.
  */
-static unsigned int startup_piix4_master_irq(struct irq_data *data)
+static int startup_piix4_master_irq(struct irq_data *data)
 {
 	legacy_pic->init(0);
 	enable_cobalt_irq(data);
diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
index 6fc6206..e5db9e0 100644
--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -408,7 +408,7 @@ static void adnp_irq_bus_unlock(struct irq_data *data)
 	mutex_unlock(&adnp->irq_lock);
 }
 
-static unsigned int adnp_irq_startup(struct irq_data *data)
+static int adnp_irq_startup(struct irq_data *data)
 {
 	struct adnp *adnp = irq_data_get_irq_chip_data(data);
 
diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index f32357e..6e99465 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -449,7 +449,7 @@ static void bcm_kona_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static unsigned int bcm_kona_gpio_irq_startup(struct irq_data *d)
+static int bcm_kona_gpio_irq_startup(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index 1e98a98..203f9fa5 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -99,7 +99,7 @@ static void em_gio_irq_enable(struct irq_data *d)
 	em_gio_write(p, GIO_IEN, BIT(irqd_to_hwirq(d)));
 }
 
-static unsigned int em_gio_irq_startup(struct irq_data *d)
+static int em_gio_irq_startup(struct irq_data *d)
 {
 	struct em_gio_priv *p = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
index e585163..7a63536 100644
--- a/drivers/gpio/gpio-intel-mid.c
+++ b/drivers/gpio/gpio-intel-mid.c
@@ -235,7 +235,7 @@ static void intel_mid_irq_mask(struct irq_data *d)
 {
 }
 
-static unsigned int intel_mid_irq_startup(struct irq_data *d)
+static int intel_mid_irq_startup(struct irq_data *d)
 {
 	struct intel_mid_gpio *priv = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 66b1853..1232df4 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -301,7 +301,7 @@ static void lp_irq_disable(struct irq_data *d)
 	spin_unlock_irqrestore(&lg->lock, flags);
 }
 
-static unsigned int lp_irq_startup(struct irq_data *d)
+static int lp_irq_startup(struct irq_data *d)
 {
 	struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 1ac288e..326736f 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -440,7 +440,7 @@ static void mcp23s08_irq_bus_unlock(struct irq_data *data)
 	mutex_unlock(&mcp->irq_lock);
 }
 
-static unsigned int mcp23s08_irq_startup(struct irq_data *data)
+static int mcp23s08_irq_startup(struct irq_data *data)
 {
 	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
 
diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
index 23e0613..33a086e 100644
--- a/drivers/gpio/gpio-tz1090.c
+++ b/drivers/gpio/gpio-tz1090.c
@@ -302,7 +302,7 @@ static void tz1090_gpio_irq_next_edge(struct tz1090_gpio_bank *bank,
 	__global_unlock2(lstat);
 }
 
-static unsigned int gpio_startup_irq(struct irq_data *data)
+static int gpio_startup_irq(struct irq_data *data)
 {
 	/*
 	 * This warning indicates that the type of the irq hasn't been set
diff --git a/drivers/irqchip/irq-metag.c b/drivers/irqchip/irq-metag.c
index 8e94d7a..12469d6 100644
--- a/drivers/irqchip/irq-metag.c
+++ b/drivers/irqchip/irq-metag.c
@@ -34,7 +34,7 @@ struct metag_internal_irq_priv {
 /* Private data for the one and only internal interrupt controller */
 static struct metag_internal_irq_priv metag_internal_irq_priv;
 
-static unsigned int metag_internal_irq_startup(struct irq_data *data);
+static int metag_internal_irq_startup(struct irq_data *data);
 static void metag_internal_irq_shutdown(struct irq_data *data);
 static void metag_internal_irq_ack(struct irq_data *data);
 static void metag_internal_irq_mask(struct irq_data *data);
@@ -88,7 +88,7 @@ static inline void __iomem *metag_hwvec_addr(irq_hw_number_t hw)
  *	Multiplex interrupts for @irq onto TR1. Clear any pending
  *	interrupts.
  */
-static unsigned int metag_internal_irq_startup(struct irq_data *data)
+static int metag_internal_irq_startup(struct irq_data *data)
 {
 	/* Clear (toggle) the bit in HWSTATMETA for our interrupt. */
 	metag_internal_irq_ack(data);
diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 7a39562..cdcf722 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -316,7 +316,7 @@ static void adi_gpio_unmask_irq(struct irq_data *d)
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-static unsigned int adi_gpio_irq_startup(struct irq_data *d)
+static int adi_gpio_irq_startup(struct irq_data *d)
 {
 	unsigned long flags;
 	struct gpio_port *port = irq_data_get_irq_chip_data(d);
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 665b96b..505a261 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -371,7 +371,7 @@ static void byt_irq_mask(struct irq_data *d)
 {
 }
 
-static unsigned int byt_irq_startup(struct irq_data *d)
+static int byt_irq_startup(struct irq_data *d)
 {
 	struct byt_gpio *vg = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index ef2bf31..b1e7333 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -805,7 +805,7 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	return 0;
 }
 
-static unsigned int msm_gpio_irq_startup(struct irq_data *d)
+static int msm_gpio_irq_startup(struct irq_data *d)
 {
 	struct msm_pinctrl *pctrl = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 53a1111..9c68265 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -844,7 +844,7 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	return 0;
 }
 
-static unsigned int nmk_gpio_irq_startup(struct irq_data *d)
+static int nmk_gpio_irq_startup(struct irq_data *d)
 {
 	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
index a0d6152..89bec51 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -594,7 +594,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
 	return 0;
 }
 
-static unsigned int sirfsoc_gpio_irq_startup(struct irq_data *d)
+static int sirfsoc_gpio_irq_startup(struct irq_data *d)
 {
 	struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index f4a9e33..4429ecc 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -520,7 +520,7 @@ static void mask_ack_pirq(struct irq_data *data)
 	eoi_pirq(data);
 }
 
-static unsigned int __startup_pirq(unsigned int irq)
+static int __startup_pirq(unsigned int irq)
 {
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
@@ -563,7 +563,7 @@ out:
 	return 0;
 }
 
-static unsigned int startup_pirq(struct irq_data *data)
+static int startup_pirq(struct irq_data *data)
 {
 	return __startup_pirq(data->irq);
 }
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..6835778 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -307,7 +307,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  */
 struct irq_chip {
 	const char	*name;
-	unsigned int	(*irq_startup)(struct irq_data *data);
+	int		(*irq_startup)(struct irq_data *data);
 	void		(*irq_shutdown)(struct irq_data *data);
 	void		(*irq_enable)(struct irq_data *data);
 	void		(*irq_disable)(struct irq_data *data);
diff --git a/kernel/irq/dummychip.c b/kernel/irq/dummychip.c
index 988dc58..2994839 100644
--- a/kernel/irq/dummychip.c
+++ b/kernel/irq/dummychip.c
@@ -27,7 +27,7 @@ static void ack_bad(struct irq_data *data)
  */
 static void noop(struct irq_data *data) { }
 
-static unsigned int noop_ret(struct irq_data *data)
+static int noop_ret(struct irq_data *data)
 {
 	return 0;
 }
-- 
1.9.0

