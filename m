Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbaJUVR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:17:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58342 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbaJUVR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:17:26 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: zyw@rock-chips.com
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 1/6] pinctrl: rockchip: add suspend/resume functions
Date: Tue, 21 Oct 2014 23:20:11 +0200
Message-ID: <3477070.K1aFAOaaEU@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1413862968-2691-1-git-send-email-zyw@rock-chips.com>
References: <1413862894-2623-1-git-send-email-zyw@rock-chips.com> <1413862968-2691-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Montag, 20. Oktober 2014, 20:42:48 schrieb zyw@rock-chips.com:
> From: Chris <zyw@rock-chips.com>

Please use your full name like "Chris Zhong"

> 
> support suspend/resume of pinctrl, it allows handling sleep mode
> for hogged pins in pinctrl
> 
> Signed-off-by: Chris <zyw@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>

also, please use only one Signed-off-by line for yourself :-)


> ---
> 
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/pinctrl/pinctrl-rockchip.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index d0f3c18..d384d99 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1795,6 +1795,31 @@ static struct rockchip_pin_ctrl
> *rockchip_pinctrl_get_soc_data( return ctrl;
>  }
> 
> +#ifdef CONFIG_PM
> +static int rockchip_pinctrl_suspend(struct platform_device *pdev,
> +				    pm_message_t state)
> +{
> +	struct rockchip_pinctrl *info;
> +
> +	info = platform_get_drvdata(pdev);
> +	if (!info)
> +		return -EINVAL;
> +
> +	return pinctrl_force_sleep(info->pctl_dev);
> +}
> +
> +static int rockchip_pinctrl_resume(struct platform_device *pdev)
> +{
> +	struct rockchip_pinctrl *info;
> +
> +	info = platform_get_drvdata(pdev);
> +	if (!info)
> +		return -EINVAL;
> +
> +	return pinctrl_force_default(info->pctl_dev);
> +}
> +#endif
> +
>  static int rockchip_pinctrl_probe(struct platform_device *pdev)
>  {
>  	struct rockchip_pinctrl *info;
> @@ -2010,6 +2035,10 @@ static struct platform_driver rockchip_pinctrl_driver
> = { .owner	= THIS_MODULE,
>  		.of_match_table = rockchip_pinctrl_dt_match,
>  	},
> +	#ifdef CONFIG_PM
> +	.suspend = rockchip_pinctrl_suspend,
> +	.resume = rockchip_pinctrl_resume,
> +	#endif

as Dmitry already pointed out, this is the legacy suspend interface and should 
not be used anymore.


>  };
> 
>  static int __init rockchip_pinctrl_drv_register(void)

