Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3EKJwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 05:52:53 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49525 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3EKJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 05:52:51 -0400
Message-ID: <518E14F1.6000008@kernel.org>
Date: Sat, 11 May 2013 10:52:49 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Axel Lin <axel.lin@ingics.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v3] iio: dac: Fix build error when CONFIG_SPI_MASTER=y
 && CONFIG_I2C=m
References: <1368085759.3454.0.camel@phoenix> <518B5F73.4010702@metafoo.de>
In-Reply-To: <518B5F73.4010702@metafoo.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 09:33 AM, Lars-Peter Clausen wrote:
> On 05/09/2013 09:49 AM, Axel Lin wrote:
>> This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m:
>>
>> drivers/built-in.o: In function `ad5064_i2c_write':
>> drivers/iio/dac/ad5064.c:608: undefined reference to `i2c_master_send'
>> drivers/built-in.o: In function `ad5064_i2c_register_driver':
>> drivers/iio/dac/ad5064.c:646: undefined reference to `i2c_register_driver'
>> drivers/built-in.o: In function `ad5064_i2c_unregister_driver':
>> drivers/iio/dac/ad5064.c:651: undefined reference to `i2c_del_driver'
>> make: *** [vmlinux] Error 1
>>
>> When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
>> Thus don't allow the drivers to be compiled as built-in when CONFIG_I2C=m.
>>
>> The real fix though is to break the driver apart into a SPI part, an I2C part
>> and a common part. But that's something for 3.11 while this is something for
>> 3.10/stable.
>>
>> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Thanks for taking care of this.
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Jonathan when you apply this please also add:
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> 
> since he reported the issue as well
>
Done and applied to fixes-togreg branch of iio.git

Thanks all.
>> ---
>> v3: Update comment
>>
>>  drivers/iio/dac/Kconfig | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
>> index f4a6f08..b61160b 100644
>> --- a/drivers/iio/dac/Kconfig
>> +++ b/drivers/iio/dac/Kconfig
>> @@ -5,7 +5,7 @@ menu "Digital to analog converters"
>>  
>>  config AD5064
>>  	tristate "Analog Devices AD5064 and similar multi-channel DAC driver"
>> -	depends on (SPI_MASTER || I2C)
>> +	depends on (SPI_MASTER && I2C!=m) || I2C
>>  	help
>>  	  Say yes here to build support for Analog Devices AD5024, AD5025, AD5044,
>>  	  AD5045, AD5064, AD5064-1, AD5065, AD5628, AD5629R, AD5648, AD5666, AD5668,
>> @@ -27,7 +27,7 @@ config AD5360
>>  
>>  config AD5380
>>  	tristate "Analog Devices AD5380/81/82/83/84/90/91/92 DAC driver"
>> -	depends on (SPI_MASTER || I2C)
>> +	depends on (SPI_MASTER && I2C!=m) || I2C
>>  	select REGMAP_I2C if I2C
>>  	select REGMAP_SPI if SPI_MASTER
>>  	help
>> @@ -57,7 +57,7 @@ config AD5624R_SPI
>>  
>>  config AD5446
>>  	tristate "Analog Devices AD5446 and similar single channel DACs driver"
>> -	depends on (SPI_MASTER || I2C)
>> +	depends on (SPI_MASTER && I2C!=m) || I2C
>>  	help
>>  	  Say yes here to build support for Analog Devices AD5300, AD5301, AD5310,
>>  	  AD5311, AD5320, AD5321, AD5444, AD5446, AD5450, AD5451, AD5452, AD5453,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
