Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3IXJfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:35:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53787 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3IXJfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:35:31 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-00-52415ce13114
Message-id: <52415CDF.4090002@samsung.com>
Date: Tue, 24 Sep 2013 11:35:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/6] clk: exynos-audss: convert to platform device
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org>
 <1379982078-23381-1-git-send-email-abrestic@chromium.org>
In-reply-to: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t/xa7oPYxyDDLa9ErVY+f4vo8X8I+dY
	Lc4uO8hmceDPDkaLc69WMlrsnrOYxaJ3wVU2i51bbrBZbHp8jdViYdsSFovLu+awWcw4v4/J
	4vZlXoul1y8yWTydcJHN4vfN72wWE6avZbGYsugwq8XhFQeYLNa9nM5icfJPL6PFjzPdLBav
	DraxWKyf8ZrFov3vXjYHSY8189YwerQ097B5LPh8hd1jdsNFFo/Lfb1MHiuXf2HzeLV6JqvH
	nWt72Dw2L6n36NuyitHjzIIj7B6fN8l5bJwbGsAbxWWTkpqTWZZapG+XwJXxd/0+1oLzIhVb
	Fn9jb2A8JdDFyMkhIWAice/TFlYIW0ziwr31bF2MXBxCAksZJZadn8MC4XxilFjYco8dpIpX
	QEvi55m1TCA2i4CqxKQrbWwgNpuAoUTv0T5GEFtUIEBi8ZJzUPWCEj8m32MBsUUEdCWmXjgN
	1sssMI1d4teuYhBbWMBTYt2nhVDLGhgl7t3pASviFHCTaGu7yQLRoCOxv3UaG4QtL7F5zVvm
	CYwCs5DsmIWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQuL8yw7GxcesDjEK
	cDAq8fBeTHAIEmJNLCuuzD3EKMHBrCTCe8PWMUiINyWxsiq1KD++qDQntfgQIxMHp1QDY23W
	FIspTcV3gvjqWNpa3R/+/SWXz6UhY3A9/Wh6o6jVU5lJnzguXq3oScyseJhTrS8tderA5Kdx
	VjMupz6qFz3zaZ/B7oOGOo5+xke7LCvKTEs0zIsN/hulxWr/PPvdWvxwBtuea53OTVzPfNXz
	An5F1E4LMA/9Zx1m+am56PYp4/XfAuqVWIozEg21mIuKEwFn/91x0QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24/09/13 02:21, Andrew Bresticker wrote:
> @@ -62,24 +64,29 @@ static struct syscore_ops exynos_audss_clk_syscore_ops = {
>  #endif /* CONFIG_PM_SLEEP */
>  
>  /* register exynos_audss clocks */
> -static void __init exynos_audss_clk_init(struct device_node *np)
> +static int exynos_audss_clk_probe(struct platform_device *pdev)
>  {
> -	reg_base = of_iomap(np, 0);
> -	if (!reg_base) {
> -		pr_err("%s: failed to map audss registers\n", __func__);
> -		return;
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	reg_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(reg_base)) {
> +		dev_err(&pdev->dev, "failed to map audss registers\n");
> +		return PTR_ERR(reg_base);
>  	}
>  
> -	clk_table = kzalloc(sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
> +	clk_table = devm_kzalloc(&pdev->dev,
> +				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
>  				GFP_KERNEL);
>  	if (!clk_table) {
> -		pr_err("%s: could not allocate clk lookup table\n", __func__);
> -		return;
> +		dev_err(&pdev->dev, "could not allocate clk lookup table\n");

You could drop this error log, k*alloc() functions already log any errors.

> +		return -ENOMEM;
>  	}
>  
>  	clk_data.clks = clk_table;
>  	clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
> -	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> +	of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
> +				&clk_data);

>  	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
>  				mout_audss_p, ARRAY_SIZE(mout_audss_p),
> @@ -128,8 +135,53 @@ static void __init exynos_audss_clk_init(struct device_node *np)
>  #endif
>  
>  	pr_info("Exynos: Audss: clock setup completed\n");
> +
> +	return 0;
> +}
> +
> +static int exynos_audss_clk_remove(struct platform_device *pdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++) {
> +		if (clk_table[i])

This would need to be:
		if (!IS_ERR(clk_table[i]))

Note the clock provider should be unregistered first, to avoid potential
race condition, where the clock provider returns an invalid pointer to
a clock, which has already been unregistered and freed.

I just noticed the sequence in probe needs to be fixed as well. i.e.
clocks should be created with clk_register() before the clock provider
is actually registered. It might warrant a separate patch but it's
probably also fine to make such change part of this patch.

> +			clk_unregister(clk_table[i]);
> +	}
> +
> +	of_clk_del_provider(pdev->dev.of_node);
> +
> +	return 0;
>  }

--
Thanks,
Sylwester
