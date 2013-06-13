Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3FMCbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:31:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:22406 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab3FMCbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:31:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="scan'208";a="254293544"
Message-ID: <1371090701.2135.14.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/1] thermal: consider emul_temperature while computing
 trend
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Durgadoss R <durgadoss.r@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Jun 2013 10:31:41 +0800
In-Reply-To: <1369863420-21913-1-git-send-email-eduardo.valentin@ti.com>
References: <1369863420-21913-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 17:37 -0400, Eduardo Valentin wrote:
> In case emulated temperature is in use, using the trend
> provided by driver layer can lead to bogus situation.
> In this case, debugger user would set a temperature value,
> but the trend would be from driver computation.
> 
> To avoid this situation, this patch changes the get_tz_trend()
> to consider the emulated temperature whenever that is in use.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Durgadoss R <durgadoss.r@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

patch applied.

thanks,
rui
> ---
>  drivers/thermal/thermal_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index d755440..c00dc92 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -155,7 +155,8 @@ int get_tz_trend(struct thermal_zone_device *tz, int trip)
>  {
>  	enum thermal_trend trend;
>  
> -	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
> +	if (tz->emul_temperature || !tz->ops->get_trend ||
> +	    tz->ops->get_trend(tz, trip, &trend)) {
>  		if (tz->temperature > tz->last_temperature)
>  			trend = THERMAL_TREND_RAISING;
>  		else if (tz->temperature < tz->last_temperature)


