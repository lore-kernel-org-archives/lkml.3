Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3JGKvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:51:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41693 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3JGKvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:51:05 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-4d-52529217e486
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Mon, 07 Oct 2013 12:50:54 +0200
Message-id: <1985237.ukkgSmGrTt@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5727785.7GtnvaVLcG@amdc1032>
References: <3702969.8rn3SOscJE@amdc1032> <524F0766.8070302@ti.com>
 <5727785.7GtnvaVLcG@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQV3xSUFBBmumG1v8nXSM3WLN/p9M
	Fmeb3rBbXN41h83ic+8RRosnD/vYHNg8fv+axOixeM9LJo++LasYPY7f2M7k8XmTXABrFJdN
	SmpOZllqkb5dAlfG/gkrmQqWG1YcOl7awNih1sXIySEhYCLxat8zVghbTOLCvfVsXYxcHEIC
	0xkltv5+DuW0MEncWLuDHaSKTcBKYmL7KkYQW0RAT+LGiydMIEXMAisZJXZ0nQQrEhaIkZh2
	oJUJxGYRUJU4/2AamM0roCkx4+h3sBpRAU+JT5OWMoPYnAJaEg+WHgGrERJIljhz7y87RL2g
	xI/J91hAbGYBeYl9+6eyQtg6Evtbp7FNYBSYhaRsFpKyWUjKFjAyr2IUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIDu5nUjsYVzZYHGIU4GBU4uHdcT8wSIg1say4MvcQowQHs5IIb09rUJAQ
	b0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGRucbzKkllxZn
	955POp9w+sUNduHWE7dNp1WWn9Myv5F5SJn9s3fdxddB8TkTDZRSm+LMNu7Q4dJqyNfScIkp
	9XjBuHSDvTTfvBCv2FWW6/SV/u1dNIPvxpvgPOlF3SKhzadZpFrzgt7cvNCxLZl7J3P1eqXQ
	NAPFDZ+feot7M2s1NU9YsWi3EktxRqKhFnNRcSIAFzHD8WoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 07, 2013 11:57:16 AM Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Friday, October 04, 2013 02:22:30 PM Eduardo Valentin wrote:
> > On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> > > Menu for Texas Instruments thermal support is visible on all
> > > platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> > > be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> > > config option is selected by SoCs config options to fulfill
> > > EXYNOS_THERMAL config option dependency). Thus the code which
> > > is never used can be build. Fix it by making TI menu dependent
> > > on ARCH_OMAP2PLUS config option.
> > > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/thermal/Kconfig | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > > index 57e06a9..a709c63 100644
> > > --- a/drivers/thermal/Kconfig
> > > +++ b/drivers/thermal/Kconfig
> > > @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
> > >  	  notification methods.
> > >  
> > >  menu "Texas Instruments thermal drivers"
> > > +depends on ARCH_OMAP2PLUS
> > 
> > No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
> > option to offer thermal control. So, the HW supported is TI bandgap IP,
> > not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
> > (different) version of this device.
> > 
> > However, DRA7 devices, for instance, also feature the bandgap IP
> > (different version of those present in OMAP devices), and it is not
> > ARCH_OMAP2PLUS.
> 
> Then you have wrong dependencies anyway since ARCH_BANDGAP is selected

s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/

> currently only by ARCH_OMAP2PLUS and EXYNOS SoCs.
> 
> arch/arm/mach-omap2/Kconfig (next-20130927):
> 
> config ARCH_OMAP2PLUS
>         bool
>         select ARCH_HAS_BANDGAP
>         select ARCH_HAS_CPUFREQ
>         select ARCH_HAS_HOLES_MEMORYMODEL
>         select ARCH_OMAP
>         select ARCH_REQUIRE_GPIOLIB
>         select CLKDEV_LOOKUP
>         select CLKSRC_MMIO
>         select GENERIC_CLOCKEVENTS
>         select GENERIC_IRQ_CHIP
>         select HAVE_CLK
>         select OMAP_DM_TIMER
>         select PINCTRL
>         select PROC_DEVICETREE if PROC_FS
>         select SOC_BUS
>         select SPARSE_IRQ
>         select TI_PRIV_EDMA
>         select USE_OF
>         help
>           Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
> 
> drivers/thermal/ti-soc-thermal/Kconfig (next-20130927):
> 
> config TI_SOC_THERMAL
>         tristate "Texas Instruments SoCs temperature sensor driver"
>         depends on THERMAL
>         depends on ARCH_HAS_BANDGAP
>         help
>           If you say yes here you get support for the Texas Instruments
>           OMAP4460+ on die bandgap temperature sensor support. The register
>           set is part of system control module.
> 
>           This includes alert interrupts generation and also the TSHUT
>           support.

and for EXYNOS it looks like that (next-20130927):

arch/arm/mach-exynos/Kconfig:

config CPU_EXYNOS4210
	bool "SAMSUNG EXYNOS4210"
	default y
	depends on ARCH_EXYNOS4
	select ARCH_HAS_BANDGAP
	select ARM_CPU_SUSPEND if PM
	select PINCTRL_EXYNOS
	select PM_GENERIC_DOMAINS if PM
	select S5P_PM if PM
	select S5P_SLEEP if PM
	select SAMSUNG_DMADEV
	help
	  Enable EXYNOS4210 CPU support

config SOC_EXYNOS4212
	bool "SAMSUNG EXYNOS4212"
	default y
	depends on ARCH_EXYNOS4
	select ARCH_HAS_BANDGAP
	select PINCTRL_EXYNOS
	select PM_GENERIC_DOMAINS if PM
	select S5P_PM if PM
	select S5P_SLEEP if PM
	select SAMSUNG_DMADEV
	help
	  Enable EXYNOS4212 SoC support

config SOC_EXYNOS4412
	bool "SAMSUNG EXYNOS4412"
	default y
	depends on ARCH_EXYNOS4
	select ARCH_HAS_BANDGAP
	select PINCTRL_EXYNOS
	select PM_GENERIC_DOMAINS if PM
	select SAMSUNG_DMADEV
	help
	  Enable EXYNOS4412 SoC support

config SOC_EXYNOS5250
	bool "SAMSUNG EXYNOS5250"
	default y
	depends on ARCH_EXYNOS5
	select ARCH_HAS_BANDGAP
	select PINCTRL_EXYNOS
	select PM_GENERIC_DOMAINS if PM
	select S5P_PM if PM
	select S5P_SLEEP if PM
	select S5P_DEV_MFC
	select SAMSUNG_DMADEV
	help
	  Enable EXYNOS5250 SoC support

config SOC_EXYNOS5420
	bool "SAMSUNG EXYNOS5420"
	default y
	depends on ARCH_EXYNOS5
	select PM_GENERIC_DOMAINS if PM
	select S5P_PM if PM
	select S5P_SLEEP if PM
	help
	  Enable EXYNOS5420 SoC support

config SOC_EXYNOS5440
	bool "SAMSUNG EXYNOS5440"
	default y
	depends on ARCH_EXYNOS5
	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
	select ARCH_HAS_BANDGAP
	select ARCH_HAS_OPP
	select HAVE_ARM_ARCH_TIMER
	select AUTO_ZRELADDR
	select MIGHT_HAVE_PCI
	select PCI_DOMAINS if PCI
	select PINCTRL_EXYNOS5440
	select PM_OPP
	help
	  Enable EXYNOS5440 SoC support

drivers/thermal/Kconfig:

menu "Samsung thermal drivers"
depends on PLAT_SAMSUNG
source "drivers/thermal/samsung/Kconfig"
endmenu

drivers/thermal/samsung/Kconfig

config EXYNOS_THERMAL
	tristate "Exynos thermal management unit driver"
	depends on ARCH_HAS_BANDGAP && OF
	help
	  If you say yes here you get support for the TMU (Thermal Management
	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver initialises
	  the TMU, reports temperature and handles cooling action if defined.
	  This driver uses the Exynos core thermal APIs and TMU configuration
	  data from the supported SoCs.


> > And because of that, the design of this driver is different. It is not
> > expected to depend on an arch, but the arch code is expected to select
> > ARCH_HAS_BANDGAP.
> 
> There should be additional dependencies beside ARCH_BANDGAP, i.e. on

s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/

> EXYNOS platforms we currently also have dependency on PLAT_SAMSUNG
> (should be ARCH_EXYNOS instead, my other patch fixes it).
> 
> > >  source "drivers/thermal/ti-soc-thermal/Kconfig"
> > >  endmenu
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

