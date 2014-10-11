Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaJKShh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:37:37 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56396 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaJKShf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:37:35 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, Sonny Rao <sonnyrao@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: Add CLK_SET_RATE_PARENT to aclk_cpu_pre
Date: Sat, 11 Oct 2014 20:37:20 +0200
Message-ID: <1438809.8b7neIcoln@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412615727-8772-1-git-send-email-dianders@chromium.org>
References: <1412615727-8772-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Am Montag, 6. Oktober 2014, 10:15:27 schrieb Doug Anderson:
> We'd like to be able to call clk_set_rate() on aclk_cpu (a gate) at
> bootup.  In order for this to have any effect we need its parent
> (aclk_cpu_pre) to percolate the rate change to _its_ parent
> (aclk_cpu_src).  Add CLK_SET_RATE_PARENT to make this happen.

added this to a branch for 3.19


Thanks
Heiko

> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index d053529..4d98f53 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -279,7 +279,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[]
> __initdata = { RK3288_CLKGATE_CON(0), 11, GFLAGS),
>  	COMPOSITE_NOGATE(0, "aclk_cpu_src", mux_aclk_cpu_src_p, 0,
>  			RK3288_CLKSEL_CON(1), 15, 1, MFLAGS, 3, 5, DFLAGS),
> -	DIV(0, "aclk_cpu_pre", "aclk_cpu_src", 0,
> +	DIV(0, "aclk_cpu_pre", "aclk_cpu_src", CLK_SET_RATE_PARENT,
>  			RK3288_CLKSEL_CON(1), 0, 3, DFLAGS),
>  	GATE(ACLK_CPU, "aclk_cpu", "aclk_cpu_pre", 0,
>  			RK3288_CLKGATE_CON(0), 3, GFLAGS),

