Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3HYVuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 17:50:17 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35996 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3HYVuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 17:50:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1375609657-15434-3-git-send-email-maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375609657-15434-3-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <20130825215008.8231.41811@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCHv3 02/10] clk: sunxi: fix initialization of basic clocks
Date: Sun, 25 Aug 2013 14:50:08 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime Ripard (2013-08-04 02:47:29)
> From: Emilio López <emilio@elopez.com.ar>
> 
> With the recent move towards CLK_OF_DECLARE(...), the driver stopped
> initializing osc32k, which is compatible "fixed-clock". This is because
> we never called of_clk_init(NULL). Fix this by moving the only other
> simple clock (osc24M) to use CLK_OF_DECLARE(...) and call of_clk_init(NULL)
> to initialize both of them.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>

Taken into clk-next.

Regards,
Mike

> ---
>  drivers/clk/sunxi/clk-sunxi.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index db1c45b..567963f 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -69,6 +69,7 @@ static void __init sunxi_osc_clk_setup(struct device_node *node)
>                 clk_register_clkdev(clk, clk_name, NULL);
>         }
>  }
> +CLK_OF_DECLARE(sunxi_osc, "allwinner,sun4i-osc-clk", sunxi_osc_clk_setup);
>  
>  
>  
> @@ -422,12 +423,6 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
>         of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
>  }
>  
> -/* Matches for of_clk_init */
> -static const __initconst struct of_device_id clk_match[] = {
> -       {.compatible = "allwinner,sun4i-osc-clk", .data = sunxi_osc_clk_setup,},
> -       {}
> -};
> -
>  /* Matches for factors clocks */
>  static const __initconst struct of_device_id clk_factors_match[] = {
>         {.compatible = "allwinner,sun4i-pll1-clk", .data = &pll1_data,},
> @@ -482,8 +477,8 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
>  
>  void __init sunxi_init_clocks(void)
>  {
> -       /* Register all the simple sunxi clocks on DT */
> -       of_clk_init(clk_match);
> +       /* Register all the simple and basic clocks on DT */
> +       of_clk_init(NULL);
>  
>         /* Register factor clocks */
>         of_sunxi_table_clock_setup(clk_factors_match, sunxi_factors_clk_setup);
> -- 
> 1.8.3.4
