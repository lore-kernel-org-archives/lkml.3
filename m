Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3EFPUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:20:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:23653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab3EFPUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:20:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="332580230"
Message-ID: <1367853589.2079.66.camel@rzhang1-mobl4>
Subject: Re: [PATCH V2 04/20] thermal: exynos: Move exynos_thermal.h from
 include/* to driver/* folder
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Date: Mon, 06 May 2013 23:19:49 +0800
In-Reply-To: <1366972671-9227-5-git-send-email-amit.daniel@samsung.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
	 <1366972671-9227-5-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 16:07 +0530, Amit Daniel Kachhap wrote:
> This patch renames and moves  include/linux/platform_data/exynos_thermal.h to
> drivers/thermal/samsung/exynos_tmu.h. This file movement is needed as exynos
> SOC's are not supporting non-DT based platforms. Also the rename is needed as this
> file now just contains exynos tmu driver related definations.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

this one looks okay to me.

thanks,
rui
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c    |    1 -
>  drivers/thermal/samsung/exynos_thermal_common.h    |   15 +++++++++++++++
>  drivers/thermal/samsung/exynos_tmu.c               |    2 +-
>  .../thermal/samsung/exynos_tmu.h                   |   15 ---------------
>  4 files changed, 16 insertions(+), 17 deletions(-)
>  rename include/linux/platform_data/exynos_thermal.h => drivers/thermal/samsung/exynos_tmu.h (88%)
> 
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
> index 9a57606..dae5476 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -27,7 +27,6 @@
>  #include <linux/kernel.h>
>  #include <linux/kobject.h>
>  #include <linux/mutex.h>
> -#include <linux/platform_data/exynos_thermal.h>
>  #include <linux/slab.h>
>  #include <linux/thermal.h>
>  #include "exynos_thermal_common.h"
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
> index 165401f..985b848 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -44,6 +44,21 @@
>  
>  #define EXYNOS_ZONE_COUNT	3
>  
> +/**
> + * struct freq_clip_table
> + * @freq_clip_max: maximum frequency allowed for this cooling state.
> + * @temp_level: Temperature level at which the temperature clipping will
> + *	happen.
> + * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
> + *
> + * This structure is required to be filled and passed to the
> + * cpufreq_cooling_unregister function.
> + */
> +struct freq_clip_table {
> +	unsigned int freq_clip_max;
> +	unsigned int temp_level;
> +	const struct cpumask *mask_val;
> +};
>  struct	thermal_trip_point_conf {
>  	int trip_val[MAX_TRIP_COUNT];
>  	int trip_count;
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 3de3e61..a02f2c9 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -30,10 +30,10 @@
>  #include <linux/mutex.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> -#include <linux/platform_data/exynos_thermal.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  #include "exynos_thermal_common.h"
> +#include "exynos_tmu.h"
>  
>  /* Exynos generic registers */
>  #define EXYNOS_TMU_REG_TRIMINFO		0x0
> diff --git a/include/linux/platform_data/exynos_thermal.h b/drivers/thermal/samsung/exynos_tmu.h
> similarity index 88%
> rename from include/linux/platform_data/exynos_thermal.h
> rename to drivers/thermal/samsung/exynos_tmu.h
> index da7e627..342fb1f 100644
> --- a/include/linux/platform_data/exynos_thermal.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -33,21 +33,6 @@ enum soc_type {
>  	SOC_ARCH_EXYNOS4210 = 1,
>  	SOC_ARCH_EXYNOS,
>  };
> -/**
> - * struct freq_clip_table
> - * @freq_clip_max: maximum frequency allowed for this cooling state.
> - * @temp_level: Temperature level at which the temperature clipping will
> - *	happen.
> - * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
> - *
> - * This structure is required to be filled and passed to the
> - * cpufreq_cooling_unregister function.
> - */
> -struct freq_clip_table {
> -	unsigned int freq_clip_max;
> -	unsigned int temp_level;
> -	const struct cpumask *mask_val;
> -};
>  
>  /**
>   * struct exynos_tmu_platform_data


