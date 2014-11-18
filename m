Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaKRVfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:35:09 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34908 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbaKRVfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:35:06 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1416312860-4446-15-git-send-email-tomeu.vizoso@collabora.com>
Cc: "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Alexandre Courbot" <gnurou@gmail.com>, linux-kernel@vger.kernel.org
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416312860-4446-15-git-send-email-tomeu.vizoso@collabora.com>
Message-ID: <20141118213500.25314.17794@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 14/14] clk: tegra: Set the EMC clock as the parent of the MC
 clock
Date: Tue, 18 Nov 2014 13:35:00 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomeu Vizoso (2014-11-18 04:13:16)
> On Tegra124, as we now have a proper driver for the EMC.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Looks good to me.

Regards,
Mike

> ---
>  drivers/clk/tegra/clk-tegra124.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
> index d56d1e2..0ac43d6 100644
> --- a/drivers/clk/tegra/clk-tegra124.c
> +++ b/drivers/clk/tegra/clk-tegra124.c
> @@ -150,11 +150,6 @@ static const char *mux_plld_out0_plld2_out0[] = {
>  };
>  #define mux_plld_out0_plld2_out0_idx NULL
>  
> -static const char *mux_pllmcp_clkm[] = {
> -       "pll_m", "pll_c", "pll_p", "clk_m", "pll_m_ud", "pll_c2", "pll_c3",
> -};
> -#define mux_pllmcp_clkm_idx NULL
> -
>  static struct div_nmp pllxc_nmp = {
>         .divm_shift = 0,
>         .divm_width = 8,
> @@ -1123,13 +1118,7 @@ static __init void tegra124_periph_clk_init(void __iomem *clk_base,
>                                clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
>         clks[TEGRA124_CLK_DSIB_MUX] = clk;
>  
> -       /* emc mux */
> -       clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
> -                              ARRAY_SIZE(mux_pllmcp_clkm), 0,
> -                              clk_base + CLK_SOURCE_EMC,
> -                              29, 3, 0, &emc_lock);
> -
> -       clk = tegra_clk_register_mc("mc", "emc_mux", clk_base + CLK_SOURCE_EMC,
> +       clk = tegra_clk_register_mc("mc", "emc", clk_base + CLK_SOURCE_EMC,
>                                     &emc_lock);
>         clks[TEGRA124_CLK_MC] = clk;
>  
> -- 
> 1.9.3
> 
