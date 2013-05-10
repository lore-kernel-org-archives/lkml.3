Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab3EJBxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:53:50 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:63216 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab3EJBxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:53:46 -0400
MIME-Version: 1.0
In-Reply-To: <518BA478.5050706@ti.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
	<1367931671-3906-5-git-send-email-amit.daniel@samsung.com>
	<518BA478.5050706@ti.com>
Date: Fri, 10 May 2013 07:23:43 +0530
X-Google-Sender-Auth: JzTMTnR3llgGkGD-lYrKDBxHjq4
Message-ID: <CADGdYn5ps6zqgPUEvf40+z3P17Y4tXxK+KqxPGu2y75vjVTmrA@mail.gmail.com>
Subject: Re: [PATCH V3 04/21] thermal: exynos: Move exynos_thermal.h from
 include/* to driver/* folder
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 9, 2013 at 6:58 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Hello Amit,
>
> On 07-05-2013 09:00, Amit Daniel Kachhap wrote:
>> This patch renames and moves  include/linux/platform_data/exynos_thermal.h to
>> drivers/thermal/samsung/exynos_tmu.h. This file movement is needed as exynos
>> SOC's are not supporting non-DT based platforms. Also the rename is needed as this
>> file now just contains exynos tmu driver related definations.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_thermal_common.c    |    1 -
>>  drivers/thermal/samsung/exynos_thermal_common.h    |   15 +++++++++++++++
>>  drivers/thermal/samsung/exynos_tmu.c               |    2 +-
>>  .../thermal/samsung/exynos_tmu.h                   |   15 ---------------
>>  4 files changed, 16 insertions(+), 17 deletions(-)
>>  rename include/linux/platform_data/exynos_thermal.h => drivers/thermal/samsung/exynos_tmu.h (88%)
>>
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
>> index 9a57606..dae5476 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.c
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
>> @@ -27,7 +27,6 @@
>>  #include <linux/kernel.h>
>>  #include <linux/kobject.h>
>>  #include <linux/mutex.h>
>> -#include <linux/platform_data/exynos_thermal.h>
>>  #include <linux/slab.h>
>>  #include <linux/thermal.h>
>>  #include "exynos_thermal_common.h"
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
>> index da2add0..1c3f8b7 100644
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
>> index 3de3e61..a02f2c9 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -30,10 +30,10 @@
>>  #include <linux/mutex.h>
>>  #include <linux/of.h>
>>  #include <linux/platform_device.h>
>> -#include <linux/platform_data/exynos_thermal.h>
>>  #include <linux/slab.h>
>>  #include <linux/workqueue.h>
>>  #include "exynos_thermal_common.h"
>> +#include "exynos_tmu.h"
>>
>>  /* Exynos generic registers */
>>  #define EXYNOS_TMU_REG_TRIMINFO              0x0
>> diff --git a/include/linux/platform_data/exynos_thermal.h b/drivers/thermal/samsung/exynos_tmu.h
>> similarity index 88%
>> rename from include/linux/platform_data/exynos_thermal.h
>> rename to drivers/thermal/samsung/exynos_tmu.h
>> index da7e627..342fb1f 100644
>> --- a/include/linux/platform_data/exynos_thermal.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -33,21 +33,6 @@ enum soc_type {
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
>
> You explain why you need to rename the header, and thats what you do in
> this patch. On the other hand, you also move the freq_clip_table
> structure definition. This change is present in this patch, I dont see
> the connection with the file rename, and you also do not explain why it
> is needed. Can you please consider, either split this change to other
> (new) patch or explain it also in this patch?
Yes I forgot to add explanation here. This is done to fix compilation
issue when this header is moved. Basically struct freq_clip_table is a
candidate of common header and I have not included exynos_tmu.h into
exynos_thermal_common.h. Will provide a detailed explanation.

Thanks,
Amit
>
>
>>  /**
>>   * struct exynos_tmu_platform_data
>>
>
>
