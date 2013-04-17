Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966816Ab3DQPhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:37:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:30096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964924Ab3DQPhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:37:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,494,1363158000"; 
   d="scan'208";a="296380813"
Message-ID: <1366213041.2091.68.camel@rzhang1-mobl4>
Subject: Re: [PATCH RESEND 03/11] thermal: rename notify_thermal_framework
 to thermal_notify_framework
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 23:37:21 +0800
In-Reply-To: <1365437258-31412-4-git-send-email-eduardo.valentin@ti.com>
References: <1365437258-31412-1-git-send-email-eduardo.valentin@ti.com>
	 <1365437258-31412-4-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 12:07 -0400, Eduardo Valentin wrote:
> To follow the prefix names used by the thermal exported functions,
> this patch renames notify_thermal_framework to thermal_notify_framework.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Hmm, I'm okay with this one.

thanks,
rui
> ---
>  Documentation/thermal/sysfs-api.txt |    2 +-
>  drivers/thermal/thermal_sys.c       |    6 +++---
>  include/linux/thermal.h             |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
> index 6859661..4b23190 100644
> --- a/Documentation/thermal/sysfs-api.txt
> +++ b/Documentation/thermal/sysfs-api.txt
> @@ -363,7 +363,7 @@ This function returns the thermal_instance corresponding to a given
>  {thermal_zone, cooling_device, trip_point} combination. Returns NULL
>  if such an instance does not exist.
>  
> -5.3:notify_thermal_framework:
> +5.3:thermal_notify_framework:
>  This function handles the trip events from sensor drivers. It starts
>  throttling the cooling devices according to the policy configured.
>  For CRITICAL and HOT trip points, this notifies the respective drivers,
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 9542600..ffaf6d3 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1420,7 +1420,7 @@ void thermal_cdev_update(struct thermal_cooling_device *cdev)
>  EXPORT_SYMBOL(thermal_cdev_update);
>  
>  /**
> - * notify_thermal_framework - Sensor drivers use this API to notify framework
> + * thermal_notify_framework - Sensor drivers use this API to notify framework
>   * @tz:		thermal zone device
>   * @trip:	indicates which trip point has been crossed
>   *
> @@ -1431,11 +1431,11 @@ EXPORT_SYMBOL(thermal_cdev_update);
>   * The throttling policy is based on the configured platform data; if no
>   * platform data is provided, this uses the step_wise throttling policy.
>   */
> -void notify_thermal_framework(struct thermal_zone_device *tz, int trip)
> +void thermal_notify_framework(struct thermal_zone_device *tz, int trip)
>  {
>  	handle_thermal_trip(tz, trip);
>  }
> -EXPORT_SYMBOL(notify_thermal_framework);
> +EXPORT_SYMBOL(thermal_notify_framework);
>  
>  /**
>   * create_trip_attrs - create attributes for trip points
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f0bd7f9..e8ec9d8 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -242,7 +242,7 @@ int get_tz_trend(struct thermal_zone_device *, int);
>  struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
>  		struct thermal_cooling_device *, int);
>  void thermal_cdev_update(struct thermal_cooling_device *);
> -void notify_thermal_framework(struct thermal_zone_device *, int);
> +void thermal_notify_framework(struct thermal_zone_device *, int);
>  
>  int thermal_register_governor(struct thermal_governor *);
>  void thermal_unregister_governor(struct thermal_governor *);


