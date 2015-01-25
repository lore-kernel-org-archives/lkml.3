Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbbAYXBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 18:01:50 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51052 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbbAYXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 18:01:49 -0500
Message-ID: <54C575DB.9050802@kernel.org>
Date: Sun, 25 Jan 2015 23:01:47 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 04/10] iio: core: Introduce IO_CHAN_INFO_CALIBWEIGHT
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com> <1421003416-27557-5-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1421003416-27557-5-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/15 19:10, Irina Tirdea wrote:
> Some devices need the weight of the user to compute other
> parameters. One of this devices is Freescale's MMA9553L
> (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> that needs the weight of the user to compute the number of calories burnt.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Applied with trivial typo fix to patch title...
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
>  drivers/iio/industrialio-core.c         | 1 +
>  include/linux/iio/iio.h                 | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 80b5efb1..71dc8db 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -351,6 +351,13 @@ Description:
>  		to compute the stride length, distance, speed and activity
>  		type.
>  
> +What:		/sys/bus/iio/devices/iio:deviceX/in_energy_calibweight
> +KernelVersion:	3.20
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Weight of the user (in kg). It is needed by some pedometers
> +		to compute the calories burnt by the user.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale_available
>  What:		/sys/.../iio:deviceX/in_voltageX_scale_available
>  What:		/sys/.../iio:deviceX/in_voltage-voltage_scale_available
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 18a8ab9..4ee6fdf 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -125,6 +125,7 @@ static const char * const iio_chan_info_postfix[] = {
>  	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
>  	[IIO_CHAN_INFO_ENABLE] = "en",
>  	[IIO_CHAN_INFO_CALIBHEIGHT] = "calibheight",
> +	[IIO_CHAN_INFO_CALIBWEIGHT] = "calibweight",
>  };
>  
>  /**
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index 878d861..752a929 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -40,6 +40,7 @@ enum iio_chan_info_enum {
>  	IIO_CHAN_INFO_INT_TIME,
>  	IIO_CHAN_INFO_ENABLE,
>  	IIO_CHAN_INFO_CALIBHEIGHT,
> +	IIO_CHAN_INFO_CALIBWEIGHT,
>  };
>  
>  enum iio_shared_by {
> 

