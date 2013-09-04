Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385Ab3IDUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:16:17 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:39772 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850Ab3IDUQP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:16:15 -0400
From: Denis CIOCCA <denis.ciocca@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Date: Wed, 4 Sep 2013 22:15:45 +0200
Subject: Re: [PATCH 06/11] iio: pressure-core: st: Expand and rename
 LPS331AP's channel descriptor
Thread-Topic: [PATCH 06/11] iio: pressure-core: st: Expand and rename
 LPS331AP's channel descriptor
Thread-Index: Ac6pq4sPVtUU1mzlRTiNsxLyGlSfvQ==
Message-ID: <522794F1.90301@st.com>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378287103-21765-7-git-send-email-lee.jones@linaro.org>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
acceptlanguage: it-IT, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Due to the MACRO used, the task of reading, understanding and maintaining
> the LPS331AP's channel descriptor is substantially difficult. This patch
> is based on the view that it's better to have easy to read, maintainable
> code than to save a few lines here and there. For that reason we're
> expanding the array so initialisation is completed in full.
Also for this one, the channel names are general and can be shared 
between different sensors. For the channel definition it's not a problem 
for me, but I think it's not necessary adds all that code...

Denis

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/iio/pressure/st_pressure_core.c | 45 +++++++++++++++++++++++++--------
>   1 file changed, 34 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index becfb25..7ba9299 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -58,16 +58,39 @@
>   #define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
>   #define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
>   
> -static const struct iio_chan_spec st_press_channels[] = {
> -	ST_SENSORS_LSM_CHANNELS(IIO_PRESSURE,
> +static const struct iio_chan_spec st_press_lsp331ap_channels[] = {
> +	{
> +		.type = IIO_PRESSURE,
> +		.channel2 = IIO_NO_MOD,
> +		.address = ST_PRESS_LPS331AP_OUT_XL_ADDR,
> +		.scan_index = ST_SENSORS_SCAN_X,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 24,
> +			.storagebits = 24,
> +			.endianness = IIO_LE,
> +		},
> +		.info_mask_separate =
>   			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
> -			ST_SENSORS_SCAN_X, 0, IIO_NO_MOD, 'u', IIO_LE, 24, 24,
> -			ST_PRESS_LPS331AP_OUT_XL_ADDR),
> -	ST_SENSORS_LSM_CHANNELS(IIO_TEMP,
> -			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE) |
> -						BIT(IIO_CHAN_INFO_OFFSET),
> -			-1, 0, IIO_NO_MOD, 's', IIO_LE, 16, 16,
> -			ST_TEMP_LPS331AP_OUT_L_ADDR),
> +		.modified = 0,
> +	},
> +	{
> +		.type = IIO_TEMP,
> +		.channel2 = IIO_NO_MOD,
> +		.address = ST_TEMP_LPS331AP_OUT_L_ADDR,
> +		.scan_index = -1,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 16,
> +			.storagebits = 16,
> +			.endianness = IIO_LE,
> +		},
> +		.info_mask_separate =
> +			BIT(IIO_CHAN_INFO_RAW) |
> +			BIT(IIO_CHAN_INFO_SCALE) |
> +			BIT(IIO_CHAN_INFO_OFFSET),
> +		.modified = 0,
> +	},
>   	IIO_CHAN_SOFT_TIMESTAMP(1)
>   };
>   
> @@ -77,7 +100,7 @@ static const struct st_sensors st_press_sensors[] = {
>   		.sensors_supported = {
>   			[0] = LPS331AP_PRESS_DEV_NAME,
>   		},
> -		.ch = (struct iio_chan_spec *)st_press_channels,
> +		.ch = (struct iio_chan_spec *)st_press_lsp331ap_channels,
>   		.odr = {
>   			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
>   			.mask = ST_PRESS_LPS331AP_ODR_MASK,
> @@ -214,7 +237,7 @@ int st_press_common_probe(struct iio_dev *indio_dev)
>   	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
>   	pdata->multiread_bit = pdata->sensor->multi_read_bit;
>   	indio_dev->channels = pdata->sensor->ch;
> -	indio_dev->num_channels = ARRAY_SIZE(st_press_channels);
> +	indio_dev->num_channels = ARRAY_SIZE(st_press_lsp331ap_channels);
>   
>   	pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
>   						&pdata->sensor->fs.fs_avl[0];
