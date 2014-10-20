Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaJTMEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:04:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43755 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJTMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:04:14 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, cf@rock-chips.com, dkl@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Derek Basehore <dbasehore@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>, Jianqun <jay.xu@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: add npll to source of sclk_gpu
Date: Mon, 20 Oct 2014 14:03:55 +0200
Message-ID: <1597385.dcyynQU2fv@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1413499597-23908-1-git-send-email-kever.yang@rock-chips.com>
References: <1413499597-23908-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Donnerstag, 16. Oktober 2014, 15:46:36 schrieb Kever Yang:
> This patch make a common source for uart0 pll src and sclk_gpu,
> so that gpu can get its cloc from npll.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

I've added this to my v3.19-clk/next branch [after adding a small paragraph to 
the commit message, explaining why the gpu now also uses the npl].

Thanks
Heiko


> ---
> 
>  drivers/clk/rockchip/clk-rk3288.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index 504b6c2a..3f839cf 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -174,14 +174,14 @@ PNAME(mux_aclk_cpu_src_p)	= { "cpll_aclk_cpu",
> "gpll_aclk_cpu" }; PNAME(mux_pll_src_cpll_gpll_p)		= { "cpll", "gpll" };
>  PNAME(mux_pll_src_npll_cpll_gpll_p)	= { "npll", "cpll", "gpll" };
>  PNAME(mux_pll_src_cpll_gpll_npll_p)	= { "cpll", "gpll", "npll" };
> -PNAME(mux_pll_src_cpll_gpll_usb480m_p)	= { "cpll", "gpll", "usb480m" };
> +PNAME(mux_pll_src_cpll_gpll_usb480m_p)	= { "cpll", "gpll", "usbphy480m_src"
> }; +PNAME(mux_pll_src_cpll_gll_usb_npll_p)	= { "cpll", "gpll",
> "usbphy480m_src", "npll" };
> 
>  PNAME(mux_mmc_src_p)	= { "cpll", "gpll", "xin24m", "xin24m" };
>  PNAME(mux_i2s_pre_p)	= { "i2s_src", "i2s_frac", "ext_i2s", "xin12m" };
>  PNAME(mux_i2s_clkout_p)	= { "i2s_pre", "xin12m" };
>  PNAME(mux_spdif_p)	= { "spdif_pre", "spdif_frac", "xin12m" };
>  PNAME(mux_spdif_8ch_p)	= { "spdif_8ch_pre", "spdif_8ch_frac", "xin12m" };
> -PNAME(mux_uart0_pll_p)	= { "cpll", "gpll", "usbphy_480m_src", "npll" };
>  PNAME(mux_uart0_p)	= { "uart0_src", "uart0_frac", "xin24m" };
>  PNAME(mux_uart1_p)	= { "uart1_src", "uart1_frac", "xin24m" };
>  PNAME(mux_uart2_p)	= { "uart2_src", "uart2_frac", "xin24m" };
> @@ -427,7 +427,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[]
> __initdata = { RK3288_CLKSEL_CON(33), 0, 5, DFLAGS,
>  			RK3288_CLKGATE_CON(5), 8, GFLAGS),
> 
> -	COMPOSITE(SCLK_GPU, "sclk_gpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
> +	COMPOSITE(SCLK_GPU, "sclk_gpu", mux_pll_src_cpll_gll_usb_npll_p, 0,
>  			RK3288_CLKSEL_CON(34), 6, 2, MFLAGS, 0, 5, DFLAGS,
>  			RK3288_CLKGATE_CON(5), 7, GFLAGS),
> 
> @@ -504,7 +504,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[]
> __initdata = { RK3288_CLKSEL_CON(38), 15, 1, MFLAGS, 8, 5, DFLAGS,
>  			RK3288_CLKGATE_CON(5), 6, GFLAGS),
> 
> -	COMPOSITE(0, "uart0_src", mux_uart0_pll_p, 0,
> +	COMPOSITE(0, "uart0_src", mux_pll_src_cpll_gll_usb_npll_p, 0,
>  			RK3288_CLKSEL_CON(13), 13, 2, MFLAGS, 0, 7, DFLAGS,
>  			RK3288_CLKGATE_CON(1), 8, GFLAGS),
>  	COMPOSITE_FRAC(0, "uart0_frac", "uart0_src", 0,

