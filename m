Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaLDQJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:09:00 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:44121 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaLDQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:08:58 -0500
MIME-Version: 1.0
In-Reply-To: <1417661375-2872-1-git-send-email-addy.ke@rock-chips.com>
References: <1417661375-2872-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 4 Dec 2014 08:08:57 -0800
X-Google-Sender-Auth: FZnTXpxHKAV5vMdp2a8O2457QqU
Message-ID: <CAD=FV=U8eGRFs5G+QfuRF0z1y_7G540r+uCQzPtgOT=KKD7s0g@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: rockchip: set dw_mmc max-freq 150Mhz
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Alexandru Stan <amstan@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, han jiang <hj@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>, wei.luo@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Wed, Dec 3, 2014 at 6:49 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> All of mmc controllers include SDMMC, SDIO0, SDIO1, and EMMC on RK3288
> are limited to 150Mhz. It was mainly caused by two reasons:
> - RK3288's IO pad(except DDR IO pad) is generic, which can only support
>   the max of 150Mhz.
> - Mmc controller was designed at 150Mhz, and the pressure test by IC team
>   was based on this freequency point.
>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)

Your explanation is reasonable.  The 150MHz rate is also listed in the
latest datasheet.  It's unfortunate that we won't get full speed of
SDR104 or hs200 on this SoC, but correctness certainly outweighs
performance.

Reviewed-by: Doug Anderson <dianders@chromium.org>

I have tested that this prevents the speed from going above 150MHz on
rk3288-pinky on SD Cards, so:

Tested-by: Doug Anderson <dianders@chromium.org>

-Doug
