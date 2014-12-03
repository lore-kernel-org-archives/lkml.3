Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaLCFN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:13:58 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50766 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaLCFN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:13:56 -0500
MIME-Version: 1.0
In-Reply-To: <1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
	<1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
Date: Tue, 2 Dec 2014 21:13:55 -0800
X-Google-Sender-Auth: ob0PSjid2eLb-KgXZ7897ApNXrQ
Message-ID: <CAD=FV=VupzfrWWkRMmQz_c57Gq59gmM4Oq=iYrYfHuTeR8giKQ@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Tue, Dec 2, 2014 at 6:37 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> high_ns calculated from the low division of CLKDIV register is the sum
> of actual measured high_ns and rise_ns. The rise time which related to
> external pull-up resistor can be up to the maximum rise time in I2C spec.
>
> In my test, if external pull-up resistor is 4.7K, rise_ns is about
> 700ns. So the actual measured high_ns is about 3900ns, which is less
> than 4000ns(the minimum high_ns in I2C spec).
>
> To fix this bug, min_low_ns should include fall time and min_high_ns
> should include rise time too.
>
> This patch merged the patch that Doug submitted to chromium, which
> can get the rise and fall times for signals from the device tree.
> This allows us to more accurately calculate timings. see:
> https://chromium-review.googlesource.com/#/c/232774/
>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - merged the patch that Doug submitted to chromium
>
>  Documentation/devicetree/bindings/i2c/i2c-rk3x.txt | 10 ++++
>  drivers/i2c/busses/i2c-rk3x.c                      | 55 +++++++++++++++-------
>  2 files changed, 47 insertions(+), 18 deletions(-)

This looks good to me.  Thank you for spinning.

Reviewed-by: Doug Anderson <dianders@chromium.org>
