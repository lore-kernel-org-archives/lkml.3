Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3ENJbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:31:04 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:54734 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693Ab3ENJbB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:31:01 -0400
From: Denis CIOCCA <denis.ciocca@st.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 14 May 2013 11:30:32 +0200
Subject: Re: [PATCH] iio: STMicroelectronics: remove three useless selects
Thread-Topic: [PATCH] iio: STMicroelectronics: remove three useless selects
Thread-Index: Ac5Qha6UdlXdH42BToGA2LVqe2W4QQ==
Message-ID: <1426549.ftB3AjjfpY@elitebook-8460p>
References: <1368522350.1350.98.camel@x61.thuisdomein>
In-Reply-To: <1368522350.1350.98.camel@x61.thuisdomein>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: KMail/4.8.5 (Linux/3.2.0-41-generic; KDE/4.8.5; x86_64; ; )
acceptlanguage: it-IT, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Acked-by: Denis Ciocca <denis.ciocca@st.com>

Thanks,
Denis

On Tuesday, May 14, 2013 11:05:50 AM Paul Bolle wrote:
> Drivers for STMicroelectronics accelerometers, gyroscopes, and
> magnetometers were added in v3.9. They all have a (similar) select
> statement in their Kconfig files for a non-existant Kconfig symbol.
> These select statements can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) Perhaps it was intended (in development versions of these drivers) to
> have separate buffer and core drivers. One hint is that in the buffer
> related source files one can find the usual MODULE_* macros. Those
> macros can also be found in the core source files. I do wonder what
> happens at build time now these drivers have two copies of these macros.
> 
>  drivers/iio/accel/Kconfig        | 1 -
>  drivers/iio/gyro/Kconfig         | 1 -
>  drivers/iio/magnetometer/Kconfig | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
> index bb59496..719d83f 100644
> --- a/drivers/iio/accel/Kconfig
> +++ b/drivers/iio/accel/Kconfig
> @@ -28,7 +28,6 @@ config IIO_ST_ACCEL_3AXIS
>  	select IIO_ST_ACCEL_I2C_3AXIS if (I2C)
>  	select IIO_ST_ACCEL_SPI_3AXIS if (SPI_MASTER)
>  	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
> -	select IIO_ST_ACCEL_BUFFER if (IIO_TRIGGERED_BUFFER)
>  	help
>  	  Say yes here to build support for STMicroelectronics accelerometers:
>  	  LSM303DLH, LSM303DLHC, LIS3DH, LSM330D, LSM330DL, LSM330DLC,
> diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
> index 6be4628..b8daf1b 100644
> --- a/drivers/iio/gyro/Kconfig
> +++ b/drivers/iio/gyro/Kconfig
> @@ -47,7 +47,6 @@ config IIO_ST_GYRO_3AXIS
>  	select IIO_ST_GYRO_I2C_3AXIS if (I2C)
>  	select IIO_ST_GYRO_SPI_3AXIS if (SPI_MASTER)
>  	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
> -	select IIO_ST_GYRO_BUFFER if (IIO_TRIGGERED_BUFFER)
>  	help
>  	  Say yes here to build support for STMicroelectronics gyroscopes:
>  	  L3G4200D, LSM330DL, L3GD20, L3GD20H, LSM330DLC, L3G4IS, LSM330.
> diff --git a/drivers/iio/magnetometer/Kconfig
> b/drivers/iio/magnetometer/Kconfig
 index bd1cfb6..c332b0a 100644
> --- a/drivers/iio/magnetometer/Kconfig
> +++ b/drivers/iio/magnetometer/Kconfig
> @@ -32,7 +32,6 @@ config IIO_ST_MAGN_3AXIS
>  	select IIO_ST_MAGN_I2C_3AXIS if (I2C)
>  	select IIO_ST_MAGN_SPI_3AXIS if (SPI_MASTER)
>  	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
> -	select IIO_ST_MAGN_BUFFER if (IIO_TRIGGERED_BUFFER)
>  	help
>  	  Say yes here to build support for STMicroelectronics magnetometers:
>  	  LSM303DLHC, LSM303DLM, LIS3MDL.
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
