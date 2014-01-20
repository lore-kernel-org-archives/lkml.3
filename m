Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaATNM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:12:58 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56897 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaATNMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:12:55 -0500
Date: Mon, 20 Jan 2014 14:12:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.14
Message-ID: <20140120131250.GA11840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   # HEAD: 00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506 clocksource: Timer-sun5i: Switch to sched_clock_register()

The main changes are:

  - ARM clocksource/clockevent improvements and fixes.

  - Generic timekeeping updates: TAI fixes/improvements, cleanups.

  - Posix cpu timer cleanups and improvements.

  - Dynticks updates: full dynticks bugfixes, optimizations and cleanups.

 Thanks,

	Ingo

------------------>
Axel Lin (1):
      clocksource: bcm_kona_timer: Remove unused bcm_timer_ids

Borislav Petkov (1):
      rtc-cmos: Add an alarm disable quirk

Ezequiel Garcia (1):
      clocksource: armada-370-xp: Enable timer divider only when needed

Frederic Weisbecker (15):
      nohz: Convert a few places to use local per cpu accesses
      context_tracking: Wrap static key check into more intuitive function name
      context_tracking: Rename context_tracking_active() to context_tracking_cpu_is_enabled()
      posix-timers: Spare workqueue if there is no full dynticks CPU to kick
      posix-timers: Fix full dynticks CPUs kick on timer rescheduling
      posix-timers: Remove dead thread posix cpu timers caching
      posix-timers: Remove dead process posix cpu timers caching
      posix-timers: Cleanup reaped target handling
      posix-timers: Remove dead task special case
      posix-timers: Remove useless clock sample on timers cleanup
      posix-timers: Consolidate posix_cpu_clock_get()
      posix-timers: Use sighand lock instead of tasklist_lock for task clock sample
      posix-timers: Use sighand lock instead of tasklist_lock on timer deletion
      posix-timers: Remove remaining uses of tasklist_lock
      posix-timers: Convert abuses of BUG_ON to WARN_ON

Jingoo Han (2):
      clocksource: sh_tmu: Remove unnecessary platform_set_drvdata()
      clocksource: sh_mtu2: Remove unnecessary platform_set_drvdata()

John Stultz (7):
      timekeeping: Fix lost updates to tai adjustment
      timekeeping: Fix potential lost pv notification of time change
      timekeeping: Avoid possible deadlock from clock_was_set_delayed
      tick/timekeeping: Call update_wall_time outside the jiffies lock
      timekeeping: Fix CLOCK_TAI timer/nanosleep delays
      timekeeping: Fix missing timekeeping_update in suspend path
      timekeeping: Remove comment that's mostly out of date

Laurent Pinchart (1):
      clocksource: sh_cmt: Add clk_prepare/unprepare support

Linus Walleij (1):
      clocksource: clksrc-of: Warn if no clock sources are found

Maxime Ripard (7):
      clockevent: sun4i: Fill the irq field in the clockevent structure
      clocksource: sun4i: Change CPU mask to cpu_possible_mask
      clocksource: sun4i: Increase a bit the clock event and sources rating
      clocksource: Add Allwinner SoCs HS timers driver
      ARM: sun5i: a10s: Add support for the High Speed Timers
      ARM: sun5i: a13: Add support for the High Speed Timers
      ARM: sun7i: a20: Add support for the High Speed Timers

Michael Opdenacker (3):
      clocksource: misc drivers: Remove deprecated IRQF_DISABLED
      clocksource: tegra: Remove deprecated IRQF_DISABLED
      clocksource: vt8500: Remove deprecated IRQF_DISABLED

Paul Gortmaker (1):
      trivial: fix spelling in CONTEXT_TRACKING_FORCE help text

Stephen Boyd (5):
      clocksource: arm_global_timer: Switch to sched_clock_register()
      clocksource: cadence_ttc_timer: Switch to sched_clock_register()
      clocksource: sun4i: Switch to sched_clock_register()
      clocksource: orion: Switch to sched_clock_register()
      clocksource: Timer-sun5i: Switch to sched_clock_register()

Yijing Wang (1):
      timekeeper: fix comment typo for tk_setup_internals()


 .../bindings/timer/allwinner,sun5i-a13-hstimer.txt |  22 ++
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   7 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   7 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  10 +
 arch/arm/mach-sunxi/Kconfig                        |   1 +
 drivers/clocksource/Kconfig                        |   4 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/arm_global_timer.c             |   4 +-
 drivers/clocksource/bcm_kona_timer.c               |   6 -
 drivers/clocksource/cadence_ttc_timer.c            |   7 +-
 drivers/clocksource/clksrc-of.c                    |   4 +
 drivers/clocksource/cs5535-clockevt.c              |   2 +-
 drivers/clocksource/dw_apb_timer.c                 |   3 +-
 drivers/clocksource/nomadik-mtu.c                  |   2 +-
 drivers/clocksource/samsung_pwm_timer.c            |   2 +-
 drivers/clocksource/sh_cmt.c                       |  23 +-
 drivers/clocksource/sh_mtu2.c                      |   4 +-
 drivers/clocksource/sh_tmu.c                       |   4 +-
 drivers/clocksource/sun4i_timer.c                  |  11 +-
 drivers/clocksource/tegra20_timer.c                |   2 +-
 drivers/clocksource/time-armada-370-xp.c           |  18 +-
 drivers/clocksource/time-orion.c                   |   4 +-
 drivers/clocksource/timer-sun5i.c                  | 192 ++++++++++++
 drivers/clocksource/vt8500_timer.c                 |   2 +-
 drivers/rtc/rtc-cmos.c                             |  52 +++-
 include/linux/context_tracking.h                   |  10 +-
 include/linux/context_tracking_state.h             |  11 +-
 include/linux/tick.h                               |   8 +-
 include/linux/vtime.h                              |   4 +-
 init/Kconfig                                       |   2 +-
 kernel/context_tracking.c                          |   8 +-
 kernel/posix-cpu-timers.c                          | 327 +++++++++------------
 kernel/softirq.c                                   |   4 +-
 kernel/time/tick-broadcast.c                       |   6 +-
 kernel/time/tick-common.c                          |   1 +
 kernel/time/tick-internal.h                        |   5 +-
 kernel/time/tick-sched.c                           |  40 ++-
 kernel/time/timekeeping.c                          |  53 ++--
 38 files changed, 556 insertions(+), 317 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
 create mode 100644 drivers/clocksource/timer-sun5i.c

diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
new file mode 100644
index 0000000..7c26154
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
@@ -0,0 +1,22 @@
+Allwinner SoCs High Speed Timer Controller
+
+Required properties:
+
+- compatible :	should be "allwinner,sun5i-a13-hstimer" or
+		"allwinner,sun7i-a20-hstimer"
+- reg : Specifies base physical address and size of the registers.
+- interrupts :	The interrupts of these timers (2 for the sun5i IP, 4 for the sun7i
+		one)
+- clocks: phandle to the source clock (usually the AHB clock)
+
+Example:
+
+timer@01c60000 {
+	compatible = "allwinner,sun7i-a20-hstimer";
+	reg = <0x01c60000 0x1000>;
+	interrupts = <0 51 1>,
+		     <0 52 1>,
+		     <0 53 1>,
+		     <0 54 1>;
+	clocks = <&ahb1_gates 19>;
+};
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 5247674..e674c94 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -332,5 +332,12 @@
 			clock-frequency = <100000>;
 			status = "disabled";
 		};
+
+		timer@01c60000 {
+			compatible = "allwinner,sun5i-a13-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <82>, <83>;
+			clocks = <&ahb_gates 28>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index ce8ef2a..1ccd75d 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -273,5 +273,12 @@
 			clock-frequency = <100000>;
 			status = "disabled";
 		};
+
+		timer@01c60000 {
+			compatible = "allwinner,sun5i-a13-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <82>, <83>;
+			clocks = <&ahb_gates 28>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 367611a..0135039 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -395,6 +395,16 @@
 			status = "disabled";
 		};
 
+		hstimer@01c60000 {
+			compatible = "allwinner,sun7i-a20-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <0 81 1>,
+				     <0 82 1>,
+				     <0 83 1>,
+				     <0 84 1>;
+			clocks = <&ahb_gates 28>;
+		};
+
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index c9e72c8..bce0d42 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -12,3 +12,4 @@ config ARCH_SUNXI
 	select PINCTRL_SUNXI
 	select SPARSE_IRQ
 	select SUN4I_TIMER
+	select SUN5I_HSTIMER
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 634c4d6..cd6950f 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -37,6 +37,10 @@ config SUN4I_TIMER
 	select CLKSRC_MMIO
 	bool
 
+config SUN5I_HSTIMER
+	select CLKSRC_MMIO
+	bool
+
 config VT8500_TIMER
 	bool
 
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 33621ef..358358d 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
+obj-$(CONFIG_SUN5I_HSTIMER)	+= timer-sun5i.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index c639b1a..0fc31d0 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -202,7 +202,7 @@ static struct clocksource gt_clocksource = {
 };
 
 #ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-static u32 notrace gt_sched_clock_read(void)
+static u64 notrace gt_sched_clock_read(void)
 {
 	return gt_counter_read();
 }
@@ -217,7 +217,7 @@ static void __init gt_clocksource_init(void)
 	writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
 
 #ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-	setup_sched_clock(gt_sched_clock_read, 32, gt_clk_rate);
+	sched_clock_register(gt_sched_clock_read, 64, gt_clk_rate);
 #endif
 	clocksource_register_hz(&gt_clocksource, gt_clk_rate);
 }
diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0d7d8c3..5176e76 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -98,12 +98,6 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
 	return;
 }
 
-static const struct of_device_id bcm_timer_ids[] __initconst = {
-	{.compatible = "brcm,kona-timer"},
-	{.compatible = "bcm,kona-timer"}, /* deprecated name */
-	{},
-};
-
 static void __init kona_timers_init(struct device_node *node)
 {
 	u32 freq;
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4b..8c7382b 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -158,7 +158,7 @@ static cycle_t __ttc_clocksource_read(struct clocksource *cs)
 				TTC_COUNT_VAL_OFFSET);
 }
 
-static u32 notrace ttc_sched_clock_read(void)
+static u64 notrace ttc_sched_clock_read(void)
 {
 	return __raw_readl(ttc_sched_clock_val_reg);
 }
@@ -306,7 +306,7 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	}
 
 	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
-	setup_sched_clock(ttc_sched_clock_read, 16,
+	sched_clock_register(ttc_sched_clock_read, 16,
 			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
 }
 
@@ -388,8 +388,7 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	__raw_writel(0x1,  ttcce->ttc.base_addr + TTC_IER_OFFSET);
 
 	err = request_irq(irq, ttc_clock_event_interrupt,
-			  IRQF_DISABLED | IRQF_TIMER,
-			  ttcce->ce.name, ttcce);
+			  IRQF_TIMER, ttcce->ce.name, ttcce);
 	if (WARN_ON(err)) {
 		kfree(ttcce);
 		return;
diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index b9ddd9e..ae2e427 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -28,6 +28,7 @@ void __init clocksource_of_init(void)
 	struct device_node *np;
 	const struct of_device_id *match;
 	clocksource_of_init_fn init_func;
+	unsigned clocksources = 0;
 
 	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
 		if (!of_device_is_available(np))
@@ -35,5 +36,8 @@ void __init clocksource_of_init(void)
 
 		init_func = match->data;
 		init_func(np);
+		clocksources++;
 	}
+	if (!clocksources)
+		pr_crit("%s: no matching clocksources found\n", __func__);
 }
diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index ea21048..db21052 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -131,7 +131,7 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
+	.flags = IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };
 
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index e54ca10..f3656a6 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -243,8 +243,7 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 	dw_ced->irqaction.dev_id	= &dw_ced->ced;
 	dw_ced->irqaction.irq		= irq;
 	dw_ced->irqaction.flags		= IRQF_TIMER | IRQF_IRQPOLL |
-					  IRQF_NOBALANCING |
-					  IRQF_DISABLED;
+					  IRQF_NOBALANCING;
 
 	dw_ced->eoi = apbt_eoi;
 	err = setup_irq(irq, &dw_ced->irqaction);
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index ed7b73b..152a3f3 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -187,7 +187,7 @@ static irqreturn_t nmdk_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction nmdk_timer_irq = {
 	.name		= "Nomadik Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= nmdk_timer_interrupt,
 	.dev_id		= &nmdk_clkevt,
 };
diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index 85082e8..5645cfc 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -264,7 +264,7 @@ static irqreturn_t samsung_clock_event_isr(int irq, void *dev_id)
 
 static struct irqaction samsung_clock_event_irq = {
 	.name		= "samsung_time_irq",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= samsung_clock_event_isr,
 	.dev_id		= &time_event_device,
 };
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 0965e98..0b1836a 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -634,12 +634,18 @@ static int sh_cmt_clock_event_next(unsigned long delta,
 
 static void sh_cmt_clock_event_suspend(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweroff(&ced_to_sh_cmt(ced)->pdev->dev);
+	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+
+	pm_genpd_syscore_poweroff(&p->pdev->dev);
+	clk_unprepare(p->clk);
 }
 
 static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweron(&ced_to_sh_cmt(ced)->pdev->dev);
+	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+
+	clk_prepare(p->clk);
+	pm_genpd_syscore_poweron(&p->pdev->dev);
 }
 
 static void sh_cmt_register_clockevent(struct sh_cmt_priv *p,
@@ -726,8 +732,7 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 	p->irqaction.name = dev_name(&p->pdev->dev);
 	p->irqaction.handler = sh_cmt_interrupt;
 	p->irqaction.dev_id = p;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "cmt_fck");
@@ -737,6 +742,10 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 		goto err2;
 	}
 
+	ret = clk_prepare(p->clk);
+	if (ret < 0)
+		goto err3;
+
 	if (res2 && (resource_size(res2) == 4)) {
 		/* assume both CMSTR and CMCSR to be 32-bit */
 		p->read_control = sh_cmt_read32;
@@ -773,19 +782,21 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 			      cfg->clocksource_rating);
 	if (ret) {
 		dev_err(&p->pdev->dev, "registration failed\n");
-		goto err3;
+		goto err4;
 	}
 	p->cs_enabled = false;
 
 	ret = setup_irq(irq, &p->irqaction);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to request irq %d\n", irq);
-		goto err3;
+		goto err4;
 	}
 
 	platform_set_drvdata(pdev, p);
 
 	return 0;
+err4:
+	clk_unprepare(p->clk);
 err3:
 	clk_put(p->clk);
 err2:
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 3cf1283..e30d76e 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -302,8 +302,7 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_mtu2_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "mtu2_fck");
@@ -358,7 +357,6 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 	ret = sh_mtu2_setup(p, pdev);
 	if (ret) {
 		kfree(p);
-		platform_set_drvdata(pdev, NULL);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 63557cd..ecd7b60 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -462,8 +462,7 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_tmu_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "tmu_fck");
@@ -523,7 +522,6 @@ static int sh_tmu_probe(struct platform_device *pdev)
 	ret = sh_tmu_setup(p, pdev);
 	if (ret) {
 		kfree(p);
-		platform_set_drvdata(pdev, NULL);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index a4f6119..bf497af 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -114,7 +114,7 @@ static int sun4i_clkevt_next_event(unsigned long evt,
 
 static struct clock_event_device sun4i_clockevent = {
 	.name = "sun4i_tick",
-	.rating = 300,
+	.rating = 350,
 	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode = sun4i_clkevt_mode,
 	.set_next_event = sun4i_clkevt_next_event,
@@ -138,7 +138,7 @@ static struct irqaction sun4i_timer_irq = {
 	.dev_id = &sun4i_clockevent,
 };
 
-static u32 sun4i_timer_sched_read(void)
+static u64 notrace sun4i_timer_sched_read(void)
 {
 	return ~readl(timer_base + TIMER_CNTVAL_REG(1));
 }
@@ -170,9 +170,9 @@ static void __init sun4i_timer_init(struct device_node *node)
 	       TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(1));
 
-	setup_sched_clock(sun4i_timer_sched_read, 32, rate);
+	sched_clock_register(sun4i_timer_sched_read, 32, rate);
 	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
-			      rate, 300, 32, clocksource_mmio_readl_down);
+			      rate, 350, 32, clocksource_mmio_readl_down);
 
 	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
 
@@ -190,7 +190,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 	val = readl(timer_base + TIMER_IRQ_EN_REG);
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
 
-	sun4i_clockevent.cpumask = cpumask_of(0);
+	sun4i_clockevent.cpumask = cpu_possible_mask;
+	sun4i_clockevent.irq = irq;
 
 	clockevents_config_and_register(&sun4i_clockevent, rate,
 					TIMER_SYNC_TICKS, 0xffffffff);
diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index 6428492..d1869f0 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -149,7 +149,7 @@ static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction tegra_timer_irq = {
 	.name		= "timer0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_HIGH,
+	.flags		= IRQF_TIMER | IRQF_TRIGGER_HIGH,
 	.handler	= tegra_timer_interrupt,
 	.dev_id		= &tegra_clockevent,
 };
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 4e7f680..ee8691b 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -76,6 +76,7 @@
 static void __iomem *timer_base, *local_base;
 static unsigned int timer_clk;
 static bool timer25Mhz = true;
+static u32 enable_mask;
 
 /*
  * Number of timer ticks per jiffy.
@@ -121,8 +122,7 @@ armada_370_xp_clkevt_next_event(unsigned long delta,
 	/*
 	 * Enable the timer.
 	 */
-	local_timer_ctrl_clrset(TIMER0_RELOAD_EN,
-				TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+	local_timer_ctrl_clrset(TIMER0_RELOAD_EN, enable_mask);
 	return 0;
 }
 
@@ -141,9 +141,7 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 		/*
 		 * Enable timer.
 		 */
-		local_timer_ctrl_clrset(0, TIMER0_RELOAD_EN |
-					   TIMER0_EN |
-					   TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+		local_timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
 	} else {
 		/*
 		 * Disable timer.
@@ -240,10 +238,13 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	WARN_ON(!timer_base);
 	local_base = of_iomap(np, 1);
 
-	if (timer25Mhz)
+	if (timer25Mhz) {
 		set = TIMER0_25MHZ;		
-	else
+		enable_mask = TIMER0_EN;
+	} else {
 		clr = TIMER0_25MHZ;
+		enable_mask = TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT);
+	}
 	timer_ctrl_clrset(clr, set);
 	local_timer_ctrl_clrset(clr, set);
 
@@ -262,8 +263,7 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	writel(0xffffffff, timer_base + TIMER0_VAL_OFF);
 	writel(0xffffffff, timer_base + TIMER0_RELOAD_OFF);
 
-	timer_ctrl_clrset(0, TIMER0_EN | TIMER0_RELOAD_EN |
-			     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+	timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
 
 	/*
 	 * Set scale and timer for sched_clock.
diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index 9c7f018..2006622 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL(orion_timer_ctrl_clrset);
 /*
  * Free-running clocksource handling.
  */
-static u32 notrace orion_read_sched_clock(void)
+static u64 notrace orion_read_sched_clock(void)
 {
 	return ~readl(timer_base + TIMER0_VAL);
 }
@@ -135,7 +135,7 @@ static void __init orion_timer_init(struct device_node *np)
 	clocksource_mmio_init(timer_base + TIMER0_VAL, "orion_clocksource",
 			      clk_get_rate(clk), 300, 32,
 			      clocksource_mmio_readl_down);
-	setup_sched_clock(orion_read_sched_clock, 32, clk_get_rate(clk));
+	sched_clock_register(orion_read_sched_clock, 32, clk_get_rate(clk));
 
 	/* setup timer1 as clockevent timer */
 	if (setup_irq(irq, &orion_clkevt_irq))
diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
new file mode 100644
index 0000000..deebcd6
--- /dev/null
+++ b/drivers/clocksource/timer-sun5i.c
@@ -0,0 +1,192 @@
+/*
+ * Allwinner SoCs hstimer driver.
+ *
+ * Copyright (C) 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqreturn.h>
+#include <linux/sched_clock.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#define TIMER_IRQ_EN_REG		0x00
+#define TIMER_IRQ_EN(val)			BIT(val)
+#define TIMER_IRQ_ST_REG		0x04
+#define TIMER_CTL_REG(val)		(0x20 * (val) + 0x10)
+#define TIMER_CTL_ENABLE			BIT(0)
+#define TIMER_CTL_RELOAD			BIT(1)
+#define TIMER_CTL_CLK_PRES(val)			(((val) & 0x7) << 4)
+#define TIMER_CTL_ONESHOT			BIT(7)
+#define TIMER_INTVAL_LO_REG(val)	(0x20 * (val) + 0x14)
+#define TIMER_INTVAL_HI_REG(val)	(0x20 * (val) + 0x18)
+#define TIMER_CNTVAL_LO_REG(val)	(0x20 * (val) + 0x1c)
+#define TIMER_CNTVAL_HI_REG(val)	(0x20 * (val) + 0x20)
+
+#define TIMER_SYNC_TICKS	3
+
+static void __iomem *timer_base;
+static u32 ticks_per_jiffy;
+
+/*
+ * When we disable a timer, we need to wait at least for 2 cycles of
+ * the timer source clock. We will use for that the clocksource timer
+ * that is already setup and runs at the same frequency than the other
+ * timers, and we never will be disabled.
+ */
+static void sun5i_clkevt_sync(void)
+{
+	u32 old = readl(timer_base + TIMER_CNTVAL_LO_REG(1));
+
+	while ((old - readl(timer_base + TIMER_CNTVAL_LO_REG(1))) < TIMER_SYNC_TICKS)
+		cpu_relax();
+}
+
+static void sun5i_clkevt_time_stop(u8 timer)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
+
+	sun5i_clkevt_sync();
+}
+
+static void sun5i_clkevt_time_setup(u8 timer, u32 delay)
+{
+	writel(delay, timer_base + TIMER_INTVAL_LO_REG(timer));
+}
+
+static void sun5i_clkevt_time_start(u8 timer, bool periodic)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+
+	if (periodic)
+		val &= ~TIMER_CTL_ONESHOT;
+	else
+		val |= TIMER_CTL_ONESHOT;
+
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
+	       timer_base + TIMER_CTL_REG(timer));
+}
+
+static void sun5i_clkevt_mode(enum clock_event_mode mode,
+			      struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		sun5i_clkevt_time_stop(0);
+		sun5i_clkevt_time_setup(0, ticks_per_jiffy);
+		sun5i_clkevt_time_start(0, true);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		sun5i_clkevt_time_stop(0);
+		sun5i_clkevt_time_start(0, false);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		sun5i_clkevt_time_stop(0);
+		break;
+	}
+}
+
+static int sun5i_clkevt_next_event(unsigned long evt,
+				   struct clock_event_device *unused)
+{
+	sun5i_clkevt_time_stop(0);
+	sun5i_clkevt_time_setup(0, evt - TIMER_SYNC_TICKS);
+	sun5i_clkevt_time_start(0, false);
+
+	return 0;
+}
+
+static struct clock_event_device sun5i_clockevent = {
+	.name = "sun5i_tick",
+	.rating = 340,
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode = sun5i_clkevt_mode,
+	.set_next_event = sun5i_clkevt_next_event,
+};
+
+
+static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
+
+	writel(0x1, timer_base + TIMER_IRQ_ST_REG);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction sun5i_timer_irq = {
+	.name = "sun5i_timer0",
+	.flags = IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = sun5i_timer_interrupt,
+	.dev_id = &sun5i_clockevent,
+};
+
+static u64 sun5i_timer_sched_read(void)
+{
+	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
+}
+
+static void __init sun5i_timer_init(struct device_node *node)
+{
+	unsigned long rate;
+	struct clk *clk;
+	int ret, irq;
+	u32 val;
+
+	timer_base = of_iomap(node, 0);
+	if (!timer_base)
+		panic("Can't map registers");
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0)
+		panic("Can't parse IRQ");
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk))
+		panic("Can't get timer clock");
+	clk_prepare_enable(clk);
+	rate = clk_get_rate(clk);
+
+	writel(~0, timer_base + TIMER_INTVAL_LO_REG(1));
+	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
+	       timer_base + TIMER_CTL_REG(1));
+
+	sched_clock_register(sun5i_timer_sched_read, 32, rate);
+	clocksource_mmio_init(timer_base + TIMER_CNTVAL_LO_REG(1), node->name,
+			      rate, 340, 32, clocksource_mmio_readl_down);
+
+	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
+
+	ret = setup_irq(irq, &sun5i_timer_irq);
+	if (ret)
+		pr_warn("failed to setup irq %d\n", irq);
+
+	/* Enable timer0 interrupt */
+	val = readl(timer_base + TIMER_IRQ_EN_REG);
+	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
+
+	sun5i_clockevent.cpumask = cpu_possible_mask;
+	sun5i_clockevent.irq = irq;
+
+	clockevents_config_and_register(&sun5i_clockevent, rate,
+					TIMER_SYNC_TICKS, 0xffffffff);
+}
+CLOCKSOURCE_OF_DECLARE(sun5i_a13, "allwinner,sun5i-a13-hstimer",
+		       sun5i_timer_init);
+CLOCKSOURCE_OF_DECLARE(sun7i_a20, "allwinner,sun7i-a20-hstimer",
+		       sun5i_timer_init);
diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
index ad3c0e8..1098ed3 100644
--- a/drivers/clocksource/vt8500_timer.c
+++ b/drivers/clocksource/vt8500_timer.c
@@ -124,7 +124,7 @@ static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq = {
 	.name    = "vt8500_timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags   = IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = vt8500_timer_interrupt,
 	.dev_id  = &clockevent,
 };
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f148762..a2325bc 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -34,11 +34,11 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
-#include <linux/mod_devicetable.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/dmi.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -377,6 +377,51 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
+/*
+ * Do not disable RTC alarm on shutdown - workaround for b0rked BIOSes.
+ */
+static bool alarm_disable_quirk;
+
+static int __init set_alarm_disable_quirk(const struct dmi_system_id *id)
+{
+	alarm_disable_quirk = true;
+	pr_info("rtc-cmos: BIOS has alarm-disable quirk. ");
+	pr_info("RTC alarms disabled\n");
+	return 0;
+}
+
+static const struct dmi_system_id rtc_quirks[] __initconst = {
+	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "IBM Truman",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
+		},
+	},
+	/* https://bugzilla.novell.com/show_bug.cgi?id=812592 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "Gigabyte GA-990XA-UD3",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA-990XA-UD3"),
+		},
+	},
+	/* http://permalink.gmane.org/gmane.linux.kernel/1604474 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "Toshiba Satellite L300",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite L300"),
+		},
+	},
+	{}
+};
+
 static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -385,6 +430,9 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	if (!is_valid_irq(cmos->irq))
 		return -EINVAL;
 
+	if (alarm_disable_quirk)
+		return 0;
+
 	spin_lock_irqsave(&rtc_lock, flags);
 
 	if (enabled)
@@ -1157,6 +1205,8 @@ static int __init cmos_init(void)
 			platform_driver_registered = true;
 	}
 
+	dmi_check_system(rtc_quirks);
+
 	if (retval == 0)
 		return 0;
 
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 1581587..37b81bd 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -17,13 +17,13 @@ extern void __context_tracking_task_switch(struct task_struct *prev,
 
 static inline void user_enter(void)
 {
-	if (static_key_false(&context_tracking_enabled))
+	if (context_tracking_is_enabled())
 		context_tracking_user_enter();
 
 }
 static inline void user_exit(void)
 {
-	if (static_key_false(&context_tracking_enabled))
+	if (context_tracking_is_enabled())
 		context_tracking_user_exit();
 }
 
@@ -31,7 +31,7 @@ static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
 
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return 0;
 
 	prev_ctx = this_cpu_read(context_tracking.state);
@@ -42,7 +42,7 @@ static inline enum ctx_state exception_enter(void)
 
 static inline void exception_exit(enum ctx_state prev_ctx)
 {
-	if (static_key_false(&context_tracking_enabled)) {
+	if (context_tracking_is_enabled()) {
 		if (prev_ctx == IN_USER)
 			context_tracking_user_enter();
 	}
@@ -51,7 +51,7 @@ static inline void exception_exit(enum ctx_state prev_ctx)
 static inline void context_tracking_task_switch(struct task_struct *prev,
 						struct task_struct *next)
 {
-	if (static_key_false(&context_tracking_enabled))
+	if (context_tracking_is_enabled())
 		__context_tracking_task_switch(prev, next);
 }
 #else
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 0f1979d..97a8122 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -22,15 +22,20 @@ struct context_tracking {
 extern struct static_key context_tracking_enabled;
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
-static inline bool context_tracking_in_user(void)
+static inline bool context_tracking_is_enabled(void)
 {
-	return __this_cpu_read(context_tracking.state) == IN_USER;
+	return static_key_false(&context_tracking_enabled);
 }
 
-static inline bool context_tracking_active(void)
+static inline bool context_tracking_cpu_is_enabled(void)
 {
 	return __this_cpu_read(context_tracking.active);
 }
+
+static inline bool context_tracking_in_user(void)
+{
+	return __this_cpu_read(context_tracking.state) == IN_USER;
+}
 #else
 static inline bool context_tracking_in_user(void) { return false; }
 static inline bool context_tracking_active(void) { return false; }
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5128d33..0175d86 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -104,7 +104,7 @@ extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
-extern void tick_check_idle(int cpu);
+extern void tick_check_idle(void);
 extern int tick_oneshot_mode_active(void);
 #  ifndef arch_needs_cpu
 #   define arch_needs_cpu(cpu) (0)
@@ -112,7 +112,7 @@ extern int tick_oneshot_mode_active(void);
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(int cpu) { }
+static inline void tick_check_idle(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 # endif
 
@@ -121,7 +121,7 @@ static inline void tick_init(void) { }
 static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(int cpu) { }
+static inline void tick_check_idle(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
@@ -165,7 +165,7 @@ extern cpumask_var_t tick_nohz_full_mask;
 
 static inline bool tick_nohz_full_enabled(void)
 {
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return false;
 
 	return tick_nohz_full_running;
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index f5b72b3..c5165fd 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -19,8 +19,8 @@ static inline bool vtime_accounting_enabled(void) { return true; }
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static inline bool vtime_accounting_enabled(void)
 {
-	if (static_key_false(&context_tracking_enabled)) {
-		if (context_tracking_active())
+	if (context_tracking_is_enabled()) {
+		if (context_tracking_cpu_is_enabled())
 			return true;
 	}
 
diff --git a/init/Kconfig b/init/Kconfig
index 4e5d96a..5236dc5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -532,7 +532,7 @@ config CONTEXT_TRACKING_FORCE
 	  dynticks subsystem by forcing the context tracking on all
 	  CPUs in the system.
 
-	  Say Y only if you're working on the developpement of an
+	  Say Y only if you're working on the development of an
 	  architecture backend for the context tracking.
 
 	  Say N otherwise, this option brings an overhead that you
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index e5f3917..6cb20d2 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -53,10 +53,10 @@ void context_tracking_user_enter(void)
 	/*
 	 * Repeat the user_enter() check here because some archs may be calling
 	 * this from asm and if no CPU needs context tracking, they shouldn't
-	 * go further. Repeat the check here until they support the static key
-	 * check.
+	 * go further. Repeat the check here until they support the inline static
+	 * key check.
 	 */
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return;
 
 	/*
@@ -160,7 +160,7 @@ void context_tracking_user_exit(void)
 {
 	unsigned long flags;
 
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return;
 
 	if (in_interrupt())
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c7f31aa..3b89464 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -233,7 +233,8 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 
 /*
  * Sample a process (thread group) clock for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
+ * Must be called with task sighand lock held for safe while_each_thread()
+ * traversal.
  */
 static int cpu_clock_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
@@ -260,30 +261,53 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	return 0;
 }
 
+static int posix_cpu_clock_get_task(struct task_struct *tsk,
+				    const clockid_t which_clock,
+				    struct timespec *tp)
+{
+	int err = -EINVAL;
+	unsigned long long rtn;
+
+	if (CPUCLOCK_PERTHREAD(which_clock)) {
+		if (same_thread_group(tsk, current))
+			err = cpu_clock_sample(which_clock, tsk, &rtn);
+	} else {
+		unsigned long flags;
+		struct sighand_struct *sighand;
+
+		/*
+		 * while_each_thread() is not yet entirely RCU safe,
+		 * keep locking the group while sampling process
+		 * clock for now.
+		 */
+		sighand = lock_task_sighand(tsk, &flags);
+		if (!sighand)
+			return err;
+
+		if (tsk == current || thread_group_leader(tsk))
+			err = cpu_clock_sample_group(which_clock, tsk, &rtn);
+
+		unlock_task_sighand(tsk, &flags);
+	}
+
+	if (!err)
+		sample_to_timespec(which_clock, rtn, tp);
+
+	return err;
+}
+
 
 static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
-	int error = -EINVAL;
-	unsigned long long rtn;
+	int err = -EINVAL;
 
 	if (pid == 0) {
 		/*
 		 * Special case constant value for our own clocks.
 		 * We don't have to do any lookup to find ourselves.
 		 */
-		if (CPUCLOCK_PERTHREAD(which_clock)) {
-			/*
-			 * Sampling just ourselves we can do with no locking.
-			 */
-			error = cpu_clock_sample(which_clock,
-						 current, &rtn);
-		} else {
-			read_lock(&tasklist_lock);
-			error = cpu_clock_sample_group(which_clock,
-						       current, &rtn);
-			read_unlock(&tasklist_lock);
-		}
+		err = posix_cpu_clock_get_task(current, which_clock, tp);
 	} else {
 		/*
 		 * Find the given PID, and validate that the caller
@@ -292,29 +316,12 @@ static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 		struct task_struct *p;
 		rcu_read_lock();
 		p = find_task_by_vpid(pid);
-		if (p) {
-			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
-					error = cpu_clock_sample(which_clock,
-								 p, &rtn);
-				}
-			} else {
-				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->sighand) {
-					error =
-					    cpu_clock_sample_group(which_clock,
-							           p, &rtn);
-				}
-				read_unlock(&tasklist_lock);
-			}
-		}
+		if (p)
+			err = posix_cpu_clock_get_task(p, which_clock, tp);
 		rcu_read_unlock();
 	}
 
-	if (error)
-		return error;
-	sample_to_timespec(which_clock, rtn, tp);
-	return 0;
+	return err;
 }
 
 
@@ -371,36 +378,40 @@ static int posix_cpu_timer_create(struct k_itimer *new_timer)
  */
 static int posix_cpu_timer_del(struct k_itimer *timer)
 {
-	struct task_struct *p = timer->it.cpu.task;
 	int ret = 0;
+	unsigned long flags;
+	struct sighand_struct *sighand;
+	struct task_struct *p = timer->it.cpu.task;
 
-	if (likely(p != NULL)) {
-		read_lock(&tasklist_lock);
-		if (unlikely(p->sighand == NULL)) {
-			/*
-			 * We raced with the reaping of the task.
-			 * The deletion should have cleared us off the list.
-			 */
-			BUG_ON(!list_empty(&timer->it.cpu.entry));
-		} else {
-			spin_lock(&p->sighand->siglock);
-			if (timer->it.cpu.firing)
-				ret = TIMER_RETRY;
-			else
-				list_del(&timer->it.cpu.entry);
-			spin_unlock(&p->sighand->siglock);
-		}
-		read_unlock(&tasklist_lock);
+	WARN_ON_ONCE(p == NULL);
 
-		if (!ret)
-			put_task_struct(p);
+	/*
+	 * Protect against sighand release/switch in exit/exec and process/
+	 * thread timer list entry concurrent read/writes.
+	 */
+	sighand = lock_task_sighand(p, &flags);
+	if (unlikely(sighand == NULL)) {
+		/*
+		 * We raced with the reaping of the task.
+		 * The deletion should have cleared us off the list.
+		 */
+		WARN_ON_ONCE(!list_empty(&timer->it.cpu.entry));
+	} else {
+		if (timer->it.cpu.firing)
+			ret = TIMER_RETRY;
+		else
+			list_del(&timer->it.cpu.entry);
+
+		unlock_task_sighand(p, &flags);
 	}
 
+	if (!ret)
+		put_task_struct(p);
+
 	return ret;
 }
 
-static void cleanup_timers_list(struct list_head *head,
-				unsigned long long curr)
+static void cleanup_timers_list(struct list_head *head)
 {
 	struct cpu_timer_list *timer, *next;
 
@@ -414,16 +425,11 @@ static void cleanup_timers_list(struct list_head *head,
  * time for later timer_gettime calls to return.
  * This must be called with the siglock held.
  */
-static void cleanup_timers(struct list_head *head,
-			   cputime_t utime, cputime_t stime,
-			   unsigned long long sum_exec_runtime)
+static void cleanup_timers(struct list_head *head)
 {
-
-	cputime_t ptime = utime + stime;
-
-	cleanup_timers_list(head, cputime_to_expires(ptime));
-	cleanup_timers_list(++head, cputime_to_expires(utime));
-	cleanup_timers_list(++head, sum_exec_runtime);
+	cleanup_timers_list(head);
+	cleanup_timers_list(++head);
+	cleanup_timers_list(++head);
 }
 
 /*
@@ -433,41 +439,14 @@ static void cleanup_timers(struct list_head *head,
  */
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
-	cputime_t utime, stime;
-
 	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
 						sizeof(unsigned long long));
-	task_cputime(tsk, &utime, &stime);
-	cleanup_timers(tsk->cpu_timers,
-		       utime, stime, tsk->se.sum_exec_runtime);
+	cleanup_timers(tsk->cpu_timers);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, stime;
-
-	task_cputime(tsk, &utime, &stime);
-	cleanup_timers(tsk->signal->cpu_timers,
-		       utime + sig->utime, stime + sig->stime,
-		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
-}
-
-static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
-{
-	struct cpu_timer_list *timer = &itimer->it.cpu;
-
-	/*
-	 * That's all for this thread or process.
-	 * We leave our residual in expires to be reported.
-	 */
-	put_task_struct(timer->task);
-	timer->task = NULL;
-	if (timer->expires < now) {
-		timer->expires = 0;
-	} else {
-		timer->expires -= now;
-	}
+	cleanup_timers(tsk->signal->cpu_timers);
 }
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
@@ -477,8 +456,7 @@ static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 
 /*
  * Insert the timer on the appropriate list before any timers that
- * expire later.  This must be called with the tasklist_lock held
- * for reading, interrupts disabled and p->sighand->siglock taken.
+ * expire later.  This must be called with the sighand lock held.
  */
 static void arm_timer(struct k_itimer *timer)
 {
@@ -569,7 +547,8 @@ static void cpu_timer_fire(struct k_itimer *timer)
 
 /*
  * Sample a process (thread group) timer for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
+ * Must be called with task sighand lock held for safe while_each_thread()
+ * traversal.
  */
 static int cpu_timer_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
@@ -608,7 +587,8 @@ static DECLARE_WORK(nohz_kick_work, nohz_kick_work_fn);
  */
 static void posix_cpu_timer_kick_nohz(void)
 {
-	schedule_work(&nohz_kick_work);
+	if (context_tracking_is_enabled())
+		schedule_work(&nohz_kick_work);
 }
 
 bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk)
@@ -631,43 +611,39 @@ static inline void posix_cpu_timer_kick_nohz(void) { }
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
+static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 			       struct itimerspec *new, struct itimerspec *old)
 {
+	unsigned long flags;
+	struct sighand_struct *sighand;
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long old_expires, new_expires, old_incr, val;
 	int ret;
 
-	if (unlikely(p == NULL)) {
-		/*
-		 * Timer refers to a dead task's clock.
-		 */
-		return -ESRCH;
-	}
+	WARN_ON_ONCE(p == NULL);
 
 	new_expires = timespec_to_sample(timer->it_clock, &new->it_value);
 
-	read_lock(&tasklist_lock);
 	/*
-	 * We need the tasklist_lock to protect against reaping that
-	 * clears p->sighand.  If p has just been reaped, we can no
+	 * Protect against sighand release/switch in exit/exec and p->cpu_timers
+	 * and p->signal->cpu_timers read/write in arm_timer()
+	 */
+	sighand = lock_task_sighand(p, &flags);
+	/*
+	 * If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
-	if (unlikely(p->sighand == NULL)) {
-		read_unlock(&tasklist_lock);
-		put_task_struct(p);
-		timer->it.cpu.task = NULL;
+	if (unlikely(sighand == NULL)) {
 		return -ESRCH;
 	}
 
 	/*
 	 * Disarm any old timer after extracting its expiry time.
 	 */
-	BUG_ON(!irqs_disabled());
+	WARN_ON_ONCE(!irqs_disabled());
 
 	ret = 0;
 	old_incr = timer->it.cpu.incr;
-	spin_lock(&p->sighand->siglock);
 	old_expires = timer->it.cpu.expires;
 	if (unlikely(timer->it.cpu.firing)) {
 		timer->it.cpu.firing = -1;
@@ -724,12 +700,11 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		 * disable this firing since we are already reporting
 		 * it as an overrun (thanks to bump_cpu_timer above).
 		 */
-		spin_unlock(&p->sighand->siglock);
-		read_unlock(&tasklist_lock);
+		unlock_task_sighand(p, &flags);
 		goto out;
 	}
 
-	if (new_expires != 0 && !(flags & TIMER_ABSTIME)) {
+	if (new_expires != 0 && !(timer_flags & TIMER_ABSTIME)) {
 		new_expires += val;
 	}
 
@@ -743,9 +718,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		arm_timer(timer);
 	}
 
-	spin_unlock(&p->sighand->siglock);
-	read_unlock(&tasklist_lock);
-
+	unlock_task_sighand(p, &flags);
 	/*
 	 * Install the new reload setting, and
 	 * set up the signal and overrun bookkeeping.
@@ -787,7 +760,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
 	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
-	int clear_dead;
+
+	WARN_ON_ONCE(p == NULL);
 
 	/*
 	 * Easy part: convert the reload time.
@@ -800,52 +774,34 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		return;
 	}
 
-	if (unlikely(p == NULL)) {
-		/*
-		 * This task already died and the timer will never fire.
-		 * In this case, expires is actually the dead value.
-		 */
-	dead:
-		sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
-				   &itp->it_value);
-		return;
-	}
-
 	/*
 	 * Sample the clock to take the difference with the expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
-		clear_dead = p->exit_state;
 	} else {
-		read_lock(&tasklist_lock);
-		if (unlikely(p->sighand == NULL)) {
+		struct sighand_struct *sighand;
+		unsigned long flags;
+
+		/*
+		 * Protect against sighand release/switch in exit/exec and
+		 * also make timer sampling safe if it ends up calling
+		 * thread_group_cputime().
+		 */
+		sighand = lock_task_sighand(p, &flags);
+		if (unlikely(sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
 			 * Call the timer disarmed, nothing else to do.
 			 */
-			put_task_struct(p);
-			timer->it.cpu.task = NULL;
 			timer->it.cpu.expires = 0;
-			read_unlock(&tasklist_lock);
-			goto dead;
+			sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
+					   &itp->it_value);
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead = (unlikely(p->exit_state) &&
-				      thread_group_empty(p));
+			unlock_task_sighand(p, &flags);
 		}
-		read_unlock(&tasklist_lock);
-	}
-
-	if (unlikely(clear_dead)) {
-		/*
-		 * We've noticed that the thread is dead, but
-		 * not yet reaped.  Take this opportunity to
-		 * drop our task ref.
-		 */
-		clear_dead_task(timer, now);
-		goto dead;
 	}
 
 	if (now < timer->it.cpu.expires) {
@@ -1059,14 +1015,12 @@ static void check_process_timers(struct task_struct *tsk,
  */
 void posix_cpu_timer_schedule(struct k_itimer *timer)
 {
+	struct sighand_struct *sighand;
+	unsigned long flags;
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long now;
 
-	if (unlikely(p == NULL))
-		/*
-		 * The task was cleaned up already, no future firings.
-		 */
-		goto out;
+	WARN_ON_ONCE(p == NULL);
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
@@ -1074,49 +1028,45 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
-		if (unlikely(p->exit_state)) {
-			clear_dead_task(timer, now);
+		if (unlikely(p->exit_state))
+			goto out;
+
+		/* Protect timer list r/w in arm_timer() */
+		sighand = lock_task_sighand(p, &flags);
+		if (!sighand)
 			goto out;
-		}
-		read_lock(&tasklist_lock); /* arm_timer needs it.  */
-		spin_lock(&p->sighand->siglock);
 	} else {
-		read_lock(&tasklist_lock);
-		if (unlikely(p->sighand == NULL)) {
+		/*
+		 * Protect arm_timer() and timer sampling in case of call to
+		 * thread_group_cputime().
+		 */
+		sighand = lock_task_sighand(p, &flags);
+		if (unlikely(sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
 			 */
-			put_task_struct(p);
-			timer->it.cpu.task = p = NULL;
 			timer->it.cpu.expires = 0;
-			goto out_unlock;
+			goto out;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
-			/*
-			 * We've noticed that the thread is dead, but
-			 * not yet reaped.  Take this opportunity to
-			 * drop our task ref.
-			 */
-			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead_task(timer, now);
-			goto out_unlock;
+			unlock_task_sighand(p, &flags);
+			/* Optimizations: if the process is dying, no need to rearm */
+			goto out;
 		}
-		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
-		/* Leave the tasklist_lock locked for the call below.  */
+		/* Leave the sighand locked for the call below.  */
 	}
 
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
-	BUG_ON(!irqs_disabled());
+	WARN_ON_ONCE(!irqs_disabled());
 	arm_timer(timer);
-	spin_unlock(&p->sighand->siglock);
-
-out_unlock:
-	read_unlock(&tasklist_lock);
+	unlock_task_sighand(p, &flags);
 
+	/* Kick full dynticks CPUs in case they need to tick on the new timer */
+	posix_cpu_timer_kick_nohz();
 out:
 	timer->it_overrun_last = timer->it_overrun;
 	timer->it_overrun = -1;
@@ -1200,7 +1150,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	struct k_itimer *timer, *next;
 	unsigned long flags;
 
-	BUG_ON(!irqs_disabled());
+	WARN_ON_ONCE(!irqs_disabled());
 
 	/*
 	 * The fast path checks that there are no expired thread or thread
@@ -1256,13 +1206,6 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 			cpu_timer_fire(timer);
 		spin_unlock(&timer->it_lock);
 	}
-
-	/*
-	 * In case some timers were rescheduled after the queue got emptied,
-	 * wake up full dynticks CPUs.
-	 */
-	if (tsk->signal->cputimer.running)
-		posix_cpu_timer_kick_nohz();
 }
 
 /*
@@ -1274,7 +1217,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 {
 	unsigned long long now;
 
-	BUG_ON(clock_idx == CPUCLOCK_SCHED);
+	WARN_ON_ONCE(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11025cc..11348de 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -311,8 +311,6 @@ asmlinkage void do_softirq(void)
  */
 void irq_enter(void)
 {
-	int cpu = smp_processor_id();
-
 	rcu_irq_enter();
 	if (is_idle_task(current) && !in_interrupt()) {
 		/*
@@ -320,7 +318,7 @@ void irq_enter(void)
 		 * here, as softirq will be serviced on return from interrupt.
 		 */
 		local_bh_disable();
-		tick_check_idle(cpu);
+		tick_check_idle();
 		_local_bh_enable();
 	}
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9532690..43780ab 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -538,10 +538,10 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
  * Called from irq_enter() when idle was interrupted to reenable the
  * per cpu device.
  */
-void tick_check_oneshot_broadcast(int cpu)
+void tick_check_oneshot_broadcast_this_cpu(void)
 {
-	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
+	if (cpumask_test_cpu(smp_processor_id(), tick_broadcast_oneshot_mask)) {
+		struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 
 		/*
 		 * We might be in the middle of switching over from
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 162b03a..20b2fe3 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -85,6 +85,7 @@ static void tick_periodic(int cpu)
 
 		do_timer(1);
 		write_sequnlock(&jiffies_lock);
+		update_wall_time();
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 18e71f7..8329669 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -51,7 +51,7 @@ extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
-extern void tick_check_oneshot_broadcast(int cpu);
+extern void tick_check_oneshot_broadcast_this_cpu(void);
 bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
@@ -62,7 +62,7 @@ static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
-static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline void tick_check_oneshot_broadcast_this_cpu(void) { }
 static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
@@ -155,3 +155,4 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 #endif
 
 extern void do_timer(unsigned long ticks);
+extern void update_wall_time(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ea20f7d..0ddd020 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -86,6 +86,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&jiffies_lock);
+	update_wall_time();
 }
 
 /*
@@ -391,11 +392,9 @@ __setup("nohz=", setup_tick_nohz);
  */
 static void tick_nohz_update_jiffies(ktime_t now)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
 
-	ts->idle_waketime = now;
+	__this_cpu_write(tick_cpu_sched.idle_waketime, now);
 
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
@@ -426,17 +425,15 @@ update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_upda
 
 }
 
-static void tick_nohz_stop_idle(int cpu, ktime_t now)
+static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-
-	update_ts_time_stats(cpu, ts, now, NULL);
+	update_ts_time_stats(smp_processor_id(), ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
 }
 
-static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
+static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
@@ -754,7 +751,7 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 	ktime_t now, expires;
 	int cpu = smp_processor_id();
 
-	now = tick_nohz_start_idle(cpu, ts);
+	now = tick_nohz_start_idle(ts);
 
 	if (can_stop_idle_tick(cpu, ts)) {
 		int was_stopped = ts->tick_stopped;
@@ -911,8 +908,7 @@ static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
  */
 void tick_nohz_idle_exit(void)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
 
 	local_irq_disable();
@@ -925,7 +921,7 @@ void tick_nohz_idle_exit(void)
 		now = ktime_get();
 
 	if (ts->idle_active)
-		tick_nohz_stop_idle(cpu, now);
+		tick_nohz_stop_idle(ts, now);
 
 	if (ts->tick_stopped) {
 		tick_nohz_restart_sched_tick(ts, now);
@@ -1009,12 +1005,10 @@ static void tick_nohz_switch_to_nohz(void)
  * timer and do not touch the other magic bits which need to be done
  * when idle is left.
  */
-static void tick_nohz_kick_tick(int cpu, ktime_t now)
+static void tick_nohz_kick_tick(struct tick_sched *ts, ktime_t now)
 {
 #if 0
 	/* Switch back to 2.6.27 behaviour */
-
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t delta;
 
 	/*
@@ -1029,36 +1023,36 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
 #endif
 }
 
-static inline void tick_check_nohz(int cpu)
+static inline void tick_check_nohz_this_cpu(void)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
 		return;
 	now = ktime_get();
 	if (ts->idle_active)
-		tick_nohz_stop_idle(cpu, now);
+		tick_nohz_stop_idle(ts, now);
 	if (ts->tick_stopped) {
 		tick_nohz_update_jiffies(now);
-		tick_nohz_kick_tick(cpu, now);
+		tick_nohz_kick_tick(ts, now);
 	}
 }
 
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
-static inline void tick_check_nohz(int cpu) { }
+static inline void tick_check_nohz_this_cpu(void) { }
 
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
  */
-void tick_check_idle(int cpu)
+void tick_check_idle(void)
 {
-	tick_check_oneshot_broadcast(cpu);
-	tick_check_nohz(cpu);
+	tick_check_oneshot_broadcast_this_cpu();
+	tick_check_nohz_this_cpu();
 }
 
 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 87b4f00..0aa4ce8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -77,7 +77,7 @@ static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
 	tk->wall_to_monotonic = wtm;
 	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
 	tk->offs_real = timespec_to_ktime(tmp);
-	tk->offs_tai = ktime_sub(tk->offs_real, ktime_set(tk->tai_offset, 0));
+	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
 
 static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
@@ -90,8 +90,9 @@ static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
 }
 
 /**
- * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ * tk_setup_internals - Set up internals to use clocksource clock.
  *
+ * @tk:		The target timekeeper to setup.
  * @clock:		Pointer to clocksource.
  *
  * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
@@ -595,7 +596,7 @@ s32 timekeeping_get_tai_offset(void)
 static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
 {
 	tk->tai_offset = tai_offset;
-	tk->offs_tai = ktime_sub(tk->offs_real, ktime_set(tai_offset, 0));
+	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tai_offset, 0));
 }
 
 /**
@@ -610,6 +611,7 @@ void timekeeping_set_tai_offset(s32 tai_offset)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 	__timekeeping_set_tai_offset(tk, tai_offset);
+	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
@@ -1023,6 +1025,8 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
+
+	timekeeping_update(tk, TK_MIRROR);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1130,16 +1134,6 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 		 * we can adjust by 1.
 		 */
 		error >>= 2;
-		/*
-		 * XXX - In update_wall_time, we round up to the next
-		 * nanosecond, and store the amount rounded up into
-		 * the error. This causes the likely below to be unlikely.
-		 *
-		 * The proper fix is to avoid rounding up by using
-		 * the high precision tk->xtime_nsec instead of
-		 * xtime.tv_nsec everywhere. Fixing this will take some
-		 * time.
-		 */
 		if (likely(error <= interval))
 			adj = 1;
 		else
@@ -1255,7 +1249,7 @@ out_adjust:
 static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
-	unsigned int action = 0;
+	unsigned int clock_set = 0;
 
 	while (tk->xtime_nsec >= nsecps) {
 		int leap;
@@ -1277,11 +1271,10 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
-			clock_was_set_delayed();
-			action = TK_CLOCK_WAS_SET;
+			clock_set = TK_CLOCK_WAS_SET;
 		}
 	}
-	return action;
+	return clock_set;
 }
 
 /**
@@ -1294,7 +1287,8 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
  * Returns the unconsumed cycles.
  */
 static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
-						u32 shift)
+						u32 shift,
+						unsigned int *clock_set)
 {
 	cycle_t interval = tk->cycle_interval << shift;
 	u64 raw_nsecs;
@@ -1308,7 +1302,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->cycle_last += interval;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
-	accumulate_nsecs_to_secs(tk);
+	*clock_set |= accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
 	raw_nsecs = (u64)tk->raw_interval << shift;
@@ -1359,14 +1353,14 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
  */
-static void update_wall_time(void)
+void update_wall_time(void)
 {
 	struct clocksource *clock;
 	struct timekeeper *real_tk = &timekeeper;
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
-	unsigned int action;
+	unsigned int clock_set = 0;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1401,7 +1395,8 @@ static void update_wall_time(void)
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= tk->cycle_interval) {
-		offset = logarithmic_accumulation(tk, offset, shift);
+		offset = logarithmic_accumulation(tk, offset, shift,
+							&clock_set);
 		if (offset < tk->cycle_interval<<shift)
 			shift--;
 	}
@@ -1419,7 +1414,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	action = accumulate_nsecs_to_secs(tk);
+	clock_set |= accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
@@ -1435,10 +1430,12 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, action);
+	timekeeping_update(real_tk, clock_set);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+	if (clock_set)
+		clock_was_set();
 }
 
 /**
@@ -1583,7 +1580,6 @@ struct timespec get_monotonic_coarse(void)
 void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
-	update_wall_time();
 	calc_global_load(ticks);
 }
 
@@ -1698,12 +1694,14 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
-		update_pvclock_gtod(tk, true);
-		clock_was_set_delayed();
+		timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	}
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
+	if (tai != orig_tai)
+		clock_was_set();
+
 	ntp_notify_cmos_timer();
 
 	return ret;
@@ -1739,4 +1737,5 @@ void xtime_update(unsigned long ticks)
 	write_seqlock(&jiffies_lock);
 	do_timer(ticks);
 	write_sequnlock(&jiffies_lock);
+	update_wall_time();
 }
