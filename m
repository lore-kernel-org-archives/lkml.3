Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3KAQZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:25:32 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65356 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3KAQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAGc3s_f5OYc90nSPkmJpNyQ6VrerKwKONm+6jE=K_FzOATu3AQ@mail.gmail.com>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
	<1381763305-7085-3-git-send-email-v.tyrtov@samsung.com>
	<20131022094410.11944.31261@quantum>
	<CAGc3s_f5OYc90nSPkmJpNyQ6VrerKwKONm+6jE=K_FzOATu3AQ@mail.gmail.com>
Date: Fri, 1 Nov 2013 14:25:26 -0200
Message-ID: <CAGc3s_dN_tzJWhaUP9xgsg36O4bsiC4AoAViTwqXhRh+8pSDuQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] clk: exynos5410: register clocks using common
 clock framework
From: Mauro Ribeiro <mdrjr0@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nevermind, didn't read the clk-pll.c properly..
pll_35xx and pl_2550 will default to the same code.


Best Regards,
Mauro

On Fri, Nov 1, 2013 at 1:53 PM, Mauro Ribeiro <mdrjr0@gmail.com> wrote:
> Is the PLL35xx driver compatible with the ones used on 5410?
>
> +static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
> +       [apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
> +               APLL_CON0, NULL),
> +       [cpll] = PLL(pll_35xx, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
> +               CPLL_CON0, NULL),
> +       [mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll", MPLL_LOCK,
> +               MPLL_CON0, NULL),
> +       [bpll] = PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll", BPLL_LOCK,
> +               BPLL_CON0, NULL),
> +       [kpll] = PLL(pll_35xx, CLK_FOUT_KPLL, "fout_kpll", "fin_pll", KPLL_LOCK,
> +               KPLL_CON0, NULL),
>
> It registers all the PLL's with the same PLL. While the manual says
> others PLL names.
>
> Regards,
> Mauro
>
> On Tue, Oct 22, 2013 at 7:44 AM, Mike Turquette <mturquette@linaro.org> wrote:
>> Quoting Vyacheslav Tyrtov (2013-10-14 08:08:23)
>>> From: Tarek Dakhran <t.dakhran@samsung.com>
>>>
>>> The EXYNOS5410 clocks are statically listed and registered
>>> using the Samsung specific common clock helper functions.
>>>
>>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>>
>> Looks good to me. Any objections for me to take this through the clk
>> tree?
>>
>> Regards,
>> Mike
>>
>>> ---
>>>  .../devicetree/bindings/clock/exynos5410-clock.txt |  37 +++
>>>  drivers/clk/samsung/Makefile                       |   1 +
>>>  drivers/clk/samsung/clk-exynos5410.c               | 251 +++++++++++++++++++++
>>>  include/dt-bindings/clock/exynos5410.h             | 175 ++++++++++++++
>>>  4 files changed, 464 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>>  create mode 100644 include/dt-bindings/clock/exynos5410.h
>>>
>>> diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>> new file mode 100644
>>> index 0000000..a462da231
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>> @@ -0,0 +1,37 @@
>>> +* Samsung Exynos5410 Clock Controller
>>> +
>>> +The Exynos5410 clock controller generates and supplies clock to various
>>> +controllers within the Exynos5410 SoC.
>>> +
>>> +Required Properties:
>>> +
>>> +- compatible: should be "samsung,exynos5410-clock"
>>> +
>>> +- reg: physical base address of the controller and length of memory mapped
>>> +  region.
>>> +
>>> +- #clock-cells: should be 1.
>>> +
>>> +All available clocks are defined as preprocessor macros in
>>> +dt-bindings/clock/exynos5410.h header and can be used in device
>>> +tree sources.
>>> +
>>> +Example 1: An example of a clock controller node is listed below.
>>> +
>>> +       clock: clock-controller@0x10010000 {
>>> +               compatible = "samsung,exynos5410-clock";
>>> +               reg = <0x10010000 0x30000>;
>>> +               #clock-cells = <1>;
>>> +       };
>>> +
>>> +Example 2: UART controller node that consumes the clock generated by the clock
>>> +          controller. Refer to the standard clock bindings for information
>>> +          about 'clocks' and 'clock-names' property.
>>> +
>>> +       serial@12C20000 {
>>> +               compatible = "samsung,exynos4210-uart";
>>> +               reg = <0x12C00000 0x100>;
>>> +               interrupts = <0 51 0>;
>>> +               clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
>>> +               clock-names = "uart", "clk_uart_baud0";
>>> +       };
>>> diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
>>> index 3413380..5a446ca 100644
>>> --- a/drivers/clk/samsung/Makefile
>>> +++ b/drivers/clk/samsung/Makefile
>>> @@ -5,6 +5,7 @@
>>>  obj-$(CONFIG_COMMON_CLK)       += clk.o clk-pll.o
>>>  obj-$(CONFIG_ARCH_EXYNOS4)     += clk-exynos4.o
>>>  obj-$(CONFIG_SOC_EXYNOS5250)   += clk-exynos5250.o
>>> +obj-$(CONFIG_SOC_EXYNOS5410)   += clk-exynos5410.o
>>>  obj-$(CONFIG_SOC_EXYNOS5420)   += clk-exynos5420.o
>>>  obj-$(CONFIG_SOC_EXYNOS5440)   += clk-exynos5440.o
>>>  obj-$(CONFIG_ARCH_EXYNOS)      += clk-exynos-audss.o
>>> diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
>>> new file mode 100644
>>> index 0000000..c5eba08
>>> --- /dev/null
>>> +++ b/drivers/clk/samsung/clk-exynos5410.c
>>> @@ -0,0 +1,251 @@
>>> +/*
>>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
>>> + * Author: Tarek Dakhran <t.dakhran@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * Common Clock Framework support for Exynos5410 SoC.
>>> +*/
>>> +
>>> +#include <dt-bindings/clock/exynos5410.h>
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/clkdev.h>
>>> +#include <linux/clk-provider.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +
>>> +#include "clk.h"
>>> +
>>> +#define APLL_LOCK               0x0
>>> +#define APLL_CON0               0x100
>>> +#define CPLL_LOCK               0x10020
>>> +#define CPLL_CON0               0x10120
>>> +#define MPLL_LOCK               0x4000
>>> +#define MPLL_CON0               0x4100
>>> +#define BPLL_LOCK               0x20010
>>> +#define BPLL_CON0               0x20110
>>> +#define KPLL_LOCK               0x28000
>>> +#define KPLL_CON0               0x28100
>>> +
>>> +#define SRC_CPU                        0x200
>>> +#define DIV_CPU0               0x500
>>> +#define SRC_CPERI1             0x4204
>>> +#define DIV_TOP0               0x10510
>>> +#define DIV_TOP1               0x10514
>>> +#define DIV_FSYS1              0x1054c
>>> +#define DIV_FSYS2              0x10550
>>> +#define DIV_PERIC0             0x10558
>>> +#define SRC_TOP0               0x10210
>>> +#define SRC_TOP1               0x10214
>>> +#define SRC_TOP2               0x10218
>>> +#define SRC_FSYS               0x10244
>>> +#define SRC_PERIC0             0x10250
>>> +#define SRC_MASK_FSYS          0x10340
>>> +#define SRC_MASK_PERIC0                0x10350
>>> +#define GATE_BUS_FSYS0         0x10740
>>> +#define GATE_IP_FSYS           0x10944
>>> +#define GATE_IP_PERIC          0x10950
>>> +#define GATE_IP_PERIS          0x10960
>>> +#define SRC_CDREX              0x20200
>>> +#define SRC_KFC                        0x28200
>>> +#define DIV_KFC0               0x28500
>>> +
>>> +/* list of PLLs */
>>> +enum exynos5410_plls {
>>> +       apll, cpll, mpll,
>>> +       bpll, kpll,
>>> +       nr_plls                 /* number of PLLs */
>>> +};
>>> +
>>> +/*
>>> + * list of controller registers to be saved and restored during a
>>> + * suspend/resume cycle.
>>> + */
>>> +static unsigned long exynos5410_clk_regs[] __initdata = {
>>> +       SRC_CPU,
>>> +       DIV_CPU0,
>>> +       SRC_CPERI1,
>>> +       DIV_TOP0,
>>> +       DIV_TOP1,
>>> +       DIV_FSYS1,
>>> +       DIV_FSYS2,
>>> +       DIV_PERIC0,
>>> +       SRC_TOP0,
>>> +       SRC_TOP1,
>>> +       SRC_TOP2,
>>> +       SRC_FSYS,
>>> +       SRC_PERIC0,
>>> +       SRC_MASK_FSYS,
>>> +       SRC_MASK_PERIC0,
>>> +       GATE_BUS_FSYS0,
>>> +       GATE_IP_FSYS,
>>> +       GATE_IP_PERIC,
>>> +       GATE_IP_PERIS,
>>> +       SRC_CDREX,
>>> +       SRC_KFC,
>>> +       DIV_KFC0,
>>> +};
>>> +
>>> +/* list of all parent clocks */
>>> +PNAME(apll_p)          = { "fin_pll", "fout_apll", };
>>> +PNAME(bpll_p)          = { "fin_pll", "fout_bpll", };
>>> +PNAME(cpll_p)          = { "fin_pll", "fout_cpll" };
>>> +PNAME(mpll_p)          = { "fin_pll", "fout_mpll", };
>>> +PNAME(kpll_p)          = { "fin_pll", "fout_kpll", };
>>> +
>>> +PNAME(mout_cpu_p)      = { "mout_apll", "sclk_mpll", };
>>> +PNAME(mout_kfc_p)      = { "mout_kpll", "sclk_mpll", };
>>> +
>>> +PNAME(mpll_user_p)     = { "fin_pll", "sclk_mpll", };
>>> +PNAME(bpll_user_p)     = { "fin_pll", "sclk_bpll", };
>>> +PNAME(mpll_bpll_p)     = { "sclk_mpll_muxed", "sclk_bpll_muxed", };
>>> +
>>> +PNAME(group2_p)                = { "fin_pll", "fin_pll", "none", "none",
>>> +                       "none", "none", "sclk_mpll_bpll",
>>> +                        "none", "none", "sclk_cpll" };
>>> +
>>> +/* fixed rate clocks generated outside the soc */
>>> +static struct samsung_fixed_rate_clock exynos5410_frt_ext_clks[] __initdata = {
>>> +       FRATE(CLK_FIN_PLL, "fin_pll", NULL, CLK_IS_ROOT, 0),
>>> +};
>>> +
>>> +static struct samsung_mux_clock exynos5410_mux_clks[] __initdata = {
>>> +       MUX(0, "mout_apll", apll_p, SRC_CPU, 0, 1),
>>> +       MUX(0, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1),
>>> +
>>> +       MUX(0, "mout_kpll", kpll_p, SRC_KFC, 0, 1),
>>> +       MUX(0, "mout_kfc", mout_kfc_p, SRC_KFC, 16, 1),
>>> +
>>> +       MUX(0, "sclk_mpll", mpll_p, SRC_CPERI1, 8, 1),
>>> +       MUX(0, "sclk_mpll_muxed", mpll_user_p, SRC_TOP2, 20, 1),
>>> +
>>> +       MUX(0, "sclk_bpll", bpll_p, SRC_CDREX, 0, 1),
>>> +       MUX(0, "sclk_bpll_muxed", bpll_user_p, SRC_TOP2, 24, 1),
>>> +
>>> +       MUX(0, "sclk_cpll", cpll_p, SRC_TOP2, 8, 1),
>>> +
>>> +       MUX(0, "sclk_mpll_bpll", mpll_bpll_p, SRC_TOP1, 20, 1),
>>> +
>>> +       MUX(0, "mout_mmc0", group2_p, SRC_FSYS, 0, 4),
>>> +       MUX(0, "mout_mmc1", group2_p, SRC_FSYS, 4, 4),
>>> +       MUX(0, "mout_mmc2", group2_p, SRC_FSYS, 8, 4),
>>> +
>>> +       MUX(0, "mout_uart0", group2_p, SRC_PERIC0, 0, 4),
>>> +       MUX(0, "mout_uart1", group2_p, SRC_PERIC0, 4, 4),
>>> +       MUX(0, "mout_uart2", group2_p, SRC_PERIC0, 8, 4),
>>> +
>>> +       MUX(0, "mout_aclk200", mpll_bpll_p, SRC_TOP0, 12, 1),
>>> +       MUX(0, "mout_aclk400", mpll_bpll_p, SRC_TOP0, 20, 1),
>>> +};
>>> +
>>> +static struct samsung_div_clock exynos5410_div_clks[] __initdata = {
>>> +       DIV(0, "div_arm", "mout_cpu", DIV_CPU0, 0, 3),
>>> +       DIV(0, "div_arm2", "div_arm", DIV_CPU0, 28, 3),
>>> +
>>> +       DIV(0, "div_acp", "div_arm2", DIV_CPU0, 8, 3),
>>> +       DIV(0, "div_cpud", "div_arm2", DIV_CPU0, 4, 3),
>>> +       DIV(0, "div_atb", "div_arm2", DIV_CPU0, 16, 3),
>>> +       DIV(0, "pclk_dbg", "div_arm2", DIV_CPU0, 20, 3),
>>> +
>>> +       DIV(0, "div_kfc", "mout_kfc", DIV_KFC0, 0, 3),
>>> +       DIV(0, "div_aclk", "div_kfc", DIV_KFC0, 4, 3),
>>> +       DIV(0, "div_pclk", "div_kfc", DIV_KFC0, 20, 3),
>>> +
>>> +       DIV(0, "aclk66_pre", "sclk_mpll_muxed", DIV_TOP1, 24, 3),
>>> +       DIV(0, "aclk66", "aclk66_pre", DIV_TOP0, 0, 3),
>>> +
>>> +       DIV(0, "div_mmc0", "mout_mmc0", DIV_FSYS1, 0, 4),
>>> +       DIV(0, "div_mmc1", "mout_mmc1", DIV_FSYS1, 16, 4),
>>> +       DIV(0, "div_mmc2", "mout_mmc2", DIV_FSYS2, 0, 4),
>>> +
>>> +       DIV_F(0, "div_mmc_pre0", "div_mmc0",
>>> +                       DIV_FSYS1, 8, 8, CLK_SET_RATE_PARENT, 0),
>>> +       DIV_F(0, "div_mmc_pre1", "div_mmc1",
>>> +                       DIV_FSYS1, 24, 8, CLK_SET_RATE_PARENT, 0),
>>> +       DIV_F(0, "div_mmc_pre2", "div_mmc2",
>>> +                       DIV_FSYS2, 8, 8, CLK_SET_RATE_PARENT, 0),
>>> +
>>> +       DIV(0, "div_uart0", "mout_uart0", DIV_PERIC0, 0, 4),
>>> +       DIV(0, "div_uart1", "mout_uart1", DIV_PERIC0, 4, 4),
>>> +       DIV(0, "div_uart2", "mout_uart2", DIV_PERIC0, 8, 4),
>>> +       DIV(0, "div_uart3", "mout_uart3", DIV_PERIC0, 12, 4),
>>> +
>>> +       DIV(0, "aclk200", "mout_aclk200", DIV_TOP0, 12, 3),
>>> +       DIV(0, "aclk400", "mout_aclk400", DIV_TOP0, 24, 3),
>>> +};
>>> +
>>> +static struct samsung_gate_clock exynos5410_gate_clks[] __initdata = {
>>> +       GATE(CLK_MCT, "mct", "aclk66", GATE_IP_PERIS, 18, 0, 0),
>>> +
>>> +       GATE(CLK_SCLK_MMC0, "sclk_mmc0", "div_mmc_pre0",
>>> +                       SRC_MASK_FSYS, 0, CLK_SET_RATE_PARENT, 0),
>>> +       GATE(CLK_SCLK_MMC1, "sclk_mmc1", "div_mmc_pre1",
>>> +                       SRC_MASK_FSYS, 4, CLK_SET_RATE_PARENT, 0),
>>> +       GATE(CLK_SCLK_MMC2, "sclk_mmc2", "div_mmc_pre2",
>>> +                       SRC_MASK_FSYS, 8, CLK_SET_RATE_PARENT, 0),
>>> +
>>> +       GATE(CLK_MMC0, "sdmmc0", "aclk200", GATE_BUS_FSYS0, 12, 0, 0),
>>> +       GATE(CLK_MMC1, "sdmmc1", "aclk200", GATE_BUS_FSYS0, 13, 0, 0),
>>> +       GATE(CLK_MMC2, "sdmmc2", "aclk200", GATE_BUS_FSYS0, 14, 0, 0),
>>> +
>>> +       GATE(CLK_UART0, "uart0", "aclk66", GATE_IP_PERIC, 0, 0, 0),
>>> +       GATE(CLK_UART1, "uart1", "aclk66", GATE_IP_PERIC, 1, 0, 0),
>>> +       GATE(CLK_UART2, "uart2", "aclk66", GATE_IP_PERIC, 2, 0, 0),
>>> +
>>> +       GATE(CLK_SCLK_UART0, "sclk_uart0", "div_uart0",
>>> +                       SRC_MASK_PERIC0, 0, CLK_SET_RATE_PARENT, 0),
>>> +       GATE(CLK_SCLK_UART1, "sclk_uart1", "div_uart1",
>>> +                       SRC_MASK_PERIC0, 4, CLK_SET_RATE_PARENT, 0),
>>> +       GATE(CLK_SCLK_UART2, "sclk_uart2", "div_uart2",
>>> +                       SRC_MASK_PERIC0, 8, CLK_SET_RATE_PARENT, 0),
>>> +};
>>> +
>>> +static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
>>> +       [apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
>>> +               APLL_CON0, NULL),
>>> +       [cpll] = PLL(pll_35xx, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
>>> +               CPLL_CON0, NULL),
>>> +       [mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll", MPLL_LOCK,
>>> +               MPLL_CON0, NULL),
>>> +       [bpll] = PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll", BPLL_LOCK,
>>> +               BPLL_CON0, NULL),
>>> +       [kpll] = PLL(pll_35xx, CLK_FOUT_KPLL, "fout_kpll", "fin_pll", KPLL_LOCK,
>>> +               KPLL_CON0, NULL),
>>> +};
>>> +
>>> +static struct of_device_id ext_clk_match[] __initdata = {
>>> +       { .compatible = "samsung,clock-oscclk", .data = (void *)0, },
>>> +       { },
>>> +};
>>> +
>>> +/* register exynos5410 clocks */
>>> +static void __init exynos5410_clk_init(struct device_node *np)
>>> +{
>>> +       void __iomem *reg_base;
>>> +
>>> +       reg_base = of_iomap(np, 0);
>>> +       if (!reg_base)
>>> +               panic("%s: failed to map registers\n", __func__);
>>> +
>>> +       samsung_clk_init(np, reg_base, CLK_NR_CLKS,
>>> +                       exynos5410_clk_regs, ARRAY_SIZE(exynos5410_clk_regs),
>>> +                       NULL, 0);
>>> +       samsung_clk_of_register_fixed_ext(exynos5410_frt_ext_clks,
>>> +                       ARRAY_SIZE(exynos5410_frt_ext_clks),
>>> +                       ext_clk_match);
>>> +       samsung_clk_register_pll(exynos5410_plls, ARRAY_SIZE(exynos5410_plls),
>>> +                                       reg_base);
>>> +
>>> +       samsung_clk_register_mux(exynos5410_mux_clks,
>>> +                       ARRAY_SIZE(exynos5410_mux_clks));
>>> +       samsung_clk_register_div(exynos5410_div_clks,
>>> +                       ARRAY_SIZE(exynos5410_div_clks));
>>> +       samsung_clk_register_gate(exynos5410_gate_clks,
>>> +                       ARRAY_SIZE(exynos5410_gate_clks));
>>> +
>>> +       pr_debug("Exynos5410: clock setup completed.\n");
>>> +}
>>> +CLK_OF_DECLARE(exynos5410_clk, "samsung,exynos5410-clock", exynos5410_clk_init);
>>> diff --git a/include/dt-bindings/clock/exynos5410.h b/include/dt-bindings/clock/exynos5410.h
>>> new file mode 100644
>>> index 0000000..9b4a58b
>>> --- /dev/null
>>> +++ b/include/dt-bindings/clock/exynos5410.h
>>> @@ -0,0 +1,175 @@
>>> +#ifndef _DT_BINDINGS_CLOCK_EXYNOS_5410_H
>>> +#define _DT_BINDINGS_CLOCK_EXYNOS_5410_H
>>> +
>>> +/* core clocks */
>>> +#define CLK_FIN_PLL 1
>>> +#define CLK_FOUT_APLL 2
>>> +#define CLK_FOUT_CPLL 3
>>> +#define CLK_FOUT_DPLL 4
>>> +#define CLK_FOUT_EPLL 5
>>> +#define CLK_FOUT_RPLL 6
>>> +#define CLK_FOUT_IPLL 7
>>> +#define CLK_FOUT_SPLL 8
>>> +#define CLK_FOUT_VPLL 9
>>> +#define CLK_FOUT_MPLL 10
>>> +#define CLK_FOUT_BPLL 11
>>> +#define CLK_FOUT_KPLL 12
>>> +
>>> +/* gate for special clocks (sclk) */
>>> +#define CLK_SCLK_UART0 128
>>> +#define CLK_SCLK_UART1 129
>>> +#define CLK_SCLK_UART2 130
>>> +#define CLK_SCLK_UART3 131
>>> +#define CLK_SCLK_MMC0 132
>>> +#define CLK_SCLK_MMC1 133
>>> +#define CLK_SCLK_MMC2 134
>>> +#define CLK_SCLK_SPI0 135
>>> +#define CLK_SCLK_SPI1 136
>>> +#define CLK_SCLK_SPI2 137
>>> +#define CLK_SCLK_I2S1 138
>>> +#define CLK_SCLK_I2S2 139
>>> +#define CLK_SCLK_PCM1 140
>>> +#define CLK_SCLK_PCM2 141
>>> +#define CLK_SCLK_SPDIF 142
>>> +#define CLK_SCLK_HDMI 143
>>> +#define CLK_SCLK_PIXEL 144
>>> +#define CLK_SCLK_DP1 145
>>> +#define CLK_SCLK_MIPI1 146
>>> +#define CLK_SCLK_FIMD1 147
>>> +#define CLK_SCLK_MAUDIO0 148
>>> +#define CLK_SCLK_MAUPCM0 149
>>> +#define CLK_SCLK_USBD300 150
>>> +#define CLK_SCLK_USBD301 151
>>> +#define CLK_SCLK_USBPHY300 152
>>> +#define CLK_SCLK_USBPHY301 153
>>> +#define CLK_SCLK_UNIPRO 154
>>> +#define CLK_SCLK_PWM 155
>>> +#define CLK_SCLK_GSCL_WA 156
>>> +#define CLK_SCLK_GSCL_WB 157
>>> +#define CLK_SCLK_HDMIPHY 158
>>> +
>>> +/* gate clocks */
>>> +#define CLK_ACLK66_PERIC 256
>>> +#define CLK_UART0 257
>>> +#define CLK_UART1 258
>>> +#define CLK_UART2 259
>>> +#define CLK_UART3 260
>>> +#define CLK_I2C0 261
>>> +#define CLK_I2C1 262
>>> +#define CLK_I2C2 263
>>> +#define CLK_I2C3 264
>>> +#define CLK_I2C4 265
>>> +#define CLK_I2C5 266
>>> +#define CLK_I2C6 267
>>> +#define CLK_I2C7 268
>>> +#define CLK_I2C_HDMI 269
>>> +#define CLK_TSADC 270
>>> +#define CLK_SPI0 271
>>> +#define CLK_SPI1 272
>>> +#define CLK_SPI2 273
>>> +#define CLK_KEYIF 274
>>> +#define CLK_I2S1 275
>>> +#define CLK_I2S2 276
>>> +#define CLK_PCM1 277
>>> +#define CLK_PCM2 278
>>> +#define CLK_PWM 279
>>> +#define CLK_SPDIF 280
>>> +#define CLK_I2C8 281
>>> +#define CLK_I2C9 282
>>> +#define CLK_I2C10 283
>>> +#define CLK_ACLK66_PSGEN 300
>>> +#define CLK_CHIPID 301
>>> +#define CLK_SYSREG 302
>>> +#define CLK_TZPC0 303
>>> +#define CLK_TZPC1 304
>>> +#define CLK_TZPC2 305
>>> +#define CLK_TZPC3 306
>>> +#define CLK_TZPC4 307
>>> +#define CLK_TZPC5 308
>>> +#define CLK_TZPC6 309
>>> +#define CLK_TZPC7 310
>>> +#define CLK_TZPC8 311
>>> +#define CLK_TZPC9 312
>>> +#define CLK_HDMI_CEC 313
>>> +#define CLK_SECKEY 314
>>> +#define CLK_MCT 315
>>> +#define CLK_WDT 316
>>> +#define CLK_RTC 317
>>> +#define CLK_TMU 318
>>> +#define CLK_TMU_GPU 319
>>> +#define CLK_PCLK66_GPIO 330
>>> +#define CLK_ACLK200_FSYS2 350
>>> +#define CLK_MMC0 351
>>> +#define CLK_MMC1 352
>>> +#define CLK_MMC2 353
>>> +#define CLK_SROMC 354
>>> +#define CLK_UFS 355
>>> +#define CLK_ACLK200_FSYS 360
>>> +#define CLK_TSI 361
>>> +#define CLK_PDMA0 362
>>> +#define CLK_PDMA1 363
>>> +#define CLK_RTIC 364
>>> +#define CLK_USBH20 365
>>> +#define CLK_USBD300 366
>>> +#define CLK_USBD301 367
>>> +#define CLK_ACLK400_MSCL 380
>>> +#define CLK_MSCL0 381
>>> +#define CLK_MSCL1 382
>>> +#define CLK_MSCL2 383
>>> +#define CLK_SMMU_MSCL0 384
>>> +#define CLK_SMMU_MSCL1 385
>>> +#define CLK_SMMU_MSCL2 386
>>> +#define CLK_ACLK333 400
>>> +#define CLK_MFC 401
>>> +#define CLK_SMMU_MFCL 402
>>> +#define CLK_SMMU_MFCR 403
>>> +#define CLK_ACLK200_DISP1 410
>>> +#define CLK_DSIM1 411
>>> +#define CLK_DP1 412
>>> +#define CLK_HDMI 413
>>> +#define CLK_ACLK300_DISP1 420
>>> +#define CLK_FIMD1 421
>>> +#define CLK_SMMU_FIMD1 422
>>> +#define CLK_ACLK166 430
>>> +#define CLK_MIXER 431
>>> +#define CLK_ACLK266 440
>>> +#define CLK_ROTATOR 441
>>> +#define CLK_MDMA1 442
>>> +#define CLK_SMMU_ROTATOR 443
>>> +#define CLK_SMMU_MDMA1 444
>>> +#define CLK_ACLK300_JPEG 450
>>> +#define CLK_JPEG 451
>>> +#define CLK_JPEG2 452
>>> +#define CLK_SMMU_JPEG 453
>>> +#define CLK_ACLK300_GSCL 460
>>> +#define CLK_SMMU_GSCL0 461
>>> +#define CLK_SMMU_GSCL1 462
>>> +#define CLK_GSCL_WA 463
>>> +#define CLK_GSCL_WB 464
>>> +#define CLK_GSCL0 465
>>> +#define CLK_GSCL1 466
>>> +#define CLK_CLK_3AA 467
>>> +#define CLK_ACLK266_G2D 470
>>> +#define CLK_SSS 471
>>> +#define CLK_SLIM_SSS 472
>>> +#define CLK_MDMA0 473
>>> +#define CLK_ACLK333_G2D 480
>>> +#define CLK_G2D 481
>>> +#define CLK_ACLK333_432_GSCL 490
>>> +#define CLK_SMMU_3AA 491
>>> +#define CLK_SMMU_FIMCL0 492
>>> +#define CLK_SMMU_FIMCL1 493
>>> +#define CLK_SMMU_FIMCL3 494
>>> +#define CLK_FIMC_LITE3 495
>>> +#define CLK_ACLK_G3D 500
>>> +#define CLK_G3D 501
>>> +#define CLK_SMMU_MIXER 502
>>> +
>>> +/* mux clocks */
>>> +#define CLK_MOUT_HDMI 640
>>> +
>>> +/* divider clocks */
>>> +#define CLK_DOUT_PIXEL 768
>>> +#define CLK_NR_CLKS 769
>>> +
>>> +#endif /* _DT_BINDINGS_CLOCK_EXYNOS_5410_H */
>>> --
>>> 1.8.1.5
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
