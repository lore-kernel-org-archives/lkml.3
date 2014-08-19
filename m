Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaHSNDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:03:42 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:48863 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaHSNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:03:39 -0400
Date: Tue, 19 Aug 2014 09:03:42 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v5 04/10] thermal: document struct
 thermal_zone_device and thermal_governor
Message-ID: <20140819130342.GA4628@developer>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
 <1405001928-12697-5-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405001928-12697-5-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:18:42PM +0100, Javi Merino wrote:
> Document struct thermal_zone_device and struct thermal_governor fields
> and their use by the thermal framework code.

I am getting mangled text in this email. For instance, checkpatch.pl
complains:
ERROR: patch seems to be corrupt (line wrapped?)
#61: FILE: include/linux/thermal.h:159:
=20

ERROR: spaces required around that '=' (ctx:ExV)
#110: FILE: include/linux/thermal.h:218:
+=09struct mutex lock;
 ^



> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  include/linux/thermal.h | 46 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7ea7d9..0305cde21a74 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -158,6 +158,42 @@ struct thermal_attr {
>  	char name[THERMAL_NAME_LENGTH];
>  };
>  
> +/**
> + * struct thermal_zone_device - structure for a thermal zone
> + * @id:		unique id number for each thermal zone
> + * @type:	the thermal zone device type
> + * @device:	&struct device for this thermal zone
> + * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
> + * @trip_type_attrs:	attributes for trip points for sysfs: trip type
> + * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> + * @devdata:	private pointer for device private data
> + * @trips:	number of trip points the thermal zone supports
> + * @passive_delay:	number of milliseconds to wait between polls when
> + *			performing passive cooling.  Currenty only used by the
> + *			step-wise governor
> + * @polling_delay:	number of milliseconds to wait between polls when
> + *			checking whether trip points have been crossed (0 for
> + *			interrupt driven systems)
> + * @temperature:	current temperature.  This is only for core code,
> + *			drivers should use thermal_zone_get_temp() to get the
> + *			current temperature
> + * @last_temperature:	previous temperature read
> + * @emul_temperature:	emulated temperature when using CONFIG_THERMAL_EMULATION
> + * @passive:		1 if you've crossed a passive trip point, 0 otherwise.
> + *			Currenty only used by the step-wise governor.
> + * @forced_passive:	If > 0, temperature at which to switch on all ACPI
> + *			processor cooling devices.  Currently only used by the
> + *			step-wise governor.
> + * @ops:	operations this &thermal_zone_device supports
> + * @tzp:	thermal zone parameters
> + * @governor:	pointer to the governor for this thermal zone
> + * @thermal_instances:	list of &struct thermal_instance of this thermal zone
> + * @idr:	&struct idr to generate unique id for this zone's cooling
> + *		devices
> + * @lock:	lock to protect thermal_instances list
> + * @node:	node in thermal_tz_list (in thermal_core.c)
> + * @poll_queue:	delayed work for polling
> + */
>  struct thermal_zone_device {
>  	int id;
>  	char type[THERMAL_NAME_LENGTH];
> @@ -179,12 +215,18 @@ struct thermal_zone_device {
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
> 1.9.1
> 
> 
