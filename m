Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaJDMxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 08:53:14 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58132 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaJDMxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 08:53:13 -0400
Message-ID: <542FEDB7.3050302@kernel.org>
Date: Sat, 04 Oct 2014 13:53:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: irina.tirdea@intel.com
Subject: Re: [RFC PATCH 4/8] iio: core: Introduce pedometer STEP counter modifier
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com> <1412257439-15683-5-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1412257439-15683-5-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/14 14:43, Daniel Baluta wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> One of the functionalities of a pedometer is a step counter.
> The step counter needs to be enabled and then it will count the steps
> in its hardware register. Whenever the applications need to check
> the step count, they will read the step counter register.
> 
> To support this functionality we need a steps attribute that
> will export the number of steps.
> 
> For more information on the pedometer requirements for Android see
> http://source.android.com/devices/sensors/composite_sensors.html#counter.
> 
> A device that has the pedometer functionality this interface needs to
> support is Freescale's MMA9553L:
> http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
I'm not keen on multiplexing different types of data onto a single activity type.
Steps is well enough defined on it's own to have it's own channel type.

in_steps_input would be fine by me.  I suppose steps might mean something else
though...

> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
>  drivers/iio/industrialio-core.c         | 1 +
>  include/linux/iio/types.h               | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 070346d..feacb45 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -949,6 +949,13 @@ Description:
>  		and the relevant _type attributes to establish the data storage
>  		format.
>  
> +What:		/sys/.../iio:deviceX/in_activity_steps_raw
> +KernelVersion:	3.17
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This attribute is used to read the number of steps taken by the user
> +		since the last reboot while activated.
> +
>  What:		/sys/.../iio:deviceX/in_anglvel_z_quadrature_correction_raw
>  KernelVersion:	2.6.38
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index e453ef9..935a8a1 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -96,6 +96,7 @@ static const char * const iio_modifier_names[] = {
>  	[IIO_MOD_JOGGING] = "jogging",
>  	[IIO_MOD_WALKING] = "walking",
>  	[IIO_MOD_STILL] = "still",
> +	[IIO_MOD_PED_STEPS] = "steps",
>  };
>  
>  /* relies on pairs of these shared then separate */
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 003638d..ae51780 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -65,6 +65,7 @@ enum iio_modifier {
>  	IIO_MOD_JOGGING,
>  	IIO_MOD_WALKING,
>  	IIO_MOD_STILL,
> +	IIO_MOD_PED_STEPS,
>  };
>  
>  enum iio_event_type {
> 
