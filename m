Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaKWAyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 19:54:41 -0500
Received: from gloria.sntech.de ([95.129.55.99]:45572 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbaKWAyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 19:54:40 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Mike Turquette <mturquette@linaro.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: fix clock gate for rk3188 spdif_pre
Date: Sun, 23 Nov 2014 01:58:24 +0100
Message-ID: <4871254.UVsZ9NLXxR@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416562062-14286-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1416562062-14286-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. November 2014, 10:27:41 schrieb Julien CHAUVEAU:
> In rk3188 clock branches, spdif_pre gate was set to RK2928_CLKGATE_CON(13)
> bit 13. This appears to be a copy-paste error because such a register does
> not exist. We correct it to RK2928_CLKGATE_CON(0) and find out that the
> rk3188 spdif clock is the same as the rk3066 spdif clock, so we move it to
> the common clock branches.
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

applied to my clk branch for 3.19 after verifying the manual-values


Thanks
Heiko

> ---
>  drivers/clk/rockchip/clk-rk3188.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3188.c
> b/drivers/clk/rockchip/clk-rk3188.c index b0293c4..725d841 100644
> --- a/drivers/clk/rockchip/clk-rk3188.c
> +++ b/drivers/clk/rockchip/clk-rk3188.c
> @@ -330,6 +330,15 @@ static struct rockchip_clk_branch common_clk_branches[]
> __initdata = { RK2928_CLKSEL_CON(24), 8, 8, DFLAGS,
>  			RK2928_CLKGATE_CON(2), 8, GFLAGS),
> 
> +	COMPOSITE_NOMUX(0, "spdif_pre", "i2s_src", 0,
> +			RK2928_CLKSEL_CON(5), 0, 7, DFLAGS,
> +			RK2928_CLKGATE_CON(0), 13, GFLAGS),
> +	COMPOSITE_FRAC(0, "spdif_frac", "spdif_pll", 0,
> +			RK2928_CLKSEL_CON(9), 0,
> +			RK2928_CLKGATE_CON(0), 14, GFLAGS),
> +	MUX(SCLK_SPDIF, "sclk_spdif", mux_sclk_spdif_p, 0,
> +			RK2928_CLKSEL_CON(5), 8, 2, MFLAGS),
> +
>  	/*
>  	 * Clock-Architecture Diagram 4
>  	 */
> @@ -577,14 +586,6 @@ static struct rockchip_clk_branch
> rk3066a_clk_branches[] __initdata = { RK2928_CLKGATE_CON(0), 12, GFLAGS),
>  	MUX(SCLK_I2S2, "sclk_i2s2", mux_sclk_i2s2_p, 0,
>  			RK2928_CLKSEL_CON(4), 8, 2, MFLAGS),
> -	COMPOSITE_NOMUX(0, "spdif_pre", "i2s_src", 0,
> -			RK2928_CLKSEL_CON(5), 0, 7, DFLAGS,
> -			RK2928_CLKGATE_CON(0), 13, GFLAGS),
> -	COMPOSITE_FRAC(0, "spdif_frac", "spdif_pll", 0,
> -			RK2928_CLKSEL_CON(9), 0,
> -			RK2928_CLKGATE_CON(0), 14, GFLAGS),
> -	MUX(SCLK_SPDIF, "sclk_spdif", mux_sclk_spdif_p, 0,
> -			RK2928_CLKSEL_CON(5), 8, 2, MFLAGS),
> 
>  	GATE(HCLK_I2S1, "hclk_i2s1", "hclk_cpu", 0, RK2928_CLKGATE_CON(7), 3,
> GFLAGS), GATE(HCLK_I2S2, "hclk_i2s2", "hclk_cpu", 0, RK2928_CLKGATE_CON(7),
> 4, GFLAGS), @@ -675,14 +676,6 @@ static struct rockchip_clk_branch
> rk3188_clk_branches[] __initdata = { RK2928_CLKGATE_CON(0), 10, GFLAGS),
>  	MUX(SCLK_I2S0, "sclk_i2s0", mux_sclk_i2s0_p, 0,
>  			RK2928_CLKSEL_CON(3), 8, 2, MFLAGS),
> -	COMPOSITE_NOMUX(0, "spdif_pre", "i2s_src", 0,
> -			RK2928_CLKSEL_CON(5), 0, 7, DFLAGS,
> -			RK2928_CLKGATE_CON(13), 13, GFLAGS),
> -	COMPOSITE_FRAC(0, "spdif_frac", "spdif_pll", 0,
> -			RK2928_CLKSEL_CON(9), 0,
> -			RK2928_CLKGATE_CON(0), 14, GFLAGS),
> -	MUX(SCLK_SPDIF, "sclk_spdif", mux_sclk_spdif_p, 0,
> -			RK2928_CLKSEL_CON(5), 8, 2, MFLAGS),
> 
>  	GATE(0, "hclk_imem0", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 14, GFLAGS),
>  	GATE(0, "hclk_imem1", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 15, GFLAGS),

