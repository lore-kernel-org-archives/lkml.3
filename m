Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3ALLu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:50:29 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:8953
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab3ALLuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:50:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz709fIzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dh8275chz2dh87h2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: John Stultz <john.stultz@linaro.org>, <arm@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH v2 2/3] ARM: use clockevents_config_and_register() where possible
Date: Sat, 12 Jan 2013 19:50:05 +0800
Message-ID: <1357991406-22778-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clockevent core is able to figure out the best mult and shift,
calculate min_delta_ns and max_delta_ns, with the necessary info passed
into clockevents_config_and_register().  Use this combined configure
and register function where possible to make the codes less error prone
and gain some positive diff stat.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Reviewed-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Tested-by: Roland Stigge <stigge@antcom.de>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: David Brown <davidb@codeaurora.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Acked-by: Barry Song <baohua.song@csr.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Tony Prisk <linux@prisktech.co.nz>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-at91/at91rm9200_time.c     |    7 ++-----
 arch/arm/mach-cns3xxx/core.c             |   13 +++----------
 arch/arm/mach-exynos/mct.c               |   18 ++++--------------
 arch/arm/mach-footbridge/dc21285-timer.c |    6 +-----
 arch/arm/mach-imx/epit.c                 |   15 +++------------
 arch/arm/mach-imx/time.c                 |   15 +++------------
 arch/arm/mach-ixp4xx/common.c            |   11 ++---------
 arch/arm/mach-lpc32xx/timer.c            |    9 +--------
 arch/arm/mach-mmp/time.c                 |    7 ++-----
 arch/arm/mach-msm/timer.c                |    6 +-----
 arch/arm/mach-mxs/timer.c                |   24 +++++-------------------
 arch/arm/mach-netx/time.c                |   10 ++--------
 arch/arm/mach-omap1/time.c               |   11 ++---------
 arch/arm/mach-omap1/timer32k.c           |   12 ++----------
 arch/arm/mach-omap2/timer.c              |   13 +++----------
 arch/arm/mach-prima2/timer.c             |   10 ++--------
 arch/arm/mach-pxa/time.c                 |    8 ++------
 arch/arm/mach-sa1100/time.c              |    8 ++------
 arch/arm/mach-tegra/timer.c              |    8 ++------
 arch/arm/mach-vt8500/timer.c             |    9 ++-------
 arch/arm/mach-w90x900/time.c             |   10 ++--------
 arch/arm/plat-iop/time.c                 |    9 ++-------
 arch/arm/plat-orion/time.c               |    6 +-----
 arch/arm/plat-samsung/s5p-time.c         |    9 +--------
 arch/arm/plat-spear/time.c               |    8 +-------
 25 files changed, 53 insertions(+), 209 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index cafe988..20a28ac 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -174,7 +174,6 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
 static struct clock_event_device clkevt = {
 	.name		= "at91_tick",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.rating		= 150,
 	.set_next_event	= clkevt32k_next_event,
 	.set_mode	= clkevt32k_mode,
@@ -265,11 +264,9 @@ void __init at91rm9200_timer_init(void)
 	at91_st_write(AT91_ST_RTMR, 1);
 
 	/* Setup timer clockevent, with minimum of two ticks (important!!) */
-	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
-	clkevt.max_delta_ns = clockevent_delta2ns(AT91_ST_ALMV, &clkevt);
-	clkevt.min_delta_ns = clockevent_delta2ns(2, &clkevt) + 1;
 	clkevt.cpumask = cpumask_of(0);
-	clockevents_register_device(&clkevt);
+	clockevents_config_and_register(&clkevt, AT91_SLOW_CLOCK,
+					2, AT91_ST_ALMV);
 
 	/* register clocksource */
 	clocksource_register_hz(&clk32k, AT91_SLOW_CLOCK);
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 031805b..3eb74d1 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -134,7 +134,6 @@ static int cns3xxx_timer_set_next_event(unsigned long evt,
 
 static struct clock_event_device cns3xxx_tmr1_clockevent = {
 	.name		= "cns3xxx timer1",
-	.shift		= 8,
 	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= cns3xxx_timer_set_mode,
 	.set_next_event	= cns3xxx_timer_set_next_event,
@@ -145,15 +144,9 @@ static struct clock_event_device cns3xxx_tmr1_clockevent = {
 static void __init cns3xxx_clockevents_init(unsigned int timer_irq)
 {
 	cns3xxx_tmr1_clockevent.irq = timer_irq;
-	cns3xxx_tmr1_clockevent.mult =
-		div_sc((cns3xxx_cpu_clock() >> 3) * 1000000, NSEC_PER_SEC,
-		       cns3xxx_tmr1_clockevent.shift);
-	cns3xxx_tmr1_clockevent.max_delta_ns =
-		clockevent_delta2ns(0xffffffff, &cns3xxx_tmr1_clockevent);
-	cns3xxx_tmr1_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xf, &cns3xxx_tmr1_clockevent);
-
-	clockevents_register_device(&cns3xxx_tmr1_clockevent);
+	clockevents_config_and_register(&cns3xxx_tmr1_clockevent,
+					(cns3xxx_cpu_clock() >> 3) * 1000000,
+					0xf, 0xffffffff);
 }
 
 /*
diff --git a/arch/arm/mach-exynos/mct.c b/arch/arm/mach-exynos/mct.c
index 57668eb..070d51e 100644
--- a/arch/arm/mach-exynos/mct.c
+++ b/arch/arm/mach-exynos/mct.c
@@ -255,13 +255,9 @@ static struct irqaction mct_comp_event_irq = {
 
 static void exynos4_clockevent_init(void)
 {
-	clockevents_calc_mult_shift(&mct_comp_device, clk_rate, 5);
-	mct_comp_device.max_delta_ns =
-		clockevent_delta2ns(0xffffffff, &mct_comp_device);
-	mct_comp_device.min_delta_ns =
-		clockevent_delta2ns(0xf, &mct_comp_device);
 	mct_comp_device.cpumask = cpumask_of(0);
-	clockevents_register_device(&mct_comp_device);
+	clockevents_config_and_register(&mct_comp_device, clk_rate,
+					0xf, 0xffffffff);
 
 	if (soc_is_exynos5250())
 		setup_irq(EXYNOS5_IRQ_MCT_G0, &mct_comp_event_irq);
@@ -404,14 +400,8 @@ static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
 	evt->set_mode = exynos4_tick_set_mode;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = 450;
-
-	clockevents_calc_mult_shift(evt, clk_rate / (TICK_BASE_CNT + 1), 5);
-	evt->max_delta_ns =
-		clockevent_delta2ns(0x7fffffff, evt);
-	evt->min_delta_ns =
-		clockevent_delta2ns(0xf, evt);
-
-	clockevents_register_device(evt);
+	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
+					0xf, 0x7fffffff);
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
index 3b54196..a9918b6 100644
--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -101,12 +101,8 @@ static void __init footbridge_timer_init(void)
 
 	setup_irq(ce->irq, &footbridge_timer_irq);
 
-	clockevents_calc_mult_shift(ce, mem_fclk_21285, 5);
-	ce->max_delta_ns = clockevent_delta2ns(0xffffff, ce);
-	ce->min_delta_ns = clockevent_delta2ns(0x000004, ce);
 	ce->cpumask = cpumask_of(smp_processor_id());
-
-	clockevents_register_device(ce);
+	clockevents_config_and_register(ce, mem_fclk_21285, 0x4, 0xffffff);
 }
 
 struct sys_timer footbridge_timer = {
diff --git a/arch/arm/mach-imx/epit.c b/arch/arm/mach-imx/epit.c
index 04a5961..e02de18 100644
--- a/arch/arm/mach-imx/epit.c
+++ b/arch/arm/mach-imx/epit.c
@@ -178,7 +178,6 @@ static struct irqaction epit_timer_irq = {
 static struct clock_event_device clockevent_epit = {
 	.name		= "epit",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.set_mode	= epit_set_mode,
 	.set_next_event	= epit_set_next_event,
 	.rating		= 200,
@@ -186,18 +185,10 @@ static struct clock_event_device clockevent_epit = {
 
 static int __init epit_clockevent_init(struct clk *timer_clk)
 {
-	unsigned int c = clk_get_rate(timer_clk);
-
-	clockevent_epit.mult = div_sc(c, NSEC_PER_SEC,
-					clockevent_epit.shift);
-	clockevent_epit.max_delta_ns =
-			clockevent_delta2ns(0xfffffffe, &clockevent_epit);
-	clockevent_epit.min_delta_ns =
-			clockevent_delta2ns(0x800, &clockevent_epit);
-
 	clockevent_epit.cpumask = cpumask_of(0);
-
-	clockevents_register_device(&clockevent_epit);
+	clockevents_config_and_register(&clockevent_epit,
+					clk_get_rate(timer_clk),
+					0x800, 0xfffffffe);
 
 	return 0;
 }
diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index f017302..62769df 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -256,7 +256,6 @@ static struct irqaction mxc_timer_irq = {
 static struct clock_event_device clockevent_mxc = {
 	.name		= "mxc_timer1",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.set_mode	= mxc_set_mode,
 	.set_next_event	= mx1_2_set_next_event,
 	.rating		= 200,
@@ -264,21 +263,13 @@ static struct clock_event_device clockevent_mxc = {
 
 static int __init mxc_clockevent_init(struct clk *timer_clk)
 {
-	unsigned int c = clk_get_rate(timer_clk);
-
 	if (timer_is_v2())
 		clockevent_mxc.set_next_event = v2_set_next_event;
 
-	clockevent_mxc.mult = div_sc(c, NSEC_PER_SEC,
-					clockevent_mxc.shift);
-	clockevent_mxc.max_delta_ns =
-			clockevent_delta2ns(0xfffffffe, &clockevent_mxc);
-	clockevent_mxc.min_delta_ns =
-			clockevent_delta2ns(0xff, &clockevent_mxc);
-
 	clockevent_mxc.cpumask = cpumask_of(0);
-
-	clockevents_register_device(&clockevent_mxc);
+	clockevents_config_and_register(&clockevent_mxc,
+					clk_get_rate(timer_clk),
+					0xff, 0xfffffffe);
 
 	return 0;
 }
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 8c0c0e2..65ff98c 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -523,22 +523,15 @@ static struct clock_event_device clockevent_ixp4xx = {
 	.name		= "ixp4xx timer1",
 	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.rating         = 200,
-	.shift		= 24,
 	.set_mode	= ixp4xx_set_mode,
 	.set_next_event	= ixp4xx_set_next_event,
 };
 
 static void __init ixp4xx_clockevent_init(void)
 {
-	clockevent_ixp4xx.mult = div_sc(IXP4XX_TIMER_FREQ, NSEC_PER_SEC,
-					clockevent_ixp4xx.shift);
-	clockevent_ixp4xx.max_delta_ns =
-		clockevent_delta2ns(0xfffffffe, &clockevent_ixp4xx);
-	clockevent_ixp4xx.min_delta_ns =
-		clockevent_delta2ns(0xf, &clockevent_ixp4xx);
 	clockevent_ixp4xx.cpumask = cpumask_of(0);
-
-	clockevents_register_device(&clockevent_ixp4xx);
+	clockevents_config_and_register(&clockevent_ixp4xx, IXP4XX_TIMER_FREQ,
+					0xf, 0xfffffffe);
 }
 
 void ixp4xx_restart(char mode, const char *cmd)
diff --git a/arch/arm/mach-lpc32xx/timer.c b/arch/arm/mach-lpc32xx/timer.c
index c40667c..502b3c6 100644
--- a/arch/arm/mach-lpc32xx/timer.c
+++ b/arch/arm/mach-lpc32xx/timer.c
@@ -70,7 +70,6 @@ static void lpc32xx_clkevt_mode(enum clock_event_mode mode,
 static struct clock_event_device lpc32xx_clkevt = {
 	.name		= "lpc32xx_clkevt",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.rating		= 300,
 	.set_next_event	= lpc32xx_clkevt_next_event,
 	.set_mode	= lpc32xx_clkevt_mode,
@@ -141,14 +140,8 @@ static void __init lpc32xx_timer_init(void)
 	setup_irq(IRQ_LPC32XX_TIMER0, &lpc32xx_timer_irq);
 
 	/* Setup the clockevent structure. */
-	lpc32xx_clkevt.mult = div_sc(clkrate, NSEC_PER_SEC,
-		lpc32xx_clkevt.shift);
-	lpc32xx_clkevt.max_delta_ns = clockevent_delta2ns(-1,
-		&lpc32xx_clkevt);
-	lpc32xx_clkevt.min_delta_ns = clockevent_delta2ns(1,
-		&lpc32xx_clkevt) + 1;
 	lpc32xx_clkevt.cpumask = cpumask_of(0);
-	clockevents_register_device(&lpc32xx_clkevt);
+	clockevents_config_and_register(&lpc32xx_clkevt, clkrate, 1, -1);
 
 	/* Use timer1 as clock source. */
 	__raw_writel(LPC32XX_TIMER_CNTR_TCR_RESET,
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 936447c..86a18b3 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -141,7 +141,6 @@ static void timer_set_mode(enum clock_event_mode mode,
 static struct clock_event_device ckevt = {
 	.name		= "clockevent",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.rating		= 200,
 	.set_next_event	= timer_set_next_event,
 	.set_mode	= timer_set_mode,
@@ -198,15 +197,13 @@ void __init timer_init(int irq)
 
 	setup_sched_clock(mmp_read_sched_clock, 32, CLOCK_TICK_RATE);
 
-	ckevt.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt.shift);
-	ckevt.max_delta_ns = clockevent_delta2ns(MAX_DELTA, &ckevt);
-	ckevt.min_delta_ns = clockevent_delta2ns(MIN_DELTA, &ckevt);
 	ckevt.cpumask = cpumask_of(0);
 
 	setup_irq(irq, &timer_irq);
 
 	clocksource_register_hz(&cksrc, CLOCK_TICK_RATE);
-	clockevents_register_device(&ckevt);
+	clockevents_config_and_register(&ckevt, CLOCK_TICK_RATE,
+					MIN_DELTA, MAX_DELTA);
 }
 
 #ifdef CONFIG_OF
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 476549a..b9e7449 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -144,13 +144,9 @@ static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 	evt->rating = msm_clockevent.rating;
 	evt->set_mode = msm_timer_set_mode;
 	evt->set_next_event = msm_timer_set_next_event;
-	evt->shift = msm_clockevent.shift;
-	evt->mult = div_sc(GPT_HZ, NSEC_PER_SEC, evt->shift);
-	evt->max_delta_ns = clockevent_delta2ns(0xf0000000, evt);
-	evt->min_delta_ns = clockevent_delta2ns(4, evt);
 
 	*__this_cpu_ptr(msm_evt.percpu_evt) = evt;
-	clockevents_register_device(evt);
+	clockevents_config_and_register(evt, GPT_HZ, 4, 0xf0000000);
 	enable_percpu_irq(evt->irq, IRQ_TYPE_EDGE_RISING);
 	return 0;
 }
diff --git a/arch/arm/mach-mxs/timer.c b/arch/arm/mach-mxs/timer.c
index 856f4c7..27451b1 100644
--- a/arch/arm/mach-mxs/timer.c
+++ b/arch/arm/mach-mxs/timer.c
@@ -195,7 +195,6 @@ static void mxs_set_mode(enum clock_event_mode mode,
 static struct clock_event_device mxs_clockevent_device = {
 	.name		= "mxs_timrot",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.set_mode	= mxs_set_mode,
 	.set_next_event	= timrotv2_set_next_event,
 	.rating		= 200,
@@ -203,25 +202,12 @@ static struct clock_event_device mxs_clockevent_device = {
 
 static int __init mxs_clockevent_init(struct clk *timer_clk)
 {
-	unsigned int c = clk_get_rate(timer_clk);
-
-	mxs_clockevent_device.mult =
-		div_sc(c, NSEC_PER_SEC, mxs_clockevent_device.shift);
-	mxs_clockevent_device.cpumask = cpumask_of(0);
-	if (timrot_is_v1()) {
+	if (timrot_is_v1())
 		mxs_clockevent_device.set_next_event = timrotv1_set_next_event;
-		mxs_clockevent_device.max_delta_ns =
-			clockevent_delta2ns(0xfffe, &mxs_clockevent_device);
-		mxs_clockevent_device.min_delta_ns =
-			clockevent_delta2ns(0xf, &mxs_clockevent_device);
-	} else {
-		mxs_clockevent_device.max_delta_ns =
-			clockevent_delta2ns(0xfffffffe, &mxs_clockevent_device);
-		mxs_clockevent_device.min_delta_ns =
-			clockevent_delta2ns(0xf, &mxs_clockevent_device);
-	}
-
-	clockevents_register_device(&mxs_clockevent_device);
+	mxs_clockevent_device.cpumask = cpumask_of(0);
+	clockevents_config_and_register(&mxs_clockevent_device,
+					clk_get_rate(timer_clk), 0xf,
+					timrot_is_v1() ? 0xfffe : 0xfffffffe);
 
 	return 0;
 }
diff --git a/arch/arm/mach-netx/time.c b/arch/arm/mach-netx/time.c
index e24c141..d780a93 100644
--- a/arch/arm/mach-netx/time.c
+++ b/arch/arm/mach-netx/time.c
@@ -76,7 +76,6 @@ static int netx_set_next_event(unsigned long evt,
 
 static struct clock_event_device netx_clockevent = {
 	.name = "netx-timer" __stringify(TIMER_CLOCKEVENT),
-	.shift = 32,
 	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_next_event = netx_set_next_event,
 	.set_mode = netx_set_mode,
@@ -140,16 +139,11 @@ static void __init netx_timer_init(void)
 	clocksource_mmio_init(NETX_GPIO_COUNTER_CURRENT(TIMER_CLOCKSOURCE),
 		"netx_timer", CLOCK_TICK_RATE, 200, 32, clocksource_mmio_readl_up);
 
-	netx_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
-			netx_clockevent.shift);
-	netx_clockevent.max_delta_ns =
-		clockevent_delta2ns(0xfffffffe, &netx_clockevent);
 	/* with max_delta_ns >= delta2ns(0x800) the system currently runs fine.
 	 * Adding some safety ... */
-	netx_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xa00, &netx_clockevent);
 	netx_clockevent.cpumask = cpumask_of(0);
-	clockevents_register_device(&netx_clockevent);
+	clockevents_config_and_register(&netx_clockevent, CLOCK_TICK_RATE,
+					0xa00, 0xfffffffe);
 }
 
 struct sys_timer netx_timer = {
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 4d4816f..5b7c556 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -145,7 +145,6 @@ static void omap_mpu_set_mode(enum clock_event_mode mode,
 static struct clock_event_device clockevent_mpu_timer1 = {
 	.name		= "mpu_timer1",
 	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.set_next_event	= omap_mpu_set_next_event,
 	.set_mode	= omap_mpu_set_mode,
 };
@@ -170,15 +169,9 @@ static __init void omap_init_mpu_timer(unsigned long rate)
 	setup_irq(INT_TIMER1, &omap_mpu_timer1_irq);
 	omap_mpu_timer_start(0, (rate / HZ) - 1, 1);
 
-	clockevent_mpu_timer1.mult = div_sc(rate, NSEC_PER_SEC,
-					    clockevent_mpu_timer1.shift);
-	clockevent_mpu_timer1.max_delta_ns =
-		clockevent_delta2ns(-1, &clockevent_mpu_timer1);
-	clockevent_mpu_timer1.min_delta_ns =
-		clockevent_delta2ns(1, &clockevent_mpu_timer1);
-
 	clockevent_mpu_timer1.cpumask = cpumask_of(0);
-	clockevents_register_device(&clockevent_mpu_timer1);
+	clockevents_config_and_register(&clockevent_mpu_timer1, rate,
+					1, -1);
 }
 
 
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 41152fa..0b74246 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -140,7 +140,6 @@ static void omap_32k_timer_set_mode(enum clock_event_mode mode,
 static struct clock_event_device clockevent_32k_timer = {
 	.name		= "32k-timer",
 	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.set_next_event	= omap_32k_timer_set_next_event,
 	.set_mode	= omap_32k_timer_set_mode,
 };
@@ -165,16 +164,9 @@ static __init void omap_init_32k_timer(void)
 {
 	setup_irq(INT_OS_TIMER, &omap_32k_timer_irq);
 
-	clockevent_32k_timer.mult = div_sc(OMAP_32K_TICKS_PER_SEC,
-					   NSEC_PER_SEC,
-					   clockevent_32k_timer.shift);
-	clockevent_32k_timer.max_delta_ns =
-		clockevent_delta2ns(0xfffffffe, &clockevent_32k_timer);
-	clockevent_32k_timer.min_delta_ns =
-		clockevent_delta2ns(1, &clockevent_32k_timer);
-
 	clockevent_32k_timer.cpumask = cpumask_of(0);
-	clockevents_register_device(&clockevent_32k_timer);
+	clockevents_config_and_register(&clockevent_32k_timer,
+					OMAP_32K_TICKS_PER_SEC, 1, 0xfffffffe);
 }
 
 /*
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 691aa67..3e2ffdb 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -131,7 +131,6 @@ static void omap2_gp_timer_set_mode(enum clock_event_mode mode,
 static struct clock_event_device clockevent_gpt = {
 	.name		= "gp_timer",
 	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.rating		= 300,
 	.set_next_event	= omap2_gp_timer_set_next_event,
 	.set_mode	= omap2_gp_timer_set_mode,
@@ -340,17 +339,11 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 
 	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
 
-	clockevent_gpt.mult = div_sc(clkev.rate, NSEC_PER_SEC,
-				     clockevent_gpt.shift);
-	clockevent_gpt.max_delta_ns =
-		clockevent_delta2ns(0xffffffff, &clockevent_gpt);
-	clockevent_gpt.min_delta_ns =
-		clockevent_delta2ns(3, &clockevent_gpt);
-		/* Timer internal resynch latency. */
-
 	clockevent_gpt.cpumask = cpu_possible_mask;
 	clockevent_gpt.irq = omap_dm_timer_get_irq(&clkev);
-	clockevents_register_device(&clockevent_gpt);
+	clockevents_config_and_register(&clockevent_gpt, clkev.rate,
+					3, /* Timer internal resynch latency */
+					0xffffffff);
 
 	pr_info("OMAP clockevent source: GPTIMER%d at %lu Hz\n",
 		gptimer_id, clkev.rate);
diff --git a/arch/arm/mach-prima2/timer.c b/arch/arm/mach-prima2/timer.c
index d95bf25..4f69e67 100644
--- a/arch/arm/mach-prima2/timer.c
+++ b/arch/arm/mach-prima2/timer.c
@@ -175,15 +175,9 @@ static u32 notrace sirfsoc_read_sched_clock(void)
 
 static void __init sirfsoc_clockevent_init(void)
 {
-	clockevents_calc_mult_shift(&sirfsoc_clockevent, CLOCK_TICK_RATE, 60);
-
-	sirfsoc_clockevent.max_delta_ns =
-		clockevent_delta2ns(-2, &sirfsoc_clockevent);
-	sirfsoc_clockevent.min_delta_ns =
-		clockevent_delta2ns(2, &sirfsoc_clockevent);
-
 	sirfsoc_clockevent.cpumask = cpumask_of(0);
-	clockevents_register_device(&sirfsoc_clockevent);
+	clockevents_config_and_register(&sirfsoc_clockevent, CLOCK_TICK_RATE,
+					2, -2);
 }
 
 /* initialize the kernel jiffy timer source */
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 4bc47d6..08cc47f 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -113,18 +113,14 @@ static void __init pxa_timer_init(void)
 
 	setup_sched_clock(pxa_read_sched_clock, 32, clock_tick_rate);
 
-	clockevents_calc_mult_shift(&ckevt_pxa_osmr0, clock_tick_rate, 4);
-	ckevt_pxa_osmr0.max_delta_ns =
-		clockevent_delta2ns(0x7fffffff, &ckevt_pxa_osmr0);
-	ckevt_pxa_osmr0.min_delta_ns =
-		clockevent_delta2ns(MIN_OSCR_DELTA * 2, &ckevt_pxa_osmr0) + 1;
 	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
 
 	setup_irq(IRQ_OST0, &pxa_ost0_irq);
 
 	clocksource_mmio_init(OSCR, "oscr0", clock_tick_rate, 200, 32,
 		clocksource_mmio_readl_up);
-	clockevents_register_device(&ckevt_pxa_osmr0);
+	clockevents_config_and_register(&ckevt_pxa_osmr0, clock_tick_rate,
+					MIN_OSCR_DELTA * 2, 0x7fffffff);
 }
 
 #ifdef CONFIG_PM
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 80702c9..6e980da 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -91,18 +91,14 @@ static void __init sa1100_timer_init(void)
 
 	setup_sched_clock(sa1100_read_sched_clock, 32, 3686400);
 
-	clockevents_calc_mult_shift(&ckevt_sa1100_osmr0, 3686400, 4);
-	ckevt_sa1100_osmr0.max_delta_ns =
-		clockevent_delta2ns(0x7fffffff, &ckevt_sa1100_osmr0);
-	ckevt_sa1100_osmr0.min_delta_ns =
-		clockevent_delta2ns(MIN_OSCR_DELTA * 2, &ckevt_sa1100_osmr0) + 1;
 	ckevt_sa1100_osmr0.cpumask = cpumask_of(0);
 
 	setup_irq(IRQ_OST0, &sa1100_timer_irq);
 
 	clocksource_mmio_init(OSCR, "oscr", CLOCK_TICK_RATE, 200, 32,
 		clocksource_mmio_readl_up);
-	clockevents_register_device(&ckevt_sa1100_osmr0);
+	clockevents_config_and_register(&ckevt_sa1100_osmr0, 3686400,
+					MIN_OSCR_DELTA * 2, 0x7fffffff);
 }
 
 #ifdef CONFIG_PM
diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index e4863f3..bc86161 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -259,14 +259,10 @@ static void __init tegra_init_timer(void)
 		BUG();
 	}
 
-	clockevents_calc_mult_shift(&tegra_clockevent, 1000000, 5);
-	tegra_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x1fffffff, &tegra_clockevent);
-	tegra_clockevent.min_delta_ns =
-		clockevent_delta2ns(0x1, &tegra_clockevent);
 	tegra_clockevent.cpumask = cpu_all_mask;
 	tegra_clockevent.irq = tegra_timer_irq.irq;
-	clockevents_register_device(&tegra_clockevent);
+	clockevents_config_and_register(&tegra_clockevent, 1000000,
+					0x1, 0x1fffffff);
 #ifdef CONFIG_HAVE_ARM_TWD
 	twd_local_timer_of_register();
 #endif
diff --git a/arch/arm/mach-vt8500/timer.c b/arch/arm/mach-vt8500/timer.c
index 3dd21a4..ed66cf0 100644
--- a/arch/arm/mach-vt8500/timer.c
+++ b/arch/arm/mach-vt8500/timer.c
@@ -168,17 +168,12 @@ void __init vt8500_timer_init(void)
 		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
 					__func__, clocksource.name);
 
-	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
-
-	/* copy-pasted from mach-msm; no idea */
-	clockevent.max_delta_ns =
-		clockevent_delta2ns(0xf0000000, &clockevent);
-	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
 	clockevent.cpumask = cpumask_of(0);
 
 	if (setup_irq(timer_irq, &irq))
 		pr_err("%s: setup_irq failed for %s\n", __func__,
 							clockevent.name);
-	clockevents_register_device(&clockevent);
+	clockevents_config_and_register(&clockevent, VT8500_TIMER_HZ,
+					4, 0xf0000000);
 }
 
diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
index fa27c49..b61ab3e 100644
--- a/arch/arm/mach-w90x900/time.c
+++ b/arch/arm/mach-w90x900/time.c
@@ -91,7 +91,6 @@ static int nuc900_clockevent_setnextevent(unsigned long evt,
 
 static struct clock_event_device nuc900_clockevent_device = {
 	.name		= "nuc900-timer0",
-	.shift		= 32,
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= nuc900_clockevent_setmode,
 	.set_next_event	= nuc900_clockevent_setnextevent,
@@ -133,15 +132,10 @@ static void __init nuc900_clockevents_init(void)
 	__raw_writel(RESETINT, REG_TISR);
 	setup_irq(IRQ_TIMER0, &nuc900_timer0_irq);
 
-	nuc900_clockevent_device.mult = div_sc(rate, NSEC_PER_SEC,
-					nuc900_clockevent_device.shift);
-	nuc900_clockevent_device.max_delta_ns = clockevent_delta2ns(0xffffffff,
-					&nuc900_clockevent_device);
-	nuc900_clockevent_device.min_delta_ns = clockevent_delta2ns(0xf,
-					&nuc900_clockevent_device);
 	nuc900_clockevent_device.cpumask = cpumask_of(0);
 
-	clockevents_register_device(&nuc900_clockevent_device);
+	clockevents_config_and_register(&nuc900_clockevent_device, rate,
+					0xf, 0xffffffff);
 }
 
 static void __init nuc900_clocksource_init(void)
diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index cbfbbe4..837a2d5 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -156,14 +156,9 @@ void __init iop_init_time(unsigned long tick_rate)
 	write_tmr0(timer_ctl & ~IOP_TMR_EN);
 	write_tisr(1);
 	setup_irq(IRQ_IOP_TIMER0, &iop_timer_irq);
-	clockevents_calc_mult_shift(&iop_clockevent,
-				    tick_rate, IOP_MIN_RANGE);
-	iop_clockevent.max_delta_ns =
-		clockevent_delta2ns(0xfffffffe, &iop_clockevent);
-	iop_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xf, &iop_clockevent);
 	iop_clockevent.cpumask = cpumask_of(0);
-	clockevents_register_device(&iop_clockevent);
+	clockevents_config_and_register(&iop_clockevent, tick_rate,
+					0xf, 0xfffffffe);
 
 	/*
 	 * Set up free-running clocksource timer 1.
diff --git a/arch/arm/plat-orion/time.c b/arch/arm/plat-orion/time.c
index 0f4fa86..5d5ac0f 100644
--- a/arch/arm/plat-orion/time.c
+++ b/arch/arm/plat-orion/time.c
@@ -156,7 +156,6 @@ orion_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 static struct clock_event_device orion_clkevt = {
 	.name		= "orion_tick",
 	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
-	.shift		= 32,
 	.rating		= 300,
 	.set_next_event	= orion_clkevt_next_event,
 	.set_mode	= orion_clkevt_mode,
@@ -221,9 +220,6 @@ orion_time_init(void __iomem *_bridge_base, u32 _bridge_timer1_clr_mask,
 	 * Setup clockevent timer (interrupt-driven).
 	 */
 	setup_irq(irq, &orion_timer_irq);
-	orion_clkevt.mult = div_sc(tclk, NSEC_PER_SEC, orion_clkevt.shift);
-	orion_clkevt.max_delta_ns = clockevent_delta2ns(0xfffffffe, &orion_clkevt);
-	orion_clkevt.min_delta_ns = clockevent_delta2ns(1, &orion_clkevt);
 	orion_clkevt.cpumask = cpumask_of(0);
-	clockevents_register_device(&orion_clkevt);
+	clockevents_config_and_register(&orion_clkevt, tclk, 1, 0xfffffffe);
 }
diff --git a/arch/arm/plat-samsung/s5p-time.c b/arch/arm/plat-samsung/s5p-time.c
index 028b6e8..798268b 100644
--- a/arch/arm/plat-samsung/s5p-time.c
+++ b/arch/arm/plat-samsung/s5p-time.c
@@ -274,15 +274,8 @@ static void __init s5p_clockevent_init(void)
 	clock_rate = clk_get_rate(tin_event);
 	clock_count_per_tick = clock_rate / HZ;
 
-	clockevents_calc_mult_shift(&time_event_device,
-				    clock_rate, S5PTIMER_MIN_RANGE);
-	time_event_device.max_delta_ns =
-		clockevent_delta2ns(-1, &time_event_device);
-	time_event_device.min_delta_ns =
-		clockevent_delta2ns(1, &time_event_device);
-
 	time_event_device.cpumask = cpumask_of(0);
-	clockevents_register_device(&time_event_device);
+	clockevents_config_and_register(&time_event_device, clock_rate, 1, -1);
 
 	irq_number = timer_source.event_id + IRQ_TIMER0;
 	setup_irq(irq_number, &s5p_clock_event_irq);
diff --git a/arch/arm/plat-spear/time.c b/arch/arm/plat-spear/time.c
index 03321af..bd5c53c 100644
--- a/arch/arm/plat-spear/time.c
+++ b/arch/arm/plat-spear/time.c
@@ -186,15 +186,9 @@ static void __init spear_clockevent_init(int irq)
 	tick_rate = clk_get_rate(gpt_clk);
 	tick_rate >>= CTRL_PRESCALER16;
 
-	clockevents_calc_mult_shift(&clkevt, tick_rate, SPEAR_MIN_RANGE);
-
-	clkevt.max_delta_ns = clockevent_delta2ns(0xfff0,
-			&clkevt);
-	clkevt.min_delta_ns = clockevent_delta2ns(3, &clkevt);
-
 	clkevt.cpumask = cpumask_of(0);
 
-	clockevents_register_device(&clkevt);
+	clockevents_config_and_register(&clkevt, tick_rate, 3, 0xfff0);
 
 	setup_irq(irq, &spear_timer_irq);
 }
-- 
1.7.9.5


