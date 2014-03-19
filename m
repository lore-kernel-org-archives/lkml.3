Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbaCSOTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:19:08 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:48023 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:19:05 -0400
Date: Wed, 19 Mar 2014 15:18:20 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 09/16] avr32/at32ap: switch to the generic PWM framework
Message-ID: <20140319141820.GA20872@samfundet.no>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-10-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395234209-15546-10-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 19 Mar 2014 14:03:22 +0100 or thereabout, Alexandre Belloni wrote:
> Switch to the pwm/pwm-atmel driver instead of misc/atmel_pwm
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/mach-at32ap/at32ap700x.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index a1f4d1e91b52..db85b5ec3351 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1553,7 +1553,7 @@ static struct resource atmel_pwm0_resource[] __initdata = {
>  	IRQ(24),
>  };
>  static struct clk atmel_pwm0_mck = {
> -	.name		= "pwm_clk",
> +	.name		= "at91sam9rl-pwm",

I found this a tiny bit weird, but found the matching instance in
drivers/pwm/pwm-atmel.c

IMHO it would initially have been better to call it atpwm_v1 or something
similar, more generic. But I guess that is too late to change at this point.

>  	.parent		= &pbb_clk,
>  	.mode		= pbb_clk_mode,
>  	.get_rate	= pbb_clk_get_rate,
> @@ -1568,7 +1568,7 @@ struct platform_device *__init at32_add_device_pwm(u32 mask)
>  	if (!mask)
>  		return NULL;
>  
> -	pdev = platform_device_alloc("atmel_pwm", 0);
> +	pdev = platform_device_alloc("at91sam9rl-pwm", 0);
>  	if (!pdev)
>  		return NULL;
>  
> @@ -1576,9 +1576,6 @@ struct platform_device *__init at32_add_device_pwm(u32 mask)
>  				ARRAY_SIZE(atmel_pwm0_resource)))
>  		goto out_free_pdev;
>  
> -	if (platform_device_add_data(pdev, &mask, sizeof(mask)))
> -		goto out_free_pdev;
> -
>  	pin_mask = 0;
>  	if (mask & (1 << 0))
>  		pin_mask |= (1 << 28);
-- 
mvh
Hans-Christian Egtvedt
