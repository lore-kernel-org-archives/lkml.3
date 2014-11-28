Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaK1OBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:01:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36188 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbaK1OBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:01:03 -0500
Date: Fri, 28 Nov 2014 14:00:59 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Message-ID: <20141128140059.GH25883@leverpostej>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-17-git-send-email-cw00.choi@samsung.com>
 <20141127111834.GB857@leverpostej>
 <54787621.4000503@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54787621.4000503@samsung.com>
Thread-Topic: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 01:18:25PM +0000, Chanwoo Choi wrote:
> Dear Mark,
> 
> On 11/27/2014 08:18 PM, Mark Rutland wrote:
> > On Thu, Nov 27, 2014 at 07:35:13AM +0000, Chanwoo Choi wrote:
> >> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC
> >> based on Octal core CPUs (quad Cortex-A57 and quad Cortex-A53).
> >>
> >> Cc: Kukjin Kim <kgene.kim@samsung.com>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Olof Johansson <olof@lixom.net>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will.deacon@arm.com>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Acked-by: Inki Dae <inki.dae@samsung.com>
> >> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> >> ---
> >>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
> >>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 523 +++++++++++++++
> >>  2 files changed, 1221 insertions(+)
> >>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
> >>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
> >

[...]

> >> +       cpus {
> >> +               #address-cells = <2>;
> >> +               #size-cells = <0>;
> >> +
> >> +               cpu0: cpu@100 {
> >> +                       device_type = "cpu";
> >> +                       compatible = "arm,cortex-a53", "arm,armv8";
> >> +                       enable-method = "psci";
> >
> > While the CPU nodes have enable-methods, I didn't spot a PSCI node
> > anywhere, so this dts cannot possibly have been used to bring up an SMP
> > system.
> >
> > How has this dts been tested?
> >
> > What PSCI revision have you implemented? Have have you tested it?
> 
> My mistake,
> Exynos5433 supports PSCI v0.1. I'll add following PSCI nodes:
> I tested the boot of secondary cpu.
> 
>         psci {
>                 compatible = "arm,psci";
>                 method = "smc";
>                 cpu_off = <0x84000002>;
>                 cpu_on = <0xC4000003>;
>         };

Ok. I take it _any_ CPU may be hotplugged (including CPU0), given that
you don't have MIGRATE_INFO_TYPE from PSCI 0.2 to tell you that this is
not possible? If not, attempting to hotplug CPU0 will result in a BUG()
and the kernel will explode.

Has that been tested? 

Do all CPUs enter the kernel at EL2?

> >> +       soc: soc {
> >> +               compatible = "simple-bus";
> >> +               #address-cells = <1>;
> >> +               #size-cells = <1>;
> >> +               ranges;
> >> +
> >> +               fixed-rate-clocks {
> >> +                       #address-cells = <1>;
> >> +                       #size-cells = <0>;
> >> +
> >> +                       xusbxti: clock@0 {
> >> +                               compatible = "fixed-clock";
> >> +                               clock-output-names = "xusbxti";
> >> +                               #clock-cells = <0>;
> >> +                       };
> >> +               };
> >
> > Get rid of the fixed-rate-clocks container node. It's pointless and
> > messy. Given you only have one there's no need for the bogus
> > unit-address either.
> 
> OK, I'll remove unneeded code and will add following dt node for fin_pll.
> 
>         fin_pll: xxti {
>                 compatible = "fixed-clock";
>                 clock-output-names = "fin_pll";
>                 #clock-cells = <0>;
>         };

That looks fine to me.

[...]

> >> +               mct@101c0000 {
> >> +                       compatible = "samsung,exynos4210-mct";
> >> +                       reg = <0x101c0000 0x800>;
> >> +                       interrupts = <0 102 0>, <0 103 0>, <0 104 0>, <0 105 0>,
> >> +                               <0 106 0>, <0 107 0>, <0 108 0>, <0 109>,
> >> +                               <0 110 0>, <0 111 0>, <0 112 0>, <0 113 0>;
> >> +                       clocks = <&cmu_top CLK_FIN_PLL>, <&cmu_peris CLK_PCLK_MCT>;
> >> +                       clock-names = "fin_pll", "mct";
> >> +               };
> >
> > Hase this block had no changes whatsoever since its use in Exynos4210?
> > Do we not need a "samsung,exynos5433-mct" comaptible string too?
> 
> The type of Exynos5433's MCT(Multi-Core Timer) IP is the same with the type of Exynos4210 MCT.
> Just Exynos5433 have eight local timer for Octa cores.

So "samsung,exynos4210-mct" should appear in the list. I'm just
wondering if it's worth having:

	compatible = "samsung,exynos5433-mct", "samsung,exynos4210-mct";

Just in case we need to special-case the 5433 MCT for some reason later.

> 
>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7
> 134:          0          0          0          0          0          0          0          0       GIC 134  mct_comp_irq
> 138:       3189          0          0          0          0          0          0          0       GIC 138  mct_tick0
> 139:          0       2670          0          0          0          0          0          0       GIC 139  mct_tick1
> 140:          0          0       2763          0          0          0          0          0       GIC 140  mct_tick2
> 141:          0          0          0       2732          0          0          0          0       GIC 141  mct_tick3
> 142:          0          0          0          0       2998          0          0          0       GIC 142  mct_tick4
> 143:          0          0          0          0          0       2664          0          0       GIC 143  mct_tick5
> 144:          0          0          0          0          0          0       2485          0       GIC 144  mct_tick6
> 145:          0          0          0          0          0          0          0       2681       GIC 145  mct_tick7
> 
> But, existing exynos-mct.c driver(drivers/clocksource/exynos-mct.c) used
> 'register_current_timer_delay()' function which is supported on arm 32bit.
> I fix it as following diff and then I'll send it to support 64-bit Exynos SoC on exynos-mct.c.
> 
>  drivers/clocksource/Kconfig      | 1 -
>  drivers/clocksource/exynos_mct.c | 4 ++++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 9042060..27ef3fa 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -134,7 +134,6 @@ config CLKSRC_METAG_GENERIC
> 
>  config CLKSRC_EXYNOS_MCT
>         def_bool y if ARCH_EXYNOS
> -       depends on !ARM64
>         help
>           Support for Multi Core Timer controller on Exynos SoCs.
> 
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 9403061..d9c7dbb 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
>         return exynos4_read_count_32();
>  }
> 
> +#if !defined(CONFIG_ARM64)
>  static struct delay_timer exynos4_delay_timer;
> 
>  static cycles_t exynos4_read_current_timer(void)
> @@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
>                          "cycles_t needs to move to 32-bit for ARM64 usage");
>         return exynos4_read_count_32();
>  }
> +#endif
> 
>  static void __init exynos4_clocksource_init(void)
>  {
>         exynos4_mct_frc_start();
> 
> +#if !defined(CONFIG_ARM64)
>         exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>         exynos4_delay_timer.freq = clk_rate;
>         register_current_timer_delay(&exynos4_delay_timer);
> +#endif

Why not make both of these depend on CONFIG_ARM, rather than
!CONFIG_ARM64? We care about the presence of the delay_timer struct and
functions, which (from grepping around) exist in arch/arm and nowhere
else.

> >> +               gic:interrupt-controller@11001000 {
> >> +                       compatible = "arm,cortex-a15-gic";
> >
> > Given this is multi-cluster, surely this is an external GIC-400, for
> > which we have a supported compatible string?
> >
> > So this should at least be:
> >
> >       compatible = "arm,gic-400", "arm,cortex-a15-gic";
> 
> Exynos5433 used GIC-400. I'll modify it as following:
> 
>         compatible = "arm,gic-400";

Ok. The former variant (with "arm,cortex-a15-gic" later in the list) has
the benefit of working with KVM today (which doesn't currently look for
"arm,gic-400").

> >> +                       #interrupt-cells = <3>;
> >> +                       interrupt-controller;
> >> +                       reg =   <0x11001000 0x1000>,
> >> +                               <0x11002000 0x1000>,
> >> +                               <0x11004000 0x2000>,
> >> +                               <0x11006000 0x2000>;
> >
> > As far as I am aware, the GICC size is 8KiB. Regardless of whether we
> > currently use the second page of registers, they should be described.
> 
> The GICC (CPU Interface Register) register of Exynos5433 is range of 0x1100_2000 ~ 0x1100_2100.

That does not sound right. Per the GICv2 architecture, GICC is at least
0x1004 bytes long (as GICC_DIR lives at offset 0x1000).

> But, I'll modify GICC size from 4KiB to 8KiB as following according to your comment:
>         <0x11002000 0x1000> -> <0x11002000 0x2000>

To clarify: is GICC_DIR accessible in Exynos5433 systems, or is
everything past offset 0x100 not physically mapped?

> >> +                       interrupts = <1 9 0xf04>;
> >> +               };
> >> +
> >> +               serial_0: serial@14C10000 {
> >
> > Nit: Please be consistent with capitalisation of hex. IMO it's better
> > to leave it all lower-case.
> 
> I'll use the lower-case for all base address.

Thanks.

> 
> >
> > [...]
> >
> >> +               timer {
> >> +                       compatible = "arm,armv8-timer";
> >> +                       interrupts = <1 13 0xff01>,
> >> +                                    <1 14 0xff01>,
> >> +                                    <1 11 0xff01>,
> >> +                                    <1 10 0xff01>;
> >> +                       clock-frequency = <24000000>;
> >> +                       use-clocksource-only;
> >> +                       use-physical-timer;
> >
> > As Marc said, NAK for these last three properties.
> >
> > There is no excuse for not setting CNTFRQ_EL0, especially given a PSCI
> > implementation. The last two properties have never been supported in
> > mainline, and shouldn't be necessary regardless.
> 
> OK, I'll remove last three properties.

Thanks.

Mark.
