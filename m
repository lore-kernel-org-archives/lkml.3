Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3FLApo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:45:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37190 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3FLApm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:45:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370442111-13215-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1370442111-13215-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130612004537.8816.13976@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: tegra: fix pllre initilization
Date: Tue, 11 Jun 2013 17:45:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-05 07:21:46)
> The PLLRE flags weren't set correctly. Fixed in this patch.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Taken into clk-next.

Thanks,
Mike

> ---
>  drivers/clk/tegra/clk-pll.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> index 4293643..197074a 100644
> --- a/drivers/clk/tegra/clk-pll.c
> +++ b/drivers/clk/tegra/clk-pll.c
> @@ -1424,7 +1424,7 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
>         struct tegra_clk_pll *pll;
>         struct clk *clk;
>  
> -       pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
> +       pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_LOCK_MISC;
>         pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
>                               freq_table, lock);
>         if (IS_ERR(pll))
> @@ -1451,7 +1451,6 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
>         val &= ~BIT(29);
>         pll_writel_misc(val, pll);
>  
> -       pll_flags |= TEGRA_PLL_LOCK_MISC;
>         clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
>                                       &tegra_clk_pllre_ops);
>         if (IS_ERR(clk))
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
