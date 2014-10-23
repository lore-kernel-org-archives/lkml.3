Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaJWQXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:23:30 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43884 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaJWQX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:23:29 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] pinctrl: rockchip: Parse pin groups before calling pinctrl_register()
Date: Thu, 23 Oct 2014 18:26:33 +0200
Message-ID: <2697554.Rv8qaADZsg@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1413913655-22351-3-git-send-email-dianders@chromium.org>
References: <1413913655-22351-1-git-send-email-dianders@chromium.org> <1413913655-22351-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. Oktober 2014, 10:47:34 schrieb Doug Anderson:
> Just like in (529301c pinctrl: samsung: Parse pin groups before
> calling pinctrl_register()), Rockchip also needs to parse pin groups
> earlier to make hogs work.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Chris Zhong <zyw@rock-chips.com>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

> ---
> Changes in v2: None
> 
>  drivers/pinctrl/pinctrl-rockchip.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index 8a3c582..6c14f6c 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1262,6 +1262,10 @@ static int rockchip_pinctrl_register(struct
> platform_device *pdev, }
>  	}
> 
> +	ret = rockchip_pinctrl_parse_dt(pdev, info);
> +	if (ret)
> +		return ret;
> +
>  	info->pctl_dev = pinctrl_register(ctrldesc, &pdev->dev, info);
>  	if (!info->pctl_dev) {
>  		dev_err(&pdev->dev, "could not register pinctrl driver\n");
> @@ -1279,12 +1283,6 @@ static int rockchip_pinctrl_register(struct
> platform_device *pdev, pinctrl_add_gpio_range(info->pctl_dev,
> &pin_bank->grange);
>  	}
> 
> -	ret = rockchip_pinctrl_parse_dt(pdev, info);
> -	if (ret) {
> -		pinctrl_unregister(info->pctl_dev);
> -		return ret;
> -	}
> -
>  	return 0;
>  }

