Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaJUATc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:19:32 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:55551 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaJUATb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:19:31 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 216.239.45.75
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <9e97f9728815f9b84cce72aa80540c40>
X-DNS-TYPE: 0
Message-ID: <5445A689.8040707@rock-chips.com>
Date: Mon, 20 Oct 2014 17:19:21 -0700
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>
CC: Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pinctrl: rockchip: Parse pin groups before calling
 pinctrl_register()
References: <1413847670-12245-1-git-send-email-dianders@chromium.org> <1413847670-12245-3-git-send-email-dianders@chromium.org>
In-Reply-To: <1413847670-12245-3-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/20/2014 04:27 PM, Doug Anderson wrote:
> Just like in (529301c pinctrl: samsung: Parse pin groups before
> calling pinctrl_register()), Rockchip also needs to parse pin groups
> earlier to make hogs work.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>   drivers/pinctrl/pinctrl-rockchip.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
> index 65efb88..14a5683 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1263,6 +1263,10 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
>   		}
>   	}
>   
> +	ret = rockchip_pinctrl_parse_dt(pdev, info);
> +	if (ret)
> +		return ret;
> +
>   	info->pctl_dev = pinctrl_register(ctrldesc, &pdev->dev, info);
>   	if (!info->pctl_dev) {
>   		dev_err(&pdev->dev, "could not register pinctrl driver\n");
> @@ -1280,12 +1284,6 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
>   		pinctrl_add_gpio_range(info->pctl_dev, &pin_bank->grange);
>   	}
>   
> -	ret = rockchip_pinctrl_parse_dt(pdev, info);
> -	if (ret) {
> -		pinctrl_unregister(info->pctl_dev);
> -		return ret;
> -	}
> -
>   	return 0;
>   }
>   

Tested-by: Chris Zhong <zyw@rock-chips.com>
