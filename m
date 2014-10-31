Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaJaFOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 01:14:19 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46685 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaJaFOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 01:14:16 -0400
MIME-Version: 1.0
In-Reply-To: <1414727409-6765-1-git-send-email-addy.ke@rock-chips.com>
References: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
	<1414727409-6765-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 30 Oct 2014 22:14:15 -0700
X-Google-Sender-Auth: LDkUln8E9uAe7BjhKqWrb3fSaMA
Message-ID: <CAD=FV=VegP+6QDEmiU6J9GuT9Sv7yJ_1bQiNhTfFqcXs6hsUkQ@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: add support for the other bit of sdio interrupt
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Thu, Oct 30, 2014 at 8:50 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> +static int dw_mci_rk3288_parse_dt(struct dw_mci *host)
> +{
> +       struct device_node *np = host->dev->of_node;
> +       int sdio_id0;
> +
> +       if (!of_property_read_u32(np, "rockchip,sdio-interrupt-slot0",
> +                                 &sdio_id0))
> +               host->sdio_id0 = sdio_id0;

This function is only run on rk3288 and on all rk3288 SoCs this value
is exactly 8.  Just replace this with:

  /* SDIO IRQ shows up as if it were slot 8 on rk3288 SoCs */
  host->sdio_id0 = 8;
