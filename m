Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbaFSHEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:04:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:5654 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaFSHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:04:40 -0400
Message-ID: <53A28B82.9040701@atmel.com>
Date: Thu, 19 Jun 2014 09:04:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers:video:fbdev atmel_lcdfb.c power GPIO registration
 bug
References: <1403142732-31706-1-git-send-email-mwelling@ieee.org>
In-Reply-To: <1403142732-31706-1-git-send-email-mwelling@ieee.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/2014 03:52, Michael Welling :
> A list that was intended for storing power control GPIOs was never
> initialized correctly or filled. Without these lines of added code
> the kernel hangs when trying to access an uninitialized list when a
> power control GPIO is registered with the device tree.
> 
> Signed-off-by: Michael Welling <mwelling@ieee.org>

Indeed.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, best regards,

> ---
>  drivers/video/fbdev/atmel_lcdfb.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
> index e683b6e..d36e830 100644
> --- a/drivers/video/fbdev/atmel_lcdfb.c
> +++ b/drivers/video/fbdev/atmel_lcdfb.c
> @@ -1057,6 +1057,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
>  		goto put_display_node;
>  	}
>  
> +	INIT_LIST_HEAD(&pdata->pwr_gpios);
>  	ret = -ENOMEM;
>  	for (i = 0; i < of_gpio_named_count(display_np, "atmel,power-control-gpio"); i++) {
>  		gpio = of_get_named_gpio_flags(display_np, "atmel,power-control-gpio",
> @@ -1082,6 +1083,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
>  			dev_err(dev, "set direction output gpio %d failed\n", gpio);
>  			goto put_display_node;
>  		}
> +		list_add(&og->list, &pdata->pwr_gpios);
>  	}
>  
>  	if (is_gpio_power)
> 


-- 
Nicolas Ferre
