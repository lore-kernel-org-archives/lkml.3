Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3HFB2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:28:20 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:22564
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490Ab3HFB2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:28:18 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ic89bh146fI1432Ic857h1447Ide40hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839hd24hf0ah119dh1288h12a5h12bdh137ah1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1bceh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i34h1155h192ch)
Date: Mon, 5 Aug 2013 18:28:01 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stuart Menefy <stuart.menefy@st.com>, Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <51F77D93.4030505@linaro.org>
 <51F97842.6050200@linaro.org>
 <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local>
 <51F97CE3.9030306@linaro.org>
 <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local>
 <51F99747.4060901@linaro.org>
 <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CNfT9TXqV7nd4cfk"
Content-Disposition: inline
In-Reply-To: <51FA9F54.3060704@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <712d31e9-3584-48e1-aa9f-55bc94fa62c9@DB9EHSMHS001.ehs.local>
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CNfT9TXqV7nd4cfk
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, Aug 01, 2013 at 07:48:04PM +0200, Daniel Lezcano wrote:
> On 08/01/2013 07:43 PM, S=C3=B6ren Brinkmann wrote:
> > On Thu, Aug 01, 2013 at 07:29:12PM +0200, Daniel Lezcano wrote:
> >> On 08/01/2013 01:38 AM, S=C3=B6ren Brinkmann wrote:
> >>> On Thu, Aug 01, 2013 at 01:01:27AM +0200, Daniel Lezcano wrote:
> >>>> On 08/01/2013 12:18 AM, S=C3=B6ren Brinkmann wrote:
> >>>>> On Wed, Jul 31, 2013 at 11:08:51PM +0200, Daniel Lezcano wrote:
> >>>>>> On 07/31/2013 10:58 PM, S=C3=B6ren Brinkmann wrote:
> >>>>>>> On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano wrote:
> >>>>>>>> On 07/31/2013 12:34 AM, S=C3=B6ren Brinkmann wrote:
> >>>>>>>>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano wrote:=

> >>>>>>>>>> On 07/30/2013 02:03 AM, S=C3=B6ren Brinkmann wrote:
> >>>>>>>>>>> Hi Daniel,
> >>>>>>>>>>>
> >>>>>>>>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano wrot=
e:
> >>>>>>>>>>> (snip)
> >>>>>>>>>>>>
> >>>>>>>>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle framework=
 the local
> >>>>>>>>>>>> timer will be stopped when entering to the idle state. In th=
is case, the
> >>>>>>>>>>>> cpuidle framework will call clockevents_notify(ENTER) and sw=
itches to a
> >>>>>>>>>>>> broadcast timer and will call clockevents_notify(EXIT) when =
exiting the
> >>>>>>>>>>>> idle state, switching the local timer back in use.
> >>>>>>>>>>>
> >>>>>>>>>>> I've been thinking about this, trying to understand how this =
makes my
> >>>>>>>>>>> boot attempts on Zynq hang. IIUC, the wrongly provided TIMER_=
STOP flag
> >>>>>>>>>>> would make the timer core switch to a broadcast device even t=
hough it
> >>>>>>>>>>> wouldn't be necessary. But shouldn't it still work? It sounds=
 like we do
> >>>>>>>>>>> something useless, but nothing wrong in a sense that it shoul=
d result in
> >>>>>>>>>>> breakage. I guess I'm missing something obvious. This timer s=
ystem will
> >>>>>>>>>>> always remain a mystery to me.
> >>>>>>>>>>>
> >>>>>>>>>>> Actually this more or less leads to the question: What is thi=
s
> >>>>>>>>>>> 'broadcast timer'. I guess that is some clockevent device whi=
ch is
> >>>>>>>>>>> common to all cores? (that would be the cadence_ttc for Zynq)=
. Is the
> >>>>>>>>>>> hang pointing to some issue with that driver?
> >>>>>>>>>>
> >>>>>>>>>> If you look at the /proc/timer_list, which timer is used for b=
roadcasting ?
> >>>>>>>>>
> >>>>>>>>> So, the correct run results (full output attached).
> >>>>>>>>>
> >>>>>>>>> The vanilla kernel uses the twd timers as local timers and the =
TTC as
> >>>>>>>>> broadcast device:
> >>>>>>>>> 	Tick Device: mode:     1                                      =
                   =

> >>>>>>>>> 	Broadcast device  =

> >>>>>>>>> 	Clock Event Device: ttc_clockevent
> >>>>>>>>>
> >>>>>>>>> When I remove the offending CPUIDLE flag and add the DT fragmen=
t to
> >>>>>>>>> enable the global timer, the twd timers are still used as local=
 timers
> >>>>>>>>> and the broadcast device is the global timer:
> >>>>>>>>> 	Tick Device: mode:     1                                      =
                   =

> >>>>>>>>> 	Broadcast device                                              =
                   =

> >>>>>>>>> 	Clock Event Device: arm_global_timer
> >>>>>>>>>
> >>>>>>>>> Again, since boot hangs in the actually broken case, I don't se=
e way to
> >>>>>>>>> obtain this information for that case.
> >>>>>>>>
> >>>>>>>> Can't you use the maxcpus=3D1 option to ensure the system to boo=
t up ?
> >>>>>>>
> >>>>>>> Right, that works. I forgot about that option after you mentioned=
, that
> >>>>>>> it is most likely not that useful.
> >>>>>>>
> >>>>>>> Anyway, this are those sysfs files with an unmodified cpuidle dri=
ver and
> >>>>>>> the gt enabled and having maxcpus=3D1 set.
> >>>>>>>
> >>>>>>> /proc/timer_list:
> >>>>>>> 	Tick Device: mode:     1
> >>>>>>> 	Broadcast device
> >>>>>>> 	Clock Event Device: arm_global_timer
> >>>>>>> 	 max_delta_ns:   12884902005
> >>>>>>> 	 min_delta_ns:   1000
> >>>>>>> 	 mult:           715827876
> >>>>>>> 	 shift:          31
> >>>>>>> 	 mode:           3
> >>>>>>
> >>>>>> Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)
> >>>>>>
> >>>>>> The previous timer_list output you gave me when removing the offen=
ding
> >>>>>> cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).
> >>>>>>
> >>>>>> Is it possible you try to get this output again right after onlini=
ng the
> >>>>>> cpu1 in order to check if the broadcast device switches to SHUTDOW=
N ?
> >>>>>
> >>>>> How do I do that? I tried to online CPU1 after booting with maxcpus=
=3D1
> >>>>> and that didn't end well:
> >>>>> 	# echo 1 > online && cat /proc/timer_list =

> >>>>
> >>>> Hmm, I was hoping to have a small delay before the kernel hangs but
> >>>> apparently this is not the case... :(
> >>>>
> >>>> I suspect the global timer is shutdown at one moment but I don't
> >>>> understand why and when.
> >>>>
> >>>> Can you add a stack trace in the "clockevents_shutdown" function wit=
h
> >>>> the clockevent device name ? Perhaps, we may see at boot time an
> >>>> interesting trace when it hangs.
> >>>
> >>> I did this change:
> >>> 	diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> >>> 	index 38959c8..3ab11c1 100644
> >>> 	--- a/kernel/time/clockevents.c
> >>> 	+++ b/kernel/time/clockevents.c
> >>> 	@@ -92,6 +92,8 @@ void clockevents_set_mode(struct clock_event_devic=
e *dev,
> >>> 	  */
> >>> 	 void clockevents_shutdown(struct clock_event_device *dev)
> >>> 	 {
> >>> 	+       pr_info("ce->name:%s\n", dev->name);
> >>> 	+       dump_stack();
> >>> 	        clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> >>> 	        dev->next_event.tv64 =3D KTIME_MAX;
> >>> 	 }
> >>>
> >>> It is hit a few times during boot, so I attach a full boot log. I rea=
lly
> >>> don't know what to look for, but I hope you can spot something in it.=
 I
> >>> really appreciate you taking the time.
> >>
> >> Thanks for the traces.
> > =

> > Sure.
> > =

> >>
> >> If you try without the ttc_clockevent configured in the kernel (but wi=
th
> >> twd and gt), does it boot ?
> > =

> > Absence of the TTC doesn't seem to make any difference. It hangs at the=

> > same location.
> =

> Ok, IMO there is a problem with the broadcast device registration (may
> be vs twd).
> =

> I will check later (kid duty) :)

I was actually waiting for an update from your side and did something
else, but I seem to have run into this again. I was overhauling the
cadence_ttc (patch attached, based on tip/timers/core). And it seems to
show the same behavior as enabling the global_timer. With cpuidle off, it
works. With cpuidle, on it hangs. Removing the TIMER_STOP flag from the
C2 state makes it boot again.
It works just fine on our 3.10 kernel.

Another thing I noticed - probably unrelated but hard to tell: On
3.11-rc1 and later my system stops for quite some time at the hand off
to userspace. I.e. I see the 'freeing unused kernel memory...' line and
sometimes the following 'Welcome to Buildroot...' and then it stops and
on good kernels it continues after a while and boots through and on bad
ones it just hangs there.

	S=C3=B6ren


--CNfT9TXqV7nd4cfk
Content-Type: text/x-diff; charset="utf-8"
Content-Disposition: attachment;
	filename="0001-clocksource-cadence_ttc-Use-only-one-counter.patch"

>From db4ad00ab774555ba8113ca6fcb9ceace15cfbbc Mon Sep 17 00:00:00 2001
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Date: Mon, 5 Aug 2013 15:48:59 -0700
Subject: [PATCH] clocksource/cadence_ttc: Use only one counter

Currently the driver uses two of the three counters the TTC provides to
implement a clocksource and a clockevent device. By using the TTC's
match feature we can implement both use cases using a single counter
only.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 97 ++++++++++++---------------------
 1 file changed, 36 insertions(+), 61 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4b..d6ab818 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -46,6 +46,7 @@
 #define TTC_CNT_CNTRL_OFFSET		0x0C /* Counter Control Reg, RW */
 #define TTC_COUNT_VAL_OFFSET		0x18 /* Counter Value Reg, RO */
 #define TTC_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
+#define TTC_MATCH1_OFFSET	0x30 /* Match reg, RW */
 #define TTC_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
 #define TTC_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
 
@@ -61,7 +62,10 @@
 #define PRESCALE		2048	/* The exponent must match this */
 #define CLK_CNTRL_PRESCALE	((PRESCALE_EXPONENT - 1) << 1)
 #define CLK_CNTRL_PRESCALE_EN	1
-#define CNT_CNTRL_RESET		(1 << 4)
+#define CNT_CNTRL_RESET		BIT(4)
+#define CNT_CNTRL_MATCH		BIT(3)
+
+#define TTC_INTERRUPT_MATCH1	BIT(1)
 
 /**
  * struct ttc_timer - This definition defines local timer structure
@@ -90,6 +94,7 @@ struct ttc_timer_clocksource {
 struct ttc_timer_clockevent {
 	struct ttc_timer		ttc;
 	struct clock_event_device	ce;
+	unsigned long			interval;
 };
 
 #define to_ttc_timer_clkevent(x) \
@@ -103,25 +108,25 @@ static void __iomem *ttc_sched_clock_val_reg;
  * @timer:	Pointer to the timer instance
  * @cycles:	Timer interval ticks
  **/
-static void ttc_set_interval(struct ttc_timer *timer,
-					unsigned long cycles)
+static void ttc_set_interval(struct ttc_timer *timer, unsigned long cycles)
 {
-	u32 ctrl_reg;
+	struct ttc_timer_clockevent *ttcce = container_of(timer,
+			struct ttc_timer_clockevent, ttc);
 
-	/* Disable the counter, set the counter value  and re-enable counter */
-	ctrl_reg = __raw_readl(timer->base_addr + TTC_CNT_CNTRL_OFFSET);
-	ctrl_reg |= TTC_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	/* set interval */
+	u32 reg = __raw_readl(timer->base_addr + TTC_COUNT_VAL_OFFSET);
+	reg += cycles;
+	__raw_writel(reg, timer->base_addr + TTC_MATCH1_OFFSET);
 
-	__raw_writel(cycles, timer->base_addr + TTC_INTR_VAL_OFFSET);
+	/* enable match interrupt */
+	__raw_writel(TTC_INTERRUPT_MATCH1, timer->base_addr + TTC_IER_OFFSET);
 
-	/*
-	 * Reset the counter (0x10) so that it starts from 0, one-shot
-	 * mode makes this needed for timing to be right.
-	 */
-	ctrl_reg |= CNT_CNTRL_RESET;
-	ctrl_reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	/* enable timer */
+	reg = __raw_readl(timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+	reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
+	__raw_writel(reg, timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+
+	ttcce->interval = cycles;
 }
 
 /**
@@ -139,6 +144,8 @@ static irqreturn_t ttc_clock_event_interrupt(int irq, void *dev_id)
 
 	/* Acknowledge the interrupt and call event handler */
 	__raw_readl(timer->base_addr + TTC_ISR_OFFSET);
+	if (ttce->ce.mode == CLOCK_EVT_MODE_PERIODIC)
+		ttc_set_interval(timer, ttce->interval);
 
 	ttce->ce.event_handler(&ttce->ce);
 
@@ -192,7 +199,6 @@ static void ttc_set_mode(enum clock_event_mode mode,
 {
 	struct ttc_timer_clockevent *ttce = to_ttc_timer_clkevent(evt);
 	struct ttc_timer *timer = &ttce->ttc;
-	u32 ctrl_reg;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -203,18 +209,9 @@ static void ttc_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_ONESHOT:
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl_reg = __raw_readl(timer->base_addr +
-					TTC_CNT_CNTRL_OFFSET);
-		ctrl_reg |= TTC_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
-				timer->base_addr + TTC_CNT_CNTRL_OFFSET);
+		__raw_writel(0, timer->base_addr + TTC_IER_OFFSET);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
-		ctrl_reg = __raw_readl(timer->base_addr +
-					TTC_CNT_CNTRL_OFFSET);
-		ctrl_reg &= ~TTC_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
-				timer->base_addr + TTC_CNT_CNTRL_OFFSET);
 		break;
 	}
 }
@@ -287,17 +284,6 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	ttccs->cs.mask = CLOCKSOURCE_MASK(16);
 	ttccs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	/*
-	 * Setup the clock source counter to be an incrementing counter
-	 * with no interrupt and it rolls over at 0xFFFF. Pre-scale
-	 * it by 32 also. Let it start running now.
-	 */
-	__raw_writel(0x0,  ttccs->ttc.base_addr + TTC_IER_OFFSET);
-	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-		     ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
-	__raw_writel(CNT_CNTRL_RESET,
-		     ttccs->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
-
 	err = clocksource_register_hz(&ttccs->cs,
 			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
 	if (WARN_ON(err)) {
@@ -377,16 +363,6 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	ttcce->ce.irq = irq;
 	ttcce->ce.cpumask = cpu_possible_mask;
 
-	/*
-	 * Setup the clock event timer to be an interval timer which
-	 * is prescaled by 32 using the interval interrupt. Leave it
-	 * disabled for now.
-	 */
-	__raw_writel(0x23, ttcce->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
-	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-		     ttcce->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
-	__raw_writel(0x1,  ttcce->ttc.base_addr + TTC_IER_OFFSET);
-
 	err = request_irq(irq, ttc_clock_event_interrupt,
 			  IRQF_DISABLED | IRQF_TIMER,
 			  ttcce->ce.name, ttcce);
@@ -409,7 +385,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 {
 	unsigned int irq;
 	void __iomem *timer_baseaddr;
-	struct clk *clk_cs, *clk_ce;
+	struct clk *clk;
 	static int initialized;
 	int clksel;
 
@@ -429,7 +405,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
-	irq = irq_of_parse_and_map(timer, 1);
+	irq = irq_of_parse_and_map(timer, 0);
 	if (irq <= 0) {
 		pr_err("ERROR: invalid interrupt number\n");
 		BUG();
@@ -437,22 +413,21 @@ static void __init ttc_timer_init(struct device_node *timer)
 
 	clksel = __raw_readl(timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
 	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
-	clk_cs = of_clk_get(timer, clksel);
-	if (IS_ERR(clk_cs)) {
+	clk = of_clk_get(timer, clksel);
+	if (IS_ERR(clk)) {
 		pr_err("ERROR: timer input clock not found\n");
 		BUG();
 	}
 
-	clksel = __raw_readl(timer_baseaddr + 4 + TTC_CLK_CNTRL_OFFSET);
-	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
-	clk_ce = of_clk_get(timer, clksel);
-	if (IS_ERR(clk_ce)) {
-		pr_err("ERROR: timer input clock not found\n");
-		BUG();
-	}
+	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
+			timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
+
+	/* start timer in overflow and match mode */
+	__raw_writel(CNT_CNTRL_RESET | CNT_CNTRL_MATCH,
+			timer_baseaddr + TTC_CNT_CNTRL_OFFSET);
 
-	ttc_setup_clocksource(clk_cs, timer_baseaddr);
-	ttc_setup_clockevent(clk_ce, timer_baseaddr + 4, irq);
+	ttc_setup_clocksource(clk, timer_baseaddr);
+	ttc_setup_clockevent(clk, timer_baseaddr, irq);
 
 	pr_info("%s #0 at %p, irq=%d\n", timer->name, timer_baseaddr, irq);
 }
-- 
1.8.3.4


--CNfT9TXqV7nd4cfk--
