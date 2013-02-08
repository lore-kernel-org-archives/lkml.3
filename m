Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3BHFWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:22:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11723 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3BHFWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:22:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 07 Feb 2013 21:20:08 -0800
Message-ID: <51148B8C.2000005@nvidia.com>
Date: Fri, 8 Feb 2013 10:52:20 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: local arrays should be static
References: <1360254640-25831-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1360254640-25831-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013 10:00 PM, Peter De Schrijver wrote:
> cclk_g_parents, cclk_lp_parents and sclk_parents are only accessed from within
> clk-tegra30.c. Declare them static to avoid namespace polution.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>

> ---
>   drivers/clk/tegra/clk-tegra30.c |   20 ++++++++++----------
>   1 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
> index a163812..d169ef0 100644
> --- a/drivers/clk/tegra/clk-tegra30.c
> +++ b/drivers/clk/tegra/clk-tegra30.c
> @@ -1249,16 +1249,16 @@ static void __init tegra30_pmc_clk_init(void)
>   
>   }
>   
> -const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> -				 "pll_p_cclkg", "pll_p_out4_cclkg",
> -				 "pll_p_out3_cclkg", "unused", "pll_x" };
> -const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> -				  "pll_p_cclklp", "pll_p_out4_cclklp",
> -				  "pll_p_out3_cclklp", "unused", "pll_x",
> -				  "pll_x_out0" };
> -const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
> -			       "pll_p_out3", "pll_p_out2", "unused",
> -			       "clk_32k", "pll_m_out1" };
> +static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> +					"pll_p_cclkg", "pll_p_out4_cclkg",
> +					"pll_p_out3_cclkg", "unused", "pll_x" };
> +static const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> +					 "pll_p_cclklp", "pll_p_out4_cclklp",
> +					 "pll_p_out3_cclklp", "unused", "pll_x",
> +					 "pll_x_out0" };
> +static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
> +				      "pll_p_out3", "pll_p_out2", "unused",
> +				      "clk_32k", "pll_m_out1" };
>   
>   static void __init tegra30_super_clk_init(void)
>   {

