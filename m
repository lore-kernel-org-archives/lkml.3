Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBJB7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:59:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:35938 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBJB7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:59:42 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <tony@atomide.com>,
        <egtvedt@samfundet.no>, <linux@prisktech.co.nz>,
        <geert@linux-m68k.org>, <David.Laight@ACULAB.COM>,
        <daniel.lezcano@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <x86@kernel.org>, Yijing Wang <wangyijing@huawei.com>
Subject: [Update][PATCH 2/2] clocksource: Make clocksource register functions void
Date: Mon, 10 Feb 2014 09:58:35 +0800
Message-ID: <1391997515-57736-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, clocksource_register() and __clocksource_register_scale()
functions always return 0, it's pointless, make functions void.
And remove the dead code that check the clocksource_register_hz()
return value.

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/arm/mach-davinci/time.c                    |    5 ++---
 arch/arm/mach-msm/timer.c                       |    4 +---
 arch/arm/mach-omap2/timer.c                     |    8 +++-----
 arch/avr32/kernel/time.c                        |    4 +---
 arch/blackfin/kernel/time-ts.c                  |    6 ++----
 arch/microblaze/kernel/timer.c                  |    3 +--
 arch/mips/jz4740/time.c                         |    6 +-----
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    3 ++-
 arch/openrisc/kernel/time.c                     |    3 +--
 arch/powerpc/kernel/time.c                      |    6 +-----
 arch/um/kernel/time.c                           |    6 +-----
 arch/x86/platform/uv/uv_time.c                  |   14 ++++++--------
 drivers/clocksource/acpi_pm.c                   |    3 ++-
 drivers/clocksource/cadence_ttc_timer.c         |    6 +-----
 drivers/clocksource/exynos_mct.c                |    4 +---
 drivers/clocksource/i8253.c                     |    3 ++-
 drivers/clocksource/mmio.c                      |    3 ++-
 drivers/clocksource/samsung_pwm_timer.c         |    5 +----
 drivers/clocksource/scx200_hrt.c                |    3 ++-
 drivers/clocksource/tcb_clksrc.c                |    8 +-------
 drivers/clocksource/timer-marco.c               |    2 +-
 drivers/clocksource/timer-prima2.c              |    2 +-
 drivers/clocksource/vt8500_timer.c              |    4 +---
 include/linux/clocksource.h                     |    8 ++++----
 kernel/time/clocksource.c                       |    6 ++----
 kernel/time/jiffies.c                           |    3 ++-
 26 files changed, 45 insertions(+), 83 deletions(-)

diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 24ad30f..92b772f 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -387,9 +387,8 @@ void __init davinci_timer_init(void)
 
 	/* setup clocksource */
 	clocksource_davinci.name = id_to_name[clocksource_id];
-	if (clocksource_register_hz(&clocksource_davinci,
-				    davinci_clock_tick_rate))
-		printk(err, clocksource_davinci.name);
+	clocksource_register_hz(&clocksource_davinci,
+				    davinci_clock_tick_rate);
 
 	sched_clock_register(davinci_read_sched_clock, 32,
 			  davinci_clock_tick_rate);
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index fd16449..ab485bc 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -226,9 +226,7 @@ static void __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
 
 err:
 	writel_relaxed(TIMER_ENABLE_EN, source_base + TIMER_ENABLE);
-	res = clocksource_register_hz(cs, dgt_hz);
-	if (res)
-		pr_err("clocksource_register failed\n");
+	clocksource_register_hz(cs, dgt_hz);
 	sched_clock_register(msm_sched_clock_read, sched_bits, dgt_hz);
 }
 
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 74044aa..032e1da 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -473,11 +473,9 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 				   OMAP_TIMER_NONPOSTED);
 	sched_clock_register(dmtimer_read_sched_clock, 32, clksrc.rate);
 
-	if (clocksource_register_hz(&clocksource_gpt, clksrc.rate))
-		pr_err("Could not register clocksource %s\n",
-			clocksource_gpt.name);
-	else
-		pr_info("OMAP clocksource: %s at %lu Hz\n",
+	clocksource_register_hz(&clocksource_gpt, clksrc.rate);
+
+	pr_info("OMAP clocksource: %s at %lu Hz\n",
 			clocksource_gpt.name, clksrc.rate);
 }
 
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index d0f771b..51b4a66 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -134,9 +134,7 @@ void __init time_init(void)
 
 	/* figure rate for counter */
 	counter_hz = clk_get_rate(boot_cpu_data.clk);
-	ret = clocksource_register_hz(&counter, counter_hz);
-	if (ret)
-		pr_debug("timer: could not register clocksource: %d\n", ret);
+	clocksource_register_hz(&counter, counter_hz);
 
 	/* setup COMPARE clockevent */
 	comparator.mult = div_sc(counter_hz, NSEC_PER_SEC, comparator.shift);
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index cb0a484..df3bb08 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -51,8 +51,7 @@ static inline unsigned long long bfin_cs_cycles_sched_clock(void)
 
 static int __init bfin_cs_cycles_init(void)
 {
-	if (clocksource_register_hz(&bfin_cs_cycles, get_cclk()))
-		panic("failed to register clocksource");
+	clocksource_register_hz(&bfin_cs_cycles, get_cclk());
 
 	return 0;
 }
@@ -103,8 +102,7 @@ static int __init bfin_cs_gptimer0_init(void)
 {
 	setup_gptimer0();
 
-	if (clocksource_register_hz(&bfin_cs_gptimer0, get_sclk()))
-		panic("failed to register clocksource");
+	clocksource_register_hz(&bfin_cs_gptimer0, get_sclk());
 
 	return 0;
 }
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index fb0c614..5b8ec44 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -213,8 +213,7 @@ static struct clocksource clocksource_microblaze = {
 
 static int __init xilinx_clocksource_init(void)
 {
-	if (clocksource_register_hz(&clocksource_microblaze, timer_clock_freq))
-		panic("failed to register clocksource");
+	clocksource_register_hz(&clocksource_microblaze, timer_clock_freq);
 
 	/* stop timer1 */
 	out_be32(timer_baseaddr + TCSR1,
diff --git a/arch/mips/jz4740/time.c b/arch/mips/jz4740/time.c
index 5e430ce..041cdff 100644
--- a/arch/mips/jz4740/time.c
+++ b/arch/mips/jz4740/time.c
@@ -105,7 +105,6 @@ static struct irqaction timer_irqaction = {
 
 void __init plat_time_init(void)
 {
-	int ret;
 	uint32_t clk_rate;
 	uint16_t ctrl;
 
@@ -121,10 +120,7 @@ void __init plat_time_init(void)
 
 	clockevents_register_device(&jz4740_clockevent);
 
-	ret = clocksource_register_hz(&jz4740_clocksource, clk_rate);
-
-	if (ret)
-		printk(KERN_ERR "Failed to register clocksource: %d\n", ret);
+	clocksource_register_hz(&jz4740_clocksource, clk_rate);
 
 	setup_irq(JZ4740_IRQ_TCU0, &timer_irqaction);
 
diff --git a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
index c639b9d..9fa6d99 100644
--- a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
+++ b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
@@ -208,7 +208,8 @@ int __init init_mfgpt_clocksource(void)
 	if (num_possible_cpus() > 1)	/* MFGPT does not scale! */
 		return 0;
 
-	return clocksource_register_hz(&clocksource_mfgpt, MFGPT_TICK_RATE);
+	clocksource_register_hz(&clocksource_mfgpt, MFGPT_TICK_RATE);
+	return 0;
 }
 
 arch_initcall(init_mfgpt_clocksource);
diff --git a/arch/openrisc/kernel/time.c b/arch/openrisc/kernel/time.c
index 7c52e94..3f789aa 100644
--- a/arch/openrisc/kernel/time.c
+++ b/arch/openrisc/kernel/time.c
@@ -156,8 +156,7 @@ static struct clocksource openrisc_timer = {
 
 static int __init openrisc_timer_init(void)
 {
-	if (clocksource_register_hz(&openrisc_timer, cpuinfo.clock_frequency))
-		panic("failed to register clocksource");
+	clocksource_register_hz(&openrisc_timer, cpuinfo.clock_frequency);
 
 	/* Enable the incrementer: 'continuous' mode with interrupt disabled */
 	mtspr(SPR_TTMR, SPR_TTMR_CR);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b3dab20..2e66b6f 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -792,11 +792,7 @@ static void __init clocksource_init(void)
 	else
 		clock = &clocksource_timebase;
 
-	if (clocksource_register_hz(clock, tb_ticks_per_sec)) {
-		printk(KERN_ERR "clocksource: %s is already registered\n",
-		       clock->name);
-		return;
-	}
+	clocksource_register_hz(clock, tb_ticks_per_sec);
 
 	printk(KERN_INFO "clocksource: %s mult[%x] shift[%d] registered\n",
 	       clock->name, clock->mult, clock->shift);
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 117568d..2034b58 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -92,11 +92,7 @@ static void __init setup_itimer(void)
 		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
 	itimer_clockevent.min_delta_ns =
 		clockevent_delta2ns(1, &itimer_clockevent);
-	err = clocksource_register_hz(&itimer_clocksource, USEC_PER_SEC);
-	if (err) {
-		printk(KERN_ERR "clocksource_register_hz returned %d\n", err);
-		return;
-	}
+	clocksource_register_hz(&itimer_clocksource, USEC_PER_SEC);
 	clockevents_register_device(&itimer_clockevent);
 }
 
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 5c86786..b963774 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -379,15 +379,13 @@ static __init int uv_rtc_setup_clock(void)
 	if (!is_uv_system())
 		return -ENODEV;
 
-	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
-	if (rc)
-		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
-	else
-		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
-			sn_rtc_cycles_per_second/(unsigned long)1E6);
+	clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
+
+	pr_info("UV RTC clocksource registered freq %lu MHz\n",
+		sn_rtc_cycles_per_second/(unsigned long)1E6);
 
-	if (rc || !uv_rtc_evt_enable || x86_platform_ipi_callback)
-		return rc;
+	if (!uv_rtc_evt_enable || x86_platform_ipi_callback)
+		return 0;
 
 	/* Setup and register clockevents */
 	rc = uv_rtc_allocate_timers();
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 6eab889..ab1dc63 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -218,8 +218,9 @@ static int __init init_acpi_pm_clocksource(void)
 		return -ENODEV;
 	}
 
-	return clocksource_register_hz(&clocksource_acpi_pm,
+	clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
+	return 0;
 }
 
 /* We use fs_initcall because we want the PCI fixups to have run
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 63f176d..b9b56ed 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -301,11 +301,7 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	__raw_writel(CNT_CNTRL_RESET,
 		     ttccs->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
 
-	err = clocksource_register_hz(&ttccs->cs, ttccs->ttc.freq / PRESCALE);
-	if (WARN_ON(err)) {
-		kfree(ttccs);
-		return;
-	}
+	clocksource_register_hz(&ttccs->cs, ttccs->ttc.freq / PRESCALE);
 
 	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
 	sched_clock_register(ttc_sched_clock_read, 16, ttccs->ttc.freq / PRESCALE);
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 48f76bc..fcb9454 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -197,9 +197,7 @@ struct clocksource mct_frc = {
 static void __init exynos4_clocksource_init(void)
 {
 	exynos4_mct_frc_start(0, 0);
-
-	if (clocksource_register_hz(&mct_frc, clk_rate))
-		panic("%s: can't register clocksource\n", mct_frc.name);
+	clocksource_register_hz(&mct_frc, clk_rate);
 }
 
 static void exynos4_mct_comp0_stop(void)
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 14ee3ef..9c45f0a 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -95,7 +95,8 @@ static struct clocksource i8253_cs = {
 
 int __init clocksource_i8253_init(void)
 {
-	return clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
+	clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
+	return 0;
 }
 #endif
 
diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index c0e2512..6e0b530 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -69,5 +69,6 @@ int __init clocksource_mmio_init(void __iomem *base, const char *name,
 	cs->clksrc.mask = CLOCKSOURCE_MASK(bits);
 	cs->clksrc.flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	return clocksource_register_hz(&cs->clksrc, hz);
+	clocksource_register_hz(&cs->clksrc, hz);
+	return 0;
 }
diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index 5645cfc..c59292f 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -340,7 +340,6 @@ static void __init samsung_clocksource_init(void)
 {
 	unsigned long pclk;
 	unsigned long clock_rate;
-	int ret;
 
 	pclk = clk_get_rate(pwm.timerclk);
 
@@ -361,9 +360,7 @@ static void __init samsung_clocksource_init(void)
 						pwm.variant.bits, clock_rate);
 
 	samsung_clocksource.mask = CLOCKSOURCE_MASK(pwm.variant.bits);
-	ret = clocksource_register_hz(&samsung_clocksource, clock_rate);
-	if (ret)
-		panic("samsung_clocksource_timer: can't register clocksource\n");
+	clocksource_register_hz(&samsung_clocksource, clock_rate);
 }
 
 static void __init samsung_timer_resources(void)
diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx200_hrt.c
index 64f9e82..57bdc04 100644
--- a/drivers/clocksource/scx200_hrt.c
+++ b/drivers/clocksource/scx200_hrt.c
@@ -83,7 +83,8 @@ static int __init init_hrt_clocksource(void)
 
 	pr_info("enabling scx200 high-res timer (%s MHz +%d ppm)\n", mhz27 ? "27":"1", ppm);
 
-	return clocksource_register_hz(&cs_hrt, freq);
+	clocksource_register_hz(&cs_hrt, freq);
+	return 0;
 }
 
 module_init(init_hrt_clocksource);
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 00fdd11..805245d 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -340,9 +340,7 @@ static int __init tcb_clksrc_init(void)
 	}
 
 	/* and away we go! */
-	ret = clocksource_register_hz(&clksrc, divided_rate);
-	if (ret)
-		goto err_disable_t1;
+	clocksource_register_hz(&clksrc, divided_rate);
 
 	/* channel 2:  periodic and oneshot timer support */
 	ret = setup_clkevents(tc, clk32k_divisor_idx);
@@ -354,10 +352,6 @@ static int __init tcb_clksrc_init(void)
 err_unregister_clksrc:
 	clocksource_unregister(&clksrc);
 
-err_disable_t1:
-	if (!tc->tcb_config || tc->tcb_config->counter_width != 32)
-		clk_disable_unprepare(tc->clk[1]);
-
 err_disable_t0:
 	clk_disable_unprepare(t0_clk);
 
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 09a17d9..ae78ce0 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -283,7 +283,7 @@ static void __init sirfsoc_marco_timer_init(void)
 	/* Clear all interrupts */
 	writel_relaxed(0xFFFF, sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
 
-	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE));
+	clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE);
 
 	sirfsoc_clockevent_init();
 }
diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index 8a492d3..c9cc307 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -204,7 +204,7 @@ static void __init sirfsoc_prima2_timer_init(struct device_node *np)
 	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_HI);
 	writel_relaxed(BIT(0), sirfsoc_timer_base + SIRFSOC_TIMER_STATUS);
 
-	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE));
+	clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE);
 
 	sched_clock_register(sirfsoc_read_sched_clock, 64, CLOCK_TICK_RATE);
 
diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
index 1098ed3..13f5fa4 100644
--- a/drivers/clocksource/vt8500_timer.c
+++ b/drivers/clocksource/vt8500_timer.c
@@ -150,9 +150,7 @@ static void __init vt8500_timer_init(struct device_node *np)
 	writel(0xf, regbase + TIMER_STATUS_VAL);
 	writel(~0, regbase + TIMER_MATCH_VAL);
 
-	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
-		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
-					__func__, clocksource.name);
+	clocksource_register_hz(&clocksource, VT8500_TIMER_HZ);
 
 	clockevent.cpumask = cpumask_of(0);
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 67301a4..5a17c5e 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -282,7 +282,7 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 }
 
 
-extern int clocksource_register(struct clocksource*);
+extern void clocksource_register(struct clocksource *);
 extern int clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
@@ -301,17 +301,17 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
  * Don't call __clocksource_register_scale directly, use
  * clocksource_register_hz/khz
  */
-extern int
+extern void
 __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
 extern void
 __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq);
 
-static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
+static inline void clocksource_register_hz(struct clocksource *cs, u32 hz)
 {
 	return __clocksource_register_scale(cs, 1, hz);
 }
 
-static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
+static inline void clocksource_register_khz(struct clocksource *cs, u32 khz)
 {
 	return __clocksource_register_scale(cs, 1000, khz);
 }
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9951575..686ff72 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -782,7 +782,7 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
  * This *SHOULD NOT* be called directly! Please use the
  * clocksource_register_hz() or clocksource_register_khz helper functions.
  */
-int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+void __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 
 	/* Initialize mult/shift and max_idle_ns */
@@ -794,7 +794,6 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 	clocksource_enqueue_watchdog(cs);
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(__clocksource_register_scale);
 
@@ -804,7 +803,7 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
  * @cs:		clocksource to be registered
  *
  */
-int clocksource_register(struct clocksource *cs)
+void clocksource_register(struct clocksource *cs)
 {
 	/* calculate max adjustment for given mult/shift */
 	cs->maxadj = clocksource_max_adjustment(cs);
@@ -820,7 +819,6 @@ int clocksource_register(struct clocksource *cs)
 	clocksource_enqueue_watchdog(cs);
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
-	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 7a925ba..ae4c534 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -88,7 +88,8 @@ EXPORT_SYMBOL(jiffies);
 
 static int __init init_jiffies_clocksource(void)
 {
-	return clocksource_register(&clocksource_jiffies);
+	clocksource_register(&clocksource_jiffies);
+	return 0;
 }
 
 core_initcall(init_jiffies_clocksource);
-- 
1.7.1


