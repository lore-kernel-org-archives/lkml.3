Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966624Ab3DQPJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:09:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:64516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966486Ab3DQPJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,492,1363158000"; 
   d="scan'208";a="296335666"
Message-ID: <1366211375.2091.52.camel@rzhang1-mobl4>
Subject: Re: [PATCH RESEND 04/11] thermal: rename get_thermal_instance to
 thermal_instance_get
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 23:09:35 +0800
In-Reply-To: <1365437258-31412-5-git-send-email-eduardo.valentin@ti.com>
References: <1365437258-31412-1-git-send-email-eduardo.valentin@ti.com>
	 <1365437258-31412-5-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 12:07 -0400, Eduardo Valentin wrote:
> To follow the prefix names used by the thermal exported functions,
> this patch renames get_thermal_instance to thermal_instance_get.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

NACK.

with the change of building all thermal governors into thermal_sys
module, get_thermal_instance becomes an internally helper function,
rather than external API.
thus I think it is okay to use the current name get_thermal_instance.
But you remind me a need a cleanup patch to remove these APIs. :)

thanks,
rui
> ---
>  Documentation/thermal/sysfs-api.txt |    2 +-
>  drivers/thermal/fair_share.c        |    2 +-
>  drivers/thermal/thermal_sys.c       |    4 ++--
>  include/linux/thermal.h             |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
> index 4b23190..059b3bf 100644
> --- a/Documentation/thermal/sysfs-api.txt
> +++ b/Documentation/thermal/sysfs-api.txt
> @@ -358,7 +358,7 @@ are supposed to implement the callback. If they don't, the thermal
>  framework calculated the trend by comparing the previous and the current
>  temperature values.
>  
> -5.2:get_thermal_instance:
> +5.2:thermal_instance_get:
>  This function returns the thermal_instance corresponding to a given
>  {thermal_zone, cooling_device, trip_point} combination. Returns NULL
>  if such an instance does not exist.
> diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
> index 792479f..f629446 100644
> --- a/drivers/thermal/fair_share.c
> +++ b/drivers/thermal/fair_share.c
> @@ -95,7 +95,7 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
>  			continue;
>  
>  		cdev = tzp->tbp[i].cdev;
> -		instance = get_thermal_instance(tz, cdev, trip);
> +		instance = thermal_instance_get(tz, cdev, trip);
>  		if (!instance)
>  			continue;
>  
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index ffaf6d3..44e89c0 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -170,7 +170,7 @@ int get_tz_trend(struct thermal_zone_device *tz, int trip)
>  }
>  EXPORT_SYMBOL(get_tz_trend);
>  
> -struct thermal_instance *get_thermal_instance(struct thermal_zone_device *tz,
> +struct thermal_instance *thermal_instance_get(struct thermal_zone_device *tz,
>  			struct thermal_cooling_device *cdev, int trip)
>  {
>  	struct thermal_instance *pos = NULL;
> @@ -191,7 +191,7 @@ struct thermal_instance *get_thermal_instance(struct thermal_zone_device *tz,
>  
>  	return target_instance;
>  }
> -EXPORT_SYMBOL(get_thermal_instance);
> +EXPORT_SYMBOL(thermal_instance_get);
>  
>  static void print_bind_err_msg(struct thermal_zone_device *tz,
>  			struct thermal_cooling_device *cdev, int ret)
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index e8ec9d8..e2a49e1 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -239,7 +239,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
>  void thermal_cooling_device_unregister(struct thermal_cooling_device *);
>  
>  int get_tz_trend(struct thermal_zone_device *, int);
> -struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
> +struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,
>  		struct thermal_cooling_device *, int);
>  void thermal_cdev_update(struct thermal_cooling_device *);
>  void thermal_notify_framework(struct thermal_zone_device *, int);


