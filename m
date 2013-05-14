Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab3ENP6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:58:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54619 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab3ENP6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:58:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1368019749-19455-4-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
 <1368019749-19455-4-git-send-email-lee.jones@linaro.org>
Message-ID: <20130514155835.10068.93655@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 3/9] clk: ux500: Provide device enumeration number suffix for
 SMSC911x
Date: Tue, 14 May 2013 08:58:35 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lee Jones (2013-05-08 06:29:03)
> First Ethernet device has a ".0" appended onto the device name. It
> appears that we need this in order to obtain the correct clock.
> 
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks good to me.  Can I take this into clk-next or are you looking for
an Ack?

Regards,
Mike

> ---
>  drivers/clk/ux500/u8500_clk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
> index 0b4f35a..80069c3 100644
> --- a/drivers/clk/ux500/u8500_clk.c
> +++ b/drivers/clk/ux500/u8500_clk.c
> @@ -325,7 +325,7 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
>         clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", clkrst3_base,
>                                 BIT(0), 0);
>         clk_register_clkdev(clk, "fsmc", NULL);
> -       clk_register_clkdev(clk, NULL, "smsc911x");
> +       clk_register_clkdev(clk, NULL, "smsc911x.0");
>  
>         clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", clkrst3_base,
>                                 BIT(1), 0);
> -- 
> 1.7.10.4
