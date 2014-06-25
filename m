Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaFYVCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:02:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34440 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaFYVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:02:17 -0400
Message-ID: <53AB38D6.6070901@wwwdotorg.org>
Date: Wed, 25 Jun 2014 15:02:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: tegra: fix vi_sensor clocks on Tegra124
References: <1403712609-13624-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1403712609-13624-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 10:10 AM, Peter De Schrijver wrote:
> vi_sensor and vi_sensor2 have a wrong hw clkid on Tegra124. Fix this by
> correcting the hw clkid for Tegra124 and creating the Tegra114 vi_sensor clock
> from its own data. Tegra124 was also using the wrong internal clock id.

> diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c

> -	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
> +	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 165, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
...
> -	MUX8("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_8),
> +	MUX8("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 164, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_8),

If I'm reading the TRM right, these are CAM_MCLK/CAM_MCLK2 in the
RST_DEV_X register. Is the TRM simply inconsistent in the naming of
these clocks, or is there some other inconsistency?

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> @@ -777,7 +784,6 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
>  	[tegra_clk_spdif_in] = { .dt_id = TEGRA114_CLK_SPDIF_IN, .present = true },
>  	[tegra_clk_spdif_out] = { .dt_id = TEGRA114_CLK_SPDIF_OUT, .present = true },
>  	[tegra_clk_vi_8] = { .dt_id = TEGRA114_CLK_VI, .present = true },
> -	[tegra_clk_vi_sensor_8] = { .dt_id = TEGRA114_CLK_VI_SENSOR, .present = true },

Does it make any sense to
s/tegra_clk_vi_sensor_8/tegra_clk_vi_sensor_114/ and put the definition
into the table in clk-tegra-periph.c instead? I suppose if this clock
definition is specific to Tegra114 there's not much point, so this is
probably fine. Hopefully the new tegra_clk_vi_sensor_8 lasts longer than
just Tegra124...

So overall, I think:
Acked-by: Stephen Warren <swarren@nvidia.com>
