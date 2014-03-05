Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaCEQQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:16:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13311 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCEQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:16:09 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-f4-53174dc778f4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 03/11] ARM: exynos: Move to generic power domain bindings
Date: Wed, 05 Mar 2014 17:15:54 +0100
Message-id: <1713847.uSatLFRtJj@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1393862536-9842-4-git-send-email-tomasz.figa@gmail.com>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-4-git-send-email-tomasz.figa@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA03Re0hTURzA8c7d3bnX0ei6fJwmGoyi0rKMiINJBmXdIMGSiIrIqTe1Nh+b
	Dq3Akc5X+cJnS80wUafDtozUdEvzRZpmov5RmqHknEqYUkJpNTXwv8/v/L6/vw7NE30mxXRE
	ZCyniJTKJFBA9q5O2h/o9ncOPFTdjHDBlymIH3f083H23BM+Tqqoh7jfWgNwZvkwxNr8VgIb
	J0f4eKi5BOLFzA6AiwdMBP44JMRzvywU1neMUbhydJDAY287Ic4p0pO4r/cDH2taOyi83Hef
	xNa2FBLXF8+SWNf8G+Bu/aUTiK0rqwNsctIDyA5lZRJsk3aMYmuqliBb0TJDsEZdOmQ/jbRA
	1lxaR7HPnyayDcOpJJvVoANsde1Pil00urGG0osB264IfEI5WYSKUxw8HiQItzYPUtHfPOKn
	qjJINfgjyQB2NGKOoBn9IG/dTuj9eD3MAAJaxBQBVD77fWNIJlCnppBvqyDjjXJTdcBmB2YP
	+pGfTdkiHjMN0cibun8XNL2dCUDpTQJbQzK7UWqPFdosZPYhs7mUstmROYsaX9asvdsxfmjC
	kkbYLGISkUEzs9Hbo+W8cdJmHrMTmcwF/HXvR2ZNIcwBjHZTpt2UaTdl5YCnA45cdEi0MjhM
	7uWplMqVcZFhniFRciNY+/av4kZQo8btgKGBZKvQQjsFivhSlTJB3g4QzZM4CFNOOweKhKHS
	hNucIuq6Ik7GKduBC01KnIWvNcfOi5gwaSx3i+OiOcX/LUHbidUgdx6ZLZpnl7MyvdvopTzf
	wy4+JUExXY8eGigj0RWzcHPWF/a0CRYaV05tifBMmCj0GXWdvMoOivV8FQqe3uW7NG/Ykax2
	3ztS3kUV+HfG3V2OP2m91nlm9d6dd/1lrxzO6ZIr4AVZr+nGQMGcq1fti6OVqkQ/z6qVELc0
	ysMkIZXhUi93nkIp/Qubvydu8gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tomek,

On Monday, March 03, 2014 05:02:08 PM Tomasz Figa wrote:
> This patch moves Exynos power domain code to use the new generic power
> domain look-up framework introduced by previous patch, allowing the new
> code to be compiled with CONFIG_ARCH_EXYNOS selected as well.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  .../bindings/arm/exynos/power_domain.txt           | 12 ++--
>  arch/arm/mach-exynos/pm_domains.c                  | 80 +---------------------
>  kernel/power/Kconfig                               |  2 +-
>  3 files changed, 7 insertions(+), 87 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> index 5216b41..60f26a8 100644
> --- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> +++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> @@ -8,6 +8,8 @@ Required Properties:
>      * samsung,exynos4210-pd - for exynos4210 type power domain.
>  - reg: physical base address of the controller and length of memory mapped
>      region.
> +- #power-domain-cells: number of cells in power domain specifier;
> +    must be 0.
>  
>  Node of a device using power domains must have a samsung,power-domain property
>  defined with a phandle to respective power domain.
> @@ -17,12 +19,8 @@ Example:
>  	lcd0: power-domain-lcd0 {
>  		compatible = "samsung,exynos4210-pd";
>  		reg = <0x10023C00 0x10>;
> +		#power-domain-cells = <0>;
>  	};
>  
> -Example of the node using power domain:
> -
> -	node {
> -		/* ... */
> -		samsung,power-domain = <&lcd0>;
> -		/* ... */
> -	};
> +See Documentation/devicetree/bindings/power/power_domain.txt for description
> +of consumer-side bindings.
> diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
> index 8fd2488..48ee6c9 100644
> --- a/arch/arm/mach-exynos/pm_domains.c
> +++ b/arch/arm/mach-exynos/pm_domains.c
> @@ -75,78 +75,6 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
>  	return exynos_pd_power(domain, false);
>  }
>  
> -static void exynos_add_device_to_domain(struct exynos_pm_domain *pd,
> -					 struct device *dev)
> -{
> -	int ret;
> -
> -	dev_dbg(dev, "adding to power domain %s\n", pd->pd.name);
> -
> -	while (1) {
> -		ret = pm_genpd_add_device(&pd->pd, dev);
> -		if (ret != -EAGAIN)
> -			break;
> -		cond_resched();
> -	}
> -
> -	pm_genpd_dev_need_restore(dev, true);
> -}
> -
> -static void exynos_remove_device_from_domain(struct device *dev)
> -{
> -	struct generic_pm_domain *genpd = dev_to_genpd(dev);
> -	int ret;
> -
> -	dev_dbg(dev, "removing from power domain %s\n", genpd->name);
> -
> -	while (1) {
> -		ret = pm_genpd_remove_device(genpd, dev);
> -		if (ret != -EAGAIN)
> -			break;
> -		cond_resched();
> -	}
> -}
> -
> -static void exynos_read_domain_from_dt(struct device *dev)
> -{
> -	struct platform_device *pd_pdev;
> -	struct exynos_pm_domain *pd;
> -	struct device_node *node;
> -
> -	node = of_parse_phandle(dev->of_node, "samsung,power-domain", 0);

This removes "samsung,power-domain" phandle handling but I cannot find
in your patch series updates to existing EXYNOS dts files converting
them to use the new "power-domain" property.  Am I missing something?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> -	if (!node)
> -		return;
> -	pd_pdev = of_find_device_by_node(node);
> -	if (!pd_pdev)
> -		return;
> -	pd = platform_get_drvdata(pd_pdev);
> -	exynos_add_device_to_domain(pd, dev);
> -}
> -
> -static int exynos_pm_notifier_call(struct notifier_block *nb,
> -				    unsigned long event, void *data)
> -{
> -	struct device *dev = data;
> -
> -	switch (event) {
> -	case BUS_NOTIFY_BIND_DRIVER:
> -		if (dev->of_node)
> -			exynos_read_domain_from_dt(dev);
> -
> -		break;
> -
> -	case BUS_NOTIFY_UNBOUND_DRIVER:
> -		exynos_remove_device_from_domain(dev);
> -
> -		break;
> -	}
> -	return NOTIFY_DONE;
> -}
> -
> -static struct notifier_block platform_nb = {
> -	.notifier_call = exynos_pm_notifier_call,
> -};
> -
>  static __init int exynos4_pm_init_power_domain(void)
>  {
>  	struct platform_device *pdev;
> @@ -156,8 +84,6 @@ static __init int exynos4_pm_init_power_domain(void)
>  		struct exynos_pm_domain *pd;
>  		int on;
>  
> -		pdev = of_find_device_by_node(np);
> -
>  		pd = kzalloc(sizeof(*pd), GFP_KERNEL);
>  		if (!pd) {
>  			pr_err("%s: failed to allocate memory for domain\n",
> @@ -170,17 +96,13 @@ static __init int exynos4_pm_init_power_domain(void)
>  		pd->base = of_iomap(np, 0);
>  		pd->pd.power_off = exynos_pd_power_off;
>  		pd->pd.power_on = exynos_pd_power_on;
> -		pd->pd.of_node = np;
> -
> -		platform_set_drvdata(pdev, pd);
>  
>  		on = __raw_readl(pd->base + 0x4) & S5P_INT_LOCAL_PWR_EN;
>  
>  		pm_genpd_init(&pd->pd, NULL, !on);
> +		of_genpd_add_provider(np, of_genpd_xlate_simple, &pd->pd);
>  	}
>  
> -	bus_register_notifier(&platform_bus_type, &platform_nb);
> -
>  	return 0;
>  }
>  arch_initcall(exynos4_pm_init_power_domain);
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 45aa98e..b17588c 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -308,7 +308,7 @@ config PM_GENERIC_DOMAINS_RUNTIME
>  
>  config PM_GENERIC_DOMAINS_OF
>  	def_bool y
> -	depends on PM_GENERIC_DOMAINS && OF && !ARCH_EXYNOS
> +	depends on PM_GENERIC_DOMAINS && OF
>  
>  config CPU_PM
>  	bool

