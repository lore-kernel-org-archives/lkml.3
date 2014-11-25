Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKYPvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:51:41 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51889 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaKYPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:51:39 -0500
Date: Tue, 25 Nov 2014 15:51:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC
 clock
Message-ID: <20141125155130.GM4241@x1>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
 <1416301183-10478-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416301183-10478-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Chanwoo Choi wrote:

> This patch adds the support for S2MPS13 PMIC clock which is same with existing
> S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/clk/clk-s2mps11.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)

Applied with Mike's Ack, thanks.

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
>  	},
>  };
>  
> +static struct clk_init_data s2mps13_clks_init[S2MPS11_CLKS_NUM] = {
> +	[S2MPS11_CLK_AP] = {
> +		.name = "s2mps13_ap",
> +		.ops = &s2mps11_clk_ops,
> +		.flags = CLK_IS_ROOT,
> +	},
> +	[S2MPS11_CLK_CP] = {
> +		.name = "s2mps13_cp",
> +		.ops = &s2mps11_clk_ops,
> +		.flags = CLK_IS_ROOT,
> +	},
> +	[S2MPS11_CLK_BT] = {
> +		.name = "s2mps13_bt",
> +		.ops = &s2mps11_clk_ops,
> +		.flags = CLK_IS_ROOT,
> +	},
> +};
> +
>  static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
>  	[S2MPS11_CLK_AP] = {
>  		.name = "s2mps14_ap",
> @@ -184,6 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>  		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
>  		clks_init = s2mps11_clks_init;
>  		break;
> +	case S2MPS13X:
> +		s2mps11_reg = S2MPS13_REG_RTCCTRL;
> +		clks_init = s2mps13_clks_init;
> +		break;
>  	case S2MPS14X:
>  		s2mps11_reg = S2MPS14_REG_RTCCTRL;
>  		clks_init = s2mps14_clks_init;
> @@ -279,6 +302,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
>  
>  static const struct platform_device_id s2mps11_clk_id[] = {
>  	{ "s2mps11-clk", S2MPS11X},
> +	{ "s2mps13-clk", S2MPS13X},
>  	{ "s2mps14-clk", S2MPS14X},
>  	{ "s5m8767-clk", S5M8767X},
>  	{ },

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
