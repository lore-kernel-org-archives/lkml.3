Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaKDSIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:08:42 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:60273 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKDSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:08:38 -0500
MIME-Version: 1.0
In-Reply-To: <1415092270-24932-1-git-send-email-kever.yang@rock-chips.com>
References: <1415092270-24932-1-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 4 Nov 2014 10:08:38 -0800
X-Google-Sender-Auth: heZmVp-zVAMRjVJ4N5yMDyIX5oM
Message-ID: <CAD=FV=WAby=EdvpvqARG0c+1_jZOCWM_NAo2eEOR3+JvLC8d=Q@mail.gmail.com>
Subject: Re: [PATCH v5] clk: rockchip: disable unused clocks
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Tue, Nov 4, 2014 at 1:11 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
> all the clocks are available like default power on state.
> We have implement the clock manage in most of rockchip drivers,
> it is time to remove it for power save.
> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
> be on during boot or no module driver in kernel will initialize it.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> ---
>
> Changes in v5:
> - take CLK_IGNORE_UNUSED tag out of EMMC and UART2
> - take CLK_IGNORE_UNUSED tag out of pclk_publ*, pclk_ddrupctl*
> - add Doug's Reviewed-by and Tested-by

You also took CLK_IGNORE_UNUSED out of dclk_vop0.  I don't have a
problem with that since my test cases still work and I'm all for
removing as many of these as we can.


> Changes in v4:
> - add CLK_IGNORE_UNUSED tag for all the niu/arbi/matrix clock
>
> Changes in v3:
> - get CLK_DIVIDER_READ_ONLY tag back fro armcores
> - add CLK_IGNORE_UNUSED tag for cs_dbg, pclk_dgb_pre and pclk_rkpwm
>
> Changes in v2:
> - get some clock ID back
> - add CLK_IGNORE_UNUSED tag for aclk_strc and aclk_core in clk-rk3188.c
> - add CLK_IGNORE_UNUSED tag for rk3288 dwc2
>
>  drivers/clk/rockchip/clk-rk3188.c |  40 ++++++------
>  drivers/clk/rockchip/clk-rk3288.c | 132 +++++++++++++++++++-------------------
>  drivers/clk/rockchip/clk.c        |   9 ---
>  3 files changed, 86 insertions(+), 95 deletions(-)

For whatever reason this patch didn't apply super cleanly.  Maybe you
have other local patches to these files that you didn't send up?  It's
nice to post a patch directly atop some upstream tree.  I get:

fatal: sha1 information is lacking or useless
(drivers/clk/rockchip/clk-rk3288.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.

...but "patch -p1 < x" had no trouble applying for me...
