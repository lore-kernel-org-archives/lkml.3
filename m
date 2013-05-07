Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3EGNSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:18:49 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36599 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3EGNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <1927845.etOFu5Zfbm@amdc1227>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
	<1366972671-9227-2-git-send-email-amit.daniel@samsung.com>
	<1367852706.2079.57.camel@rzhang1-mobl4>
	<1927845.etOFu5Zfbm@amdc1227>
Date: Tue, 7 May 2013 18:48:46 +0530
X-Google-Sender-Auth: uwIZAMenRf6zMXUlSdazsGNTD0c
Message-ID: <CADGdYn5YE6KPgrJYLjh+ctgfQDboajaLWXO6qXZHJtgxXseFtg@mail.gmail.com>
Subject: Re: [PATCH V2 01/20] thermal: exynos: Moving exynos thermal files
 into samsung directory
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz Figa,

On Tue, May 7, 2013 at 3:51 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> On Monday 06 of May 2013 23:05:06 Zhang Rui wrote:
>> On Fri, 2013-04-26 at 16:07 +0530, Amit Daniel Kachhap wrote:
>> > This movement of files is done for easy maintenance and adding more
>> > new sensor's support for exynos platform easily . This will also help in
>> > bifurcating exynos common, sensor driver and sensor data related parts.
>> >
>> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> > Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> > ---
>> >
>> >  drivers/thermal/Kconfig                        |   13 +++++--------
>> >  drivers/thermal/Makefile                       |    2 +-
>> >  drivers/thermal/samsung/Kconfig                |    9 +++++++++
>> >  drivers/thermal/samsung/Makefile               |    4 ++++
>> >  drivers/thermal/{ => samsung}/exynos_thermal.c |    0
>> >  5 files changed, 19 insertions(+), 9 deletions(-)
>> >  create mode 100644 drivers/thermal/samsung/Kconfig
>> >  create mode 100644 drivers/thermal/samsung/Makefile
>> >  rename drivers/thermal/{ => samsung}/exynos_thermal.c (100%)
>> >
>> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> > index 5e3c025..081ddc5 100644
>> > --- a/drivers/thermal/Kconfig
>> > +++ b/drivers/thermal/Kconfig
>> > @@ -114,14 +114,6 @@ config KIRKWOOD_THERMAL
>> >
>> >       Support for the Kirkwood thermal sensor driver into the Linux thermal
>> >       framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
>> >
>> > -config EXYNOS_THERMAL
>> > -   tristate "Temperature sensor on Samsung EXYNOS"
>> > -   depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
>> > -   depends on CPU_THERMAL
>> > -   help
>> > -     If you say yes here you get support for TMU (Thermal Management
>> > -     Unit) on SAMSUNG EXYNOS series of SoC.
>> > -
>> >
>> >  config DOVE_THERMAL
>> >
>> >     tristate "Temperature sensor on Marvell Dove SoCs"
>> >     depends on ARCH_DOVE
>> >
>> > @@ -169,4 +161,9 @@ config INTEL_POWERCLAMP
>> >
>> >       enforce idle time which results in more package C-state residency. The
>> >       user interface is exposed via generic thermal framework.
>> >
>> > +menu "Exynos thermal drivers"
>>
>> would it be more proper to use "Samsung thermal drivers" or "Samsung
>> Exynos thermal drivers" instead?
>
> +1
>
> Still, I wonder if it really makes sense to create a separate directory and
> submenu for this.

Yes separate directory was needed as the current TMU drivers supports
many exynos SOC's with some differences in the controller itself. This
has made it unmanageable and unclean and configuration data need to be
separated from driver. With all these re-structuring, tmu support for
exynos5440 is added very cleanly. Also many changes in this patchset
are for making the driver multi-stance which is needed for 5440.

Thanks,
Amit Daniel
>
>> > +depends on PLAT_SAMSUNG
>> > +source "drivers/thermal/samsung/Kconfig"
>> > +endmenu
>> > +
>>
>> sorry I know few about arm,
>> could you tell me the difference between
>> CONFIG_ARCH_EXYNOS4/CONFIG_ARCH_EXYNOS5 and CONFIG_PLAT_SAMSUNG please,
>> I do not see the dependency between these in Kconfig file?
>
> If those files were kept at thermal/, there would be no need for this check.
> Just particular drivers would depend on platform they are for.
>
> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
> SW Solution Development, Kernel and System Framework
>>
>> >  endif
>> >
>> > diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> > index c054d41..b3063a9 100644
>> > --- a/drivers/thermal/Makefile
>> > +++ b/drivers/thermal/Makefile
>> > @@ -17,7 +17,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL) += cpu_cooling.o
>> >
>> >  obj-$(CONFIG_SPEAR_THERMAL)        += spear_thermal.o
>> >  obj-$(CONFIG_RCAR_THERMAL) += rcar_thermal.o
>> >  obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
>> >
>> > -obj-$(CONFIG_EXYNOS_THERMAL)       += exynos_thermal.o
>> > +obj-y                              += samsung/
>> >
>> >  obj-$(CONFIG_DOVE_THERMAL)         += dove_thermal.o
>> >  obj-$(CONFIG_DB8500_THERMAL)       += db8500_thermal.o
>> >  obj-$(CONFIG_ARMADA_THERMAL)       += armada_thermal.o
>> >
>> > diff --git a/drivers/thermal/samsung/Kconfig
>> > b/drivers/thermal/samsung/Kconfig new file mode 100644
>> > index 0000000..2d3d9dc
>> > --- /dev/null
>> > +++ b/drivers/thermal/samsung/Kconfig
>> > @@ -0,0 +1,9 @@
>> > +config EXYNOS_THERMAL
>> > +   tristate "Temperature sensor on Samsung EXYNOS"
>> > +   depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
>> > +   depends on CPU_THERMAL
>> > +   help
>> > +     If you say yes here you get support for TMU (Thermal Management
>> > +     Unit) on SAMSUNG EXYNOS series of SoC. This helps in registering
>> > +     the exynos thermal driver with the core thermal layer and cpu
>> > +     cooling API's.
>> > diff --git a/drivers/thermal/samsung/Makefile
>> > b/drivers/thermal/samsung/Makefile new file mode 100644
>> > index 0000000..1fe6d93
>> > --- /dev/null
>> > +++ b/drivers/thermal/samsung/Makefile
>> > @@ -0,0 +1,4 @@
>> > +#
>> > +# Samsung thermal specific Makefile
>> > +#
>> > +obj-$(CONFIG_EXYNOS_THERMAL)       += exynos_thermal.o
>> > diff --git a/drivers/thermal/exynos_thermal.c
>> > b/drivers/thermal/samsung/exynos_thermal.c similarity index 100%
>> > rename from drivers/thermal/exynos_thermal.c
>> > rename to drivers/thermal/samsung/exynos_thermal.c
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
