Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaHTMSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:18:06 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38714 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaHTMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:18:03 -0400
Date: Wed, 20 Aug 2014 13:17:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: fix bogus request for GPIO#0 when
 instantiated from DT
Message-ID: <20140820121756.GK4266@lee--X1>
References: <1408516716-28828-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408516716-28828-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Lothar Waßmann wrote:

> commit 257462dbf3ed ("pwm-backlight: switch to gpiod interface")
> introduced a regression leading to acquiring a bogus GPIO-0 when
> configured from DT without an 'enable-gpios' property.
> The driver will happily accept the 0 initialized 'enable_gpio' member
> of the struct platform_pwm_backlight_data as valid gpio number, and
> request this GPIO as enable pin. In case of multiple driver instances,
> the second will fail to register with the error message:
> pwm-backlight backlight1.23: failed to request GPIO#0: -16
> 
> Fix this by setting enable_gpio in the pdata struct to -EINVAL.
> 
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> ---
>  drivers/video/backlight/pwm_bl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to -fixes with Thierry's Ack and the blank line left.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index d7a3d13..e6ef6b4 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -172,7 +172,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
>  		data->dft_brightness = value;
>  		data->max_brightness--;
>  	}
> -
> +	data->enable_gpio = -EINVAL;
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
