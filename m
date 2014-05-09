Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaEIKD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:03:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:35711 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbaEIKD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:03:56 -0400
Message-ID: <536CA80A.60201@atmel.com>
Date: Fri, 9 May 2014 12:03:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: atmel_pwm: only build for supported platforms
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-17-git-send-email-arnd@arndb.de>
In-Reply-To: <1399560990-1402858-17-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 16:56, Arnd Bergmann :
> There is architecture code in mach-at91 that depends on the
> CONFIG_ATMEL_PWM symbol in order to call the soc-specific
> at91_add_device_pwm function. While all of this is about code
> that will be removed in the future, using DT probing and
> the PWM framework, we currently get a build failure:
> 
> arch/arm/mach-at91/built-in.o: In function `at91_pwm_leds':
> arch/arm/mach-at91/leds.c:88: undefined reference to `at91_add_device_pwm'
> 
> This patch ensures we only try to build this driver on
> platforms on which it will build and work.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks,

> ---
>  drivers/misc/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index fe2230c..ce29342 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -53,7 +53,8 @@ config AD525X_DPOT_SPI
>  
>  config ATMEL_PWM
>  	tristate "Atmel AT32/AT91 PWM support"
> -	depends on HAVE_CLK && (AVR32 || ARCH_AT91 || COMPILE_TEST)
> +	depends on HAVE_CLK
> +	depends on AVR32 || AT91SAM9263 || AT91SAM9RL || AT91SAM9G45
>  	help
>  	  This option enables device driver support for the PWM channels
>  	  on certain Atmel processors.  Pulse Width Modulation is used for
> 


-- 
Nicolas Ferre
