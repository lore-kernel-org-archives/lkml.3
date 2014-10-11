Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaJKScj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:32:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56359 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbaJKSch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:32:37 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, dianders@chromium.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] clk: rockchip: fix parent for spdif_8ch_frac on rk3288
Date: Sat, 11 Oct 2014 20:32:28 +0200
Message-ID: <2955697.uCN2kRtiKs@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412758516-18285-1-git-send-email-sonnyrao@chromium.org>
References: <1412758516-18285-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonny,

Am Mittwoch, 8. Oktober 2014, 01:55:16 schrieb Sonny Rao:
> The parent should be spdif_8ch_pre not spdif_8ch_src, which doesn't
> exist and looks to be a typo.  The TRM also confirms this.

thanks for the catch. I've added the patch to a temporary branch for 3.19 till 
we have a stable 3.18-rc1.

As nothing uses the spdif so far I don't think we'll need the fix for 3.18 
itself. Please holler if you think otherwise :-)


Heiko

> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index 2327829..e41ae1f 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -325,7 +325,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[]
> __initdata = { COMPOSITE_NOMUX(0, "spdif_8ch_pre", "spdif_src", 0,
>  			RK3288_CLKSEL_CON(40), 0, 7, DFLAGS,
>  			RK3288_CLKGATE_CON(4), 7, GFLAGS),
> -	COMPOSITE_FRAC(0, "spdif_8ch_frac", "spdif_8ch_src", 0,
> +	COMPOSITE_FRAC(0, "spdif_8ch_frac", "spdif_8ch_pre", 0,
>  			RK3288_CLKSEL_CON(41), 0,
>  			RK3288_CLKGATE_CON(4), 8, GFLAGS),
>  	COMPOSITE_NODIV(SCLK_SPDIF8CH, "sclk_spdif_8ch", mux_spdif_8ch_p, 0,

