Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3JHQ7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:59:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3JHQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:59:23 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-c4-525439ea2159
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Tue, 08 Oct 2013 18:59:19 +0200
Message-id: <1830886.95xXFHTq6V@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <52542E42.5090805@ti.com>
References: <3702969.8rn3SOscJE@amdc1032> <345331503.cxDWWY2SGj@amdc1032>
 <52542E42.5090805@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQd1XliFBBlO3Clj8nXSM3WLN/p9M
	Fmeb3rBbXN41h83ic+8RRosnD/vYHNg8fv+axOixeM9LJo++LasYPY7f2M7k8XmTXABrFJdN
	SmpOZllqkb5dAlfGm1972Qq2djBWrNj7hKWB8W9mFyMnh4SAicTHHV2sELaYxIV769m6GLk4
	hASmM0rM3fcXymlhkti+vY8JpIpNwEpiYvsqRhBbREBP4saLJ0wgRcwCKxkldnSdZAdJCAvE
	SEw70ArWwCKgKvH67U+wOK+ApsSHIwfA1okKeEp8mrSUGcTmFFCTmLn8GNhQIYFUiTfnFzJB
	1AtK/Jh8jwXEZhaQl9i3fyorhK0jsb91GtsERoFZSMpmISmbhaRsASPzKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYzgAH8mvYNxVYPFIUYBDkYlHt4H/CFBQqyJZcWVuYcYJTiYlUR4TWSB
	QrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhgLfsToLZsX
	qpH50+1ti+6zjVZhp51UtkZq/9o6h/NZd4XLn54mj9erElo+b54yv3jj89jI0MBMoyteV1cb
	ro+UvNp8QyBfvuKDEPPqgkQWPTPOr0xuihHfFs0zPng36cZlyyuLHkR/YU2Yum4O2/z03cq7
	eaRnB77Rm3jnFWezaqDKtPM5GiFKLMUZiYZazEXFiQBBQxFRbAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday, October 08, 2013 12:09:38 PM Eduardo Valentin wrote:
> Hi Bartlomiej,
> 
> On 08-10-2013 10:47, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi Eduardo,
> > 
> > On Monday, October 07, 2013 04:10:29 PM Bartlomiej Zolnierkiewicz wrote:
> >> On Monday, October 07, 2013 12:50:54 PM Bartlomiej Zolnierkiewicz wrote:
> >>> On Monday, October 07, 2013 11:57:16 AM Bartlomiej Zolnierkiewicz wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> On Friday, October 04, 2013 02:22:30 PM Eduardo Valentin wrote:
> >>>>> On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> >>>>>> Menu for Texas Instruments thermal support is visible on all
> >>>>>> platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> >>>>>> be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> >>>>>> config option is selected by SoCs config options to fulfill
> >>>>>> EXYNOS_THERMAL config option dependency). Thus the code which
> >>>>>> is never used can be build. Fix it by making TI menu dependent
> >>>>>> on ARCH_OMAP2PLUS config option.
> >>>>>>
> >>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> >>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>>> ---
> >>>>>>  drivers/thermal/Kconfig | 1 +
> >>>>>>  1 file changed, 1 insertion(+)
> >>>>>>
> >>>>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> >>>>>> index 57e06a9..a709c63 100644
> >>>>>> --- a/drivers/thermal/Kconfig
> >>>>>> +++ b/drivers/thermal/Kconfig
> >>>>>> @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
> >>>>>>  	  notification methods.
> >>>>>>  
> >>>>>>  menu "Texas Instruments thermal drivers"
> >>>>>> +depends on ARCH_OMAP2PLUS
> >>>>>
> >>>>> No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
> >>>>> option to offer thermal control. So, the HW supported is TI bandgap IP,
> >>>>> not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
> >>>>> (different) version of this device.
> >>>>>
> >>>>> However, DRA7 devices, for instance, also feature the bandgap IP
> >>>>> (different version of those present in OMAP devices), and it is not
> >>>>> ARCH_OMAP2PLUS.
> >>>>
> >>>> Then you have wrong dependencies anyway since ARCH_BANDGAP is selected
> >>>
> >>> s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/
> >>>
> >>>> currently only by ARCH_OMAP2PLUS and EXYNOS SoCs.
> >>
> >> It seems that SOC_DRA7xx config option is dependent on ARCH_OMAP2PLUS one
> >> *anyway* (thus it doesn't need to select ARCH_HAS_BANDGAP on its own). Thus
> >> my patch is correct and sufficient for the current TI bandgap IP support.
> >>
> >> if ARCH_OMAP2PLUS
> >>
> >> menu "TI OMAP2/3/4 Specific Features"
> >>
> >> config ARCH_OMAP2PLUS_TYPICAL
> >> 	bool "Typical OMAP configuration"
> >> 	default y
> >> 	select AEABI
> >> 	select HIGHMEM
> >> 	select I2C
> >> 	select I2C_OMAP
> >> 	select MENELAUS if ARCH_OMAP2
> >> 	select NEON if CPU_V7
> >> 	select PM_RUNTIME
> >> 	select REGULATOR
> >> 	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
> >> 	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
> >> 	select VFP
> >> 	help
> >> 	  Compile a kernel suitable for booting most boards
> >>
> >> config SOC_HAS_OMAP2_SDRC
> >> 	bool "OMAP2 SDRAM Controller support"
> >>
> >> config SOC_HAS_REALTIME_COUNTER
> >> 	bool "Real time free running counter"
> >> 	depends on SOC_OMAP5 || SOC_DRA7XX
> >> 	default y
> >>
> >> config SOC_DRA7XX
> >> 	bool "TI DRA7XX"
> >> 	select ARM_ARCH_TIMER
> >> 	select CPU_V7
> >> 	select ARM_GIC
> >> 	select HAVE_SMP
> >> 	select COMMON_CLK
> >> ...
> >>
> >> Best regards,
> >> --
> >> Bartlomiej Zolnierkiewicz
> >> Samsung R&D Institute Poland
> >> Samsung Electronics
> >>
> >>>> arch/arm/mach-omap2/Kconfig (next-20130927):
> >>>>
> >>>> config ARCH_OMAP2PLUS
> >>>>         bool
> >>>>         select ARCH_HAS_BANDGAP
> >>>>         select ARCH_HAS_CPUFREQ
> >>>>         select ARCH_HAS_HOLES_MEMORYMODEL
> >>>>         select ARCH_OMAP
> >>>>         select ARCH_REQUIRE_GPIOLIB
> >>>>         select CLKDEV_LOOKUP
> >>>>         select CLKSRC_MMIO
> >>>>         select GENERIC_CLOCKEVENTS
> >>>>         select GENERIC_IRQ_CHIP
> >>>>         select HAVE_CLK
> >>>>         select OMAP_DM_TIMER
> >>>>         select PINCTRL
> >>>>         select PROC_DEVICETREE if PROC_FS
> >>>>         select SOC_BUS
> >>>>         select SPARSE_IRQ
> >>>>         select TI_PRIV_EDMA
> >>>>         select USE_OF
> >>>>         help
> >>>>           Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
> >>>>
> >>>> drivers/thermal/ti-soc-thermal/Kconfig (next-20130927):
> >>>>
> >>>> config TI_SOC_THERMAL
> >>>>         tristate "Texas Instruments SoCs temperature sensor driver"
> >>>>         depends on THERMAL
> >>>>         depends on ARCH_HAS_BANDGAP
> >>>>         help
> >>>>           If you say yes here you get support for the Texas Instruments
> >>>>           OMAP4460+ on die bandgap temperature sensor support. The register
> >>>>           set is part of system control module.
> >>>>
> >>>>           This includes alert interrupts generation and also the TSHUT
> >>>>           support.
> >>>
> >>> and for EXYNOS it looks like that (next-20130927):
> >>>
> >>> arch/arm/mach-exynos/Kconfig:
> >>>
> >>> config CPU_EXYNOS4210
> >>> 	bool "SAMSUNG EXYNOS4210"
> >>> 	default y
> >>> 	depends on ARCH_EXYNOS4
> >>> 	select ARCH_HAS_BANDGAP
> >>> 	select ARM_CPU_SUSPEND if PM
> >>> 	select PINCTRL_EXYNOS
> >>> 	select PM_GENERIC_DOMAINS if PM
> >>> 	select S5P_PM if PM
> >>> 	select S5P_SLEEP if PM
> >>> 	select SAMSUNG_DMADEV
> >>> 	help
> >>> 	  Enable EXYNOS4210 CPU support
> >>>
> >>> config SOC_EXYNOS4212
> >>> 	bool "SAMSUNG EXYNOS4212"
> >>> 	default y
> >>> 	depends on ARCH_EXYNOS4
> >>> 	select ARCH_HAS_BANDGAP
> >>> 	select PINCTRL_EXYNOS
> >>> 	select PM_GENERIC_DOMAINS if PM
> >>> 	select S5P_PM if PM
> >>> 	select S5P_SLEEP if PM
> >>> 	select SAMSUNG_DMADEV
> >>> 	help
> >>> 	  Enable EXYNOS4212 SoC support
> >>>
> >>> config SOC_EXYNOS4412
> >>> 	bool "SAMSUNG EXYNOS4412"
> >>> 	default y
> >>> 	depends on ARCH_EXYNOS4
> >>> 	select ARCH_HAS_BANDGAP
> >>> 	select PINCTRL_EXYNOS
> >>> 	select PM_GENERIC_DOMAINS if PM
> >>> 	select SAMSUNG_DMADEV
> >>> 	help
> >>> 	  Enable EXYNOS4412 SoC support
> >>>
> >>> config SOC_EXYNOS5250
> >>> 	bool "SAMSUNG EXYNOS5250"
> >>> 	default y
> >>> 	depends on ARCH_EXYNOS5
> >>> 	select ARCH_HAS_BANDGAP
> >>> 	select PINCTRL_EXYNOS
> >>> 	select PM_GENERIC_DOMAINS if PM
> >>> 	select S5P_PM if PM
> >>> 	select S5P_SLEEP if PM
> >>> 	select S5P_DEV_MFC
> >>> 	select SAMSUNG_DMADEV
> >>> 	help
> >>> 	  Enable EXYNOS5250 SoC support
> >>>
> >>> config SOC_EXYNOS5420
> >>> 	bool "SAMSUNG EXYNOS5420"
> >>> 	default y
> >>> 	depends on ARCH_EXYNOS5
> >>> 	select PM_GENERIC_DOMAINS if PM
> >>> 	select S5P_PM if PM
> >>> 	select S5P_SLEEP if PM
> >>> 	help
> >>> 	  Enable EXYNOS5420 SoC support
> >>>
> >>> config SOC_EXYNOS5440
> >>> 	bool "SAMSUNG EXYNOS5440"
> >>> 	default y
> >>> 	depends on ARCH_EXYNOS5
> >>> 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
> >>> 	select ARCH_HAS_BANDGAP
> >>> 	select ARCH_HAS_OPP
> >>> 	select HAVE_ARM_ARCH_TIMER
> >>> 	select AUTO_ZRELADDR
> >>> 	select MIGHT_HAVE_PCI
> >>> 	select PCI_DOMAINS if PCI
> >>> 	select PINCTRL_EXYNOS5440
> >>> 	select PM_OPP
> >>> 	help
> >>> 	  Enable EXYNOS5440 SoC support
> >>>
> >>> drivers/thermal/Kconfig:
> >>>
> >>> menu "Samsung thermal drivers"
> >>> depends on PLAT_SAMSUNG
> >>> source "drivers/thermal/samsung/Kconfig"
> >>> endmenu
> >>>
> >>> drivers/thermal/samsung/Kconfig
> >>>
> >>> config EXYNOS_THERMAL
> >>> 	tristate "Exynos thermal management unit driver"
> >>> 	depends on ARCH_HAS_BANDGAP && OF
> >>> 	help
> >>> 	  If you say yes here you get support for the TMU (Thermal Management
> >>> 	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver initialises
> >>> 	  the TMU, reports temperature and handles cooling action if defined.
> >>> 	  This driver uses the Exynos core thermal APIs and TMU configuration
> >>> 	  data from the supported SoCs.
> >>>
> >>>
> >>>>> And because of that, the design of this driver is different. It is not
> >>>>> expected to depend on an arch, but the arch code is expected to select
> >>>>> ARCH_HAS_BANDGAP.
> >>>>
> >>>> There should be additional dependencies beside ARCH_BANDGAP, i.e. on
> >>>
> >>> s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/
> >>>
> >>>> EXYNOS platforms we currently also have dependency on PLAT_SAMSUNG
> >>>> (should be ARCH_EXYNOS instead, my other patch fixes it).
> > 
> > There is more to it. Description of commit 4a1b573 ("ARM: 7758/1: introduce
> > config HAS_BANDGAP") which introduced ARCH_HAS_BANDGAP says that "This config
> > entry follows the same idea behind ARCH_HAS_CPUFREQ." but in pract ice it does
> > currently something completely different than ARCH_HAS_CPUFREQ.
> 
> I think there is some misunderstanding. First thing is that, the fact
> that feature A follows the same idea of feature B, does not necessarily
> mean, it has to exactly the same, otherwise they would be the same
> thing, right ? :-)

OK.

> > 
> > For ARCH_HAS_CPUFREQ in arch/arm/Kconfig we first have:
> > 
> > ...
> > config ARCH_HAS_CPUFREQ
> >         bool
> >         help
> >           Internal node to signify that the ARCH has CPUFREQ support
> >           and that the relevant menu configurations are displayed for
> >           it.
> > ...
> > 
> > then later we have sub-archs/SoCs selecting it:
> > 
> > ...
> > config ARCH_EXYNOS
> >         bool "Samsung EXYNOS"
> >         select ARCH_HAS_CPUFREQ
> > ...
> > 
> > (for OMAP arch/arm/Kconfig includes arch/arm/mach-omap2/Kconfig in which
> > ARCH_OMAP2PLUS is defined and which selects ARCH_HAS_CPUFREQ)
> > 
> > and finally we have the check on the _whole_ CPUFREQ support menu (not on
> > particular sub-arch/SoCs specific driver config options):
> > 
> > ...
> > if ARCH_HAS_CPUFREQ
> > source "drivers/cpufreq/Kconfig"
> > endif
> > ...
> > 
> > Also when we take a look at drivers/cpufreq/Kconfig.arm we can see that
> > particular sub-arch/SoCs specific drivers have correct dependencies on
> > sub-arch/SoC, i.e.:
> > 
> > ...
> > config ARM_EXYNOS4210_CPUFREQ
> >         bool "SAMSUNG EXYNOS4210"
> >         depends on CPU_EXYNOS4210
> >         default y
> >         select ARM_EXYNOS_CPUFREQ
> > ...
> > config ARM_OMAP2PLUS_CPUFREQ
> >         bool "TI OMAP2+"
> >         depends on ARCH_OMAP2PLUS
> > ...
> > 
> 
> CPUfreq has a different concept in that sense. It is a design for one
> single hardware feature.
> 
> > Now lets take a look at ARCH_HAS_BANDGAP usage. In arch/arm/Kconfig we have:
> > 
> 
> 
> BANDGAP is only one component participating of the thermal framework,
> which has different players to make things working. Bandgap is a common
> terminology for one single class of hardware, it does not necessarily
> mean it defines the thermal subsystem. I think here is maybe the source
> for confusion. Bandgaps hardware are used on different scenarios, not
> only on the Linux Kernel thermal framework. Besides, the thermal
> framework does not imply only to give the support to bandgap hardware. I
> think the name would be Bandgap framework, in that case, no? In summary,
> Bandgaps can be used on different things, not only thermal framework.
> Thermal framework encapsulates also other things different than bandgap
> devices (ADC sensor, fan, policies/algorithms, cpufreq cooling devices,
> etc).
> 
> So, no, there is no way BANDGAP config, a config design to encapsulate
> bandgap device, would prevent an entire subsystem, which maps many other
> different things, to be built.
> 
> > ...
> > config ARCH_HAS_BANDGAP
> >         bool
> > ...
> > 
> > then in arch/arm/mach-exynos/Kconfig:
> > 
> > ...
> > config CPU_EXYNOS4210
> >         bool "SAMSUNG EXYNOS4210"
> >         default y
> >         depends on ARCH_EXYNOS4
> >         select ARCH_HAS_BANDGAP
> > ...
> > 
> > and in arch/arm/mach-omap2/Kconfig:
> > 
> > ...
> > config ARCH_OMAP2PLUS
> >         bool
> >         select ARCH_HAS_BANDGAP
> > ...
> > 
> > but finally we don't have the ARCH_HAS_BANDGAP check on the whole thermal
> > support menu but on _particular_ sub-arch/SoC specific driver config options.
> > 
> > In drivers/thermal/samsung/Kconfig:
> > 
> > ...
> > config EXYNOS_THERMAL
> >         tristate "Exynos thermal management unit driver"
> >         depends on ARCH_HAS_BANDGAP && OF
> > ...
> > 
> > and in drivers/thermal/ti-soc-thermal/Kconfig:
> > 
> > ...
> > config TI_SOC_THERMAL
> >         tristate "Texas Instruments SoCs temperature sensor driver"
> >         depends on THERMAL
> >         depends on ARCH_HAS_BANDGAP
> > ...
> > 
> > Therefore the current usage of ARCH_HAS_BANDGAP is wrong and results in
> > sub-arch/SoC specific driver config options being visible/selectable by user
> > on other completely unrelated sub-archs/SoCs configs. Please note that this
> > is incorrect for various reasons: it causes user confusion, unnecessary code
> > can be build into kernel and build breakages potentially can happen. Just
> > having the possibility to disable such unneeded drivers is not scalable and
> > is not enough in the long-term (we have to consider people doing things
> > like "make randconfig" and "make allyesconfig"). This should be fixed by
> > removal of ARCH_HAS_BANDGAP dependency from sub-arch/SoC specific driver
> > config options and replacing them by correct dependencies on sub-arch/SoC.
> > Then we can go and fix all archs/sub-archs/SoCs that have specific thermal
> > drivers available on them to select ARCH_HAS_BANDGAP and finally put
> > ARCH_HAS_BANDGAP dependency on the whole thermal support menu. I can later
> > look into fixing ARCH_HAS_BANDGAP usage if you are fine with it.
> 
> 
> Again, when talking about ARCH_HAS_BANDGAP config, think about the
> bandgap hardware support. Please do not confuse with thermal framework.
> They different things, different concepts.
> 
> Besides, the ARCH_HAS_BANDGAP config entry has been written with bandgap
> hardware in mind, similarly like other ARCH_HAS_*  configs have been
> designed.

OK, thermal != bandgap. I get it.

Then I suppose that you are fine with removal of ARCH_HAS_BANDGAP selects
from Samsung SoCs and ARCH_HAS_BANDGAP dependency from EXYNOS_THERMAL
config option? We have PLAT_SAMSUNG dependency anyway for EXYNOS_THERMAL
as our thermal support is Samsung hardware specific and not needed on
anything besides Samsung SoCs.

ARCH_HAS_BANDGAP would be then just one superfluos ARM config option
that nobody besides ARCH_OMAP2PLUS uses. I can sure live with that. ;-)

> Restricting drivers to be compiled to specific architecture is a poor
> design strategy. Specifically, on the TI Bandgap device driver, as I
> already mentioned to you, this is again clear, as it is currently used
> on different archs, and the code can be easily reused when other archs,
> different than DRA and OMAP, need it.

It is the correct strategy to restrict hardware specific device drivers
(i.e. ARM Exynos thermal driver) to be compiled only for hardware that
it is available on (i.e. ARM Exynos SoCs). If TI bandgap driver is not
hardware specific and can be used on non TI hardware than you're of
course right.

> Also, making your driver flexible, not restricted architectures and
> giving the support to the hardware it is supposed to make it working
> also helps on the single zImage target. It makes it an even more harder
> accomplishment if we keep adding such dependencies you are proposing.

Please don't mix multiplatform support into it as it is completely
independent issue and having proper dependencies on thermal drivers
in no way prevents having multiple thermal drivers compiled into
single zImage.

> I don't understand when you are saying this driver is breaking your
> system (build)? This is not supposed to happen as this driver does not
> (hopefully) depend on arch code, but only on standard Kernel APIs. And
> yes, the driver is not supposed to break on randconfig or allyesconfig.

It is not causing a build breakage currently. I just said that if
ARCH_HAS_BANDGAP dependency is used instead of sub-arch/SoC ones for
hardware specific thermal drivers then it can cause problems.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> If you have a real build breakage, can you please report it ? If you
> expose the real problem, then we can discuss the proper fix. But if we
> are talking about 'potential' build break then I think the proposed
> change is even less worth it.
> 
> > 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> >>>>>>  source "drivers/thermal/ti-soc-thermal/Kconfig"
> >>>>>>  endmenu
> >>>>
> >>>> Best regards,
> >>>> --
> >>>> Bartlomiej Zolnierkiewicz
> >>>> Samsung R&D Institute Poland
> >>>> Samsung Electronics
> >>>
> >>> Best regards,
> >>> --
> >>> Bartlomiej Zolnierkiewicz
> >>> Samsung R&D Institute Poland
> >>> Samsung Electronics

