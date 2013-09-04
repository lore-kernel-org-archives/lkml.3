Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076Ab3IDUSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:18:21 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:36588 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042Ab3IDUSU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:18:20 -0400
From: Denis CIOCCA <denis.ciocca@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Date: Wed, 4 Sep 2013 22:17:50 +0200
Subject: Re: [PATCH 08/11] iio: pressure-core: st: Allow for number of
 channels to vary
Thread-Topic: [PATCH 08/11] iio: pressure-core: st: Allow for number of
 channels to vary
Thread-Index: Ac6pq9UXKgjqy/+4QLO/NiSZaTLYWg==
Message-ID: <5227956E.2050607@st.com>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-9-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378287103-21765-9-git-send-email-lee.jones@linaro.org>
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

Acked-by: Denis Ciocca <denis.ciocca@st.com>
> At the moment the number of channels specified is dictated by the first
> sensor supported by the driver. As we add support for more sensors this
> is likely to vary. Instead of using the ARRAY_SIZE() of the LPS331AP's
> channel specifier we'll use a new adaptable 'struct st_sensors' element
> instead.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/iio/pressure/st_pressure_core.c | 3 ++-
>   include/linux/iio/common/st_sensors.h   | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index 423ed6a..3cf54ed 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -101,6 +101,7 @@ static const struct st_sensors st_press_sensors[] = {
>   			[0] = LPS331AP_PRESS_DEV_NAME,
>   		},
>   		.ch = (struct iio_chan_spec *)st_press_lsp331ap_channels,
> +		.num_ch = ARRAY_SIZE(st_press_lsp331ap_channels),
>   		.odr = {
>   			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
>   			.mask = ST_PRESS_LPS331AP_ODR_MASK,
> @@ -237,7 +238,7 @@ int st_press_common_probe(struct iio_dev *indio_dev)
>   	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
>   	pdata->multiread_bit = pdata->sensor->multi_read_bit;
>   	indio_dev->channels = pdata->sensor->ch;
> -	indio_dev->num_channels = ARRAY_SIZE(st_press_lsp331ap_channels);
> +	indio_dev->num_channels = pdata->sensor->num_ch;
>   
>   	if (pdata->sensor->fs.addr != 0)
>   		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
> diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
> index 72b2694..4aef925 100644
> --- a/include/linux/iio/common/st_sensors.h
> +++ b/include/linux/iio/common/st_sensors.h
> @@ -180,6 +180,7 @@ struct st_sensors {
>   	u8 wai;
>   	char sensors_supported[ST_SENSORS_MAX_4WAI][ST_SENSORS_MAX_NAME];
>   	struct iio_chan_spec *ch;
> +	int num_ch;
>   	struct st_sensor_odr odr;
>   	struct st_sensor_power pw;
>   	struct st_sensor_axis enable_axis;
