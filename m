Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaGAJBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:01:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48071 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813AbaGAJBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:01:20 -0400
Date: Tue, 1 Jul 2014 10:01:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: jianqun <xjq@rock-chips.com>
Cc: "heiko@sntech.de" <heiko@sntech.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "zhangqing@rock-chips.com" <zhangqing@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "yzq@rock-chips.com" <yzq@rock-chips.com>,
        "zhenfu.fang@rock-chips.com" <zhenfu.fang@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "kfx@rock-chips.com" <kfx@rock-chips.com>
Subject: Re: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
Message-ID: <20140701090114.GJ28740@leverpostej>
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
 <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
Thread-Topic: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:47:38AM +0100, jianqun wrote:
> From: Jianqun Xu <xjq@rock-chips.com>
>
> Add driver for I2S controller in Rockchip RK3xxx SoCs.
>
> This driver patch has been tested on the RK3288 SDK board.
>
> Signed-off-by: Jianqun Xu <xjq@rock-chips.com>
> ---
>  sound/soc/Kconfig                 |    1 +
>  sound/soc/Makefile                |    1 +
>  sound/soc/rockchip/Kconfig        |   16 +
>  sound/soc/rockchip/Makefile       |    6 +
>  sound/soc/rockchip/i2s.h          |  222 +++++++++++++
>  sound/soc/rockchip/pcm.h          |   14 +
>  sound/soc/rockchip/rockchip_i2s.c |  622 +++++++++++++++++++++++++++++++++++++
>  sound/soc/rockchip/rockchip_pcm.c |   64 ++++
>  8 files changed, 946 insertions(+)
>  create mode 100644 sound/soc/rockchip/Kconfig
>  create mode 100644 sound/soc/rockchip/Makefile
>  create mode 100644 sound/soc/rockchip/i2s.h
>  create mode 100644 sound/soc/rockchip/pcm.h
>  create mode 100644 sound/soc/rockchip/rockchip_i2s.c
>  create mode 100644 sound/soc/rockchip/rockchip_pcm.c

[...]

> +static int rockchip_i2s_probe(struct platform_device *pdev)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct rk_i2s_dev *i2s;
> +       struct resource *res;
> +       int ret;
> +
> +       i2s = devm_kzalloc(&pdev->dev, sizeof(struct rk_i2s_dev),
> +                               GFP_KERNEL);

You can use sizeof(*i2s) here.

[...]

> +       /* Try to set the I2S Channel id from dt */
> +       pdev->id = of_alias_get_id(np, "i2s");
> +       dev_set_name(&pdev->dev, "%s.%d",
> +                               pdev->dev.driver->name,
> +                               pdev->id);

This wasn't mentioned in the binding.

Cheers,
Mark.
