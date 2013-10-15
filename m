Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457Ab3JOTTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:19:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58377 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3JOTTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:19:49 -0400
Message-ID: <525D9550.2030701@wwwdotorg.org>
Date: Tue, 15 Oct 2013 13:19:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 11/19] clk: tegra: move periph clocks to common file
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-12-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-12-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> Introduce a new file for peripheral clocks common between several Tegra
> SoCs and move Tegra114 to this new infrastructure. Also PLLP and the PLLP_OUT
> clocks will be initialized here.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> @@ -966,22 +699,22 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
>  	[tegra_clk_pwm] = { .dt_id = TEGRA114_CLK_PWM, .present = true },
>  	[tegra_clk_i2s0] = { .dt_id = TEGRA114_CLK_I2S0, .present = true },
>  	[tegra_clk_i2s2] = { .dt_id = TEGRA114_CLK_I2S2, .present = true },
> -	[tegra_clk_epp] = { .dt_id = TEGRA114_CLK_EPP, .present = true },
> -	[tegra_clk_gr2d] = { .dt_id = TEGRA114_CLK_GR2D, .present = true },
> +	[tegra_clk_epp_8] = { .dt_id = TEGRA114_CLK_EPP, .present = true },
> +	[tegra_clk_gr2d_8] = { .dt_id = TEGRA114_CLK_GR2D, .present = true },
>  	[tegra_clk_usbd] = { .dt_id = TEGRA114_CLK_USBD, .present = true },
>  	[tegra_clk_isp] = { .dt_id = TEGRA114_CLK_ISP, .present = true },
> -	[tegra_clk_gr3d] = { .dt_id = TEGRA114_CLK_GR3D, .present = true },
> +	[tegra_clk_gr3d_8] = { .dt_id = TEGRA114_CLK_GR3D, .present = true },
...

Why the need to edit this table in this patch? Why not just get it right
in the previous patch, where it's first added?

> @@ -2166,9 +1606,10 @@ static void __init tegra114_clock_init(struct device_node *np)
>  
>  	tegra114_fixed_clk_init(clk_base);
>  	tegra114_pll_init(clk_base, pmc_base);
> -	tegra114_periph_clk_init(clk_base);
> +	tegra114_periph_clk_init(clk_base, pmc_base);
>  	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, &pll_a_params);
>  	tegra114_pmc_clk_init(pmc_base);
> +
>  	tegra114_super_clk_init(clk_base);

That seems like an unrelated whitespace change. There's one in the
previous patch too:

> @@ -502,7 +492,6 @@ static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
>  	{0, 0, 0, 0, 0, 0},
>  };
>  
> -
>  static struct tegra_clk_pll_params pll_a_params = {
>  	.input_min = 2000000,
>  	.input_max = 31000000,

