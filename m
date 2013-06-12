Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3FLA03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:26:29 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47570 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab3FLA01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:26:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370439442-30852-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1370439442-30852-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130612002623.8816.29653@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: tegra: pllp_out2 divider is int only
Date: Tue, 11 Jun 2013 17:26:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-05 06:37:17)
> The pllp_out2 should be integer only, the fractional bit should always be 0.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Taken into clk-next.

Thanks,
Mike

> ---
>  drivers/clk/tegra/clk-tegra114.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> index eb27764..5e029fe 100644
> --- a/drivers/clk/tegra/clk-tegra114.c
> +++ b/drivers/clk/tegra/clk-tegra114.c
> @@ -1203,8 +1203,8 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
>         /* PLLP_OUT2 */
>         clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
>                                 clk_base + PLLP_OUTA, 0, TEGRA_DIVIDER_FIXED |
> -                               TEGRA_DIVIDER_ROUND_UP, 24, 8, 1,
> -                               &pll_div_lock);
> +                               TEGRA_DIVIDER_ROUND_UP | TEGRA_DIVIDER_INT, 24,
> +                               8, 1, &pll_div_lock);
>         clk = tegra_clk_register_pll_out("pll_p_out2", "pll_p_out2_div",
>                                 clk_base + PLLP_OUTA, 17, 16,
>                                 CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
