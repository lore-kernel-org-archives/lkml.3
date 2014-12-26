Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaLZN2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 08:28:24 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45494 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaLZN2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 08:28:22 -0500
Message-ID: <549D6274.8030601@kernel.org>
Date: Fri, 26 Dec 2014 13:28:20 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH 3/8] iio: core: Introduce SPEED channel type
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com> <1419029879-12024-4-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1419029879-12024-4-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 22:57, Irina Tirdea wrote:
> Some devices export the current speed value of the user.
> 
> One of this devices is Freescale's MMA9553L
> (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> that computes the speed of the user based on the number of steps and
> stride length.
> 
> Introduce a new channel type SPEED to export these values.
> 
A fun question raised by this is whether we are going to end up with
both speed and velocity (depending on whether it is signed or not).
I suppose there isn't much to be done about that though and this looks fine
to me (as does the previous one).
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-iio |    9 +++++++++
>  drivers/iio/industrialio-core.c         |    1 +
>  include/linux/iio/types.h               |    1 +
>  3 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index a5c1dcc..07acef7 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -295,6 +295,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_tilt_comp_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_humidityrelative_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_speed_scale
>  KernelVersion:	2.6.35
>  Contact:	linux-iio@vger.kernel.org
>  Description:
> @@ -1146,6 +1147,14 @@ Description:
>  		present, output should be considered as processed with the
>  		unit in milliamps.
>  
> +What:		/sys/.../iio:deviceX/in_speed_input
> +What:		/sys/.../iio:deviceX/in_speed_raw
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This attribute is used to read the current speed value of the user.
> +		Units after application of scale are m/s.
> +
>  What:		/sys/.../iio:deviceX/in_steps_en
>  KernelVersion:	3.19
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 4a10d31..5e50aca 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -74,6 +74,7 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_STEPS] = "steps",
>  	[IIO_CALORIES] = "calories",
>  	[IIO_DISTANCE] = "distance",
> +	[IIO_SPEED] = "speed",
>  };
>  
>  static const char * const iio_modifier_names[] = {
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index b98f751..c848f45 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -34,6 +34,7 @@ enum iio_chan_type {
>  	IIO_STEPS,
>  	IIO_CALORIES,
>  	IIO_DISTANCE,
> +	IIO_SPEED,
>  };
>  
>  enum iio_modifier {
> 

