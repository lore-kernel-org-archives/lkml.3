Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab3JOTNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:13:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44822 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab3JOTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:13:48 -0400
Message-ID: <525D93E8.1010903@wwwdotorg.org>
Date: Tue, 15 Oct 2013 13:13:44 -0600
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
Subject: Re: [PATCH v3 10/19] clk: tegra: move audio clk to common file
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-11-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-11-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> Move audio clocks and PLLA initialization to a common file so it can be used by
> multiple Tegra SoCs.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> +static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
> +	[tegra_clk_rtc] = { .dt_id = TEGRA114_CLK_RTC, .present = true },
> +	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },
> +	[tegra_clk_uarta] = { .dt_id = TEGRA114_CLK_UARTA, .present = true },
...
> @@ -2194,7 +2167,7 @@ static void __init tegra114_clock_init(struct device_node *np)
...
> +	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, &pll_a_params);

I think it's worth explaining in the commit description why an array of
not-remotely-audio-related clocks is being passed into an
audio-clock-initialization function.

I see now that it's because not all SoCs have the same set of clocks,
and this table is what tells the common audio code which clocks to
actually create for this SoC, but that wasn't obvious, and hence should
be explicitly described.
