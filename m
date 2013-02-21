Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3BUIsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:48:37 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:60714 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3BUIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:48:36 -0500
Message-ID: <5125DF5C.7070700@compulab.co.il>
Date: Thu, 21 Feb 2013 10:48:28 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130123 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: rtc-v3020: use gpio_request_one()
References: <00cb01ce100d$dc282200$94786600$%han@samsung.com>
In-Reply-To: <00cb01ce100d$dc282200$94786600$%han@samsung.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/13 10:31, Jingoo Han wrote:
> Using gpio_request_one() can make the code simpler because it can
> set the direction and initial value in one shot.

If you are on this, then I think converting to gpio_request_array()
would be even better.

> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-v3020.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
> index bca5d67..d59cd24 100644
> --- a/drivers/rtc/rtc-v3020.c
> +++ b/drivers/rtc/rtc-v3020.c
> @@ -125,11 +125,10 @@ static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
>  	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
>  
>  	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
> -		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
> +		err = gpio_request_one(v3020_gpio[i].gpio, GPIOF_OUT_INIT_HIGH,
> +					v3020_gpio[i].name);
>  		if (err)
>  			goto err_request;
> -
> -		gpio_direction_output(v3020_gpio[i].gpio, 1);
>  	}

If you convert to gpio_request_array(), you can also drop the for loop.

>  
>  	chip->gpio = v3020_gpio;
> 

-- 
Regards,
Igor.
