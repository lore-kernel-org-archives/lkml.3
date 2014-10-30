Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbaJ3Sql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:46:41 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60930 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818AbaJ3Sqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:46:40 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] clk: rockchip: disable unused clocks
Date: Thu, 30 Oct 2014 19:46:14 +0100
Message-ID: <4026123.YoLyKQfs2g@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1414676335-20203-1-git-send-email-kever.yang@rock-chips.com>
References: <1414676335-20203-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Donnerstag, 30. Oktober 2014, 21:38:55 schrieb Kever Yang:
> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
> all the clocks are available like default power on state.
> We have implement the clock manage in most of rockchip drivers,
> it is time to remove it for power save.
> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
> be on during boot or no module driver in kernel will initialize it.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

I've tested this on all 3 currently supported Rockchip socs and was able to 
boot to an initramfs on all of them.

[...]

> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index 279a662..cf9d8b0 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c

[...]

> -	COMPOSITE_NOMUX(0, "armcore0", "armclk", 0,
> -			RK3288_CLKSEL_CON(36), 0, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "armcore0", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(36), 0, 3, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 0, GFLAGS),
> -	COMPOSITE_NOMUX(0, "armcore1", "armclk", 0,
> -			RK3288_CLKSEL_CON(36), 4, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "armcore1", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(36), 4, 3, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 1, GFLAGS),
> -	COMPOSITE_NOMUX(0, "armcore2", "armclk", 0,
> -			RK3288_CLKSEL_CON(36), 8, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "armcore2", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(36), 8, 3, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 2, GFLAGS),
> -	COMPOSITE_NOMUX(0, "armcore3", "armclk", 0,
> -			RK3288_CLKSEL_CON(36), 12, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "armcore3", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(36), 12, 3, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 3, GFLAGS),
> -	COMPOSITE_NOMUX(0, "l2ram", "armclk", 0,
> -			RK3288_CLKSEL_CON(37), 0, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "l2ram", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(37), 0, 3, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 4, GFLAGS),
> -	COMPOSITE_NOMUX(0, "aclk_core_m0", "armclk", 0,
> -			RK3288_CLKSEL_CON(0), 0, 4, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "aclk_core_m0", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(0), 0, 4, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 5, GFLAGS),
> -	COMPOSITE_NOMUX(0, "aclk_core_mp", "armclk", 0,
> -			RK3288_CLKSEL_CON(0), 4, 4, DFLAGS | CLK_DIVIDER_READ_ONLY,
> +	COMPOSITE_NOMUX(0, "aclk_core_mp", "armclk", CLK_IGNORE_UNUSED,
> +			RK3288_CLKSEL_CON(0), 4, 4, DFLAGS,
>  			RK3288_CLKGATE_CON(12), 6, GFLAGS),
>  	COMPOSITE_NOMUX(0, "atclk", "armclk", 0,
>  			RK3288_CLKSEL_CON(37), 4, 5, DFLAGS | CLK_DIVIDER_READ_ONLY,

For these clocks you're removing the READ_ONLY dvider-flags. If this is 
necessary for something it should be a separate patch.
In this change it is nevertheless unrelated.


Heiko
