Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaEVTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:03:19 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:47023 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaEVTDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:03:18 -0400
Date: Thu, 22 May 2014 11:27:30 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Punit.Agrawal@arm.com, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH] thermal: document struct thermal_zone_device and
 thermal_governor
Message-ID: <20140522152730.GB5246@developer>
References: <1400238968-8816-1-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400238968-8816-1-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javi,

On Fri, May 16, 2014 at 12:16:08PM +0100, Javi Merino wrote:

> Document struct struct thermal_zone_device and struct thermal_governor
> fields and their use by the thermal framework code.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> 
> ---
> 
> Hi linux-pm,
> 
> I have some patches that add new fields to these structures but I
> don't have a good place to describe those fields as these structs are
> mostly undocumented so I thought I'd document them.
> 
> I'm unsure about some of the descriptions, specially for passive and
> forced_passive so please review them.
> 
>  include/linux/thermal.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7ea7d9..af928c667dba 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -158,6 +158,40 @@ struct thermal_attr {
>  	char name[THERMAL_NAME_LENGTH];
>  };
>  
> +/**
> + * struct thermal_zone_device - structure for a thermal zone
> + * @id:		unique id number for each thermal zone
> + * @type:	the thermal zone device type
> + * @device:	struct device for this thermal zone
> + * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
> + * @trip_type_attrs:	attributes for trip points for sysfs: trip type
> + * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> + * @devdata:	private pointer for device private data
> + * @trips:	number of trip points the thermal zone supports
> + * @passive_delay:	number of milliseconds to wait between polls when
> + *			performing passive cooling.  Only used by the step-wise

I don't think this parameter is specific to step-wise.

> + *			governor
> + * @polling_delay:	number of milliseconds to wait between polls when
> + *			checking whether trip points have been crossed (0 for
> + *			interrupt driven systems)
> + * @temperature:	current temperature.  This is only for core code,
> + *			drivers should use thermal_zone_get_temp() to get the
> + *			current temperature
> + * @last_temperature:	previous temperature read
> + * @emul_temperature:	emulated temperature when using CONFIG_THERMAL_EMULATION
> + * @passive:	step-wise specific parameter.  1 if you've crossed a passive
> + *		trip point, 0 otherwise

ditto.

> + * @forced_passive:	step-wise specific parameter.  If > 0, temperature at
> + *			which to switch on all cpufreq cooling devices.

ditto.

Also, governors are not aware of specific cooling devices. 


> + * @ops:	operations this thermal_zone_device supports
> + * @tzp:	thermal zone parameters
> + * @governor:	pointer to the governor for this thermal zone
> + * @thermal_instances:	list of struct thermal_instance of this thermal zone
> + * @idr:	struct idr to generate unique id for this zone's cooling devices
> + * @lock:	lock to protect thermal_instances list
> + * @node:	node in thermal_tz_list (in thermal_core.c)
> + * @poll_queue:	delayed work for polling
> + */
>  struct thermal_zone_device {
>  	int id;
>  	char type[THERMAL_NAME_LENGTH];
> @@ -179,12 +213,18 @@ struct thermal_zone_device {
>  	struct thermal_governor *governor;
>  	struct list_head thermal_instances;
>  	struct idr idr;
> -	struct mutex lock; /* protect thermal_instances list */
> +	struct mutex lock;
>  	struct list_head node;
>  	struct delayed_work poll_queue;
>  };
>  
> -/* Structure that holds thermal governor information */
> +/**
> + * struct thermal_governor - structure that holds thermal governor information
> + * @name:	name of the governor
> + * @throttle:	callback called for every trip point even if temperature is
> + *		below the trip point temperature
> + * @governor_list:	node in thermal_governor_list (in thermal_core.c)
> + */
>  struct thermal_governor {
>  	char name[THERMAL_NAME_LENGTH];
>  	int (*throttle)(struct thermal_zone_device *tz, int trip);
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
