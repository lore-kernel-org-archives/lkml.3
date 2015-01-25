Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbbAYW7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:59:24 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51026 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbAYW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:59:22 -0500
Message-ID: <54C57548.8020706@kernel.org>
Date: Sun, 25 Jan 2015 22:59:20 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 02/10] iio: core: Introduce DISTANCE channel type
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com> <1421003416-27557-3-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1421003416-27557-3-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/15 19:10, Irina Tirdea wrote:
> Some devices export an estimation of the distance the user has covered
> since the last reset.
> 
> One of this devices is Freescale's MMA9553L
> (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> that computes the distance based on the stride length and step rate.
> 
> Introduce a new channel type DISTANCE to export these values.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Applied to the togreg branch of iio.git - pushed out
as testing for now.

> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 10 ++++++++++
>  drivers/iio/industrialio-core.c         |  1 +
>  include/linux/iio/types.h               |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 3311886..c627a9a 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -283,6 +283,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_peak_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_anglvel_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_energy_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_distance_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
> @@ -1059,6 +1060,15 @@ Description:
>  		device (e.g.: human activity sensors report energy burnt by the
>  		user). Units after application of scale are Joules.
>  
> +What:		/sys/.../iio:deviceX/in_distance_input
> +What:		/sys/.../iio:deviceX/in_distance_raw
> +KernelVersion:	3.20
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This attribute is used to read the distance covered by the user
> +		since the last reboot while activated. Units after application
> +		of scale are meters.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/store_eeprom
>  KernelVersion:	3.4.0
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 8d2c9ba..655755b 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -73,6 +73,7 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_ACTIVITY] = "activity",
>  	[IIO_STEPS] = "steps",
>  	[IIO_ENERGY] = "energy",
> +	[IIO_DISTANCE] = "distance",
>  };
>  
>  static const char * const iio_modifier_names[] = {
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 26b8a1c..a7de445 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -33,6 +33,7 @@ enum iio_chan_type {
>  	IIO_ACTIVITY,
>  	IIO_STEPS,
>  	IIO_ENERGY,
> +	IIO_DISTANCE,
>  };
>  
>  enum iio_modifier {
> 

