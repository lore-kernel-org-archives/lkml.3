Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3INQRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:17:54 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42936 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3INQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:17:53 -0400
Message-ID: <52349A4E.10401@kernel.org>
Date: Sat, 14 Sep 2013 18:18:06 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 25/38] iio: pressure-core: st: Allow for number of channels
 to vary
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-26-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378817379-8238-26-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 13:49, Lee Jones wrote:
> At the moment the number of channels specified is dictated by the first
> sensor supported by the driver. As we add support for more sensors this
> is likely to vary. Instead of using the ARRAY_SIZE() of the LPS331AP's
> channel specifier we'll use a new adaptable 'struct st_sensors' element
> instead.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied with Denis ack (again it should have been here)
> ---
>  drivers/iio/pressure/st_pressure_core.c | 3 ++-
>  include/linux/iio/common/st_sensors.h   | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index 60c2ee4..3abada2 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -107,6 +107,7 @@ static const struct st_sensors st_press_sensors[] = {
>  			[0] = LPS331AP_PRESS_DEV_NAME,
>  		},
>  		.ch = (struct iio_chan_spec *)st_press_lps331ap_channels,
> +		.num_ch = ARRAY_SIZE(st_press_lps331ap_channels),
>  		.odr = {
>  			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
>  			.mask = ST_PRESS_LPS331AP_ODR_MASK,
> @@ -245,7 +246,7 @@ int st_press_common_probe(struct iio_dev *indio_dev,
>  	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
>  	pdata->multiread_bit = pdata->sensor->multi_read_bit;
>  	indio_dev->channels = pdata->sensor->ch;
> -	indio_dev->num_channels = ARRAY_SIZE(st_press_lps331ap_channels);
> +	indio_dev->num_channels = pdata->sensor->num_ch;
>  
>  	if (pdata->sensor->fs.addr != 0)
>  		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
> diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
> index e51f654..e732fda 100644
> --- a/include/linux/iio/common/st_sensors.h
> +++ b/include/linux/iio/common/st_sensors.h
> @@ -184,6 +184,7 @@ struct st_sensors {
>  	u8 wai;
>  	char sensors_supported[ST_SENSORS_MAX_4WAI][ST_SENSORS_MAX_NAME];
>  	struct iio_chan_spec *ch;
> +	int num_ch;
>  	struct st_sensor_odr odr;
>  	struct st_sensor_power pw;
>  	struct st_sensor_axis enable_axis;
> 
