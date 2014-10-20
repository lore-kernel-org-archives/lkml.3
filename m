Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaJTL4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:56:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43680 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbaJTL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:56:38 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jianqun <jay.xu@rock-chips.com>
Cc: mturquette@linaro.org, dianders@chromium.org, kever.yang@rock-chips.com,
        dbasehore@chromium.org, mark.yao@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH] clk: rockchip: rk3288: removing the CLK_SET_RATE_PARENT from i2s_clkout
Date: Mon, 20 Oct 2014 13:56:28 +0200
Message-ID: <1581410.KVPbBdLuDz@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1413798903-13967-1-git-send-email-jay.xu@rock-chips.com>
References: <1413798903-13967-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Oktober 2014, 17:55:03 schrieb Jianqun:
> Removing the CLK_SET_RATE_PARENT from i2s_clkout, to limit i2s0_clkout
> to select between its two parent without being able influence the core
> i2s clock.
> 
> Tested on rk3288 board, suggested by Heiko.
> 
> Signed-off-by: Jianqun <jay.xu@rock-chips.com>

applied this to my v3.19-clk/next branch


Thanks
Heiko

> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index 2327829..6f97fe4 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -305,7 +305,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[]
> __initdata = { RK3288_CLKGATE_CON(4), 2, GFLAGS),
>  	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
>  			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
> -	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, CLK_SET_RATE_PARENT,
> +	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, 0,
>  			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
>  			RK3288_CLKGATE_CON(4), 0, GFLAGS),
>  	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,

