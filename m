Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaKRV7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:59:32 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52602 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaKRV7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:59:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Chanwoo Choi <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, a.zummo@towertech.it
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1416301183-10478-4-git-send-email-cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "Chanwoo Choi" <cw00.choi@samsung.com>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
 <1416301183-10478-4-git-send-email-cw00.choi@samsung.com>
Message-ID: <20141118215926.25314.90810@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCHv2 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC clock
Date: Tue, 18 Nov 2014 13:59:26 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chanwoo Choi (2014-11-18 00:59:41)
> This patch adds the support for S2MPS13 PMIC clock which is same with existing
> S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied to clk-next.

Regards,
Mike

> ---
>  drivers/clk/clk-s2mps11.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
> index b7797fb..7bb13af 100644
> --- a/drivers/clk/clk-s2mps11.c
> +++ b/drivers/clk/clk-s2mps11.c
> @@ -23,6 +23,7 @@
>  #include <linux/clk-provider.h>
>  #include <linux/platform_device.h>
>  #include <linux/mfd/samsung/s2mps11.h>
> +#include <linux/mfd/samsung/s2mps13.h>
>  #include <linux/mfd/samsung/s2mps14.h>
>  #include <linux/mfd/samsung/s5m8767.h>
>  #include <linux/mfd/samsung/core.h>
> @@ -120,6 +121,24 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
>         },
>  };
>  
> +static struct clk_init_data s2mps13_clks_init[S2MPS11_CLKS_NUM] = {
> +       [S2MPS11_CLK_AP] = {
> +               .name = "s2mps13_ap",
> +               .ops = &s2mps11_clk_ops,
> +               .flags = CLK_IS_ROOT,
> +       },
> +       [S2MPS11_CLK_CP] = {
> +               .name = "s2mps13_cp",
> +               .ops = &s2mps11_clk_ops,
> +               .flags = CLK_IS_ROOT,
> +       },
> +       [S2MPS11_CLK_BT] = {
> +               .name = "s2mps13_bt",
> +               .ops = &s2mps11_clk_ops,
> +               .flags = CLK_IS_ROOT,
> +       },
> +};
> +
>  static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
>         [S2MPS11_CLK_AP] = {
>                 .name = "s2mps14_ap",
> @@ -184,6 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>                 s2mps11_reg = S2MPS11_REG_RTC_CTRL;
>                 clks_init = s2mps11_clks_init;
>                 break;
> +       case S2MPS13X:
> +               s2mps11_reg = S2MPS13_REG_RTCCTRL;
> +               clks_init = s2mps13_clks_init;
> +               break;
>         case S2MPS14X:
>                 s2mps11_reg = S2MPS14_REG_RTCCTRL;
>                 clks_init = s2mps14_clks_init;
> @@ -279,6 +302,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
>  
>  static const struct platform_device_id s2mps11_clk_id[] = {
>         { "s2mps11-clk", S2MPS11X},
> +       { "s2mps13-clk", S2MPS13X},
>         { "s2mps14-clk", S2MPS14X},
>         { "s5m8767-clk", S5M8767X},
>         { },
> -- 
> 1.8.5.5
> 
