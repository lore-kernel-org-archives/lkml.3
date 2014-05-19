Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaESQdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:33:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48984 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaESQc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:32:59 -0400
Message-ID: <537A3234.9040707@ti.com>
Date: Mon, 19 May 2014 19:32:52 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: twl6040: Convert to use devm_clk_register
References: <1400427731.15403.1.camel@phoenix>
In-Reply-To: <1400427731.15403.1.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2014 06:42 PM, Axel Lin wrote:
> Use devm_clk_register() to simplify the code by removing twl6040_clk_remove().

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/clk/clk-twl6040.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
> index 1ada79a..9e996b4 100644
> --- a/drivers/clk/clk-twl6040.c
> +++ b/drivers/clk/clk-twl6040.c
> @@ -91,7 +91,7 @@ static int twl6040_clk_probe(struct platform_device *pdev)
>  	clkdata->twl6040 = twl6040;
>  
>  	clkdata->mcpdm_fclk.init = &wm831x_clkout_init;
> -	clkdata->clk = clk_register(&pdev->dev, &clkdata->mcpdm_fclk);
> +	clkdata->clk = devm_clk_register(&pdev->dev, &clkdata->mcpdm_fclk);
>  	if (IS_ERR(clkdata->clk))
>  		return PTR_ERR(clkdata->clk);
>  
> @@ -100,22 +100,12 @@ static int twl6040_clk_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static int twl6040_clk_remove(struct platform_device *pdev)
> -{
> -	struct twl6040_clk *clkdata = platform_get_drvdata(pdev);
> -
> -	clk_unregister(clkdata->clk);
> -
> -	return 0;
> -}
> -
>  static struct platform_driver twl6040_clk_driver = {
>  	.driver = {
>  		.name = "twl6040-clk",
>  		.owner = THIS_MODULE,
>  	},
>  	.probe = twl6040_clk_probe,
> -	.remove = twl6040_clk_remove,
>  };
>  
>  module_platform_driver(twl6040_clk_driver);
> 


-- 
Péter
