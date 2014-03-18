Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaCRLOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:14:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25998 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaCRLOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:14:35 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-94-53282a64b00a
Message-id: <53282A60.2010301@samsung.com>
Date: Tue, 18 Mar 2014 12:13:36 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 3/8] devfreq: exynos4: Add ppmu's clock control and code
 clean about regulator control
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-4-git-send-email-cw00.choi@samsung.com>
 <53233F78.8020500@samsung.com> <5326632A.8030801@samsung.com>
 <53268F48.8060704@samsung.com>
In-reply-to: <53268F48.8060704@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e/4Nd0ULY1gg+UvDS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsARxWWTkpqTWZZapG+XwJWx98kqxoL/BhUzH/1ibWC8rtbFyMkhIWAi8fvLJRYIW0zi
	wr31bF2MXBxCAksZJb7++sIO4XxmlJh/8wYTSBWvgJbE9Z77jCA2i4CqxIVJ+9hAbDYBNYnP
	DY/AbH6gmjVN18GmigpESMyduJkNoldQ4sfke2BxEQENiZl/r4DNYRb4yiRxcx7YfGGBPIlZ
	m34zQSx+xCixbNlqsCJOAW2JjfuWs0I0WEusnLQNqlleYvOat8wTGAVnIdkxC0nZLCRlCxiZ
	VzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERNvXHYxLj1kdYhTgYFTi4X3Jph4sxJpYVlyZ
	e4hRgoNZSYR3qZpGsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGs23R/A7rnm9bdof5pr6vFZ9E
	fGeH3qoVc/2a5lcsYH+R/kZ256ycGf/jkrKC3kolqS98r3Lb9ORhu+aZxj13DwuV29WvN9W8
	cLHmzJs9S+ufJ3zJ2P9Ts/Xvuq/HlfUeuM+Iq63/pbUkZufdhl0NyQY316VKW2/ud1ohmfTQ
	pmlHyZvEHZn5SizFGYmGWsxFxYkARKE9uZQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 17.03.2014 06:59, Chanwoo Choi wrote:
> Hi Tomasz,
>
> On 03/17/2014 11:51 AM, Chanwoo Choi wrote:
>> Hi Tomasz,
>>
>> On 03/15/2014 02:42 AM, Tomasz Figa wrote:
>>> Hi Chanwoo,
>>>
>>> On 13.03.2014 09:17, Chanwoo Choi wrote:
>>>> There are not the clock controller of ppmudmc0/1. This patch control the clock
>>>> of ppmudmc0/1 which is used for monitoring memory bus utilization.
>>>>
>>>> Also, this patch code clean about regulator control and free resource
>>>> when calling exit/remove function.
>>>>
>>>> For example,
>>>> busfreq@106A0000 {
>>>>      compatible = "samsung,exynos4x12-busfreq";
>>>>
>>>>      /* Clock for PPMUDMC0/1 */
>>>>      clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
>>>>      clock-names = "ppmudmc0", "ppmudmc1";
>>>>
>>>>      /* Regulator for MIF/INT block */
>>>>      vdd_mif-supply = <&buck1_reg>;
>>>>      vdd_int-supply = <&buck3_reg>;
>>>> };
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>
> I modify this patch according your comment as following:
>
> Best Regards,
> Chanwoo Choi
>
>>From c8f2fbc4c1166ec02fb2ad46164bc7ed9118721b Mon Sep 17 00:00:00 2001
> From: Chanwoo Choi <cw00.choi@samsung.com>
> Date: Fri, 14 Mar 2014 12:05:54 +0900
> Subject: [PATCH] devfreq: exynos4: Add ppmu's clock control and code clean
>   about regulator control
>
> There are not the clock controller of ppmudmc0/1. This patch control the clock
> of ppmudmc0/1 which is used for monitoring memory bus utilization.
>
> Also, this patch code clean about regulator control and free resource
> when calling exit/remove function.
>
> For example,
> busfreq@106A0000 {
> 	compatible = "samsung,exynos4x12-busfreq";
>
> 	/* Clock for PPMUDMC0/1 */
> 	clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
> 	clock-names = "ppmudmc0", "ppmudmc1";
>
> 	/* Regulator for MIF/INT block */
> 	vdd_mif-supply = <&buck1_reg>;
> 	vdd_int-supply = <&buck3_reg>;
> };
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>   drivers/devfreq/exynos/exynos4_bus.c | 97 +++++++++++++++++++++++++++++++-----
>   1 file changed, 84 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
> index 4c630fb..3956bcc 100644
> --- a/drivers/devfreq/exynos/exynos4_bus.c
> +++ b/drivers/devfreq/exynos/exynos4_bus.c
> @@ -62,6 +62,11 @@ enum exynos_ppmu_idx {
>   	PPMU_END,
>   };
>
> +static const char *exynos_ppmu_clk_name[] = {
> +	[PPMU_DMC0]	= "ppmudmc0",
> +	[PPMU_DMC1]	= "ppmudmc1",
> +};
> +
>   #define EX4210_LV_MAX	LV_2
>   #define EX4x12_LV_MAX	LV_4
>   #define EX4210_LV_NUM	(LV_2 + 1)
> @@ -86,6 +91,7 @@ struct busfreq_data {
>   	struct regulator *vdd_mif; /* Exynos4412/4212 only */
>   	struct busfreq_opp_info curr_oppinfo;
>   	struct exynos_ppmu ppmu[PPMU_END];
> +	struct clk *clk_ppmu[PPMU_END];
>
>   	struct notifier_block pm_notifier;
>   	struct mutex lock;
> @@ -724,6 +730,17 @@ static void exynos4_bus_exit(struct device *dev)
>   	struct busfreq_data *data = dev_get_drvdata(dev);
>   	int i;
>
> +	/*
> +	 * Un-map memory map and disable regulator/clocks
> +	 * to prevent power leakage.
> +	 */
> +	regulator_disable(data->vdd_int);
> +	if (data->type == TYPE_BUSF_EXYNOS4x12)
> +		regulator_disable(data->vdd_mif);
> +
> +	for (i = 0; i < PPMU_END; i++)
> +		clk_disable_unprepare(data->clk_ppmu[i]);
> +
>   	for (i = 0; i < PPMU_END; i++)
>   		iounmap(data->ppmu[i].hw_base);
>   }
> @@ -989,6 +1006,7 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
>   {
>   	struct device *dev = data->dev;
>   	struct device_node *np = dev->of_node;
> +	const char **clk_name = exynos_ppmu_clk_name;
>   	int i, ret = 0;
>
>   	if (!np) {
> @@ -1006,8 +1024,67 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
>   		}
>   	}
>
> +	for (i = 0; i < PPMU_END; i++) {
> +		data->clk_ppmu[i] = devm_clk_get(dev, clk_name[i]);
> +		if (IS_ERR(data->clk_ppmu[i])) {
> +			dev_warn(dev, "Failed to get %s clock\n", clk_name[i]);

dev_err() since this is an error.

> +			goto err_clocks;
> +		}
> +
> +		ret = clk_prepare_enable(data->clk_ppmu[i]);
> +		if (ret < 0) {
> +			dev_warn(dev, "Failed to enable %s clock\n", clk_name[i]);

Ditto.

> +			data->clk_ppmu[i] = NULL;
> +			goto err_clocks;
> +		}
> +	}
> +
> +	/* Get regulator to control voltage of int block */
> +	data->vdd_int = devm_regulator_get(dev, "vdd_int");
> +	if (IS_ERR(data->vdd_int)) {
> +		dev_err(dev, "Failed to get the regulator of vdd_int\n");
> +		ret = PTR_ERR(data->vdd_int);
> +		goto err_clocks;
> +	}
> +	ret = regulator_enable(data->vdd_int);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to enable regulator of vdd_int\n");
> +		goto err_clocks;
> +	}
> +
> +	switch (data->type) {
> +	case TYPE_BUSF_EXYNOS4210:
> +		break;

Do you need to use switch here? Wouldn't a simple if (data->type == 
TYPE_BUSF_EXYNOS4x12) work as well, resulting with simpler code?

However I would expect this code to be completely removed, after 
defining DT bindings in a way allowing you to completely drop such SoC 
type enums. Please see my other reply for explanation of Exynos power 
plane DT bindings concept.

> +	case TYPE_BUSF_EXYNOS4x12:
> +		/* Get regulator to control voltage of mif blk if Exynos4x12 */
> +		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
> +		if (IS_ERR(data->vdd_mif)) {
> +			dev_err(dev, "Failed to get the regulator vdd_mif\n");
> +			ret = PTR_ERR(data->vdd_mif);
> +			goto err_regulator;
> +		}
> +		ret = regulator_enable(data->vdd_mif);
> +		if (ret < 0) {
> +			dev_err(dev, "Failed to enable regulator of vdd_mif\n");
> +			goto err_regulator;
> +		}
> +		break;
> +	default:
> +		dev_err(dev, "Unknown device type : %d\n", data->type);
> +		return -EINVAL;
> +	};
> +
>   	return 0;
>
> +err_regulator:
> +	regulator_disable(data->vdd_int);
> +err_clocks:
> +	for (i = 0; i < PPMU_END; i++) {
> +		if (IS_ERR(data->clk_ppmu[i]))
> +			continue;
> +		else

if (!IS_ERR(...))

> +			clk_disable_unprepare(data->clk_ppmu[i]);
> +	}

Otherwise looks good.

Best regards,
Tomasz
