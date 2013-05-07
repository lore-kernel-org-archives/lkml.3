Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3EGNMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:12:16 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49865 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab3EGNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <1367852706.2079.57.camel@rzhang1-mobl4>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
	<1366972671-9227-2-git-send-email-amit.daniel@samsung.com>
	<1367852706.2079.57.camel@rzhang1-mobl4>
Date: Tue, 7 May 2013 18:42:13 +0530
X-Google-Sender-Auth: TfAvbIQSD8OOHH487mWryUh62Hc
Message-ID: <CADGdYn6xwp5qUtpPhUSrE1E4c34wN=cvkmvn9kNKd6mWUxFJ1w@mail.gmail.com>
Subject: Re: [PATCH V2 01/20] thermal: exynos: Moving exynos thermal files
 into samsung directory
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

On Mon, May 6, 2013 at 8:35 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Fri, 2013-04-26 at 16:07 +0530, Amit Daniel Kachhap wrote:
>> This movement of files is done for easy maintenance and adding more
>> new sensor's support for exynos platform easily . This will also help in
>> bifurcating exynos common, sensor driver and sensor data related parts.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/Kconfig                        |   13 +++++--------
>>  drivers/thermal/Makefile                       |    2 +-
>>  drivers/thermal/samsung/Kconfig                |    9 +++++++++
>>  drivers/thermal/samsung/Makefile               |    4 ++++
>>  drivers/thermal/{ => samsung}/exynos_thermal.c |    0
>>  5 files changed, 19 insertions(+), 9 deletions(-)
>>  create mode 100644 drivers/thermal/samsung/Kconfig
>>  create mode 100644 drivers/thermal/samsung/Makefile
>>  rename drivers/thermal/{ => samsung}/exynos_thermal.c (100%)
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 5e3c025..081ddc5 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -114,14 +114,6 @@ config KIRKWOOD_THERMAL
>>         Support for the Kirkwood thermal sensor driver into the Linux thermal
>>         framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
>>
>> -config EXYNOS_THERMAL
>> -     tristate "Temperature sensor on Samsung EXYNOS"
>> -     depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
>> -     depends on CPU_THERMAL
>> -     help
>> -       If you say yes here you get support for TMU (Thermal Management
>> -       Unit) on SAMSUNG EXYNOS series of SoC.
>> -
>>  config DOVE_THERMAL
>>       tristate "Temperature sensor on Marvell Dove SoCs"
>>       depends on ARCH_DOVE
>> @@ -169,4 +161,9 @@ config INTEL_POWERCLAMP
>>         enforce idle time which results in more package C-state residency. The
>>         user interface is exposed via generic thermal framework.
>>
>> +menu "Exynos thermal drivers"
>
> would it be more proper to use "Samsung thermal drivers" or "Samsung
> Exynos thermal drivers" instead?
Yes "Samsung thermal drivers" will look fine. Submitted with this change.
>
>> +depends on PLAT_SAMSUNG
>> +source "drivers/thermal/samsung/Kconfig"
>> +endmenu
>> +
> sorry I know few about arm,
> could you tell me the difference between
> CONFIG_ARCH_EXYNOS4/CONFIG_ARCH_EXYNOS5 and CONFIG_PLAT_SAMSUNG please,
> I do not see the dependency between these in Kconfig file?
PLAT_SAMSUNG is the superset of ARCH_EXYNOS4/5 so I used this
dependency but currently only exynos based soc's have TMU driver. Also
it matches with the folder name.

Thanks,
Amit Daniel
>
> thanks,
> rui
>>  endif
>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> index c054d41..b3063a9 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -17,7 +17,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)   += cpu_cooling.o
>>  obj-$(CONFIG_SPEAR_THERMAL)  += spear_thermal.o
>>  obj-$(CONFIG_RCAR_THERMAL)   += rcar_thermal.o
>>  obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
>> -obj-$(CONFIG_EXYNOS_THERMAL) += exynos_thermal.o
>> +obj-y                                += samsung/
>>  obj-$(CONFIG_DOVE_THERMAL)   += dove_thermal.o
>>  obj-$(CONFIG_DB8500_THERMAL) += db8500_thermal.o
>>  obj-$(CONFIG_ARMADA_THERMAL) += armada_thermal.o
>> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
>> new file mode 100644
>> index 0000000..2d3d9dc
>> --- /dev/null
>> +++ b/drivers/thermal/samsung/Kconfig
>> @@ -0,0 +1,9 @@
>> +config EXYNOS_THERMAL
>> +     tristate "Temperature sensor on Samsung EXYNOS"
>> +     depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
>> +     depends on CPU_THERMAL
>> +     help
>> +       If you say yes here you get support for TMU (Thermal Management
>> +       Unit) on SAMSUNG EXYNOS series of SoC. This helps in registering
>> +       the exynos thermal driver with the core thermal layer and cpu
>> +       cooling API's.
>> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
>> new file mode 100644
>> index 0000000..1fe6d93
>> --- /dev/null
>> +++ b/drivers/thermal/samsung/Makefile
>> @@ -0,0 +1,4 @@
>> +#
>> +# Samsung thermal specific Makefile
>> +#
>> +obj-$(CONFIG_EXYNOS_THERMAL) += exynos_thermal.o
>> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/samsung/exynos_thermal.c
>> similarity index 100%
>> rename from drivers/thermal/exynos_thermal.c
>> rename to drivers/thermal/samsung/exynos_thermal.c
>
>
