Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaJGQ4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:56:37 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61914 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbaJGQ4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <1412674438-26160-2-git-send-email-kever.yang@rock-chips.com>
References: <1412674438-26160-1-git-send-email-kever.yang@rock-chips.com>
	<1412674438-26160-2-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 7 Oct 2014 09:56:32 -0700
X-Google-Sender-Auth: U2lcmq0sO-3-BLHskOje21YVTao
Message-ID: <CAD=FV=VjgO=4j+5=yC+THE2hWM_zSXhyvo22oHHXOjm98LkaAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: rockchip: add 400MHz and 500MHz for rk3288 clock rate
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Tue, Oct 7, 2014 at 2:33 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add 400MHz and 500MHz to clock rate table for rk3288.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>  drivers/clk/rockchip/clk-rk3288.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index d053529..f6ea9c6 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -86,8 +86,10 @@ struct rockchip_pll_rate_table rk3288_pll_rates[] = {
>         RK3066_PLL_RATE( 594000000, 2, 198, 4),
>         RK3066_PLL_RATE( 552000000, 1, 46, 2),
>         RK3066_PLL_RATE( 504000000, 1, 84, 4),
> +       RK3066_PLL_RATE( 500000000, 3, 125, 2),
>         RK3066_PLL_RATE( 456000000, 1, 76, 4),
>         RK3066_PLL_RATE( 408000000, 1, 68, 4),
> +       RK3066_PLL_RATE( 400000000, 3, 50, 1),

This violates the constraints in the TRM.  That says:

Fvco = (Fin/NR)*NF value range requirement: 440MHz – 2200MHz

I believe you end up with 400Mhz, not 440.  Are you aware of this?  Is
there some reason it's OK to violate the TRM in this case?

-Doug
