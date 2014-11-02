Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaKBUob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:44:31 -0500
Received: from gloria.sntech.de ([95.129.55.99]:45715 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaKBUo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:44:27 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/7] pinctrl: rockchip: add suspend/resume functions
Date: Sun, 02 Nov 2014 21:47:11 +0100
Message-ID: <17050885.jWlDmdlhNv@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414583525-17395-2-git-send-email-zyw@rock-chips.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com> <1414583525-17395-2-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Mittwoch, 29. Oktober 2014, 19:51:59 schrieb Chris Zhong:
> support suspend/resume of pinctrl, it allows handling sleep mode
> for hogged pins in pinctrl

I've now applied patches 1 and 2 of your series to my v3.19-pinctrl/next 
branch and will be sending a pull request to LinusW shortly.

So _if_ a v7 becomes necessary you don't need to include these two patches 
anymore.


Heiko


> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> 
> ---
> 
> Changes in v6: None
> Changes in v5:
> - reset-author
> - use "__maybe_unused" annotation
> 
> Changes in v4:
> - use SIMPLE_DEV_PM_OPS for suspend/resume struct
> 
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/pinctrl/pinctrl-rockchip.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index 016f457..172ad1d 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1770,6 +1770,23 @@ static struct rockchip_pin_ctrl
> *rockchip_pinctrl_get_soc_data( return ctrl;
>  }
> 
> +static int __maybe_unused rockchip_pinctrl_suspend(struct device *dev)
> +{
> +	struct rockchip_pinctrl *info = dev_get_drvdata(dev);
> +
> +	return pinctrl_force_sleep(info->pctl_dev);
> +}
> +
> +static int __maybe_unused rockchip_pinctrl_resume(struct device *dev)
> +{
> +	struct rockchip_pinctrl *info = dev_get_drvdata(dev);
> +
> +	return pinctrl_force_default(info->pctl_dev);
> +}
> +
> +static SIMPLE_DEV_PM_OPS(rockchip_pinctrl_dev_pm_ops,
> rockchip_pinctrl_suspend, +			 rockchip_pinctrl_resume);
> +
>  static int rockchip_pinctrl_probe(struct platform_device *pdev)
>  {
>  	struct rockchip_pinctrl *info;
> @@ -1983,6 +2000,7 @@ static struct platform_driver rockchip_pinctrl_driver
> = { .driver = {
>  		.name	= "rockchip-pinctrl",
>  		.owner	= THIS_MODULE,
> +		.pm = &rockchip_pinctrl_dev_pm_ops,
>  		.of_match_table = rockchip_pinctrl_dt_match,
>  	},
>  };

