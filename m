Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3EVVHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:07:41 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38840 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3EVVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:07:39 -0400
Message-ID: <519D3395.9080200@kernel.org>
Date: Wed, 22 May 2013 22:07:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Denis CIOCCA <denis.ciocca@st.com>
CC: Paul Bolle <pebolle@tiscali.nl>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: STMicroelectronics: remove three useless selects
References: <1368522350.1350.98.camel@x61.thuisdomein> <1426549.ftB3AjjfpY@elitebook-8460p>
In-Reply-To: <1426549.ftB3AjjfpY@elitebook-8460p>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 10:30 AM, Denis CIOCCA wrote:
> Hi Paul,
> 
> Acked-by: Denis Ciocca <denis.ciocca@st.com>
Applied to togreg branch of iio.git.
> 
> Thanks,
> Denis
> 
> On Tuesday, May 14, 2013 11:05:50 AM Paul Bolle wrote:
>> Drivers for STMicroelectronics accelerometers, gyroscopes, and
>> magnetometers were added in v3.9. They all have a (similar) select
>> statement in their Kconfig files for a non-existant Kconfig symbol.
>> These select statements can safely be removed.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) Untested.
>>
>> 1) Perhaps it was intended (in development versions of these drivers) to
>> have separate buffer and core drivers. One hint is that in the buffer
>> related source files one can find the usual MODULE_* macros. Those
>> macros can also be found in the core source files. I do wonder what
>> happens at build time now these drivers have two copies of these macros.
>>
>>  drivers/iio/accel/Kconfig        | 1 -
>>  drivers/iio/gyro/Kconfig         | 1 -
>>  drivers/iio/magnetometer/Kconfig | 1 -
>>  3 files changed, 3 deletions(-)
>>
>> diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
>> index bb59496..719d83f 100644
>> --- a/drivers/iio/accel/Kconfig
>> +++ b/drivers/iio/accel/Kconfig
>> @@ -28,7 +28,6 @@ config IIO_ST_ACCEL_3AXIS
>>  	select IIO_ST_ACCEL_I2C_3AXIS if (I2C)
>>  	select IIO_ST_ACCEL_SPI_3AXIS if (SPI_MASTER)
>>  	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
>> -	select IIO_ST_ACCEL_BUFFER if (IIO_TRIGGERED_BUFFER)
>>  	help
>>  	  Say yes here to build support for STMicroelectronics accelerometers:
>>  	  LSM303DLH, LSM303DLHC, LIS3DH, LSM330D, LSM330DL, LSM330DLC,
>> diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
>> index 6be4628..b8daf1b 100644
>> --- a/drivers/iio/gyro/Kconfig
>> +++ b/drivers/iio/gyro/Kconfig
>> @@ -47,7 +47,6 @@ config IIO_ST_GYRO_3AXIS
>>  	select IIO_ST_GYRO_I2C_3AXIS if (I2C)
>>  	select IIO_ST_GYRO_SPI_3AXIS if (SPI_MASTER)
>>  	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
>> -	select IIO_ST_GYRO_BUFFER if (IIO_TRIGGERED_BUFFER)
>>  	help
>>  	  Say yes here to build support for STMicroelectronics gyroscopes:
>>  	  L3G4200D, LSM330DL, L3GD20, L3GD20H, LSM330DLC, L3G4IS, LSM330.
>> diff --git a/drivers/iio/magnetometer/Kconfig
>> b/drivers/iio/magnetometer/Kconfig
>  index bd1cfb6..c332b0a 100644
>> --- a/drivers/iio/magnetometer/Kconfig
>> +++ b/drivers/iio/magnetometer/Kconfig
>> @@ -32,7 +32,6 @@ config IIO_ST_MAGN_3AXIS
>>  	select IIO_ST_MAGN_I2C_3AXIS if (I2C)
>>  	select IIO_ST_MAGN_SPI_3AXIS if (SPI_MASTER)
>>  	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
>> -	select IIO_ST_MAGN_BUFFER if (IIO_TRIGGERED_BUFFER)
>>  	help
>>  	  Say yes here to build support for STMicroelectronics magnetometers:
>>  	  LSM303DLHC, LSM303DLM, LIS3MDL.
>> -- 
>> 1.7.11.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
