Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3EHQSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:18:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3EHQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:18:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [RFC 5/8] ARM:stih41x: Add STiH415 SOC support
Date: Wed, 8 May 2013 18:18:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, olof@lixom.net, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022297-2334-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1368022297-2334-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081818.01927.arnd@arndb.de>
X-Provags-ID: V02:K0:MNb6cAOE/cNH9/9puFBw7oxPPJ2jcEvGtvWy/eNvT6W
 BQwgSaVF4h2qQ0groLPYTsGI2eYKJKWRa/7KldzH78Ux/98dQw
 AC4wxgT47ECRjh2rxiWykO7AGOZI25eD0xnqvTDHZ4Azwi/lxh
 tI6gv9CpOYaFNl3mSH/uY4PbruD337Ooz9/0EDiyAUlWNm6AZC
 8Vx5cGg7WFxLb5dMlcSG3MN82ZTTUGIYzZyAcbCmzU3N0oDmjA
 e7FwfCN/TF6yLpheAJZ6lYOI3GhTNCQd/GN98Bo7LHhHecJgsn
 VvSusiTZ5DjPSqxnXTqSOh/bR1b1Sal6K9sYCmzu/D2pTkSKob
 0I4aM3iRBf/Z8EH/kM1w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> The STiH415 is the next generation of HD, AVC set-top box processors for
> satellite, cable, terrestrial and IP-STB markets. It is an ARM Cortex-A9
> 1.0 GHz, dual-core CPU.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stephen Gallimore <stephen.gallimore@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> ---
>  Documentation/arm/STiH41x/overview.txt         |   39 ++
>  Documentation/arm/STiH41x/stih415-overview.txt |   12 +
>  arch/arm/Kconfig                               |    3 +
>  arch/arm/Kconfig.debug                         |   38 ++
>  arch/arm/Makefile                              |    2 +
>  arch/arm/boot/dts/stih415-clock.dtsi           |   38 ++
>  arch/arm/boot/dts/stih415-pinctrl.dtsi         |  480 ++++++++++++++++++++++++
>  arch/arm/boot/dts/stih415.dtsi                 |   94 +++++
>  arch/arm/boot/dts/stih415.h                    |   20 +
>  arch/arm/boot/dts/stih41x.dtsi                 |   30 ++
>  arch/arm/boot/dts/stixxxx-pincfg.h             |   95 +++++
>  arch/arm/configs/stih41x_defconfig             |   94 +++++
>  arch/arm/include/debug/stixxxx.S               |   61 +++
>  arch/arm/mach-stih41x/Kconfig                  |   35 ++
>  arch/arm/mach-stih41x/Makefile                 |    4 +
>  arch/arm/mach-stih41x/board-dt.c               |   76 ++++
>  arch/arm/mach-stih41x/stih41x.c                |   82 ++++
>  arch/arm/mach-stih41x/stih41x.h                |    7 +
>  arch/arm/plat-stixxxx/Kconfig                  |    2 +
>  arch/arm/plat-stixxxx/Makefile                 |    2 +
>  arch/arm/plat-stixxxx/headsmp.S                |   44 +++
>  arch/arm/plat-stixxxx/include/plat/hardware.h  |   20 +
>  arch/arm/plat-stixxxx/include/plat/smp.h       |   19 +
>  arch/arm/plat-stixxxx/platsmp.c                |  144 +++++++

I think there is no point in having a separate mach- and plat- directory
here, given that modern machines require very little code. You can probably
fold the three files in mach-stih41x (board-dt.c, stih41x.c and stih41x.h)
into a single file and rename plat-stixxxx to mach-stixxxx

> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 9b31f43..42a5193 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -447,6 +447,16 @@ choice
>  		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
>  		  devices, including VT8500, WM8505, WM8650 and WM8850.
>  
> +	config DEBUG_STIH41X_UART
> +		depends on ARCH_STIH41X
> +		bool "Use StiH415/416 ASC for low-level debug"
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on StiH415/416 based platforms like B2000, B2020.
> +		  It support UART2 and SBC_UART1.
> +
> +		  If unsure, say N.
> +
>  	config DEBUG_LL_UART_NONE
>  		bool "No low-level debugging UART"
>  		depends on !ARCH_MULTIPLATFORM

I would split out the debug code into a separate patch though.

> @@ -600,6 +637,7 @@ config DEBUG_LL_INCLUDE
>  	default "debug/vt8500.S" if DEBUG_VT8500_UART0
>  	default "debug/tegra.S" if DEBUG_TEGRA_UART
>  	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
> +	default "debug/stixxxx.S" if DEBUG_STIH41X_UART
>  	default "mach/debug-macro.S"

Please keep this in alphabetical order.

> +	soc {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		#interrupt-cells = <3>;
> +		interrupt-parent = <&intc>;

The "#interrupt-cells" property doesn't belong here I think.

> +
> +		uart2: uart@fed32000 {
> +			compatible	= "st,asc";
> +			status 		= "disabled";
> +			reg		= <0xfed32000 0x2c>;
> +			interrupts	= <0 197 0>;
> +			pinctrl-names 	= "default";
> +			pinctrl-0 	= <&pinctrl_uart2>;
> +			clocks		= <&CLKS_ICN_REG_0>;
> +		};
> +
> +		/* SBC comms block ASCs in SASG1 */
> +		sbc_uart1: uart@fe531000 {
> +			compatible	= "st,asc";
> +			status 		= "disabled";
> +			reg		= <0xfe531000 0x2c>;
> +			interrupts	= <0 210 0>;
> +			clocks		= <&CLK_SYSIN>;
> +			pinctrl-names 	= "default";
> +			pinctrl-0	= <&pinctrl_sbc_uart1>;
> +		};
> +	};

Please name these devices "serial", not "uart".

> diff --git a/arch/arm/configs/stih41x_defconfig b/arch/arm/configs/stih41x_defconfig
> new file mode 100644
> index 0000000..dd9268b
> --- /dev/null
> +++ b/arch/arm/configs/stih41x_defconfig

I would prefer to have this be part of multi_v7_defconfig, unless
you have strong reason why it can't be.

> diff --git a/arch/arm/mach-stih41x/Kconfig b/arch/arm/mach-stih41x/Kconfig
> new file mode 100644
> index 0000000..9c40540
> --- /dev/null
> +++ b/arch/arm/mach-stih41x/Kconfig
> @@ -0,0 +1,35 @@
> +config ARCH_STIH41X
> +	bool "STMicroelectronics STiH41x SOCs with Flattened Device Tree" if ARCH_MULTI_V7
> +	select GENERIC_CLOCKEVENTS
> +	select CLKDEV_LOOKUP
> +	select ARM_GIC


> +if ARCH_STIH41X
> +menu "STMicroelectronics Consumer Electronics SOCs"

You can use 'menuconfig' to combine these two.

> +static void __init stih41x_timer_init(void)
> +{
> +	of_clk_init(NULL);
> +	clocksource_of_init();
> +	stih41x_l2x0_init();
> +}

I'm hoping we can kill make the clk and l2x0 init work by default in 3.11,
as clocksource_of_init already does, so you won't need this function
any more.

> +/*
> + * A basic implementation of irq_set_wake that ensures wakeup source
> + * interrupts are not disabled during PM_SUSPEND_FREEZE.
> + */
> +static int stih41x_set_wake(struct irq_data *d, unsigned int on)
> +{
> +	struct irq_desc *desc = irq_to_desc(d->irq);
> +
> +	if (on) {
> +		if (desc->action)
> +			desc->action->flags |= IRQF_NO_SUSPEND;
> +	} else {
> +		if (desc->action)
> +			desc->action->flags &= ~IRQF_NO_SUSPEND;
> +	}
> +	return 0;
> +}
> +
> +static void __init stih41x_irq_init(void)
> +{
> +	gic_arch_extn.irq_set_wake = stih41x_set_wake;
> +	gic_arch_extn.flags = IRQCHIP_MASK_ON_SUSPEND;
> +
> +	irqchip_init();
> +}

This looks like it should be generic. Why do you need this?

> +void __init stih41x_dt_init(void)
> +{
> +	of_platform_populate(NULL, of_default_bus_match_table,
> +				NULL, NULL);
> +	return;
> +}

This is already not needed in 3.10.

> +static struct map_desc stih41x_io_desc[] __initdata = {
> +#ifdef CONFIG_SMP
> +	{
> +		.virtual	= IO_ADDRESS(MPE41_SCU_BASE),
> +		.pfn		= __phys_to_pfn(MPE41_SCU_BASE),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	},
> +#endif

> +void __init stih41x_map_io(void)
> +{
> +#ifdef CONFIG_SMP
> +	stixxxx_scu_base_addr = ((void __iomem *)IO_ADDRESS(MPE41_SCU_BASE));
> +#endif
> +	iotable_init(stih41x_io_desc, ARRAY_SIZE(stih41x_io_desc));
> +}

IIRC the SCU no longer needs to be mapped this early, so you can use
ioremap these days.

> +void __init stih41x_l2x0_init(void)
> +{
> +	u32 way_size = 0x4;
> +	u32 aux_ctrl;
> +
> +	aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
> +		(0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
> +		(0x1 << L2X0_AUX_CTRL_INSTR_PREFETCH_SHIFT) |
> +		(way_size << L2X0_AUX_CTRL_WAY_SIZE_SHIFT);
> +
> +	l2x0_of_init(aux_ctrl, L2X0_AUX_CTRL_MASK);
> +}

I don't know where we stand on this, but I think we should kill all
calls like these.

	Arnd
