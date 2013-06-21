Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423256Ab3FUPRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:17:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47187 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423118Ab3FUPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:17:40 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: fix at91_extern_irq usage for non-dt boards
Date: Fri, 21 Jun 2013 17:17:36 +0200
Message-ID: <1371827856-19898-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Since 4b68520dc0ec96153bc0d87bca5ffba508edfcf
ARM: at91: add AIC5 support

we allocate the at91_extern_irq.

This patch makes it static and stores the non-dt extern irq in the soc
structure. It is then possible to use a at91_get_extern_irq() function
to get the value for outside of the irq driver. It is useful for passing
its value to at91_aic_init().

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
[nicolas.ferre@atmel.com: rework commit message]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200.c  | 8 ++++----
 arch/arm/mach-at91/at91sam9260.c | 4 ++--
 arch/arm/mach-at91/at91sam9261.c | 4 ++--
 arch/arm/mach-at91/at91sam9263.c | 2 +-
 arch/arm/mach-at91/at91sam9g45.c | 2 +-
 arch/arm/mach-at91/at91sam9rl.c  | 2 +-
 arch/arm/mach-at91/at91x40.c     | 7 +++----
 arch/arm/mach-at91/generic.h     | 2 +-
 arch/arm/mach-at91/irq.c         | 9 ++++++++-
 arch/arm/mach-at91/pm.c          | 2 +-
 arch/arm/mach-at91/setup.c       | 2 +-
 arch/arm/mach-at91/soc.h         | 1 +
 12 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index d193a40..9eb5743 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -332,10 +332,6 @@ static void __init at91rm9200_initialize(void)
 {
 	arm_pm_idle = at91rm9200_idle;
 	arm_pm_restart = at91rm9200_restart;
-	at91_extern_irq = (1 << AT91RM9200_ID_IRQ0) | (1 << AT91RM9200_ID_IRQ1)
-			| (1 << AT91RM9200_ID_IRQ2) | (1 << AT91RM9200_ID_IRQ3)
-			| (1 << AT91RM9200_ID_IRQ4) | (1 << AT91RM9200_ID_IRQ5)
-			| (1 << AT91RM9200_ID_IRQ6);
 
 	/* Initialize GPIO subsystem */
 	at91_gpio_init(at91rm9200_gpio,
@@ -388,6 +384,10 @@ static unsigned int at91rm9200_default_irq_priority[NR_AIC_IRQS] __initdata = {
 AT91_SOC_START(at91rm9200)
 	.map_io = at91rm9200_map_io,
 	.default_irq_priority = at91rm9200_default_irq_priority,
+	.extern_irq = (1 << AT91RM9200_ID_IRQ0) | (1 << AT91RM9200_ID_IRQ1)
+		    | (1 << AT91RM9200_ID_IRQ2) | (1 << AT91RM9200_ID_IRQ3)
+		    | (1 << AT91RM9200_ID_IRQ4) | (1 << AT91RM9200_ID_IRQ5)
+		    | (1 << AT91RM9200_ID_IRQ6),
 	.ioremap_registers = at91rm9200_ioremap_registers,
 	.register_clocks = at91rm9200_register_clocks,
 	.init = at91rm9200_initialize,
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index a8ce245..5de6074 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -348,8 +348,6 @@ static void __init at91sam9260_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
-	at91_extern_irq = (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IRQ1)
-			| (1 << AT91SAM9260_ID_IRQ2);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9260_gpio, 3);
@@ -400,6 +398,8 @@ static unsigned int at91sam9260_default_irq_priority[NR_AIC_IRQS] __initdata = {
 AT91_SOC_START(at91sam9260)
 	.map_io = at91sam9260_map_io,
 	.default_irq_priority = at91sam9260_default_irq_priority,
+	.extern_irq = (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IRQ1)
+		    | (1 << AT91SAM9260_ID_IRQ2),
 	.ioremap_registers = at91sam9260_ioremap_registers,
 	.register_clocks = at91sam9260_register_clocks,
 	.init = at91sam9260_initialize,
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 25efb5a..0e07932 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -290,8 +290,6 @@ static void __init at91sam9261_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
-	at91_extern_irq = (1 << AT91SAM9261_ID_IRQ0) | (1 << AT91SAM9261_ID_IRQ1)
-			| (1 << AT91SAM9261_ID_IRQ2);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9261_gpio, 3);
@@ -342,6 +340,8 @@ static unsigned int at91sam9261_default_irq_priority[NR_AIC_IRQS] __initdata = {
 AT91_SOC_START(at91sam9261)
 	.map_io = at91sam9261_map_io,
 	.default_irq_priority = at91sam9261_default_irq_priority,
+	.extern_irq = (1 << AT91SAM9261_ID_IRQ0) | (1 << AT91SAM9261_ID_IRQ1)
+		    | (1 << AT91SAM9261_ID_IRQ2),
 	.ioremap_registers = at91sam9261_ioremap_registers,
 	.register_clocks = at91sam9261_register_clocks,
 	.init = at91sam9261_initialize,
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f44ffd2..6ce7d18 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -327,7 +327,6 @@ static void __init at91sam9263_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
-	at91_extern_irq = (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IRQ1);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9263_gpio, 5);
@@ -378,6 +377,7 @@ static unsigned int at91sam9263_default_irq_priority[NR_AIC_IRQS] __initdata = {
 AT91_SOC_START(at91sam9263)
 	.map_io = at91sam9263_map_io,
 	.default_irq_priority = at91sam9263_default_irq_priority,
+	.extern_irq = (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IRQ1),
 	.ioremap_registers = at91sam9263_ioremap_registers,
 	.register_clocks = at91sam9263_register_clocks,
 	.init = at91sam9263_initialize,
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 8b7fce0..fda5026 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -374,7 +374,6 @@ static void __init at91sam9g45_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9g45_restart;
-	at91_extern_irq = (1 << AT91SAM9G45_ID_IRQ0);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9g45_gpio, 5);
@@ -425,6 +424,7 @@ static unsigned int at91sam9g45_default_irq_priority[NR_AIC_IRQS] __initdata = {
 AT91_SOC_START(at91sam9g45)
 	.map_io = at91sam9g45_map_io,
 	.default_irq_priority = at91sam9g45_default_irq_priority,
+	.extern_irq = (1 << AT91SAM9G45_ID_IRQ0),
 	.ioremap_registers = at91sam9g45_ioremap_registers,
 	.register_clocks = at91sam9g45_register_clocks,
 	.init = at91sam9g45_initialize,
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index f77fae5..d4ec0d9 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -293,7 +293,6 @@ static void __init at91sam9rl_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
-	at91_extern_irq = (1 << AT91SAM9RL_ID_IRQ0);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9rl_gpio, 4);
@@ -344,6 +343,7 @@ static unsigned int at91sam9rl_default_irq_priority[NR_AIC_IRQS] __initdata = {
 AT91_SOC_START(at91sam9rl)
 	.map_io = at91sam9rl_map_io,
 	.default_irq_priority = at91sam9rl_default_irq_priority,
+	.extern_irq = (1 << AT91SAM9RL_ID_IRQ0),
 	.ioremap_registers = at91sam9rl_ioremap_registers,
 	.register_clocks = at91sam9rl_register_clocks,
 	.init = at91sam9rl_initialize,
diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 19ca793..bad94b8 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -55,8 +55,6 @@ static void at91x40_idle(void)
 void __init at91x40_initialize(unsigned long main_clock)
 {
 	arm_pm_idle = at91x40_idle;
-	at91_extern_irq = (1 << AT91X40_ID_IRQ0) | (1 << AT91X40_ID_IRQ1)
-			| (1 << AT91X40_ID_IRQ2);
 }
 
 /*
@@ -86,9 +84,10 @@ static unsigned int at91x40_default_irq_priority[NR_AIC_IRQS] __initdata = {
 
 void __init at91x40_init_interrupts(unsigned int priority[NR_AIC_IRQS])
 {
+	u32  extern_irq = (1 << AT91X40_ID_IRQ0) | (1 << AT91X40_ID_IRQ1)
+			| (1 << AT91X40_ID_IRQ2);
 	if (!priority)
 		priority = at91x40_default_irq_priority;
 
-	at91_aic_init(priority, at91_extern_irq);
+	at91_aic_init(priority, extern_irq);
 }
-
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 78ab065..f6de36a 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -85,4 +85,4 @@ extern void __init at91_gpio_irq_setup(void);
 extern int  __init at91_gpio_of_irq_setup(struct device_node *node,
 					  struct device_node *parent);
 
-extern int at91_extern_irq;
+extern u32 at91_get_extern_irq(void);
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index e0ca591..3d192c5 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -232,7 +232,14 @@ static void __maybe_unused at91_aic5_eoi(struct irq_data *d)
 	at91_aic_write(AT91_AIC5_EOICR, 0);
 }
 
-unsigned long *at91_extern_irq;
+static unsigned long *at91_extern_irq;
+
+u32 at91_get_extern_irq(void)
+{
+	if (!at91_extern_irq)
+		return 0;
+	return *at91_extern_irq;
+}
 
 #define is_extern_irq(hwirq) test_bit(hwirq, at91_extern_irq)
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 530db30..15afb5d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -212,7 +212,7 @@ static int at91_pm_enter(suspend_state_t state)
 			(at91_pmc_read(AT91_PMC_PCSR)
 					| (1 << AT91_ID_FIQ)
 					| (1 << AT91_ID_SYS)
-					| (at91_extern_irq))
+					| (at91_get_extern_irq()))
 				& at91_aic_read(AT91_AIC_IMR),
 			state);
 
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 942dc00..b17fbcf 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -48,7 +48,7 @@ void __init at91_init_irq_default(void)
 void __init at91_init_interrupts(unsigned int *priority)
 {
 	/* Initialize the AIC interrupt controller */
-	at91_aic_init(priority, at91_extern_irq);
+	at91_aic_init(priority, at91_boot_soc.extern_irq);
 
 	/* Enable GPIO interrupts */
 	at91_gpio_irq_setup();
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index 43a225f..a1e1482 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -6,6 +6,7 @@
 
 struct at91_init_soc {
 	int builtin;
+	u32 extern_irq;
 	unsigned int *default_irq_priority;
 	void (*map_io)(void);
 	void (*ioremap_registers)(void);
-- 
1.8.2.2

