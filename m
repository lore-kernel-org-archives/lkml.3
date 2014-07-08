Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaGHPXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:23:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34990 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGHPXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:23:50 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Tue, 8 Jul 2014 16:23:46 +0100
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] thermal: document struct thermal_zone_device and
 thermal_governor
Message-ID: <20140708152346.GG2796@e104805>
References: <1403690412-10996-1-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
In-Reply-To: <1403690412-10996-1-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Jul 2014 15:23:47.0310 (UTC) FILETIME=[9CDC10E0:01CF9AC0]
X-MC-Unique: 114070816234816601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:00:12AM +0100, Javi Merino wrote:
> Document struct thermal_zone_device and struct thermal_governor fields
> and their use by the thermal framework code.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
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
> Changes since v1:
>   * Clarified that some parameters are currently only used by the
>     step-wise governor.
>   * Clarified that forced_passive operates on ACPI processor cooling
>     devices.
> 
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

I think I've addressed all the comments in the previous version, any
other objections?

