Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbaJaVxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:53:01 -0400
Received: from mout.gmx.net ([212.227.17.20]:59165 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaJaVw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:52:58 -0400
Message-ID: <545404B3.7000304@gmx.de>
Date: Fri, 31 Oct 2014 22:52:51 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, irina.tirdea@intel.com
Subject: Re: [PATCH v3 2/7] iio: core: Introduce IIO_ACTIVITY channel
References: <1414491571-11672-1-git-send-email-daniel.baluta@intel.com> <1414491571-11672-3-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1414491571-11672-3-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:umUnDutFF0dhvFYLIIs5TI3u9npezjH5HYA6wxlMHeSd0dWeXjd
 a+sYifn79yIH6nuM1DCyD3+5IgXKed8JkfHOktlGrOQSZmMt2WF9LAzAwRb0FeIDIPcdeTi
 O08UynZcTI+2tWt5Jyb7pbRtlxVFnJQY5UJXHLpjmTTQmh9HVBHREK4egrX+sYoBQYTL7gG
 ujwhVdev448BUBAHzzcXQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some typos left, maybe Jonathan can take care of them, if there are no issues for having a V4.
Daniel Baluta schrieb am 28.10.2014 11:19:
> This channel will be used for exposing information about
> activity composite sensors. Activities supported so far:
> 	* running
> 	* jogging
> 	* walking
> 	* still
> 
> THRESHOLD event is used to signal a change in the activity
> state.
> 
> We associate a confidence interval for each activity expressed
> as a percentage from 0 to 100.
>   * 0, means the sensor IS NOT reporting that activity.
>   * 100, means the sensor IS reporting that activity.
> 
> Users of this interface have two possibile means to gather
Typo: possible
> information about the ongoing activities.
> 
> 1. Event based, via event file descriptor
>   * sensor may report an event when ENTERING an activity or LEAVING
>     an activity based on a threshold value.
>   * drivers will wake up applications waiting data on the event fd
> 
> 2. Polling, by reading the sysfs associated attribute files:
>   * /sys/bus/iio/devices/iio:device0/in_activity_running_input
> expressed as percentage confidence value from 0 to 100.
> 
> This will offer an interface for Android significant motion
> composite sensor defined here:
> http://source.android.com/devices/sensors/composite_sensors.html
> 
> Activities listed above are supported by Freescale's MMA9553 sensor:
> http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 44 +++++++++++++++++++++++++++++++++
>  drivers/iio/industrialio-core.c         |  5 ++++
>  include/linux/iio/types.h               |  7 +++++-
>  3 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 5a7fc66..c3a1fd3 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -783,6 +783,40 @@ Description:
>  		met before an event is generated. If direction is not
>  		specified then this period applies to both directions.
>  
> +What:		/sys/.../events/in_activity_still_thresh_rising_en
> +What:		/sys/.../events/in_activity_still_thresh_falling_en
> +What:		/sys/.../events/in_activity_walking_thresh_rising_en
> +What:		/sys/.../events/in_activity_walking_thresh_falling_en
> +What:		/sys/.../events/in_activity_jogging_thresh_rising_en
> +What:		/sys/.../events/in_activity_jogging_thresh_falling_en
> +What:		/sys/.../events/in_activity_running_thresh_rising_en
> +What:		/sys/.../events/in_activity_running_thresh_falling_en
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Enables or disables activitity events. Depending on direction
> +		an event is generated when sensor ENTERS or LEAVES a given state.
> +
> +What:		/sys/.../events/in_activity_still_thresh_rising_value
> +What:		/sys/.../events/in_activity_still_thresh_falling_value
> +What:		/sys/.../events/in_activity_walking_thresh_rising_value
> +What:		/sys/.../events/in_activity_walking_thresh_falling_value
> +What:		/sys/.../events/in_activity_jogging_thresh_rising_value
> +What:		/sys/.../events/in_activity_jogging_thresh_falling_value
> +What:		/sys/.../events/in_activity_running_thresh_rising_value
> +What:		/sys/.../events/in_activity_running_thresh_falling_value
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Confidence value (in units as percentage) to be used
> +		for deciding when an event should be generated. E.g for
> +		running: If the confidence value reported by the sensor
> +		is greater then in_activity_running_thresh_rising_value
Typo: greater than
> +		then the sensor ENTERS running state. Conversely, if the
> +		confidence value reported by the sensor is lower than
> +		in_activity_running_thresh_falling_value then the sensor
> +		is LEAVING running state.
> +
>  What:		/sys/.../iio:deviceX/events/in_accel_mag_en
>  What:		/sys/.../iio:deviceX/events/in_accel_mag_rising_en
>  What:		/sys/.../iio:deviceX/events/in_accel_mag_falling_en
> @@ -949,6 +983,16 @@ Description:
>  		and the relevant _type attributes to establish the data storage
>  		format.
>  
> +What:		/sys/.../iio:deviceX/in_activity_still_input
> +What:		/sys/.../iio:deviceX/in_activity_walking_input
> +What:		/sys/.../iio:deviceX/in_activity_jogging_input
> +What:		/sys/.../iio:deviceX/in_activity_running_input
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This attribute is used to read the confidence for an activity
> +		expressed in units as percentage.
> +
>  What:		/sys/.../iio:deviceX/in_anglvel_z_quadrature_correction_raw
>  KernelVersion:	2.6.38
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index af3e76d..e453ef9 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -70,6 +70,7 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_CCT] = "cct",
>  	[IIO_PRESSURE] = "pressure",
>  	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
> +	[IIO_ACTIVITY] = "activity",
>  };
>  
>  static const char * const iio_modifier_names[] = {
> @@ -91,6 +92,10 @@ static const char * const iio_modifier_names[] = {
>  	[IIO_MOD_NORTH_TRUE] = "from_north_true",
>  	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
>  	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
> +	[IIO_MOD_RUNNING] = "running",
> +	[IIO_MOD_JOGGING] = "jogging",
> +	[IIO_MOD_WALKING] = "walking",
> +	[IIO_MOD_STILL] = "still",
>  };
>  
>  /* relies on pairs of these shared then separate */
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 4a2af8a..b3a241d 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -30,6 +30,7 @@ enum iio_chan_type {
>  	IIO_CCT,
>  	IIO_PRESSURE,
>  	IIO_HUMIDITYRELATIVE,
> +	IIO_ACTIVITY,
>  };
>  
>  enum iio_modifier {
> @@ -59,7 +60,11 @@ enum iio_modifier {
>  	IIO_MOD_NORTH_MAGN,
>  	IIO_MOD_NORTH_TRUE,
>  	IIO_MOD_NORTH_MAGN_TILT_COMP,
> -	IIO_MOD_NORTH_TRUE_TILT_COMP
> +	IIO_MOD_NORTH_TRUE_TILT_COMP,
> +	IIO_MOD_RUNNING,
> +	IIO_MOD_JOGGING,
> +	IIO_MOD_WALKING,
> +	IIO_MOD_STILL,
>  };
>  
>  enum iio_event_type {
> 

