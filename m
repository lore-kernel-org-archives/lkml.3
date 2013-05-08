Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3EHOAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:00:06 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:46974 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3EHOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-4-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-4-git-send-email-lee.jones@linaro.org>
Date: Wed, 8 May 2013 16:00:03 +0200
Message-ID: <CAPDyKFqsZ=z6OcRs45_DUO1Zpp_C1qUeZ2tsGCjD08H_b4L-jg@mail.gmail.com>
Subject: Re: [PATCH 3/9] clk: ux500: Provide device enumeration number suffix
 for SMSC911x
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 May 2013 15:29, Lee Jones <lee.jones@linaro.org> wrote:
> First Ethernet device has a ".0" appended onto the device name. It
> appears that we need this in order to obtain the correct clock.
>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
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
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
