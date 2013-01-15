Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3AOXxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:53:04 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38395 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab3AOXxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:53:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1355937587-31730-2-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
 <1355937587-31730-2-git-send-email-lee.jones@linaro.org>
Message-ID: <20130115235252.23734.21408@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 2/4] clk: ux500: Ensure the FMSC clock is obtainable
Date: Tue, 15 Jan 2013 15:52:52 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lee Jones (2012-12-19 09:19:45)
> The FMSC clock is traditionally used for NAND flash devices when
> used on the ux500 series platforms. This patch makes it searchable
> during a clock-name search.
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Mike Turquette <mturquette@linaro.org>

Who do you want this series to go through?

Regards,
Mike

> ---
>  drivers/clk/ux500/u8500_clk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
> index 6b889a0..a601802 100644
> --- a/drivers/clk/ux500/u8500_clk.c
> +++ b/drivers/clk/ux500/u8500_clk.c
> @@ -324,7 +324,7 @@ void u8500_clk_init(void)
>  
>         clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
>                                 BIT(0), 0);
> -       clk_register_clkdev(clk, NULL, "fsmc");
> +       clk_register_clkdev(clk, "fsmc", NULL);
>  
>         clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", U8500_CLKRST3_BASE,
>                                 BIT(1), 0);
> -- 
> 1.7.9.5
