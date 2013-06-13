Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3FMEyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:54:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:5866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3FMEyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:54:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,856,1363158000"; 
   d="scan'208";a="352659665"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
CC: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] thermal: consider emul_temperature while computing
 trend
Thread-Topic: [PATCH 1/1] thermal: consider emul_temperature while computing
 trend
Thread-Index: AQHOXLS6rG3cYdy7SUGERNmcCGTdpJkzKlQg
Date: Thu, 13 Jun 2013 04:54:01 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59CB35F7@BGSMSX101.gar.corp.intel.com>
References: <1369863420-21913-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1369863420-21913-1-git-send-email-eduardo.valentin@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Eduardo Valentin
> Sent: Thursday, May 30, 2013 3:07 AM
> To: Zhang, Rui
> Cc: Eduardo Valentin; Amit Daniel Kachhap; R, Durgadoss; linux-
> pm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/1] thermal: consider emul_temperature while computing
> trend
> 
> In case emulated temperature is in use, using the trend
> provided by driver layer can lead to bogus situation.
> In this case, debugger user would set a temperature value,
> but the trend would be from driver computation.
> 
> To avoid this situation, this patch changes the get_tz_trend()
> to consider the emulated temperature whenever that is in use.

Nice catch.
Sorry, I missed looking at it earlier. Just got woken up by Rui's reply
on this. The patch looks fine to me.

Thanks,
Durga
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Durgadoss R <durgadoss.r@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/thermal_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c
> index d755440..c00dc92 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -155,7 +155,8 @@ int get_tz_trend(struct thermal_zone_device *tz, int
> trip)
>  {
>  	enum thermal_trend trend;
> 
> -	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
> +	if (tz->emul_temperature || !tz->ops->get_trend ||
> +	    tz->ops->get_trend(tz, trip, &trend)) {
>  		if (tz->temperature > tz->last_temperature)
>  			trend = THERMAL_TREND_RAISING;
>  		else if (tz->temperature < tz->last_temperature)
> --
> 1.8.2.1.342.gfa7285d
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
