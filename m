Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3IWSWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:22:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60666 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3IWSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:22:35 -0400
Message-ID: <524086E7.3020903@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:22:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 07/12] clk: tegra: move audio clk to common file
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-8-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-8-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:40 AM, Peter De Schrijver wrote:
> Move audio clocks and PLLA initialization to a common file so it can be used by
> multiple Tegra SoCs.

> diff --git a/drivers/clk/tegra/clk-tegra-audio.c b/drivers/clk/tegra/clk-tegra-audio.c

> +static struct div_nmp pllp_nmp = {
> +	.divm_shift = 0,
> +	.divm_width = 5,
> +	.divn_shift = 8,
> +	.divn_width = 10,
> +	.divp_shift = 20,
> +	.divp_width = 3,
> +};
> +
> +static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
> +	{9600000, 282240000, 147, 5, 0, 4},
> +	{9600000, 368640000, 192, 5, 0, 4},
> +	{9600000, 240000000, 200, 8, 0, 8},
> +
> +	{28800000, 282240000, 245, 25, 0, 8},
> +	{28800000, 368640000, 320, 25, 0, 8},
> +	{28800000, 240000000, 200, 24, 0, 8},
> +	{0, 0, 0, 0, 0, 0},
> +};
> +
> +static struct tegra_clk_pll_params pll_a_params = {
> +	.input_min = 2000000,
> +	.input_max = 31000000,
> +	.cf_min = 1000000,
> +	.cf_max = 6000000,
> +	.vco_min = 200000000,
> +	.vco_max = 700000000,
> +	.base_reg = PLLA_BASE,
> +	.misc_reg = PLLA_MISC,
> +	.lock_mask = PLL_BASE_LOCK,
> +	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
> +	.lock_delay = 300,
> +	.div_nmp = &pllp_nmp,
> +};

I'm not convinced any of those tables are common across SoCs. In fact, I
can see definite differences in those tables between the 3 SoCs we
already have upstream... How will this be handled once you've enhanced
this series to handle all supported SoCs?
