Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab3BSPue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:50:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:53836 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab3BSPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:50:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="264592779"
Message-ID: <1361289021.2323.33.camel@rzhang1-mobl4>
Subject: Re: [PATCH V3 2/2] thermal: exynos: Use the new thermal trend type
 for quick cooling action.
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, jonghwa3.lee@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Date: Tue, 19 Feb 2013 23:50:21 +0800
In-Reply-To: <1360285987-13921-2-git-send-email-amit.daniel@samsung.com>
References: <1360285987-13921-1-git-send-email-amit.daniel@samsung.com>
	 <1360285987-13921-2-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 17:13 -0800, Amit Daniel Kachhap wrote:
> This patch uses the quick thermal cooling trend type macros. This is needed
> as exynos5 and other thermal sensors now supports only interrupt method for
> thresold temperature check.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

applied to thermal -next.

thanks,
rui
> ---
> 
> Hi,
> 
> Submitting these patches again as they got lost somewhere and was not merged.
> 
> Changes since V2:
> * Rebased against Rui Zhang next tree.
> * Added Kukjin Kim acked by.
> 
> All these patches are based on thermal maintainer next branch.
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git thermal
> 
>  drivers/thermal/exynos_thermal.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index 65f69cf..030bba3 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -296,7 +296,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
>  		case MONITOR_ZONE:
>  		case WARN_ZONE:
>  			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
> -								level, level)) {
> +								level, 0)) {
>  				pr_err("error binding cdev inst %d\n", i);
>  				ret = -EINVAL;
>  			}
> @@ -399,9 +399,9 @@ static int exynos_get_trend(struct thermal_zone_device *thermal,
>  		return ret;
>  
>  	if (thermal->temperature >= trip_temp)
> -		*trend = THERMAL_TREND_RAISING;
> +		*trend = THERMAL_TREND_RAISE_FULL;
>  	else
> -		*trend = THERMAL_TREND_DROPPING;
> +		*trend = THERMAL_TREND_DROP_FULL;
>  
>  	return 0;
>  }


