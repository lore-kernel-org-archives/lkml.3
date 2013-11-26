Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3KZGPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:15:46 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51089 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3KZGPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:15:42 -0500
MIME-Version: 1.0
In-Reply-To: <1440196.1vM1gSXuH1@amdc1032>
References: <2244251.cWS1a83qbK@amdc1032>
	<1440196.1vM1gSXuH1@amdc1032>
Date: Tue, 26 Nov 2013 11:45:41 +0530
Message-ID: <CADGdYn6O9LdwijYfoFqfMcrndBy3L5H=1cbSsGXMOj4yavZT0A@mail.gmail.com>
Subject: Re: [PATCH] thermal: EXYNOS: always register TMU driver with core
 thermal framework
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/13, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> Could you please also apply this patch?
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
> On Friday, October 04, 2013 02:38:25 PM Bartlomiej Zolnierkiewicz wrote:
>> There is little sense in having separate config option for
>> registering EXYNOS TMU driver with the core thermal framework.
>> Fix it by integrating EXYNOS_THERMAL_CORE config option with
>> EXYNOS_THERMAL one.
>>
Sorry for the late reply but this patch is not needed as in my opinion
as it is just decreasing the flexibility when only sensor hardware
needs to be initialised and all cooling is hw controlled.

Thanks,
Amit D
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/thermal/samsung/Kconfig                 | 14 +++-----------
>>  drivers/thermal/samsung/Makefile                |  2 +-
>>  drivers/thermal/samsung/exynos_thermal_common.h | 12 ------------
>>  3 files changed, 4 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/Kconfig
>> b/drivers/thermal/samsung/Kconfig
>> index f760389..04eabee 100644
>> --- a/drivers/thermal/samsung/Kconfig
>> +++ b/drivers/thermal/samsung/Kconfig
>> @@ -5,14 +5,6 @@ config EXYNOS_THERMAL
>>  	  If you say yes here you get support for the TMU (Thermal Management
>>  	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver
>> initialises
>>  	  the TMU, reports temperature and handles cooling action if defined.
>> -	  This driver uses the Exynos core thermal APIs and TMU configuration
>> -	  data from the supported SoCs.
>> -
>> -config EXYNOS_THERMAL_CORE
>> -	bool "Core thermal framework support for EXYNOS SOCs"
>> -	depends on EXYNOS_THERMAL
>> -	help
>> -	  If you say yes here you get support for EXYNOS TMU
>> -	  (Thermal Management Unit) common registration/unregistration
>> -	  functions to the core thermal layer and also to use the generic
>> -	  CPU cooling APIs.
>> +	  This driver uses the Exynos core thermal APIs, TMU configuration data
>> +	  from the supported SoCs, common registration/unregistration functions
>> +	  to the core thermal layer and also the generic CPU cooling APIs.
>> diff --git a/drivers/thermal/samsung/Makefile
>> b/drivers/thermal/samsung/Makefile
>> index c09d830..a829107 100644
>> --- a/drivers/thermal/samsung/Makefile
>> +++ b/drivers/thermal/samsung/Makefile
>> @@ -4,4 +4,4 @@
>>  obj-$(CONFIG_EXYNOS_THERMAL)			+= exynos_thermal.o
>>  exynos_thermal-y				:= exynos_tmu.o
>>  exynos_thermal-y				+= exynos_tmu_data.o
>> -exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)	+= exynos_thermal_common.o
>> +exynos_thermal-y				+= exynos_thermal_common.o
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h
>> b/drivers/thermal/samsung/exynos_thermal_common.h
>> index 3eb2ed9..8681679 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -88,20 +88,8 @@ struct thermal_sensor_conf {
>>  	struct device *dev;
>>  };
>>
>> -/*Functions used exynos based thermal sensor driver*/
>> -#ifdef CONFIG_EXYNOS_THERMAL_CORE
>>  void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf);
>>  int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
>>  void exynos_report_trigger(struct thermal_sensor_conf *sensor_conf);
>> -#else
>> -static inline void
>> -exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf) {
>> return; }
>>
>> -static inline int
>> -exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { return
>> 0; }
>> -
>> -static inline void
>> -exynos_report_trigger(struct thermal_sensor_conf *sensor_conf) { return;
>> }
>> -
>> -#endif /* CONFIG_EXYNOS_THERMAL_CORE */
>>  #endif /* _EXYNOS_THERMAL_COMMON_H */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
