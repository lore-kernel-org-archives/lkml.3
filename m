Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ARR6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:58:33 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41828 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3ARR6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:58:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Prashant Gaikwad <pgaikwad@nvidia.com>, <swarren@nvidia.com>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <maxime.ripard@free-electrons.com>,
        <linux@prisktech.co.nz>, <josh.cartwright@ni.com>,
        Pawel Moll <pawel.moll@arm.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
 <1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
Message-ID: <20130118175827.3982.65450@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 7/7] clk: vexpress: Use common of_clk_init() function
Date: Fri, 18 Jan 2013 09:58:27 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Prashant Gaikwad (2013-01-03 23:00:58)
> Use common of_clk_init() function for clock initialization.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Pawel or Linus,

Can I get a Tested-by before I take this series into clk-next?

Thanks,
Mike

> ---
>  drivers/clk/versatile/clk-vexpress-osc.c |    1 +
>  drivers/clk/versatile/clk-vexpress.c     |    8 +-------
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
> index dcb6ae0..256c8be 100644
> --- a/drivers/clk/versatile/clk-vexpress-osc.c
> +++ b/drivers/clk/versatile/clk-vexpress-osc.c
> @@ -144,3 +144,4 @@ error:
>                 vexpress_config_func_put(osc->func);
>         kfree(osc);
>  }
> +CLK_OF_DECLARE(vexpress_soc, "arm,vexpress-osc", vexpress_osc_of_setup);
> diff --git a/drivers/clk/versatile/clk-vexpress.c b/drivers/clk/versatile/clk-vexpress.c
> index c742ac7..f889f2f 100644
> --- a/drivers/clk/versatile/clk-vexpress.c
> +++ b/drivers/clk/versatile/clk-vexpress.c
> @@ -99,19 +99,13 @@ struct clk *vexpress_sp810_of_get(struct of_phandle_args *clkspec, void *data)
>         return vexpress_sp810_timerclken[clkspec->args[0]];
>  }
>  
> -static const __initconst struct of_device_id vexpress_fixed_clk_match[] = {
> -       { .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
> -       { .compatible = "arm,vexpress-osc", .data = vexpress_osc_of_setup, },
> -       {}
> -};
> -
>  void __init vexpress_clk_of_init(void)
>  {
>         struct device_node *node;
>         struct clk *clk;
>         struct clk *refclk, *timclk;
>  
> -       of_clk_init(vexpress_fixed_clk_match);
> +       of_clk_init(NULL);
>  
>         node = of_find_compatible_node(NULL, NULL, "arm,sp810");
>         vexpress_sp810_init(of_iomap(node, 0));
> -- 
> 1.7.4.1
