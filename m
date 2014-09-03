Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbaICVvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:51:42 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42379 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbaICVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <1409763974-29854-1-git-send-email-zyw@rock-chips.com>
References: <1409752307-29044-1-git-send-email-zyw@rock-chips.com>
	<1409763974-29854-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 3 Sep 2014 14:51:38 -0700
X-Google-Sender-Auth: 2Ii12jTmpaoldV5NUne6MBfSGiU
Message-ID: <CAD=FV=Xzz=SCHC1T5K1s1BcoLZGhUvYf+QMFUEyaPFZsHtSwfA@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] regulator: RK808: Remove pdata from the regulator
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Sep 3, 2014 at 10:06 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> Tested-by: Heiko <heiko@sntech.de>
> ---
>
> Changes in v8:
> Adviced by Doug
> - remove rk808_regulator_dts() function
> - remove the check about "client->dev.of_node"

Nice, this cleaned this up a lot.  Thanks!


>  static int rk808_regulator_probe(struct platform_device *pdev)
>  {
>         struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
>         struct i2c_client *client = rk808->i2c;
> -       struct rk808_board *pdata = dev_get_platdata(&client->dev);
>         struct regulator_config config = {};
>         struct regulator_dev *rk808_rdev;
> -       struct regulator_init_data *reg_data;
> -       int i = 0;

As Heiko mentioned, you need "struct device_node *np, *reg_np;" here.

>         int ret = 0;
> +       int i = 0;

nit: I think neither "ret" nor "i" needs to be initted here.


Otherwise I agree that this looks really good!

-Doug
