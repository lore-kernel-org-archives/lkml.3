Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaHZQbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:31:24 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42350 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaHZQbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:31:23 -0400
Date: Tue, 26 Aug 2014 17:31:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 13/18] backlight: s6e63m0: remove 'else' after a return
Message-ID: <20140826163117.GI26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b701cfc12d$cff2f910$6fd8eb30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b701cfc12d$cff2f910$6fd8eb30$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/s6e63m0.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
> index f3a65c8940ed..28bfa127fee4 100644
> --- a/drivers/video/backlight/s6e63m0.c
> +++ b/drivers/video/backlight/s6e63m0.c
> @@ -507,19 +507,19 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
>  	if (!pd->power_on) {
>  		dev_err(lcd->dev, "power_on is NULL.\n");
>  		return -EINVAL;
> -	} else {
> -		pd->power_on(lcd->ld, 1);
> -		msleep(pd->power_on_delay);
>  	}
>  
> +	pd->power_on(lcd->ld, 1);
> +	msleep(pd->power_on_delay);
> +
>  	if (!pd->reset) {
>  		dev_err(lcd->dev, "reset is NULL.\n");
>  		return -EINVAL;
> -	} else {
> -		pd->reset(lcd->ld);
> -		msleep(pd->reset_delay);
>  	}
>  
> +	pd->reset(lcd->ld);
> +	msleep(pd->reset_delay);
> +
>  	ret = s6e63m0_ldi_init(lcd);
>  	if (ret) {
>  		dev_err(lcd->dev, "failed to initialize ldi.\n");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
