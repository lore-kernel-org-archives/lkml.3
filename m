Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaKXOAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:00:40 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:63223 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKXOAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:00:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: ralf@linux-mips.org, f.fainelli@gmail.com, jfraser@broadcom.com,
        dtor@chromium.org, tglx@linutronix.de, jason@lakedaemon.net,
        jogo@openwrt.org, computersforpeace@gmail.com,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 11/11] MIPS: Add multiplatform BMIPS target
Date: Mon, 24 Nov 2014 15:00:15 +0100
Message-ID: <11772640.IZcxoRkMEM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416796846-28149-12-git-send-email-cernekee@gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com> <1416796846-28149-12-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aHcGhOpot9hVc7RCWeJhrGk9LoI+5+VeHha9DEZnifJ
 LPHrE9lBMhIUANDliZh0I2eo+FhFwSvfHOhMrCUHRitQV+bYvN
 9+7bKnhhYUo7OI63L5Hbx0IayMl/Mzfl+eOQMoyPNwna3zRJtm
 Mqr2B4She26y/s2lTYMRxWNVXDlUXwi+h0lPDtB0qYBRtTlo6N
 zKnv3PWY8FOwz+nFo1yOt6S0bgoXeK/FxaXUHcaKoyrjOM/l1N
 c6cSjYpZYgzqIJaw9JFTd6UsCcOATYj2GImdR6VM1/xT0Bm8GS
 mNThyd2VZihSLX6Y+pEwTQyVheRSbq7U9TVo5uwcL0sbivUJre
 ZujesSa7xTeWy+5Iywmo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2014 18:40:46 Kevin Cernekee wrote:
> bmips_be_defconfig supports Linux running on the following CM and DSL
> SoCs:
> 
>  - BCM3384 (BMIPS5000) cable modem application processor, BE, SMP
>  - BCM3384 (BMIPS4355) cable modem "spare CPU"*, BE
>  - BCM6328 (BMIPS4355) ADSL chip, BE
>  - BCM6368 (BMIPS4350) ADSL chip, BE, SMP
> 
> *experimental; most configurations will require changing CONFIG_PHYSICAL_START
> 
> bmips_stb_defconfig supports Linux running on the (nominally LE) STB
> chipsets:
> 
>  - BCM7125 (BMIPS4380) set-top box chip, LE, SMP
>  - BCM7346 (BMIPS5000) set-top box chip, LE, SMP
>  - BCM7360 (BMIPS3300) set-top box chip, LE
>  - BCM7420 (BMIPS5000) set-top box chip, LE, SMP
>  - BCM7425 (BMIPS5000) set-top box chip, LE, SMP
> 
> serial8250 and bcm63xx_uart do not currently coexist.  If/when this is
> fixed, it will be also possible to boot the BE image on any supported STB
> board configured for BE.  For now, each defconfig can only pick one UART
> driver, and the BE defconfig enables bcm63xx_uart.
> 
> On these MIPS systems, endianness cannot be reconfigured at runtime.  On
> STB it is sometimes offered as a board jumper or 0-ohm resistor, and
> sometimes hardwired to LE only.  The CM and DSL systems always run BE.
> 
> Device Tree is used to configure the following items:
> 
>  - UART, USB, GENET peripherals
>  - IRQ controllers
>  - Early console base address (bcm63xx_uart only)
>  - SMP or UP mode
>  - MIPS counter frequency
>  - Memory size / regions
>  - DMA remappings
>  - Kernel command line
> 
> The DT-enabled bootloader and build instructions for 3384 are posted at
> https://github.com/Broadcom/aeolus .  The other chips use legacy non-DT
> bootloaders, so they will need to select an appropriate builtin DTB at
> compile time until the bootloader is updated.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

It mihgt be good to split this into multiple patches


> ---
>  .../devicetree/bindings/mips/brcm/bmips.txt        |   8 +
>  .../devicetree/bindings/mips/brcm/soc.txt          |  12 ++
>  arch/mips/Kbuild.platforms                         |   1 +
>  arch/mips/Kconfig                                  |  36 ++++
>  arch/mips/bmips/Kconfig                            |  50 ++++++
>  arch/mips/bmips/Makefile                           |   1 +
>  arch/mips/bmips/Platform                           |   7 +
>  arch/mips/bmips/dma.c                              | 141 +++++++++++++++
>  arch/mips/bmips/irq.c                              |  38 ++++
>  arch/mips/bmips/setup.c                            | 195 +++++++++++++++++++++
>  arch/mips/boot/dts/Makefile                        |   9 +
>  arch/mips/boot/dts/bcm3384_viper.dtsi              | 108 ++++++++++++
>  arch/mips/boot/dts/bcm3384_zephyr.dtsi             | 126 +++++++++++++
>  arch/mips/boot/dts/bcm6328.dtsi                    |  87 +++++++++
>  arch/mips/boot/dts/bcm6368.dtsi                    |  94 ++++++++++
>  arch/mips/boot/dts/bcm7125.dtsi                    | 107 +++++++++++
>  arch/mips/boot/dts/bcm7346.dtsi                    | 192 ++++++++++++++++++++
>  arch/mips/boot/dts/bcm7360.dtsi                    | 129 ++++++++++++++
>  arch/mips/boot/dts/bcm7420.dtsi                    | 151 ++++++++++++++++
>  arch/mips/boot/dts/bcm7425.dtsi                    | 191 ++++++++++++++++++++

I hadn't noticed before that the dts files are now all in one
directory on MIPS, apparently after a patch from Andrew Brewsticker.
We should really coordinate these things better, we have just merged
an arm64 patch to split out the files into multiple directories.

> --- /dev/null
> +++ b/arch/mips/bmips/Kconfig
> @@ -0,0 +1,50 @@
> +choice
> +	prompt "Built-in device tree"
> +	help
> +	  Legacy bootloaders do not pass a DTB pointer to the kernel, so
> +	  if a "wrapper" is not being used, the kernel will need to include
> +	  a device tree that matches the target board.
> +
> +	  The builtin DTB will only be used if the firmware does not supply
> +	  a valid DTB.
> +
> +config DT_NONE
> +	bool "None"
> +
> +config DT_BCM93384WVG
> +	bool "BCM93384WVG Zephyr CPU"
> +	select BUILTIN_DTB
> +
> +config DT_BCM93384WVG_VIPER
> +	bool "BCM93384WVG Viper CPU (EXPERIMENTAL)"
> +	select BUILTIN_DTB

Why do you have to pick just one? I liked the suggestion of just
appending the dtb to the zImage as we do on ARM, so you can build
a combined kernel and then run it on multiple machines.

> diff --git a/arch/mips/bmips/irq.c b/arch/mips/bmips/irq.c
> new file mode 100644
> index 000000000000..14552e58ff7e
> --- /dev/null
> +++ b/arch/mips/bmips/irq.c
> @@ -0,0 +1,38 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * Copyright (C) 2014 Broadcom Corporation
> + * Author: Kevin Cernekee <cernekee@gmail.com>
> + */
> +
> +#include <linux/of.h>
> +#include <linux/irqchip.h>
> +
> +#include <asm/bmips.h>
> +#include <asm/irq.h>
> +#include <asm/irq_cpu.h>
> +#include <asm/time.h>
> +
> +unsigned int get_c0_compare_int(void)
> +{
> +	return CP0_LEGACY_COMPARE_IRQ;
> +}

Could this just become a function pointer instead of a global
variable?

> +void __init arch_init_irq(void)
> +{
> +	struct device_node *dn;
> +
> +	/* Only the STB (bcm7038) controller supports SMP IRQ affinity */
> +	dn = of_find_compatible_node(NULL, NULL, "brcm,bcm7038-l1-intc");
> +	if (dn)
> +		of_node_put(dn);
> +	else
> +		bmips_tp1_irqs = 0;
> +
> +	irqchip_init();
> +}
> +
> +OF_DECLARE_2(irqchip, mips_cpu_intc, "mti,cpu-interrupt-controller",
> +	     mips_cpu_irq_of_init);

OF_DECLARE_2 really wasn't meant to be used directly. Can you move this
code into drivers/irqchip and make it use IRQCHIP_DECLARE()?

> +
> +static const struct bmips_quirk bmips_quirk_list[] = {
> +	{ "brcm,bcm3384-viper",		&bcm3384_viper_quirks		},
> +	{ "brcm,bcm33843-viper",	&bcm3384_viper_quirks		},
> +	{ "brcm,bcm6328",		&bcm6328_quirks			},
> +	{ "brcm,bcm6368",		&bcm6368_quirks			},
> +	{ },
> +};
> +
> +void __init prom_init(void)
> +{
> +	register_bmips_smp_ops();
> +}

This seems to be the wrong place for calling this function.

> +void __init prom_free_prom_memory(void)
> +{
> +}

This in turn could live outside of the platform codefor anything
that is "multiplatform".

> +void __init plat_mem_setup(void)
> +{
> +	void *dtb;
> +	const struct bmips_quirk *q;
> +
> +	set_io_port_base(0);
> +	ioport_resource.start = 0;
> +	ioport_resource.end = ~0;

ioport_resource must not extend beyond IO_SPACE_LIMIT, which is
0xffff on MIPS. setting the I/O port base to zero is probably
not what you want. What are you trying to do here?

Maybe defer this until you have PCI support? The new generic PCI
handling should make this really easy to get right.

> +	/* Intended to somewhat resemble ARM; see Documentation/arm/Booting */
> +	if (fw_arg0 == 0 && fw_arg1 == 0xffffffff)
> +		dtb = phys_to_virt(fw_arg2);
> +	else if (__dtb_start != __dtb_end)
> +		dtb = (void *)__dtb_start;
> +	else
> +		panic("no dtb found");
> +
> +	__dt_setup_arch(dtb);
> +	strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);

Is this intended to become a generic MIPS boot interface? Better
document it in Documentation/mips/

> +	for (q = bmips_quirk_list; q->quirk_fn; q++) {
> +		if (of_flat_dt_is_compatible(of_get_flat_dt_root(),
> +					     q->compatible)) {
> +			q->quirk_fn();
> +		}
> +	}
> +}
> +

nice

> +void __init device_tree_init(void)
> +{
> +	struct device_node *np;
> +
> +	unflatten_and_copy_device_tree();
> +
> +	/* Disable SMP boot unless both CPUs are listed in DT and !disabled */
> +	np = of_find_node_by_name(NULL, "cpus");
> +	if (np && of_get_available_child_count(np) <= 1)
> +		bmips_smp_enabled = 0;
> +	of_node_put(np);
> +}

this looks also like it should be in platform
independent code

> +void __init plat_time_init(void)
> +{
> +	struct device_node *np;
> +	u32 freq;
> +
> +	np = of_find_node_by_name(NULL, "cpus");
> +	if (!np)
> +		panic("missing 'cpus' DT node");
> +	if (of_property_read_u32(np, "mips-hpt-frequency", &freq) < 0)
> +		panic("missing 'mips-hpt-frequency' property");
> +	of_node_put(np);
> +
> +	mips_hpt_frequency = freq;
> +}

Could this be part of a drivers/clocksource driver?

> +
> +int __init plat_of_setup(void)
> +{
> +	return __dt_register_buses("simple-bus", NULL);
> +}
> +
> +arch_initcall(plat_of_setup);
> +
> +static int __init plat_dev_init(void)
> +{
> +	of_clk_init(NULL);
> +	return 0;
> +}
> +
> +device_initcall(plat_dev_init);
> +
> +const char *get_system_type(void)
> +{
> +	return "BMIPS multiplatform kernel";
> +}

You could set the string from bmips_quirk_list and make this generic
as well.

> diff --git a/arch/mips/include/asm/mach-bmips/dma-coherence.h b/arch/mips/include/asm/mach-bmips/dma-coherence.h
> new file mode 100644
> index 000000000000..5481a4d1bbbf
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-bmips/dma-coherence.h
> @@ -0,0 +1,45 @@
> +#ifndef __ASM_MACH_BMIPS_DMA_COHERENCE_H
> +#define __ASM_MACH_BMIPS_DMA_COHERENCE_H
> +
> +struct device;
> +
> +extern dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t size);
> +extern dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page);
> +extern unsigned long plat_dma_addr_to_phys(struct device *dev,
> +	dma_addr_t dma_addr);
> +extern void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
> +	size_t size, enum dma_data_direction direction);

I think you could just add these to
arch/mips/include/asm/mach-generic/dma-coherence.h and get rid of the
header file, after adding a Kconfig symbol.

> diff --git a/arch/mips/include/asm/mach-bmips/spaces.h b/arch/mips/include/asm/mach-bmips/spaces.h
> new file mode 100644
> index 000000000000..1f7bc6cb6160
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-bmips/spaces.h
> @@ -0,0 +1,17 @@
> +#ifndef _ASM_BMIPS_SPACES_H
> +#define _ASM_BMIPS_SPACES_H
> +
> +#define FIXADDR_TOP		((unsigned long)(long)(int)0xff000000)
> +
> +#include <asm/mach-generic/spaces.h>
> +
> +#endif /* __ASM_BMIPS_SPACES_H */

Why does this platform need a special FIXADDR_TOP value? Would either
this value or the 0xfffe0000 from
arch/mips/include/asm/mach-generic/spaces.h would everywhere?

> diff --git a/arch/mips/include/asm/mach-bmips/war.h b/arch/mips/include/asm/mach-bmips/war.h
> new file mode 100644
> index 000000000000..65af1096cd6f
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-bmips/war.h
> @@ -0,0 +1,24 @@
> +#ifndef __ASM_MIPS_MACH_BMIPS_WAR_H
> +#define __ASM_MIPS_MACH_BMIPS_WAR_H
> +
> +#define R4600_V1_INDEX_ICACHEOP_WAR	0
> +#define R4600_V1_HIT_CACHEOP_WAR	0
> +#define R4600_V2_HIT_CACHEOP_WAR	0
> ...

As mentioned before, it seems like you are simply defining these all to zero,
like most other platforms do too. Why not add this file as
arch/mips/include/asm/mach-generic/war.h and delete all identical copies?

	Arnd
