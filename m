Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3IULvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 07:51:42 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57294 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3IULvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 07:51:40 -0400
Message-ID: <523D9670.5090107@kernel.org>
Date: Sat, 21 Sep 2013 13:52:00 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 13/20] iio: sensors-core: st: Clean-up error handling
 in st_sensors_read_axis_data()
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org> <1379347346-823-14-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1379347346-823-14-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 17:02, Lee Jones wrote:
> Gets rid of those unnecessary gotos.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied to the togreg branch of iio.git

Thanks Lee.
> ---
>  drivers/iio/common/st_sensors/st_sensors_core.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
> index c5fbe58..76e573b 100644
> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
> @@ -331,10 +331,8 @@ static int st_sensors_read_axis_data(struct iio_dev *indio_dev,
>  	unsigned int byte_for_channel = ch->scan_type.storagebits >> 3;
>  
>  	outdata = kmalloc(byte_for_channel, GFP_KERNEL);
> -	if (!outdata) {
> -		err = -EINVAL;
> -		goto st_sensors_read_axis_data_error;
> -	}
> +	if (!outdata)
> +		return -ENOMEM;
>  
>  	err = sdata->tf->read_multiple_byte(&sdata->tb, sdata->dev,
>  				ch->address, byte_for_channel,
> @@ -349,7 +347,7 @@ static int st_sensors_read_axis_data(struct iio_dev *indio_dev,
>  
>  st_sensors_free_memory:
>  	kfree(outdata);
> -st_sensors_read_axis_data_error:
> +
>  	return err;
>  }
>  
> 
