Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab3FSEoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:44:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9833 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3FSEoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:44:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 18 Jun 2013 21:43:02 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Wed, 19 Jun 2013 10:14:24 +0530
Subject: RE: [PATCH 3.9-stable] ARM: tegra30: clocks: Fix pciex clock
 registration
Thread-Topic: [PATCH 3.9-stable] ARM: tegra30: clocks: Fix pciex clock
 registration
Thread-Index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkhkJMAQebi3wAAAo4zAAZZSxgAAJq7hA
Message-ID: <C79B248886DD134989C8FF6B096A91AB91CF1615D9@BGMAIL01.nvidia.com>
References: <003501ce6c82$9be49440$d3adbcc0$%choi@samsung.com>
In-Reply-To: <003501ce6c82$9be49440$d3adbcc0$%choi@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Stephen to suggest

> -----Original Message-----
> From: Jonghwan Choi [mailto:jhbird.choi@samsung.com]
> Sent: Wednesday, June 19, 2013 5:49 AM
> To: 'Jonghwan Choi'; linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org; Jay Agarwal
> Subject: [PATCH 3.9-stable] ARM: tegra30: clocks: Fix pciex clock registration
> 
> This patch looks like it should be in the 3.9-stable tree, should we apply it?
> 
> ------------------
> 
> From: "Jay Agarwal <jagarwal@nvidia.com>"
> 
> commit ff49fad1d9bf2c49f52817b04cde8e4412434637 upstream
> 
> Registering pciex as peripheral clock instead of fixed clock as
> tegra_perih_reset_assert(deassert) api of this clock api gives warning and
> ultimately does not succeed to assert(deassert)
> 
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/clk/tegra/clk-tegra30.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
> index ba6f51b..1f8595b 100644
> --- a/drivers/clk/tegra/clk-tegra30.c
> +++ b/drivers/clk/tegra/clk-tegra30.c
> @@ -1592,6 +1592,12 @@ static void __init tegra30_periph_clk_init(void)
>  	clk_register_clkdev(clk, "afi", "tegra-pcie");
>  	clks[afi] = clk;
> 
> +	/* pciex */
> +	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base,
> 0,
> +				    74, &periph_u_regs,
> periph_clk_enb_refcnt);
> +	clk_register_clkdev(clk, "pciex", "tegra-pcie");
> +	clks[pciex] = clk;
> +
>  	/* kfuse */
>  	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
>  				    TEGRA_PERIPH_ON_APB,
> @@ -1710,11 +1716,6 @@ static void __init tegra30_fixed_clk_init(void)
>  				1, 0, &cml_lock);
>  	clk_register_clkdev(clk, "cml1", NULL);
>  	clks[cml1] = clk;
> -
> -	/* pciex */
> -	clk = clk_register_fixed_rate(NULL, "pciex", "pll_e", 0, 100000000);
> -	clk_register_clkdev(clk, "pciex", NULL);
> -	clks[pciex] = clk;
>  }
> 
>  static void __init tegra30_osc_clk_init(void)
> --
> 1.7.9.5

