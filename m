Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3JHQKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:10:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42062 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3JHQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:10:46 -0400
Message-ID: <52542E42.5090805@ti.com>
Date: Tue, 8 Oct 2013 12:09:38 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
References: <3702969.8rn3SOscJE@amdc1032> <1985237.ukkgSmGrTt@amdc1032> <1588308.i5Ha5A8RHe@amdc1032> <345331503.cxDWWY2SGj@amdc1032>
In-Reply-To: <345331503.cxDWWY2SGj@amdc1032>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="HSK5ea24eWGnGtfb1iVT9TXli9IUDTv0k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HSK5ea24eWGnGtfb1iVT9TXli9IUDTv0k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Bartlomiej,

On 08-10-2013 10:47, Bartlomiej Zolnierkiewicz wrote:
>=20
> Hi Eduardo,
>=20
> On Monday, October 07, 2013 04:10:29 PM Bartlomiej Zolnierkiewicz wrote=
:
>> On Monday, October 07, 2013 12:50:54 PM Bartlomiej Zolnierkiewicz wrot=
e:
>>> On Monday, October 07, 2013 11:57:16 AM Bartlomiej Zolnierkiewicz wro=
te:
>>>>
>>>> Hi,
>>>>
>>>> On Friday, October 04, 2013 02:22:30 PM Eduardo Valentin wrote:
>>>>> On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
>>>>>> Menu for Texas Instruments thermal support is visible on all
>>>>>> platforms and TI_SOC_THERMAL + TI_THERMAL config options can
>>>>>> be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
>>>>>> config option is selected by SoCs config options to fulfill
>>>>>> EXYNOS_THERMAL config option dependency). Thus the code which
>>>>>> is never used can be build. Fix it by making TI menu dependent
>>>>>> on ARCH_OMAP2PLUS config option.
>>>>>>
>>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com=
>
>>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>> ---
>>>>>>  drivers/thermal/Kconfig | 1 +
>>>>>>  1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>>>>> index 57e06a9..a709c63 100644
>>>>>> --- a/drivers/thermal/Kconfig
>>>>>> +++ b/drivers/thermal/Kconfig
>>>>>> @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
>>>>>>  	  notification methods.
>>>>>> =20
>>>>>>  menu "Texas Instruments thermal drivers"
>>>>>> +depends on ARCH_OMAP2PLUS
>>>>>
>>>>> No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the=

>>>>> option to offer thermal control. So, the HW supported is TI bandgap=
 IP,
>>>>> not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
>>>>> (different) version of this device.
>>>>>
>>>>> However, DRA7 devices, for instance, also feature the bandgap IP
>>>>> (different version of those present in OMAP devices), and it is not=

>>>>> ARCH_OMAP2PLUS.
>>>>
>>>> Then you have wrong dependencies anyway since ARCH_BANDGAP is select=
ed
>>>
>>> s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/
>>>
>>>> currently only by ARCH_OMAP2PLUS and EXYNOS SoCs.
>>
>> It seems that SOC_DRA7xx config option is dependent on ARCH_OMAP2PLUS =
one
>> *anyway* (thus it doesn't need to select ARCH_HAS_BANDGAP on its own).=
 Thus
>> my patch is correct and sufficient for the current TI bandgap IP suppo=
rt.
>>
>> if ARCH_OMAP2PLUS
>>
>> menu "TI OMAP2/3/4 Specific Features"
>>
>> config ARCH_OMAP2PLUS_TYPICAL
>> 	bool "Typical OMAP configuration"
>> 	default y
>> 	select AEABI
>> 	select HIGHMEM
>> 	select I2C
>> 	select I2C_OMAP
>> 	select MENELAUS if ARCH_OMAP2
>> 	select NEON if CPU_V7
>> 	select PM_RUNTIME
>> 	select REGULATOR
>> 	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
>> 	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
>> 	select VFP
>> 	help
>> 	  Compile a kernel suitable for booting most boards
>>
>> config SOC_HAS_OMAP2_SDRC
>> 	bool "OMAP2 SDRAM Controller support"
>>
>> config SOC_HAS_REALTIME_COUNTER
>> 	bool "Real time free running counter"
>> 	depends on SOC_OMAP5 || SOC_DRA7XX
>> 	default y
>>
>> config SOC_DRA7XX
>> 	bool "TI DRA7XX"
>> 	select ARM_ARCH_TIMER
>> 	select CPU_V7
>> 	select ARM_GIC
>> 	select HAVE_SMP
>> 	select COMMON_CLK
>> ...
>>
>> Best regards,
>> --
>> Bartlomiej Zolnierkiewicz
>> Samsung R&D Institute Poland
>> Samsung Electronics
>>
>>>> arch/arm/mach-omap2/Kconfig (next-20130927):
>>>>
>>>> config ARCH_OMAP2PLUS
>>>>         bool
>>>>         select ARCH_HAS_BANDGAP
>>>>         select ARCH_HAS_CPUFREQ
>>>>         select ARCH_HAS_HOLES_MEMORYMODEL
>>>>         select ARCH_OMAP
>>>>         select ARCH_REQUIRE_GPIOLIB
>>>>         select CLKDEV_LOOKUP
>>>>         select CLKSRC_MMIO
>>>>         select GENERIC_CLOCKEVENTS
>>>>         select GENERIC_IRQ_CHIP
>>>>         select HAVE_CLK
>>>>         select OMAP_DM_TIMER
>>>>         select PINCTRL
>>>>         select PROC_DEVICETREE if PROC_FS
>>>>         select SOC_BUS
>>>>         select SPARSE_IRQ
>>>>         select TI_PRIV_EDMA
>>>>         select USE_OF
>>>>         help
>>>>           Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
>>>>
>>>> drivers/thermal/ti-soc-thermal/Kconfig (next-20130927):
>>>>
>>>> config TI_SOC_THERMAL
>>>>         tristate "Texas Instruments SoCs temperature sensor driver"
>>>>         depends on THERMAL
>>>>         depends on ARCH_HAS_BANDGAP
>>>>         help
>>>>           If you say yes here you get support for the Texas Instrume=
nts
>>>>           OMAP4460+ on die bandgap temperature sensor support. The r=
egister
>>>>           set is part of system control module.
>>>>
>>>>           This includes alert interrupts generation and also the TSH=
UT
>>>>           support.
>>>
>>> and for EXYNOS it looks like that (next-20130927):
>>>
>>> arch/arm/mach-exynos/Kconfig:
>>>
>>> config CPU_EXYNOS4210
>>> 	bool "SAMSUNG EXYNOS4210"
>>> 	default y
>>> 	depends on ARCH_EXYNOS4
>>> 	select ARCH_HAS_BANDGAP
>>> 	select ARM_CPU_SUSPEND if PM
>>> 	select PINCTRL_EXYNOS
>>> 	select PM_GENERIC_DOMAINS if PM
>>> 	select S5P_PM if PM
>>> 	select S5P_SLEEP if PM
>>> 	select SAMSUNG_DMADEV
>>> 	help
>>> 	  Enable EXYNOS4210 CPU support
>>>
>>> config SOC_EXYNOS4212
>>> 	bool "SAMSUNG EXYNOS4212"
>>> 	default y
>>> 	depends on ARCH_EXYNOS4
>>> 	select ARCH_HAS_BANDGAP
>>> 	select PINCTRL_EXYNOS
>>> 	select PM_GENERIC_DOMAINS if PM
>>> 	select S5P_PM if PM
>>> 	select S5P_SLEEP if PM
>>> 	select SAMSUNG_DMADEV
>>> 	help
>>> 	  Enable EXYNOS4212 SoC support
>>>
>>> config SOC_EXYNOS4412
>>> 	bool "SAMSUNG EXYNOS4412"
>>> 	default y
>>> 	depends on ARCH_EXYNOS4
>>> 	select ARCH_HAS_BANDGAP
>>> 	select PINCTRL_EXYNOS
>>> 	select PM_GENERIC_DOMAINS if PM
>>> 	select SAMSUNG_DMADEV
>>> 	help
>>> 	  Enable EXYNOS4412 SoC support
>>>
>>> config SOC_EXYNOS5250
>>> 	bool "SAMSUNG EXYNOS5250"
>>> 	default y
>>> 	depends on ARCH_EXYNOS5
>>> 	select ARCH_HAS_BANDGAP
>>> 	select PINCTRL_EXYNOS
>>> 	select PM_GENERIC_DOMAINS if PM
>>> 	select S5P_PM if PM
>>> 	select S5P_SLEEP if PM
>>> 	select S5P_DEV_MFC
>>> 	select SAMSUNG_DMADEV
>>> 	help
>>> 	  Enable EXYNOS5250 SoC support
>>>
>>> config SOC_EXYNOS5420
>>> 	bool "SAMSUNG EXYNOS5420"
>>> 	default y
>>> 	depends on ARCH_EXYNOS5
>>> 	select PM_GENERIC_DOMAINS if PM
>>> 	select S5P_PM if PM
>>> 	select S5P_SLEEP if PM
>>> 	help
>>> 	  Enable EXYNOS5420 SoC support
>>>
>>> config SOC_EXYNOS5440
>>> 	bool "SAMSUNG EXYNOS5440"
>>> 	default y
>>> 	depends on ARCH_EXYNOS5
>>> 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
>>> 	select ARCH_HAS_BANDGAP
>>> 	select ARCH_HAS_OPP
>>> 	select HAVE_ARM_ARCH_TIMER
>>> 	select AUTO_ZRELADDR
>>> 	select MIGHT_HAVE_PCI
>>> 	select PCI_DOMAINS if PCI
>>> 	select PINCTRL_EXYNOS5440
>>> 	select PM_OPP
>>> 	help
>>> 	  Enable EXYNOS5440 SoC support
>>>
>>> drivers/thermal/Kconfig:
>>>
>>> menu "Samsung thermal drivers"
>>> depends on PLAT_SAMSUNG
>>> source "drivers/thermal/samsung/Kconfig"
>>> endmenu
>>>
>>> drivers/thermal/samsung/Kconfig
>>>
>>> config EXYNOS_THERMAL
>>> 	tristate "Exynos thermal management unit driver"
>>> 	depends on ARCH_HAS_BANDGAP && OF
>>> 	help
>>> 	  If you say yes here you get support for the TMU (Thermal Managemen=
t
>>> 	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver initia=
lises
>>> 	  the TMU, reports temperature and handles cooling action if defined=
=2E
>>> 	  This driver uses the Exynos core thermal APIs and TMU configuratio=
n
>>> 	  data from the supported SoCs.
>>>
>>>
>>>>> And because of that, the design of this driver is different. It is =
not
>>>>> expected to depend on an arch, but the arch code is expected to sel=
ect
>>>>> ARCH_HAS_BANDGAP.
>>>>
>>>> There should be additional dependencies beside ARCH_BANDGAP, i.e. on=

>>>
>>> s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/
>>>
>>>> EXYNOS platforms we currently also have dependency on PLAT_SAMSUNG
>>>> (should be ARCH_EXYNOS instead, my other patch fixes it).
>=20
> There is more to it. Description of commit 4a1b573 ("ARM: 7758/1: intro=
duce
> config HAS_BANDGAP") which introduced ARCH_HAS_BANDGAP says that "This =
config
> entry follows the same idea behind ARCH_HAS_CPUFREQ." but in pract ice =
it does
> currently something completely different than ARCH_HAS_CPUFREQ.

I think there is some misunderstanding. First thing is that, the fact
that feature A follows the same idea of feature B, does not necessarily
mean, it has to exactly the same, otherwise they would be the same
thing, right ? :-)

>=20
> For ARCH_HAS_CPUFREQ in arch/arm/Kconfig we first have:
>=20
> ...
> config ARCH_HAS_CPUFREQ
>         bool
>         help
>           Internal node to signify that the ARCH has CPUFREQ support
>           and that the relevant menu configurations are displayed for
>           it.
> ...
>=20
> then later we have sub-archs/SoCs selecting it:
>=20
> ...
> config ARCH_EXYNOS
>         bool "Samsung EXYNOS"
>         select ARCH_HAS_CPUFREQ
> ...
>=20
> (for OMAP arch/arm/Kconfig includes arch/arm/mach-omap2/Kconfig in whic=
h
> ARCH_OMAP2PLUS is defined and which selects ARCH_HAS_CPUFREQ)
>=20
> and finally we have the check on the _whole_ CPUFREQ support menu (not =
on
> particular sub-arch/SoCs specific driver config options):
>=20
> ...
> if ARCH_HAS_CPUFREQ
> source "drivers/cpufreq/Kconfig"
> endif
> ...
>=20
> Also when we take a look at drivers/cpufreq/Kconfig.arm we can see that=

> particular sub-arch/SoCs specific drivers have correct dependencies on
> sub-arch/SoC, i.e.:
>=20
> ...
> config ARM_EXYNOS4210_CPUFREQ
>         bool "SAMSUNG EXYNOS4210"
>         depends on CPU_EXYNOS4210
>         default y
>         select ARM_EXYNOS_CPUFREQ
> ...
> config ARM_OMAP2PLUS_CPUFREQ
>         bool "TI OMAP2+"
>         depends on ARCH_OMAP2PLUS
> ...
>=20

CPUfreq has a different concept in that sense. It is a design for one
single hardware feature.

> Now lets take a look at ARCH_HAS_BANDGAP usage. In arch/arm/Kconfig we =
have:
>=20


BANDGAP is only one component participating of the thermal framework,
which has different players to make things working. Bandgap is a common
terminology for one single class of hardware, it does not necessarily
mean it defines the thermal subsystem. I think here is maybe the source
for confusion. Bandgaps hardware are used on different scenarios, not
only on the Linux Kernel thermal framework. Besides, the thermal
framework does not imply only to give the support to bandgap hardware. I
think the name would be Bandgap framework, in that case, no? In summary,
Bandgaps can be used on different things, not only thermal framework.
Thermal framework encapsulates also other things different than bandgap
devices (ADC sensor, fan, policies/algorithms, cpufreq cooling devices,
etc).

So, no, there is no way BANDGAP config, a config design to encapsulate
bandgap device, would prevent an entire subsystem, which maps many other
different things, to be built.

> ...
> config ARCH_HAS_BANDGAP
>         bool
> ...
>=20
> then in arch/arm/mach-exynos/Kconfig:
>=20
> ...
> config CPU_EXYNOS4210
>         bool "SAMSUNG EXYNOS4210"
>         default y
>         depends on ARCH_EXYNOS4
>         select ARCH_HAS_BANDGAP
> ...
>=20
> and in arch/arm/mach-omap2/Kconfig:
>=20
> ...
> config ARCH_OMAP2PLUS
>         bool
>         select ARCH_HAS_BANDGAP
> ...
>=20
> but finally we don't have the ARCH_HAS_BANDGAP check on the whole therm=
al
> support menu but on _particular_ sub-arch/SoC specific driver config op=
tions.
>=20
> In drivers/thermal/samsung/Kconfig:
>=20
> ...
> config EXYNOS_THERMAL
>         tristate "Exynos thermal management unit driver"
>         depends on ARCH_HAS_BANDGAP && OF
> ...
>=20
> and in drivers/thermal/ti-soc-thermal/Kconfig:
>=20
> ...
> config TI_SOC_THERMAL
>         tristate "Texas Instruments SoCs temperature sensor driver"
>         depends on THERMAL
>         depends on ARCH_HAS_BANDGAP
> ...
>=20
> Therefore the current usage of ARCH_HAS_BANDGAP is wrong and results in=

> sub-arch/SoC specific driver config options being visible/selectable by=
 user
> on other completely unrelated sub-archs/SoCs configs. Please note that =
this
> is incorrect for various reasons: it causes user confusion, unnecessary=
 code
> can be build into kernel and build breakages potentially can happen. Ju=
st
> having the possibility to disable such unneeded drivers is not scalable=
 and
> is not enough in the long-term (we have to consider people doing things=

> like "make randconfig" and "make allyesconfig"). This should be fixed b=
y
> removal of ARCH_HAS_BANDGAP dependency from sub-arch/SoC specific drive=
r
> config options and replacing them by correct dependencies on sub-arch/S=
oC.
> Then we can go and fix all archs/sub-archs/SoCs that have specific ther=
mal
> drivers available on them to select ARCH_HAS_BANDGAP and finally put
> ARCH_HAS_BANDGAP dependency on the whole thermal support menu. I can la=
ter
> look into fixing ARCH_HAS_BANDGAP usage if you are fine with it.


Again, when talking about ARCH_HAS_BANDGAP config, think about the
bandgap hardware support. Please do not confuse with thermal framework.
They different things, different concepts.

Besides, the ARCH_HAS_BANDGAP config entry has been written with bandgap
hardware in mind, similarly like other ARCH_HAS_*  configs have been
designed.

Restricting drivers to be compiled to specific architecture is a poor
design strategy. Specifically, on the TI Bandgap device driver, as I
already mentioned to you, this is again clear, as it is currently used
on different archs, and the code can be easily reused when other archs,
different than DRA and OMAP, need it.

Also, making your driver flexible, not restricted architectures and
giving the support to the hardware it is supposed to make it working
also helps on the single zImage target. It makes it an even more harder
accomplishment if we keep adding such dependencies you are proposing.

I don't understand when you are saying this driver is breaking your
system (build)? This is not supposed to happen as this driver does not
(hopefully) depend on arch code, but only on standard Kernel APIs. And
yes, the driver is not supposed to break on randconfig or allyesconfig.

If you have a real build breakage, can you please report it ? If you
expose the real problem, then we can discuss the proper fix. But if we
are talking about 'potential' build break then I think the proposed
change is even less worth it.

>=20
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>=20
>>>>>>  source "drivers/thermal/ti-soc-thermal/Kconfig"
>>>>>>  endmenu
>>>>
>>>> Best regards,
>>>> --
>>>> Bartlomiej Zolnierkiewicz
>>>> Samsung R&D Institute Poland
>>>> Samsung Electronics
>>>
>>> Best regards,
>>> --
>>> Bartlomiej Zolnierkiewicz
>>> Samsung R&D Institute Poland
>>> Samsung Electronics
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--HSK5ea24eWGnGtfb1iVT9TXli9IUDTv0k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJULkcACgkQCXcVR3XQvP1a5gD+J62iD+qYPEaXKdn9cHnne9nF
nZvWp962IiDPH1K9+yUBAPXcljI97HQlmQdNoPdULLaaNQQByA3t7CZpdKnfU44B
=WTyN
-----END PGP SIGNATURE-----

--HSK5ea24eWGnGtfb1iVT9TXli9IUDTv0k--
