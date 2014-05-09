Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbaEIKBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:01:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:32728 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaEIKBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:01:52 -0400
Message-ID: <536CA78C.5070603@atmel.com>
Date: Fri, 9 May 2014 12:01:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 2/2] iio:adc: at91 requires the input subsystem
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1399560990-1402858-13-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 16:56, Arnd Bergmann :
> Building the at91 adc driver with CONFIG_INPUT disabled results in this
> build error:
> 
> ERROR: "input_event" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_unregister_device" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_free_device" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_register_device" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_set_abs_params" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_allocate_device" [drivers/iio/adc/at91_adc.ko] undefined!
> 
> To make sure we can build random configurations, this turns on CONFIG_INPUT
> whenever CONFIG_AT91_ADC is enabled.

Isn't it a "select" instead of "depends" that is required then?

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-iio@vger.kernel.org
> Cc: Josh Wu <josh.wu@atmel.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/iio/adc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 90f596d..a80d236 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -110,6 +110,7 @@ config AD799X
>  config AT91_ADC
>  	tristate "Atmel AT91 ADC"
>  	depends on ARCH_AT91
> +	depends on INPUT
>  	select IIO_BUFFER
>  	select IIO_TRIGGERED_BUFFER
>  	select SYSFS
> 


-- 
Nicolas Ferre
