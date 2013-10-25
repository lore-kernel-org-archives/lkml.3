Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3JYLfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:35:38 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:34265 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821Ab3JYLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:35:36 -0400
Date: Fri, 25 Oct 2013 13:12:18 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] backlight: atmel-pwm-bl: clean up get_intensity
Message-ID: <20131025111218.GT18477@ns203013.ovh.net>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-6-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382522143-32072-6-git-send-email-jhovold@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 5880856689295600462
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:55 Wed 23 Oct     , Johan Hovold wrote:
> Clean up get_intensity to increase readability.
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

this ok
> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index 52a8134..504061c 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -70,15 +70,14 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
>  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
>  {
>  	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> +	u32 cdty;
>  	u32 intensity;
>  
> -	if (pwmbl->pdata->pwm_active_low) {
> -		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> -			pwmbl->pdata->pwm_duty_min;
> -	} else {
> -		intensity = pwmbl->pdata->pwm_duty_max -
> -			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> -	}
> +	cdty = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> +	if (pwmbl->pdata->pwm_active_low)
> +		intensity = cdty - pwmbl->pdata->pwm_duty_min;
> +	else
> +		intensity = pwmbl->pdata->pwm_duty_max - cdty;
>  
>  	return (u16)intensity;
>  }
> -- 
> 1.8.4
> 
