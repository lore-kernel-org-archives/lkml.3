Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3BATkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:40:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4986 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3BATkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:40:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 01 Feb 2013 11:38:31 -0800
Message-ID: <510C1A2E.5010408@nvidia.com>
Date: Fri, 1 Feb 2013 14:40:30 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 04/10] clk: tegra: Add new fields and PLL types for
 Tegra114
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359713962-16822-5-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/2013 5:18 AM, Peter De Schrijver wrote:
> Tegra114 introduces new PLL types. This requires new clocktypes as well
> as some new fields in the pll structure.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>   drivers/clk/tegra/clk-pll.c |  719 +++++++++++++++++++++++++++++++++++++++++++
>   drivers/clk/tegra/clk.h     |   47 +++
>   2 files changed, 766 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> index 87d2f34..50114b7 100644
> --- a/drivers/clk/tegra/clk-pll.c
> +++ b/drivers/clk/tegra/clk-pll.c
> [snip]
> +struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
> +                         void __iomem *clk_base, void __iomem *pmc,
> +                         unsigned long flags, unsigned long fixed_rate,
> +                         struct tegra_clk_pll_params *pll_params,
> +                         u32 pll_flags,
> +                         struct tegra_clk_pll_freq_table *freq_table,
> +                         spinlock_t *lock)
> +{
> +       if (!pll_params->pdiv_tohw)
> +               return -EINVAL;
> +
This will cause the following warning:
warning: return makes pointer from integer without a cast

Same with occurrences in tegra_clk_register_pllm and 
tegra_clk_register_pllc.

Should this instead be returning NULL?

-rhyland

-- 
nvpublic

