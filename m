Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbaGYOrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:47:16 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:55449 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaGYOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <1406288841-23140-1-git-send-email-m.olbrich@pengutronix.de>
References: <1406284115-489-1-git-send-email-m.olbrich@pengutronix.de> <1406288841-23140-1-git-send-email-m.olbrich@pengutronix.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 25 Jul 2014 23:46:51 +0900
Message-ID: <CAAVeFu+Gaabwt_3GB8VQRyOYPKsOjCkCDEYnSet3UaQztnb+Bg@mail.gmail.com>
Subject: Re: [PATCH v2] pwm-backlight: fix probing from device-tree without enable-gpios
To: Michael Olbrich <m.olbrich@pengutronix.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 8:47 PM, Michael Olbrich
<m.olbrich@pengutronix.de> wrote:
> Since 257462dbf3ed ("pwm-backlight: switch to gpiod interface")
> enable_gpio is no longer set and remains 0 when probing from
> device-tree. This is a valid gpio number. With no enable-gpios
> specified in the device-tree this is used and probing fails
> with:
>
> pwm-backlight lcd-backlight.3: failed to request GPIO#0: -16
>
> Fix this by setting enable_gpio to -1 which is not a valid gpio
> number.

Looks good indeed. My bad for overlooking this.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

>
> Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> ---
>
> Sorry, I sent the wrong version. This one actually compiles.
>
> Michael
>
>  drivers/video/backlight/pwm_bl.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 38ca88b..e7e43cd 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -211,6 +211,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>                         dev_err(&pdev->dev, "failed to find platform data\n");
>                         return ret;
>                 }
> +               defdata.enable_gpio = -1;
>
>                 data = &defdata;
>         }
> --
> 2.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
