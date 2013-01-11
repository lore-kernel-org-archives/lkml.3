Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3AKMRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:17:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12925 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:17:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jan 2013 04:17:18 -0800
Date: Fri, 11 Jan 2013 14:17:25 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/9] clk: tegra: add clock support for tegra30
Message-ID: <20130111141725.ce3177ad04fc700186dc694d@nvidia.com>
In-Reply-To: <1357890387-23245-8-git-send-email-pgaikwad@nvidia.com>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
	<1357890387-23245-8-git-send-email-pgaikwad@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 08:46:25 +0100
Prashant Gaikwad <pgaikwad@nvidia.com> wrote:

> Add tegra30 clock support based on common clock framework.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
.......
> +static void __init tegra30_pll_init(void)
> +{
> +       struct clk *clk;
> +
> +       /* PLLC */
> +       clk = tegra_clk_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
> +                           0, &pll_c_params,
> +                           TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
> +                           pll_c_freq_table, NULL);
> +       clk_register_clkdev(clk, "pll_c", NULL);
> +       clks[pll_c] = clk;

Just I noticed that there are quite many same itegration of:

	clk_register_clkdev(clk, <ID name>, ?);
	clks[<ID>] = clk;

ID == <ID name>

Can any macro/func do the above at once?
