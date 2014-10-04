Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaJDNAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:00:40 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58189 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaJDNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:00:39 -0400
Message-ID: <542FEF75.9010707@kernel.org>
Date: Sat, 04 Oct 2014 14:00:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: irina.tirdea@intel.com
Subject: Re: [RFC PATCH 2/8] iio: core: Introduce IIO_ACTIVITY channel
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com> <1412257439-15683-3-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1412257439-15683-3-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/14 14:43, Daniel Baluta wrote:
> This channel will be used for exposing information about
> some activity composite sensors including:
> 	* motion (running, jogging, walking, still).
> 	* step counter
> 	* step detector
> 
> This will offer an interface for Android composite sensors
> defined here:
> http://source.android.com/devices/sensors/composite_sensors.html
> 
> This sensors are supported by Freescale's MMA9553 device.
> http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
This interface is interesting.... As I state on later patches,
get the less fuzzy stuff (step counting) out of here into
it's own type.

I'd also merge this at least with the next patch as it has little meaning
without that...

> ---
>  drivers/iio/industrialio-core.c | 1 +
>  include/linux/iio/types.h       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index af3e76d..67e8561 100644
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
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 4a2af8a..d58769a 100644
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
> 
