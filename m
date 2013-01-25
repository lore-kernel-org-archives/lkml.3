Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3AYEBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:01:45 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:59699 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3AYEBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:01:42 -0500
Message-ID: <1359086508.15047.0.camel@gitbox>
Subject: Re: [PATCH 5/7] clk: vt8500: Use common of_clk_init() function
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: josh.cartwright@ni.com, Prashant Gaikwad <pgaikwad@nvidia.com>,
        swarren@nvidia.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, maxime.ripard@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 25 Jan 2013 17:01:48 +1300
In-Reply-To: <20130124191534.10623.14882@quantum>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
	 <1357282858-2112-5-git-send-email-pgaikwad@nvidia.com>
	 <20130118175621.3982.82838@quantum> <1358543280.8280.2.camel@gitbox>
	 <20130124191534.10623.14882@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:15 -0800, Mike Turquette wrote:
> Quoting Tony Prisk (2013-01-18 13:08:00)
> > On Fri, 2013-01-18 at 09:56 -0800, Mike Turquette wrote:
> > > Quoting Prashant Gaikwad (2013-01-03 23:00:56)
> > > > Use common of_clk_init() function for clock initialization.
> > > > 
> > > > Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> > > 
> > > Tony,
> > > 
> > > Can I get a Tested-by from you before I take this in?
> > > 
> > Tested-by: Tony Prisk <linux@prisktech.co.nz>
> > 
> > FYI: This will need another patch to complete as we added another set of
> > clocks to this clk-vt8500.c for 3.9.
> > 
> 
> Tony, is the following patch correct?
> 
> 
> From 5b6e0adb69674c684c33503f50010644b049029c Mon Sep 17 00:00:00 2001
> From: Prashant Gaikwad <pgaikwad@nvidia.com>
> Date: Fri, 4 Jan 2013 12:30:56 +0530
> Subject: [PATCH] clk: vt8500: Use common of_clk_init() function
> 
> Use common of_clk_init() function for clock initialization.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> Tested-by: Tony Prisk <linux@prisktech.co.nz>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> [mturquette@linaro.org: added entry for wm8750-pll-clock]
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/clk-vt8500.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
> index 2515d4f..b5538bb 100644
> --- a/drivers/clk/clk-vt8500.c
> +++ b/drivers/clk/clk-vt8500.c
> @@ -291,7 +291,7 @@ static __init void vtwm_device_clk_init(struct device_node *node)
>  	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
>  	clk_register_clkdev(clk, clk_name, NULL);
>  }
> -
> +CLK_OF_DECLARE(vt8500_device, "via,vt8500-device-clock", vtwm_device_clk_init);
>  
>  /* PLL clock related functions */
>  
> @@ -612,26 +612,19 @@ static void __init vt8500_pll_init(struct device_node *node)
>  {
>  	vtwm_pll_clk_init(node, PLL_TYPE_VT8500);
>  }
> +CLK_OF_DECLARE(vt8500_pll, "via,vt8500-pll-clock", vt8500_pll_init);
>  
>  static void __init wm8650_pll_init(struct device_node *node)
>  {
>  	vtwm_pll_clk_init(node, PLL_TYPE_WM8650);
>  }
> +CLK_OF_DECLARE(wm8650_pll, "wm,wm8650-pll-clock", wm8650_pll_init);
>  
>  static void __init wm8750_pll_init(struct device_node *node)
>  {
>  	vtwm_pll_clk_init(node, PLL_TYPE_WM8750);
>  }
> -
> -static const __initconst struct of_device_id clk_match[] = {
> -	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
> -	{ .compatible = "via,vt8500-pll-clock", .data = vt8500_pll_init, },
> -	{ .compatible = "wm,wm8650-pll-clock", .data = wm8650_pll_init, },
> -	{ .compatible = "wm,wm8750-pll-clock", .data = wm8750_pll_init, },
> -	{ .compatible = "via,vt8500-device-clock",
> -					.data = vtwm_device_clk_init, },
> -	{ /* sentinel */ }
> -};
> +CLK_OF_DECLARE(wm8750_pll, "wm,wm8750-pll-clock", wm8750_pll_init);
>  
>  void __init vtwm_clk_init(void __iomem *base)
>  {
> @@ -640,5 +633,5 @@ void __init vtwm_clk_init(void __iomem *base)
>  
>  	pmc_base = base;
>  
> -	of_clk_init(clk_match);
> +	of_clk_init(NULL);
>  }

Yeap - this patch is fine.

Tested-by: Tony Prisk <linux@prisktech.co.nz>
Acked-by: Tony Prisk <linux@prisktech.co.nz>

Take your pick which signoff you want :)

Regards
Tony P

