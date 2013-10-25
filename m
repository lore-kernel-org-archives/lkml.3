Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JYLHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:07:40 -0400
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:38129 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3JYLHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:07:38 -0400
Date: Fri, 25 Oct 2013 13:09:28 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/9] backlight: atmel-pwm-bl: fix gpio polarity in remove
Message-ID: <20131025110928.GR18477@ns203013.ovh.net>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-3-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382522143-32072-3-git-send-email-jhovold@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 5833005943052086094
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
> Make sure to honour gpio polarity also at remove so that the backlight
> is actually disabled on boards with active-low enable pin.
> 
> Cc: stable@vger.kernel.org
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index 8aac273..3cb0094 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -205,8 +205,10 @@ static int atmel_pwm_bl_remove(struct platform_device *pdev)
>  {
>  	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
>  
> -	if (pwmbl->gpio_on != -1)
> -		gpio_set_value(pwmbl->gpio_on, 0);
> +	if (pwmbl->gpio_on != -1) {
here we need to use gpio_is_valid
> +		gpio_set_value(pwmbl->gpio_on,
> +					0 ^ pwmbl->pdata->on_active_low);
> +	}
>  	pwm_channel_disable(&pwmbl->pwmc);
>  	pwm_channel_free(&pwmbl->pwmc);
>  
> -- 
> 1.8.4
> 
