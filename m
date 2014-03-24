Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaCXVvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:51:33 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58995 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaCXVv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:51:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Emilio Lopez" <emilio@elopez.com.ar>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Vinod Koul" <vinod.koul@intel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1394723659-4995-2-git-send-email-maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
 <1394723659-4995-2-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <20140324215120.32624.63543@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 1/7] clk: sunxi: Remove calls to clk_put
Date: Mon, 24 Mar 2014 14:51:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime Ripard (2014-03-13 08:14:13)
> Callers of clk_put must disable the clock first. This also means that as long
> as the clock is enabled the driver should hold a reference to that clock.
> Hence, the call to clk_put here are bogus and should be removed.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Looks good to me. There is a balanced clk_put in the module remove
function?

Regards,
Mike

> ---
>  drivers/clk/sunxi/clk-sunxi.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 23baad9d934a..7119c02c9fa8 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1290,17 +1290,13 @@ static void __init sunxi_clock_protect(void)
>  
>         /* memory bus clock - sun5i+ */
>         clk = clk_get(NULL, "mbus");
> -       if (!IS_ERR(clk)) {
> +       if (!IS_ERR(clk))
>                 clk_prepare_enable(clk);
> -               clk_put(clk);
> -       }
>  
>         /* DDR clock - sun4i+ */
>         clk = clk_get(NULL, "pll5_ddr");
> -       if (!IS_ERR(clk)) {
> +       if (!IS_ERR(clk))
>                 clk_prepare_enable(clk);
> -               clk_put(clk);
> -       }
>  }
>  
>  static void __init sunxi_init_clocks(void)
> -- 
> 1.9.0
> 
