Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3EIH3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:29:13 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:34778 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3EIH3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:29:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <518B5040.8070900@jic23.retrosnub.co.uk>
Date: Thu, 09 May 2013 08:29:04 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] iio: dac: Fix build error when CONFIG_SPI_MASTER=y
 && CONFIG_I2C=m
References: <1368024363.9329.1.camel@phoenix>
In-Reply-To: <1368024363.9329.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 15:46, Axel Lin wrote:
> This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m:
>
> drivers/built-in.o: In function `ad5064_i2c_write':
> drivers/iio/dac/ad5064.c:608: undefined reference to `i2c_master_send'
> drivers/built-in.o: In function `ad5064_i2c_register_driver':
> drivers/iio/dac/ad5064.c:646: undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `ad5064_i2c_unregister_driver':
> drivers/iio/dac/ad5064.c:651: undefined reference to `i2c_del_driver'
> make: *** [vmlinux] Error 1
>
> Add config IIO_DAC_I2C_AND_SPI to handle such case:
> When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
> Thus don't allow the drivers to be compiled as built-in.
Looks good except for this comment which I think is now out of date.
>
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/iio/dac/Kconfig | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
> index f4a6f08..b61160b 100644
> --- a/drivers/iio/dac/Kconfig
> +++ b/drivers/iio/dac/Kconfig
> @@ -5,7 +5,7 @@ menu "Digital to analog converters"
>
>   config AD5064
>   	tristate "Analog Devices AD5064 and similar multi-channel DAC driver"
> -	depends on (SPI_MASTER || I2C)
> +	depends on (SPI_MASTER && I2C!=m) || I2C
>   	help
>   	  Say yes here to build support for Analog Devices AD5024, AD5025, AD5044,
>   	  AD5045, AD5064, AD5064-1, AD5065, AD5628, AD5629R, AD5648, AD5666, AD5668,
> @@ -27,7 +27,7 @@ config AD5360
>
>   config AD5380
>   	tristate "Analog Devices AD5380/81/82/83/84/90/91/92 DAC driver"
> -	depends on (SPI_MASTER || I2C)
> +	depends on (SPI_MASTER && I2C!=m) || I2C
>   	select REGMAP_I2C if I2C
>   	select REGMAP_SPI if SPI_MASTER
>   	help
> @@ -57,7 +57,7 @@ config AD5624R_SPI
>
>   config AD5446
>   	tristate "Analog Devices AD5446 and similar single channel DACs driver"
> -	depends on (SPI_MASTER || I2C)
> +	depends on (SPI_MASTER && I2C!=m) || I2C
>   	help
>   	  Say yes here to build support for Analog Devices AD5300, AD5301, AD5310,
>   	  AD5311, AD5320, AD5321, AD5444, AD5446, AD5450, AD5451, AD5452, AD5453,
>

