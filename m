Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaFYKss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:48:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34697 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669AbaFYKsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:48:46 -0400
Date: Wed, 25 Jun 2014 12:48:35 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        pebolle@tiscali.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: atmel_pwm: fix Kconfig symbols
Message-ID: <20140625104834.GA21291@piout.net>
References: <20140618093109.GQ19375@piout.net>
 <1403689436-6664-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403689436-6664-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2014 at 11:43:56 +0200, Nicolas Ferre wrote :
> AT91 symbols AT91SAM9263, AT91SAM9RL, and AT91SAM9G45 do not exist and this
> patch change them their correct ARCH_* version.
> These symbols are chosen instead of the SOC_* one because this driver is not
> converted to DT.
> Anyway, the ATMEL_PWM symbol and the associated driver will be removed soon
> during the move to the PWM sub-system.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
> Guys,
> 
> The rework is delayed to 3.17. So, in the meantime, I send this little patch
> as a fix for 3.16.
> 
> Bye,
> 
>  drivers/misc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index a43d0c467274..ee9402324a23 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -54,7 +54,7 @@ config AD525X_DPOT_SPI
>  config ATMEL_PWM
>  	tristate "Atmel AT32/AT91 PWM support"
>  	depends on HAVE_CLK
> -	depends on AVR32 || AT91SAM9263 || AT91SAM9RL || AT91SAM9G45
> +	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
>  	help
>  	  This option enables device driver support for the PWM channels
>  	  on certain Atmel processors.  Pulse Width Modulation is used for
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
