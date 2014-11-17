Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaKQKQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:16:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40797 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKQKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:16:30 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-41-5469cafb50d6
Message-id: <5469CAF9.6020700@samsung.com>
Date: Mon, 17 Nov 2014 11:16:25 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC clock
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-4-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-4-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7q/T2WGGOy+rmyx5OJVdoupD5+w
	WVz/8pzVYv6Rc6wWfya0sllMuj+BxeL1C0OLs01v2C3ufz3KaPHtSgeTxeVdc9gsnk64yGZx
	upvV4uKKL0wOfB47Z91l99i0qpPN4861PWwe804GevRtWcXoMX3eTyaPz5vkAtijuGxSUnMy
	y1KL9O0SuDLu3ZzMUvBRqOLHqkbWBsal/F2MnBwSAiYS9zqWskLYYhIX7q1n62Lk4hASWMoo
	8b1/ITuE85lRYuaCPpYuRg4OXgEtic37S0EaWARUJRbt2s4MYrMJeEhM+94DZosKREhcWTOH
	EcTmFRCU+DH5HgvIHBGBRkaJp0t+gTnMAqcZJdYuWMYEUiUs4Cvx8MwJMFtIoFZi1k6IOKeA
	i8SSw3cZQRYzC6hLTJmSCxJmFpCX2LzmLfMERoFZSHbMQqiahaRqASPzKkbR1NLkguKk9FxD
	veLE3OLSvHS95PzcTYyQyPmyg3HxMatDjAIcjEo8vBIHMkOEWBPLiitzDzFKcDArifB+Pg4U
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFj142Hm3u/qjBbLSlOUnxs/XM/W3ulekMgj35iv619v
	cu30LpvattQ6o2eR+//9Nt5yZ67dWaHX71aZZlp8muo+P++rksWcuVxtllMb52zbfj9ccNcT
	j+lR9SvlZ5pelxD5FlzIEXLlfeyhzdJ/fyUEJ209mnrwVNViHYF29VuXW+Sawo1lvJVYijMS
	DbWYi4oTAagDyAt6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 01:42, Chanwoo Choi wrote:
> This patch adds the support for S2MPS13 PMIC clock which is same with existing
> S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
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
> 		.flags = CLK_IS_ROOT,

The patch looks corrupted here. Missing '+'?

Rest looks fine.
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


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
> 

