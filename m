Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3JQW7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:59:34 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33940 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JQW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:59:32 -0400
MIME-Version: 1.0
In-Reply-To: <1382013526-12800-7-git-send-email-pdeschrijver@nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
	<1382013526-12800-7-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 17 Oct 2013 15:59:30 -0700
X-Google-Sender-Auth: hU7bwYFP1CXG6tK8UE5KyIzhVlU
Message-ID: <CAL1qeaH+DVdjB-jJMhqKWbFG7TtTAgOuSk3esRh_HPT4YfwPdA@mail.gmail.com>
Subject: Re: [PATCH v4 06/15] clk: tegra: move fields to tegra_clk_pll_params
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> @@ -1682,17 +1664,15 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
>  struct clk *tegra_clk_register_plle_tegra114(const char *name,
>                                 const char *parent_name,
>                                 void __iomem *clk_base, unsigned long flags,
> -                               unsigned long fixed_rate,
>                                 struct tegra_clk_pll_params *pll_params,
> -                               struct tegra_clk_pll_freq_table *freq_table,
>                                 spinlock_t *lock)
>  {
>         struct tegra_clk_pll *pll;
>         struct clk *clk;
>         u32 val, val_aux;
>
> -       pll = _tegra_init_pll(clk_base, NULL, fixed_rate, pll_params,
> -                             TEGRA_PLL_HAS_LOCK_ENABLE, freq_table, lock);
> +       pll_params->flags = TEGRA_PLL_HAS_LOCK_ENABLE;

Why are we just overwriting the flags?  We pass in flags here:

> @@ -661,6 +685,9 @@ static struct tegra_clk_pll_params pll_e_params = {
>         .lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
>         .lock_delay = 300,
>         .div_nmp = &plle_nmp,
> +       .freq_table = pll_e_freq_table,
> +       .flags = TEGRA_PLL_FIXED,

TEGRA_PLL_FIXED doesn't actually make a difference in the
plle_tegra114 case, but it would be nice to be correct about setting
it.

Thanks,
Andrew
