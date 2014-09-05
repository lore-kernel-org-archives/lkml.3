Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaIEPUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:20:33 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57093 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbaIEPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <54098DA6.4090704@rock-chips.com>
References: <1409884333-3544-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=W3JJM38v-X=pyLUjAzY3Ti88xUgWp9bMsX5dqp1gubpg@mail.gmail.com>
	<54098DA6.4090704@rock-chips.com>
Date: Fri, 5 Sep 2014 08:20:23 -0700
X-Google-Sender-Auth: qJzr8OnZZwU40ubHdUixzpKHwzg
Message-ID: <CAD=FV=WwCTRh44jTvTZoeFFACmWKeGyu=zWb1=BeimGMuT9r2Q@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: fix divisor calculation for SCL frequency
From: Doug Anderson <dianders@chromium.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, max.schwarz@online.de,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Fri, Sep 5, 2014 at 3:17 AM, addy ke <addy.ke@rock-chips.com> wrote:

> The following modifications is reasonable?
>
> static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
> {
>         unsigned long i2c_rate = clk_get_rate(i2c->clk);
>         unsigned int div;
>
>         /* set DIV = DIVH = DIVL
>          * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
>          *          = (clk rate) / (16 * (DIV + 1))
>          */
>         div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;
>
>         i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
> }

Yes, that looks much cleaner and is a nice solution, thanks!  Can you
send up a new patch version?

-Doug
