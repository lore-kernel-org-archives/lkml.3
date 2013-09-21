Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3IULvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 07:51:32 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57286 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3IULvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 07:51:23 -0400
Message-ID: <523D965F.2040606@kernel.org>
Date: Sat, 21 Sep 2013 13:51:43 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 12/20] iio: sensors-core: st: Clean-up error handling
 in st_sensors_init_sensor()
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org> <1379347346-823-13-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1379347346-823-13-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 17:02, Lee Jones wrote:
> Strip out all those unnecessary gotos and just return the error right away.
> 
> Aids to simplicity and reduces code.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied to the togreg branch of iio.git

Thanks
> ---
>  drivers/iio/common/st_sensors/st_sensors_core.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
> index 2672630..c5fbe58 100644
> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
> @@ -241,29 +241,28 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
>  
>  	err = st_sensors_set_enable(indio_dev, false);
>  	if (err < 0)
> -		goto init_error;
> +		return err;
>  
>  	if (sdata->current_fullscale) {
>  		err = st_sensors_set_fullscale(indio_dev,
>  					       sdata->current_fullscale->num);
>  		if (err < 0)
> -			goto init_error;
> +			return err;
>  	} else
>  		dev_info(&indio_dev->dev, "Full-scale not possible\n");
>  
>  	err = st_sensors_set_odr(indio_dev, sdata->odr);
>  	if (err < 0)
> -		goto init_error;
> +		return err;
>  
>  	/* set BDU */
>  	err = st_sensors_write_data_with_mask(indio_dev,
>  			sdata->sensor->bdu.addr, sdata->sensor->bdu.mask, true);
>  	if (err < 0)
> -		goto init_error;
> +		return err;
>  
>  	err = st_sensors_set_axis_enable(indio_dev, ST_SENSORS_ENABLE_ALL_AXIS);
>  
> -init_error:
>  	return err;
>  }
>  EXPORT_SYMBOL(st_sensors_init_sensor);
> 
