Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3BDHLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:11:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11574 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3BDHLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:11:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 03 Feb 2013 23:10:56 -0800
Message-ID: <510F5EF7.9030201@nvidia.com>
Date: Mon, 4 Feb 2013 12:40:47 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 10/10] clk: tegra: devicetree match for nvidia,tegra114-car
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-11-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359713962-16822-11-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2013 03:48 PM, Peter De Schrijver wrote:
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---

Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>

>   drivers/clk/tegra/clk.c |    1 +
>   drivers/clk/tegra/clk.h |    7 +++++++
>   2 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> index a603b9a..a328365 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -76,6 +76,7 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
>   static const struct of_device_id tegra_dt_clk_match[] = {
>   	{ .compatible = "nvidia,tegra20-car", .data = tegra20_clock_init },
>   	{ .compatible = "nvidia,tegra30-car", .data = tegra30_clock_init },
> +	{ .compatible = "nvidia,tegra114-car", .data = tegra114_clock_init },
>   	{ }
>   };
>   
> diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
> index 8756d9f..8097850 100644
> --- a/drivers/clk/tegra/clk.h
> +++ b/drivers/clk/tegra/clk.h
> @@ -576,4 +576,11 @@ void tegra30_clock_init(struct device_node *np);
>   static inline void tegra30_clock_init(struct device_node *np) {}
>   #endif /* CONFIG_ARCH_TEGRA_3x_SOC */
>   
> +#ifdef CONFIG_ARCH_TEGRA_114_SOC
> +void tegra114_clock_init(struct device_node *np);
> +#else
> +static inline void tegra114_clock_init(struct device_node *np) {}
> +#endif /* CONFIG_ARCH_TEGRA114_SOC */
> +
> +
>   #endif /* TEGRA_CLK_H */
>

