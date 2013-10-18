Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab3JRXaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:30:07 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:61624 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3JRXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:30:04 -0400
MIME-Version: 1.0
In-Reply-To: <1382102719-5531-11-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
	<1382102719-5531-11-git-send-email-pdeschrijver@nvidia.com>
Date: Fri, 18 Oct 2013 16:30:02 -0700
X-Google-Sender-Auth: VHIe8gceKLZ-8kl6DaTU9aBey24
Message-ID: <CAL1qeaGV7hUmFYZ1Gcent2GSL28OkYzp+_Z2UyaAbkrNJ-SvGg@mail.gmail.com>
Subject: Re: [PATCH v5 10/15] clk: tegra: move audio clk to common file
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> +#define PLL_BASE_LOCK BIT(27)
> +#define PLL_MISC_LOCK_ENABLE 18

It doesn't look like these are used anywhere.

> +static struct tegra_sync_source_initdata sync_source_clks[] __initdata = {
> +       { .name = "spdif_in_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_spdif_in_sync},

It's a little weird that we have macros for audio_clks and
audio2x_clks, but not for these.

> +       /* PLLA */
> +       dt_clk = tegra_lookup_dt_id(tegra_clk_pll_a, tegra_clks);
> +       if (dt_clk) {
> +               clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base,
> +                               pmc_base, 0, pll_a_params, NULL);
> +               clk_register_clkdev(clk, "pll_a", NULL);

Won't tegra_register_devclks() take care of this since there's an
entry for this in t114's devclks array?

> +               *dt_clk = clk;
> +       }
> +
> +       /* PLLA_OUT0 */
> +       dt_clk = tegra_lookup_dt_id(tegra_clk_pll_a_out0, tegra_clks);
> +       if (dt_clk) {
> +               clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
> +                               clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
> +                               8, 8, 1, NULL);
> +               clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
> +                               clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
> +                               CLK_SET_RATE_PARENT, 0, NULL);
> +               clk_register_clkdev(clk, "pll_a_out0", NULL);

Ditto.

Thanks,
Andrew
