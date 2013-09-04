Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab3IDUlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:41:17 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:52763 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670Ab3IDUlP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:41:15 -0400
X-Greylist: delayed 1807 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 16:41:14 EDT
From: Denis CIOCCA <denis.ciocca@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Date: Wed, 4 Sep 2013 22:10:17 +0200
Subject: Re: [PATCH 05/11] iio: pressure-core: st: Describe LPS331AP defines
 by name
Thread-Topic: [PATCH 05/11] iio: pressure-core: st: Describe LPS331AP
 defines by name
Thread-Index: Ac6pqsdOFwPpYNCvSKG8ikqmA0GN8A==
Message-ID: <522793A9.8040300@st.com>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378287103-21765-6-git-send-email-lee.jones@linaro.org>
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

Hi Lee,
> They're currently named *_1_*, for 'Sensor 1', but the code will be much
> more readable if we use the naming convention *_LPS331AP_* instead.
You are right, but the reason is to maintain the same structure of the 
other sensors drivers (like accel, gyro and magn). Often some sensors 
can use the same data and using 1,2,... I think it's more general.

Denis

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/iio/pressure/st_pressure_core.c | 90 ++++++++++++++++-----------------
>   1 file changed, 44 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index 9c343b4..becfb25 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -31,92 +31,90 @@
>   #define ST_PRESS_MBAR_TO_KPASCAL(x)		(x * 10)
>   #define ST_PRESS_NUMBER_DATA_CHANNELS		1
>   
> -/* DEFAULT VALUE FOR SENSORS */
> -#define ST_PRESS_DEFAULT_OUT_XL_ADDR		0x28
> -#define ST_TEMP_DEFAULT_OUT_L_ADDR		0x2b
> -
>   /* FULLSCALE */
>   #define ST_PRESS_FS_AVL_1260MB			1260
>   
> -/* CUSTOM VALUES FOR SENSOR 1 */
> -#define ST_PRESS_1_WAI_EXP			0xbb
> -#define ST_PRESS_1_ODR_ADDR			0x20
> -#define ST_PRESS_1_ODR_MASK			0x70
> -#define ST_PRESS_1_ODR_AVL_1HZ_VAL		0x01
> -#define ST_PRESS_1_ODR_AVL_7HZ_VAL		0x05
> -#define ST_PRESS_1_ODR_AVL_13HZ_VAL		0x06
> -#define ST_PRESS_1_ODR_AVL_25HZ_VAL		0x07
> -#define ST_PRESS_1_PW_ADDR			0x20
> -#define ST_PRESS_1_PW_MASK			0x80
> -#define ST_PRESS_1_FS_ADDR			0x23
> -#define ST_PRESS_1_FS_MASK			0x30
> -#define ST_PRESS_1_FS_AVL_1260_VAL		0x00
> -#define ST_PRESS_1_FS_AVL_1260_GAIN		ST_PRESS_MBAR_TO_KPASCAL(244141)
> -#define ST_PRESS_1_FS_AVL_TEMP_GAIN		2083000
> -#define ST_PRESS_1_BDU_ADDR			0x20
> -#define ST_PRESS_1_BDU_MASK			0x04
> -#define ST_PRESS_1_DRDY_IRQ_ADDR		0x22
> -#define ST_PRESS_1_DRDY_IRQ_MASK		0x04
> -#define ST_PRESS_1_MULTIREAD_BIT		true
> -#define ST_PRESS_1_TEMP_OFFSET			42500
> +/* CUSTOM VALUES FOR LPS331AP SENSOR */
> +#define ST_PRESS_LPS331AP_WAI_EXP		0xbb
> +#define ST_PRESS_LPS331AP_ODR_ADDR		0x20
> +#define ST_PRESS_LPS331AP_ODR_MASK		0x70
> +#define ST_PRESS_LPS331AP_ODR_AVL_1HZ_VAL	0x01
> +#define ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL	0x05
> +#define ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL	0x06
> +#define ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL	0x07
> +#define ST_PRESS_LPS331AP_PW_ADDR		0x20
> +#define ST_PRESS_LPS331AP_PW_MASK		0x80
> +#define ST_PRESS_LPS331AP_FS_ADDR		0x23
> +#define ST_PRESS_LPS331AP_FS_MASK		0x30
> +#define ST_PRESS_LPS331AP_FS_AVL_1260_VAL	0x00
> +#define ST_PRESS_LPS331AP_FS_AVL_1260_GAIN	ST_PRESS_MBAR_TO_KPASCAL(244141)
> +#define ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN	2083000
> +#define ST_PRESS_LPS331AP_BDU_ADDR		0x20
> +#define ST_PRESS_LPS331AP_BDU_MASK		0x04
> +#define ST_PRESS_LPS331AP_DRDY_IRQ_ADDR		0x22
> +#define ST_PRESS_LPS331AP_DRDY_IRQ_MASK		0x04
> +#define ST_PRESS_LPS331AP_MULTIREAD_BIT		true
> +#define ST_PRESS_LPS331AP_TEMP_OFFSET		42500
> +#define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
> +#define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
>   
>   static const struct iio_chan_spec st_press_channels[] = {
>   	ST_SENSORS_LSM_CHANNELS(IIO_PRESSURE,
>   			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
>   			ST_SENSORS_SCAN_X, 0, IIO_NO_MOD, 'u', IIO_LE, 24, 24,
> -			ST_PRESS_DEFAULT_OUT_XL_ADDR),
> +			ST_PRESS_LPS331AP_OUT_XL_ADDR),
>   	ST_SENSORS_LSM_CHANNELS(IIO_TEMP,
>   			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE) |
>   						BIT(IIO_CHAN_INFO_OFFSET),
>   			-1, 0, IIO_NO_MOD, 's', IIO_LE, 16, 16,
> -			ST_TEMP_DEFAULT_OUT_L_ADDR),
> +			ST_TEMP_LPS331AP_OUT_L_ADDR),
>   	IIO_CHAN_SOFT_TIMESTAMP(1)
>   };
>   
>   static const struct st_sensors st_press_sensors[] = {
>   	{
> -		.wai = ST_PRESS_1_WAI_EXP,
> +		.wai = ST_PRESS_LPS331AP_WAI_EXP,
>   		.sensors_supported = {
>   			[0] = LPS331AP_PRESS_DEV_NAME,
>   		},
>   		.ch = (struct iio_chan_spec *)st_press_channels,
>   		.odr = {
> -			.addr = ST_PRESS_1_ODR_ADDR,
> -			.mask = ST_PRESS_1_ODR_MASK,
> +			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
> +			.mask = ST_PRESS_LPS331AP_ODR_MASK,
>   			.odr_avl = {
> -				{ 1, ST_PRESS_1_ODR_AVL_1HZ_VAL, },
> -				{ 7, ST_PRESS_1_ODR_AVL_7HZ_VAL, },
> -				{ 13, ST_PRESS_1_ODR_AVL_13HZ_VAL, },
> -				{ 25, ST_PRESS_1_ODR_AVL_25HZ_VAL, },
> +				{ 1, ST_PRESS_LPS331AP_ODR_AVL_1HZ_VAL, },
> +				{ 7, ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL, },
> +				{ 13, ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL, },
> +				{ 25, ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL, },
>   			},
>   		},
>   		.pw = {
> -			.addr = ST_PRESS_1_PW_ADDR,
> -			.mask = ST_PRESS_1_PW_MASK,
> +			.addr = ST_PRESS_LPS331AP_PW_ADDR,
> +			.mask = ST_PRESS_LPS331AP_PW_MASK,
>   			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
>   			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
>   		},
>   		.fs = {
> -			.addr = ST_PRESS_1_FS_ADDR,
> -			.mask = ST_PRESS_1_FS_MASK,
> +			.addr = ST_PRESS_LPS331AP_FS_ADDR,
> +			.mask = ST_PRESS_LPS331AP_FS_MASK,
>   			.fs_avl = {
>   				[0] = {
>   					.num = ST_PRESS_FS_AVL_1260MB,
> -					.value = ST_PRESS_1_FS_AVL_1260_VAL,
> -					.gain = ST_PRESS_1_FS_AVL_1260_GAIN,
> -					.gain2 = ST_PRESS_1_FS_AVL_TEMP_GAIN,
> +					.value = ST_PRESS_LPS331AP_FS_AVL_1260_VAL,
> +					.gain = ST_PRESS_LPS331AP_FS_AVL_1260_GAIN,
> +					.gain2 = ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN,
>   				},
>   			},
>   		},
>   		.bdu = {
> -			.addr = ST_PRESS_1_BDU_ADDR,
> -			.mask = ST_PRESS_1_BDU_MASK,
> +			.addr = ST_PRESS_LPS331AP_BDU_ADDR,
> +			.mask = ST_PRESS_LPS331AP_BDU_MASK,
>   		},
>   		.drdy_irq = {
> -			.addr = ST_PRESS_1_DRDY_IRQ_ADDR,
> -			.mask = ST_PRESS_1_DRDY_IRQ_MASK,
> +			.addr = ST_PRESS_LPS331AP_DRDY_IRQ_ADDR,
> +			.mask = ST_PRESS_LPS331AP_DRDY_IRQ_MASK,
>   		},
> -		.multi_read_bit = ST_PRESS_1_MULTIREAD_BIT,
> +		.multi_read_bit = ST_PRESS_LPS331AP_MULTIREAD_BIT,
>   		.bootime = 2,
>   	},
>   };
