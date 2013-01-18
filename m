Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3ARR41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:56:27 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42884 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3ARR40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:56:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Prashant Gaikwad <pgaikwad@nvidia.com>, <swarren@nvidia.com>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <maxime.ripard@free-electrons.com>,
        <linux@prisktech.co.nz>, <josh.cartwright@ni.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1357282858-2112-5-git-send-email-pgaikwad@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
 <1357282858-2112-5-git-send-email-pgaikwad@nvidia.com>
Message-ID: <20130118175621.3982.82838@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 5/7] clk: vt8500: Use common of_clk_init() function
Date: Fri, 18 Jan 2013 09:56:21 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Prashant Gaikwad (2013-01-03 23:00:56)
> Use common of_clk_init() function for clock initialization.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Tony,

Can I get a Tested-by from you before I take this in?

Thanks,
Mike

> ---
>  drivers/clk/clk-vt8500.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
> index fe25570..3ce1c3e 100644
> --- a/drivers/clk/clk-vt8500.c
> +++ b/drivers/clk/clk-vt8500.c
> @@ -272,7 +272,7 @@ static __init void vtwm_device_clk_init(struct device_node *node)
>         rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
>         clk_register_clkdev(clk, clk_name, NULL);
>  }
> -
> +CLK_OF_DECLARE(vt8500_device, "via,vt8500-device-clock", vtwm_device_clk_init);
>  
>  /* PLL clock related functions */
>  
> @@ -502,20 +502,13 @@ static void __init vt8500_pll_init(struct device_node *node)
>  {
>         vtwm_pll_clk_init(node, PLL_TYPE_VT8500);
>  }
> +CLK_OF_DECLARE(vt8500_pll, "via,vt8500-pll-clock", vt8500_pll_init);
>  
>  static void __init wm8650_pll_init(struct device_node *node)
>  {
>         vtwm_pll_clk_init(node, PLL_TYPE_WM8650);
>  }
> -
> -static const __initconst struct of_device_id clk_match[] = {
> -       { .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
> -       { .compatible = "via,vt8500-pll-clock", .data = vt8500_pll_init, },
> -       { .compatible = "wm,wm8650-pll-clock", .data = wm8650_pll_init, },
> -       { .compatible = "via,vt8500-device-clock",
> -                                       .data = vtwm_device_clk_init, },
> -       { /* sentinel */ }
> -};
> +CLK_OF_DECLARE(wm8650_pll, "wm,wm8650-pll-clock", wm8650_pll_init);
>  
>  void __init vtwm_clk_init(void __iomem *base)
>  {
> @@ -524,5 +517,5 @@ void __init vtwm_clk_init(void __iomem *base)
>  
>         pmc_base = base;
>  
> -       of_clk_init(clk_match);
> +       of_clk_init(NULL);
>  }
> -- 
> 1.7.4.1
