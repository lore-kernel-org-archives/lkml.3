Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaDNW63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:58:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48828 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaDNW60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:58:26 -0400
Date: Tue, 15 Apr 2014 07:58:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Magnus Damm <magnus.damm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 02/11] ARM: shmobile: Armadillo 800 EVA: initialize all
 struct pwm_lookup members
Message-ID: <20140414225822.GG22518@verge.net.au>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1397512793-10325-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397512793-10325-3-git-send-email-alexandre.belloni@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:59:44PM +0200, Alexandre Belloni wrote:
> Initializing all the struct pwm_lookup members allows to get rid of the struct
> tpu_pwm_platform_data as the polarity initialization will be taken care of by
> the PWM core.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


This looks good to me.
Please let me know when the driver code has been merged and
I'll take this patch. Likewise for the other shmobile patch in this series.

> ---
>  arch/arm/mach-shmobile/board-armadillo800eva.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
> index 2858f380beae..1bf61dad9a35 100644
> --- a/arch/arm/mach-shmobile/board-armadillo800eva.c
> +++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
> @@ -31,7 +31,7 @@
>  #include <linux/gpio_keys.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/pinctrl/machine.h>
> -#include <linux/platform_data/pwm-renesas-tpu.h>
> +#include <linux/pwm.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/regulator/fixed.h>
>  #include <linux/regulator/gpio-regulator.h>
> @@ -399,24 +399,22 @@ static struct resource pwm_resources[] = {
>  	},
>  };
>  
> -static struct tpu_pwm_platform_data pwm_device_data = {
> -	.channels[2] = {
> -		.polarity = PWM_POLARITY_INVERSED,
> -	}
> -};
> -
>  static struct platform_device pwm_device = {
>  	.name = "renesas-tpu-pwm",
>  	.id = -1,
> -	.dev = {
> -		.platform_data = &pwm_device_data,
> -	},
>  	.num_resources = ARRAY_SIZE(pwm_resources),
>  	.resource = pwm_resources,
>  };
>  
>  static struct pwm_lookup pwm_lookup[] = {
> -	PWM_LOOKUP("renesas-tpu-pwm", 2, "pwm-backlight.0", NULL),
> +	{
> +		.provider = "renesas-tpu-pwm",
> +		.index = 2,
> +		.dev_id = "pwm-backlight.0",
> +		.con_id = NULL,
> +		.period = 33333,
> +		.polarity = PWM_POLARITY_INVERSED,
> +	},
>  };
>  
>  /* LCDC and backlight */
> -- 
> 1.8.3.2
> 
