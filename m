Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030458Ab3FUEdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:33:37 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62720 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965258Ab3FUEde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <51C20416.7010809@ti.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-7-git-send-email-amit.daniel@samsung.com>
	<51C20416.7010809@ti.com>
Date: Fri, 21 Jun 2013 10:03:34 +0530
X-Google-Sender-Auth: HNOUXyoasslYUDclWMEQN07vmnU
Message-ID: <CADGdYn7Y2c9B3zbrGY3LssoJHJZUD7W92KyPBN+EifydNEuDEg@mail.gmail.com>
Subject: Re: [PATCH V6 06/30] thermal: exynos: Move exynos_thermal.h from
 include/* to driver/* folder
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jun 20, 2013 at 12:48 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>> This patch renames and moves include/linux/platform_data/exynos_thermal.h to
>> drivers/thermal/samsung/exynos_tmu.h. This file movement is needed as exynos
>> SOC's are not supporting non-DT based platforms and this file now just contains
>> exynos tmu driver related definations.
>> Also struct freq_clip_table is now moved to exynos_thermal_common.c as it fixes
>> the compilation issue occuring because now this new tmu header file is included
>> in tmu driver c file and not in the common thermal header file.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_thermal_common.c    |    1 -
>>  drivers/thermal/samsung/exynos_thermal_common.h    |   15 ++++++++++++
>>  drivers/thermal/samsung/exynos_tmu.c               |    2 +-
>>  .../thermal/samsung/exynos_tmu.h                   |   24 ++++---------------
>>  4 files changed, 21 insertions(+), 21 deletions(-)
>>  rename include/linux/platform_data/exynos_thermal.h => drivers/thermal/samsung/exynos_tmu.h (84%)
>>
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
>> index 92e50bc..dd49c9f 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.c
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
>> @@ -21,7 +21,6 @@
>>   */
>>
>>  #include <linux/cpu_cooling.h>
>> -#include <linux/platform_data/exynos_thermal.h>
>>  #include <linux/slab.h>
>>  #include <linux/thermal.h>
>>
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
>> index 8df1848..068f56c 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -44,6 +44,21 @@
>>
>>  #define EXYNOS_ZONE_COUNT    3
>>
>> +/**
>> + * struct freq_clip_table
>> + * @freq_clip_max: maximum frequency allowed for this cooling state.
>> + * @temp_level: Temperature level at which the temperature clipping will
>> + *   happen.
>> + * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
>> + *
>> + * This structure is required to be filled and passed to the
>> + * cpufreq_cooling_unregister function.
>> + */
>> +struct freq_clip_table {
>> +     unsigned int freq_clip_max;
>> +     unsigned int temp_level;
>> +     const struct cpumask *mask_val;
>> +};
>>  struct       thermal_trip_point_conf {
>>       int trip_val[MAX_TRIP_COUNT];
>>       int trip_count;
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 22a8874..6aa2fd2 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -27,9 +27,9 @@
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>>  #include <linux/platform_device.h>
>> -#include <linux/platform_data/exynos_thermal.h>
>>
>>  #include "exynos_thermal_common.h"
>> +#include "exynos_tmu.h"
>>
>>  /* Exynos generic registers */
>>  #define EXYNOS_TMU_REG_TRIMINFO              0x0
>> diff --git a/include/linux/platform_data/exynos_thermal.h b/drivers/thermal/samsung/exynos_tmu.h
>> similarity index 84%
>> rename from include/linux/platform_data/exynos_thermal.h
>> rename to drivers/thermal/samsung/exynos_tmu.h
>> index da7e627..9e0f887 100644
>> --- a/include/linux/platform_data/exynos_thermal.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -1,8 +1,9 @@
>>  /*
>> - * exynos_thermal.h - Samsung EXYNOS TMU (Thermal Management Unit)
>> + * exynos_tmu.h - Samsung EXYNOS TMU (Thermal Management Unit)
>>   *
>>   *  Copyright (C) 2011 Samsung Electronics
>>   *  Donggeun Kim <dg77.kim@samsung.com>
>> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
>>   *
>>   * This program is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License as published by
>> @@ -19,8 +20,8 @@
>>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>>   */
>>
>> -#ifndef _LINUX_EXYNOS_THERMAL_H
>> -#define _LINUX_EXYNOS_THERMAL_H
>> +#ifndef _EXYNOS_TMU_H
>> +#define _EXYNOS_TMU_H
>>  #include <linux/cpu_cooling.h>
>>
>>  enum calibration_type {
>> @@ -33,21 +34,6 @@ enum soc_type {
>>       SOC_ARCH_EXYNOS4210 = 1,
>>       SOC_ARCH_EXYNOS,
>>  };
>> -/**
>> - * struct freq_clip_table
>> - * @freq_clip_max: maximum frequency allowed for this cooling state.
>> - * @temp_level: Temperature level at which the temperature clipping will
>> - *   happen.
>> - * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
>> - *
>> - * This structure is required to be filled and passed to the
>> - * cpufreq_cooling_unregister function.
>> - */
>> -struct freq_clip_table {
>> -     unsigned int freq_clip_max;
>> -     unsigned int temp_level;
>> -     const struct cpumask *mask_val;
>> -};
>>
>>  /**
>>   * struct exynos_tmu_platform_data
>> @@ -116,4 +102,4 @@ struct exynos_tmu_platform_data {
>>       struct freq_clip_table freq_tab[4];
>
> Because you have this struct right here, you need still to have:
> +#include "exynos_thermal_common.h"
>
> in your include list of exynos_tmu.h (this file).
>
> A part from this minor issue, you can add my acked:
>
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Ok will re-submit with this change.

Thanks,
Amit Daniel
>
>>       unsigned int freq_tab_count;
>>  };
>> -#endif /* _LINUX_EXYNOS_THERMAL_H */
>> +#endif /* _EXYNOS_TMU_H */
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
