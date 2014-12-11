Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbaLKSJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:09:42 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59065 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaLKSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <1418291722-25448-2-git-send-email-lyz@rock-chips.com>
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com>
	<1418291722-25448-2-git-send-email-lyz@rock-chips.com>
Date: Thu, 11 Dec 2014 10:09:40 -0800
X-Google-Sender-Auth: scArC3anZrOAIqZ5FQ77HhygCjI
Message-ID: <CAD=FV=WcAJAgj2triu1W4863BT1ew2wf-z6YNHHwiDKpnYmK4w@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
From: Doug Anderson <dianders@chromium.org>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, jwerner@chromium.org,
        Olof Johansson <olof@lixom.net>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunzhi,

On Thu, Dec 11, 2014 at 1:55 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
> +               rk_phy->clk = of_clk_get(child, 0);
> +               if (IS_ERR(rk_phy->clk)) {
> +                       dev_warn(dev, "failed to get clock\n");
> +                       rk_phy->clk = NULL;
> +               }

The device tree bindings don't specify a clock and the "dtsi" added to
rk3288 don't reference a clock.  Take that code out and avoid a
warning in the logs at bootup.

...or should there be a clock?


> +               rk_phy->phy = devm_phy_create(dev, NULL, &ops);

This has the wrong number of arguments.  Even before the change that
added the 4th argument, this is still wrong because "ops" is supposed
to be the 2nd argument, not the 3rd.

...so I'm confused how this compiled for you.  I think this ought to be:

rk_phy->phy = devm_phy_create(dev, child, &ops, NULL);

...but please correct me if I'm mistaken!
