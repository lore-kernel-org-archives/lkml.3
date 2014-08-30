Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaH3Jtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 05:49:45 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60522 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaH3Jto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 05:49:44 -0400
Message-ID: <54019E36.4030304@kernel.org>
Date: Sat, 30 Aug 2014 10:49:42 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
CC: linux-iio@vger.kernel.org
Subject: Re: [PATCH 01/11] iio: sensors-core: st: Check st_sensors_set_drdy_int_pin()'s
 return value
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/14 14:14, Lee Jones wrote:
> Value from st_sensors_set_drdy_int_pin() is assigned to err here,
> but that stored value is not used before it is overwritten.  To fix
> this we're enforcing a check on st_sensors_set_drdy_int_pin()'s
> return value and if it's an error, we're returning right away.
> 
> Cc: jic23@kernel.org
> Cc: linux-iio@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied to the togreg branch of iio.git

Thanks,

Jonathan
> ---
>  drivers/iio/common/st_sensors/st_sensors_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
> index 8a4ec00..24cfe4e 100644
> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
> @@ -306,8 +306,11 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
>  	if (of_pdata)
>  		pdata = of_pdata;
>  
> -	if (pdata)
> +	if (pdata) {
>  		err = st_sensors_set_drdy_int_pin(indio_dev, pdata);
> +		if (err < 0)
> +			return err;
> +	}
>  
>  	err = st_sensors_set_enable(indio_dev, false);
>  	if (err < 0)
> 
