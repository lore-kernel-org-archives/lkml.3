Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3IWSbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:31:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60861 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3IWSbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:31:47 -0400
Message-ID: <5240890F.6050807@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:31:43 -0600
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
Subject: Re: [PATCH 08/12] clk: tegra: move periph clocks to common file
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-9-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-9-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:41 AM, Peter De Schrijver wrote:
> Introduce a new file for peripheral clocks common between several Tegra
> SoCs and move Tegra114 to this new infrastructure. Also PLLP and the PLLP_OUT
> clocks will be initialized here.

> diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c

Similarly here: don't the following differences exist between the SoCs:

* At least the set of extant peripheral clocks, and perhaps some
parameters of those clocks.

* The set of legal parents for some peripheral clocks (?)

* pll_p frequency table, params, nmp bit positions in registers (?)

I'd really like to see this series completed so it's obvious exactly
what data/code really is common, and hence whether it makes sense to
move everything into a single cross-SoC clk-tegra-periph.c, or whether
some parts should be kept in the per-SoC files.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> @@ -2107,9 +1503,10 @@ static void __init tegra114_clock_init(struct device_node *np)
...
>  	tegra114_pmc_clk_init(pmc_base);
> +
>  	tegra114_super_clk_init(clk_base);

Seems superfluous.

