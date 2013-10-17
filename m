Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab3JQP6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:58:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38467 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3JQP6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:58:45 -0400
Message-ID: <52600931.1020803@wwwdotorg.org>
Date: Thu, 17 Oct 2013 09:58:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/15] Introduce common infra for tegra clocks
References: <1382013674-12901-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1382013674-12901-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 06:41 AM, Peter De Schrijver wrote:
> This patchset introduces common infrastructure for clocks which exist in
> several Tegra SoCs. We also also move Tegra20, Tegra30 and Tegra114 to
> this new infrastructure.

This series, and the other series "[PATCH v3 0/7] Tegra124 clock support",

Tested-by: Stephen Warren <swarren@nvidia.com>

Patch 1 in this series also (or the whole lot if you want),
Acked-by: Stephen Warren <swarren@nvidia.com>

There are some ifdef issues though, which should be fixed before
actually applying this:

tegra_defconfig builds fine.

tegra_defconfig minus CONFIG_ARCH_TEGRA_114_SOC yields:

> drivers/clk/tegra/clk-pll.c:1734:12: error: ‘clk_pll_iddq_enable’ undeclared here (not in a function)
> drivers/clk/tegra/clk-pll.c:1735:13: error: ‘clk_pll_iddq_disable’ undeclared here (not in a function)
> drivers/clk/tegra/clk-pll.c:1737:16: error: ‘clk_pll_ramp_round_rate’ undeclared here (not in a function)
> drivers/clk/tegra/clk-pll.c:1738:14: error: ‘clk_pllxc_set_rate’ undeclared here (not in a function)
> drivers/clk/tegra/clk-pll.c: In function ‘tegra_clk_register_pllss’:
> drivers/clk/tegra/clk-pll.c:1781:2: error: implicit declaration of function ‘_clip_vco_min’ [-Werror=implicit-function-declaration]
> drivers/clk/tegra/clk-pll.c:1785:2: error: implicit declaration of function ‘_pll_fixed_mdiv’ [-Werror=implicit-function-declaration]

(Thanks for Aaron Plattner for pointing that out)

Can you please double-check all 15 valid combinations of
CONFIG_ARCH_TEGRA_xx_SOC to make sure they all build.
