Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3IWSey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:34:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47055 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3IWSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:34:52 -0400
Message-ID: <524089C8.4010108@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:34:48 -0600
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
Subject: Re: [PATCH 10/12] clk: tegra: move fixed clocks to common file
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-11-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-11-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:41 AM, Peter De Schrijver wrote:
> Introduce a new file for fixed clocks common between several Tegra
> SoCs and move Tegra114 to this new infrastructure.

> diff --git a/drivers/clk/tegra/clk-tegra-fixed.c b/drivers/clk/tegra/clk-tegra-fixed.c

> +void __init tegra_fixed_clk_init(struct tegra_clk *tegra_clks)

> +	/* clk_m_div2 */
> +	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m_div2, tegra_clks);
> +	if (dt_clk) {
> +		clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
> +					CLK_SET_RATE_PARENT, 1, 2);
> +		clk_register_clkdev(clk, "clk_m_div2", NULL);
> +		*dt_clk = clk;
> +	}

I guess "fixed" means "fixed at run-time", not "identical rate in all
systems"? Since this is the crystal rate, it can vary between boards,
but I supposed if "fixed" means "fixed at run-time", considering this as
a fixed clock is fine.

But, isn't clk_m also a fixed clock then? I would expect one or two more
clocks in this file. What about clk_s, or is that known as clk_32k here?
