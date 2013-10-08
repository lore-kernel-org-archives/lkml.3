Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3JHOra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:47:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17930 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3JHOrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:47:23 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-50-52541af9c023
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Tue, 08 Oct 2013 16:47:10 +0200
Message-id: <345331503.cxDWWY2SGj@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1588308.i5Ha5A8RHe@amdc1032>
References: <3702969.8rn3SOscJE@amdc1032> <1985237.ukkgSmGrTt@amdc1032>
 <1588308.i5Ha5A8RHe@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd2fUiFBBhMbRC3+TjrGbrFm/08m
	i7NNb9gtLu+aw2bxufcIo8WTh31sDmwev39NYvRYvOclk0ffllWMHsdvbGfy+LxJLoA1issm
	JTUnsyy1SN8ugStj351VTAXz4iu+fH3M1MC4wKOLkZNDQsBE4vaSGcwQtpjEhXvr2boYuTiE
	BBYxSmy6sRTKaWGSeHVgKitIFZuAlcTE9lWMILaIgJ7EjRdPmECKmAVWMkrs6DrJDpIQFoiR
	mHaglQnEZhFQlVixezYbiM0roC3xZc5+sLiogKfEp0lLwVZzCmhJNPc9BerlANqWLvGrixei
	XFDix+R7LCA2s4C8xL79EDcwC+hI7G+dxjaBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4uJ9J72Bc1WBxiFGAg1GJh/cBf0iQEGtiWXFl7iFGCQ5mJRHeaSAh
	3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOBjk4sSc1OTS1ILYLJMnFwSjUw1m2cfZqTO3RZ
	PbfxDcn7HimMrA+LDp98qsQybc33xF1v7kedFfF44ynbxRg598e/vUv3KBZ9SH91ZPLdA/t1
	Z22ZUlc49dL9kkPC22oVnaaIpL22Dbqu+F1rO0fNvfwFzPu6Zy6xvim7ZeUJhWaWuNd6XJIB
	zneDmW9wLlfeFLVT9t6x+48eLFNiKc5INNRiLipOBAAbnEXnagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eduardo,

On Monday, October 07, 2013 04:10:29 PM Bartlomiej Zolnierkiewicz wrote:
> On Monday, October 07, 2013 12:50:54 PM Bartlomiej Zolnierkiewicz wrote:
> > On Monday, October 07, 2013 11:57:16 AM Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > On Friday, October 04, 2013 02:22:30 PM Eduardo Valentin wrote:
> > > > On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> > > > > Menu for Texas Instruments thermal support is visible on all
> > > > > platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> > > > > be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> > > > > config option is selected by SoCs config options to fulfill
> > > > > EXYNOS_THERMAL config option dependency). Thus the code which
> > > > > is never used can be build. Fix it by making TI menu dependent
> > > > > on ARCH_OMAP2PLUS config option.
> > > > > 
> > > > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > > > ---
> > > > >  drivers/thermal/Kconfig | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > > > > index 57e06a9..a709c63 100644
> > > > > --- a/drivers/thermal/Kconfig
> > > > > +++ b/drivers/thermal/Kconfig
> > > > > @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
> > > > >  	  notification methods.
> > > > >  
> > > > >  menu "Texas Instruments thermal drivers"
> > > > > +depends on ARCH_OMAP2PLUS
> > > > 
> > > > No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
> > > > option to offer thermal control. So, the HW supported is TI bandgap IP,
> > > > not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
> > > > (different) version of this device.
> > > > 
> > > > However, DRA7 devices, for instance, also feature the bandgap IP
> > > > (different version of those present in OMAP devices), and it is not
> > > > ARCH_OMAP2PLUS.
> > > 
> > > Then you have wrong dependencies anyway since ARCH_BANDGAP is selected
> > 
> > s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/
> > 
> > > currently only by ARCH_OMAP2PLUS and EXYNOS SoCs.
> 
> It seems that SOC_DRA7xx config option is dependent on ARCH_OMAP2PLUS one
> *anyway* (thus it doesn't need to select ARCH_HAS_BANDGAP on its own). Thus
> my patch is correct and sufficient for the current TI bandgap IP support.
> 
> if ARCH_OMAP2PLUS
> 
> menu "TI OMAP2/3/4 Specific Features"
> 
> config ARCH_OMAP2PLUS_TYPICAL
> 	bool "Typical OMAP configuration"
> 	default y
> 	select AEABI
> 	select HIGHMEM
> 	select I2C
> 	select I2C_OMAP
> 	select MENELAUS if ARCH_OMAP2
> 	select NEON if CPU_V7
> 	select PM_RUNTIME
> 	select REGULATOR
> 	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
> 	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
> 	select VFP
> 	help
> 	  Compile a kernel suitable for booting most boards
> 
> config SOC_HAS_OMAP2_SDRC
> 	bool "OMAP2 SDRAM Controller support"
> 
> config SOC_HAS_REALTIME_COUNTER
> 	bool "Real time free running counter"
> 	depends on SOC_OMAP5 || SOC_DRA7XX
> 	default y
> 
> config SOC_DRA7XX
> 	bool "TI DRA7XX"
> 	select ARM_ARCH_TIMER
> 	select CPU_V7
> 	select ARM_GIC
> 	select HAVE_SMP
> 	select COMMON_CLK
> ...
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> > > arch/arm/mach-omap2/Kconfig (next-20130927):
> > > 
> > > config ARCH_OMAP2PLUS
> > >         bool
> > >         select ARCH_HAS_BANDGAP
> > >         select ARCH_HAS_CPUFREQ
> > >         select ARCH_HAS_HOLES_MEMORYMODEL
> > >         select ARCH_OMAP
> > >         select ARCH_REQUIRE_GPIOLIB
> > >         select CLKDEV_LOOKUP
> > >         select CLKSRC_MMIO
> > >         select GENERIC_CLOCKEVENTS
> > >         select GENERIC_IRQ_CHIP
> > >         select HAVE_CLK
> > >         select OMAP_DM_TIMER
> > >         select PINCTRL
> > >         select PROC_DEVICETREE if PROC_FS
> > >         select SOC_BUS
> > >         select SPARSE_IRQ
> > >         select TI_PRIV_EDMA
> > >         select USE_OF
> > >         help
> > >           Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
> > > 
> > > drivers/thermal/ti-soc-thermal/Kconfig (next-20130927):
> > > 
> > > config TI_SOC_THERMAL
> > >         tristate "Texas Instruments SoCs temperature sensor driver"
> > >         depends on THERMAL
> > >         depends on ARCH_HAS_BANDGAP
> > >         help
> > >           If you say yes here you get support for the Texas Instruments
> > >           OMAP4460+ on die bandgap temperature sensor support. The register
> > >           set is part of system control module.
> > > 
> > >           This includes alert interrupts generation and also the TSHUT
> > >           support.
> > 
> > and for EXYNOS it looks like that (next-20130927):
> > 
> > arch/arm/mach-exynos/Kconfig:
> > 
> > config CPU_EXYNOS4210
> > 	bool "SAMSUNG EXYNOS4210"
> > 	default y
> > 	depends on ARCH_EXYNOS4
> > 	select ARCH_HAS_BANDGAP
> > 	select ARM_CPU_SUSPEND if PM
> > 	select PINCTRL_EXYNOS
> > 	select PM_GENERIC_DOMAINS if PM
> > 	select S5P_PM if PM
> > 	select S5P_SLEEP if PM
> > 	select SAMSUNG_DMADEV
> > 	help
> > 	  Enable EXYNOS4210 CPU support
> > 
> > config SOC_EXYNOS4212
> > 	bool "SAMSUNG EXYNOS4212"
> > 	default y
> > 	depends on ARCH_EXYNOS4
> > 	select ARCH_HAS_BANDGAP
> > 	select PINCTRL_EXYNOS
> > 	select PM_GENERIC_DOMAINS if PM
> > 	select S5P_PM if PM
> > 	select S5P_SLEEP if PM
> > 	select SAMSUNG_DMADEV
> > 	help
> > 	  Enable EXYNOS4212 SoC support
> > 
> > config SOC_EXYNOS4412
> > 	bool "SAMSUNG EXYNOS4412"
> > 	default y
> > 	depends on ARCH_EXYNOS4
> > 	select ARCH_HAS_BANDGAP
> > 	select PINCTRL_EXYNOS
> > 	select PM_GENERIC_DOMAINS if PM
> > 	select SAMSUNG_DMADEV
> > 	help
> > 	  Enable EXYNOS4412 SoC support
> > 
> > config SOC_EXYNOS5250
> > 	bool "SAMSUNG EXYNOS5250"
> > 	default y
> > 	depends on ARCH_EXYNOS5
> > 	select ARCH_HAS_BANDGAP
> > 	select PINCTRL_EXYNOS
> > 	select PM_GENERIC_DOMAINS if PM
> > 	select S5P_PM if PM
> > 	select S5P_SLEEP if PM
> > 	select S5P_DEV_MFC
> > 	select SAMSUNG_DMADEV
> > 	help
> > 	  Enable EXYNOS5250 SoC support
> > 
> > config SOC_EXYNOS5420
> > 	bool "SAMSUNG EXYNOS5420"
> > 	default y
> > 	depends on ARCH_EXYNOS5
> > 	select PM_GENERIC_DOMAINS if PM
> > 	select S5P_PM if PM
> > 	select S5P_SLEEP if PM
> > 	help
> > 	  Enable EXYNOS5420 SoC support
> > 
> > config SOC_EXYNOS5440
> > 	bool "SAMSUNG EXYNOS5440"
> > 	default y
> > 	depends on ARCH_EXYNOS5
> > 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
> > 	select ARCH_HAS_BANDGAP
> > 	select ARCH_HAS_OPP
> > 	select HAVE_ARM_ARCH_TIMER
> > 	select AUTO_ZRELADDR
> > 	select MIGHT_HAVE_PCI
> > 	select PCI_DOMAINS if PCI
> > 	select PINCTRL_EXYNOS5440
> > 	select PM_OPP
> > 	help
> > 	  Enable EXYNOS5440 SoC support
> > 
> > drivers/thermal/Kconfig:
> > 
> > menu "Samsung thermal drivers"
> > depends on PLAT_SAMSUNG
> > source "drivers/thermal/samsung/Kconfig"
> > endmenu
> > 
> > drivers/thermal/samsung/Kconfig
> > 
> > config EXYNOS_THERMAL
> > 	tristate "Exynos thermal management unit driver"
> > 	depends on ARCH_HAS_BANDGAP && OF
> > 	help
> > 	  If you say yes here you get support for the TMU (Thermal Management
> > 	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver initialises
> > 	  the TMU, reports temperature and handles cooling action if defined.
> > 	  This driver uses the Exynos core thermal APIs and TMU configuration
> > 	  data from the supported SoCs.
> > 
> > 
> > > > And because of that, the design of this driver is different. It is not
> > > > expected to depend on an arch, but the arch code is expected to select
> > > > ARCH_HAS_BANDGAP.
> > > 
> > > There should be additional dependencies beside ARCH_BANDGAP, i.e. on
> > 
> > s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/
> > 
> > > EXYNOS platforms we currently also have dependency on PLAT_SAMSUNG
> > > (should be ARCH_EXYNOS instead, my other patch fixes it).

There is more to it. Description of commit 4a1b573 ("ARM: 7758/1: introduce
config HAS_BANDGAP") which introduced ARCH_HAS_BANDGAP says that "This config
entry follows the same idea behind ARCH_HAS_CPUFREQ." but in practice it does
currently something completely different than ARCH_HAS_CPUFREQ.

For ARCH_HAS_CPUFREQ in arch/arm/Kconfig we first have:

...
config ARCH_HAS_CPUFREQ
        bool
        help
          Internal node to signify that the ARCH has CPUFREQ support
          and that the relevant menu configurations are displayed for
          it.
...

then later we have sub-archs/SoCs selecting it:

...
config ARCH_EXYNOS
        bool "Samsung EXYNOS"
        select ARCH_HAS_CPUFREQ
...

(for OMAP arch/arm/Kconfig includes arch/arm/mach-omap2/Kconfig in which
ARCH_OMAP2PLUS is defined and which selects ARCH_HAS_CPUFREQ)

and finally we have the check on the _whole_ CPUFREQ support menu (not on
particular sub-arch/SoCs specific driver config options):

...
if ARCH_HAS_CPUFREQ
source "drivers/cpufreq/Kconfig"
endif
...

Also when we take a look at drivers/cpufreq/Kconfig.arm we can see that
particular sub-arch/SoCs specific drivers have correct dependencies on
sub-arch/SoC, i.e.:

...
config ARM_EXYNOS4210_CPUFREQ
        bool "SAMSUNG EXYNOS4210"
        depends on CPU_EXYNOS4210
        default y
        select ARM_EXYNOS_CPUFREQ
...
config ARM_OMAP2PLUS_CPUFREQ
        bool "TI OMAP2+"
        depends on ARCH_OMAP2PLUS
...

Now lets take a look at ARCH_HAS_BANDGAP usage. In arch/arm/Kconfig we have:

...
config ARCH_HAS_BANDGAP
        bool
...

then in arch/arm/mach-exynos/Kconfig:

...
config CPU_EXYNOS4210
        bool "SAMSUNG EXYNOS4210"
        default y
        depends on ARCH_EXYNOS4
        select ARCH_HAS_BANDGAP
...

and in arch/arm/mach-omap2/Kconfig:

...
config ARCH_OMAP2PLUS
        bool
        select ARCH_HAS_BANDGAP
...

but finally we don't have the ARCH_HAS_BANDGAP check on the whole thermal
support menu but on _particular_ sub-arch/SoC specific driver config options.

In drivers/thermal/samsung/Kconfig:

...
config EXYNOS_THERMAL
        tristate "Exynos thermal management unit driver"
        depends on ARCH_HAS_BANDGAP && OF
...

and in drivers/thermal/ti-soc-thermal/Kconfig:

...
config TI_SOC_THERMAL
        tristate "Texas Instruments SoCs temperature sensor driver"
        depends on THERMAL
        depends on ARCH_HAS_BANDGAP
...

Therefore the current usage of ARCH_HAS_BANDGAP is wrong and results in
sub-arch/SoC specific driver config options being visible/selectable by user
on other completely unrelated sub-archs/SoCs configs. Please note that this
is incorrect for various reasons: it causes user confusion, unnecessary code
can be build into kernel and build breakages potentially can happen. Just
having the possibility to disable such unneeded drivers is not scalable and
is not enough in the long-term (we have to consider people doing things
like "make randconfig" and "make allyesconfig"). This should be fixed by
removal of ARCH_HAS_BANDGAP dependency from sub-arch/SoC specific driver
config options and replacing them by correct dependencies on sub-arch/SoC.
Then we can go and fix all archs/sub-archs/SoCs that have specific thermal
drivers available on them to select ARCH_HAS_BANDGAP and finally put
ARCH_HAS_BANDGAP dependency on the whole thermal support menu. I can later
look into fixing ARCH_HAS_BANDGAP usage if you are fine with it.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > > > >  source "drivers/thermal/ti-soc-thermal/Kconfig"
> > > > >  endmenu
> > > 
> > > Best regards,
> > > --
> > > Bartlomiej Zolnierkiewicz
> > > Samsung R&D Institute Poland
> > > Samsung Electronics
> > 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics

