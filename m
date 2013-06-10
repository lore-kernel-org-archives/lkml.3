Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3FJUye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:54:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34172 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3FJUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <1370521041-32318-19-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-19-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Jun 2013 22:54:32 +0200
Message-ID: <CAPDyKFqN-cYeEG0CtAnqGNTudJ9F3cPbs5Hoq0quTL1DhAN72w@mail.gmail.com>
Subject: Re: [PATCH 18/33] clk: ux500: Add a 2-cell Device Tree parser for
 obtaining PRCC clocks
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

On 6 June 2013 14:17, Lee Jones <lee.jones@linaro.org> wrote:
> PRCC (peripheral and kernel) clocks are specified using a property tuple
> <&phandle base bit>, where 'base' is the peripheral (1, 2, 3, 5 or 6),
> and bit is read-in value into that peripheral stipulated by the hardware
> specification.
>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/clk/ux500/u8500_clk.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
> index ef948ff..3a7040b 100644
> --- a/drivers/clk/ux500/u8500_clk.c
> +++ b/drivers/clk/ux500/u8500_clk.c
> @@ -15,6 +15,25 @@
>  #include <linux/platform_data/clk-ux500.h>
>  #include "clk.h"
>
> +struct clk *ux500_twocell_get(struct of_phandle_args *clkspec, void *data)
> +{
> +       struct clk **clk_data = data;
> +       unsigned int base, bit;
> +
> +       if (clkspec->args_count != 2)
> +               return  ERR_PTR(-EINVAL);
> +
> +       base = clkspec->args[0];
> +       bit = clkspec->args[1];
> +
> +       if (base != 1 && base != 2 && base != 3 && base != 5 && base != 6) {
> +               pr_err("%s: invalid PRCC base %d\n", __func__, base);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       return PRCC_SHOW(clk_data, base, bit);

Where did this macro come from?

Kind regards
Ulf Hansson

> +}
> +
>  const static struct of_device_id u8500_clk_of_match[] = {
>         { .compatible = "stericsson,u8500-clks", },
>         { },
> --
> 1.7.10.4
>
