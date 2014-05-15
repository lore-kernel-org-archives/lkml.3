Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaEOGlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:41:36 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55857 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaEOGlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:41:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399560990-1402858-5-git-send-email-arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>,
        "Linus Walleij" <linus.walleij@linaro.org>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-5-git-send-email-arnd@arndb.de>
Message-ID: <20140515064128.9521.73638@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk/versatile: export symbols for impd1
Date: Wed, 14 May 2014 23:41:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2014-05-08 07:56:16)
> The impd1 code on mach-integrator can be a loadable module,
> so we have to export icst_clk_register, integrator_impd1_clk_init
> and integrator_impd1_clk_exit.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Taken into clk-next.

Thanks!
Mike

> ---
>  drivers/clk/versatile/clk-icst.c  | 1 +
>  drivers/clk/versatile/clk-impd1.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
> index a820b0c..7f3868a 100644
> --- a/drivers/clk/versatile/clk-icst.c
> +++ b/drivers/clk/versatile/clk-icst.c
> @@ -160,3 +160,4 @@ struct clk *icst_clk_register(struct device *dev,
>  
>         return clk;
>  }
> +EXPORT_SYMBOL_GPL(icst_clk_register);
> diff --git a/drivers/clk/versatile/clk-impd1.c b/drivers/clk/versatile/clk-impd1.c
> index 31b44f0..264d8d5 100644
> --- a/drivers/clk/versatile/clk-impd1.c
> +++ b/drivers/clk/versatile/clk-impd1.c
> @@ -133,6 +133,7 @@ void integrator_impd1_clk_init(void __iomem *base, unsigned int id)
>         for (i = 0; i < ARRAY_SIZE(imc->clks); i++)
>                 clkdev_add(imc->clks[i]);
>  }
> +EXPORT_SYMBOL_GPL(integrator_impd1_clk_init);
>  
>  void integrator_impd1_clk_exit(unsigned int id)
>  {
> @@ -155,3 +156,4 @@ void integrator_impd1_clk_exit(unsigned int id)
>         kfree(imc->vco2name);
>         kfree(imc->vco1name);
>  }
> +EXPORT_SYMBOL_GPL(integrator_impd1_clk_exit);
> -- 
> 1.8.3.2
> 
