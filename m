Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaKXNVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:21:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28576 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKXNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:21:30 -0500
X-AuditID: cbfee68d-f79296d000004278-30-547330d76aca
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 11/12] drivers: soc: samsung: Add support for clock rate
 save/restore in power domain
Date: Mon, 24 Nov 2014 18:34:15 +0530
Message-id: <1416834256-11225-11-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSpXvDoDjEYFYrm0XD1RCL+UfOsVo8
	u7WXyaJ3wVU2i6ebHzNZbHp8jdXi8q45bBafe48wWsw4v4/JYtHWL+wWZ05fYrU4/Kad1eL4
	2nAHXo9NqzrZPO5c28PmcehwB6PH5iX1HluutrN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0C
	V8btxd/YC5q0Kzafe8PewPhdqYuRk0NCwETi5KG7TBC2mMSFe+vZuhi5OIQEljJK7J2/jwmm
	6NLxxcwQiemMEic2PYByJjBJHOnYwwhSxSZgLPFz5372LkYODhEBb4nl1xRBapgFVjNJbG3/
	ADZJWCBPYuvUPrAaFgFViQ8vREHCvAIeEncmtbKAhCUEFCTmTLIBCXMChV8cbIFa1cIocenx
	XFYQR0LgErvEkj9/2EGqWAQEJL5NPgTVLCux6QAzxNGSEgdX3GCZwCi8gJFhFaNoakFyQXFS
	epGhXnFibnFpXrpecn7uJkZgxJz+96x3B+PtA9aHGAU4GJV4eD9sLAoRYk0sK67MPcRoCrRh
	IrOUaHI+MC7zSuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLg
	lGpg7P7yX+mZ4MPvb1Z+CdA4qVZuEnLv+nKBA5v2XDxv2FSzSXbjyUzLWz3aPlPirk+eo868
	RTHgrKqIF1ekRwmbj1yl3zvDbhO2BGZj5fmKr67u3FV+8KjXtHX/BDoki+IcbASelpSIOtTc
	9z91MJivwuFsRtycCvPEOQ7CGo7TDQNXeFmxpe1UYinOSDTUYi4qTgQADmMhqZMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQd3rBsUhBncOm1s0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuL34G3tBk3bF5nNv2BsYvyt1MXJySAiYSFw6vpgZ
	whaTuHBvPVsXIxeHkMB0RokTmx4wQzgTmCSOdOxhBKliEzCW+LlzP3sXIweHiIC3xPJriiA1
	zAKrmSS2tn9gAqkRFsiT2Dq1D6yGRUBV4sMLUZAwr4CHxJ1JrSwgYQkBBYk5k2xAwpxA4RcH
	W6BWtTBKXHo8l3UCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx+Ex6B+OqBotD
	jAIcjEo8vDPWF4UIsSaWFVfmHmKU4GBWEuEVEysOEeJNSaysSi3Kjy8qzUktPsRoCnTURGYp
	0eR8YKrIK4k3NDYxNzU2tTSxMDGzVBLnvXEzN0RIID2xJDU7NbUgtQimj4mDU6qBMTTvtGPa
	3akeISaWmxkmTFaY+7jquatD/8aditt3y+vWh25329l0RlFYPfu4zz+FrOmC7jKvEtxNXm7M
	3MiZtXbjdPtvj5/Mj9ZattAs8TkHa0J3GesDz7iFctYJueEsDKey89UjnqySu/2i331y1r0p
	33jnHK5N/GvmnVuaVLz805xFdUsnKrEUZyQaajEXFScCAFeVs9TdAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While turning power domain to on/off, some clocks rates might change and
need to be saved/restored in the Exynos7 SOC. This patch adds the
framework for saving those clocks before power off and restoring it back
after power on operation.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../bindings/arm/exynos/power_domain.txt           |    7 ++
 drivers/soc/samsung/pm_domains.c                   |   74 ++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index c48769e..97fec1b 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -32,6 +32,11 @@ Optional Properties:
 	before turning off a power domain.
 - pd-off-en-clock-names: clocks can be specified as,
 	- clkN: N can vary between 0-30.
+- pd-rate-clocks: List of clock handles. The rates of these clocks are required
+	to be saved before turning off a power domain and restoring after turning
+	on a power domain.
+- pd-rate-clock-names: clocks can be specified as,
+	- clkN: N can vary between 0-30.
 - parents: phandle of parent power domains.
 
 Node of a device using power domains must have a samsung,power-domain property
@@ -55,6 +60,8 @@ Example:
 		pd-on-en-clock-names = "clk0", "clk1";
 		pd-off-en-clocks = <&clock CLK_IP1>, <&clock CLK_IP2>,
 		pd-off-en-clock-names = "clk0", "clk1";
+		pd-rate-clocks = <&clock CLK_IP3>, <&clock CLK_IP4>,
+		pd-rate-clock-names = "clk0", "clk1";
 		#power-domain-cells = <0>;
 	};
 
diff --git a/drivers/soc/samsung/pm_domains.c b/drivers/soc/samsung/pm_domains.c
index 5407eb7..a235277 100644
--- a/drivers/soc/samsung/pm_domains.c
+++ b/drivers/soc/samsung/pm_domains.c
@@ -36,6 +36,12 @@ struct clk_enable_list {
 	unsigned int en_status;
 };
 
+struct clk_rate_list {
+	struct clk **clks;
+	unsigned int *rates;
+	unsigned int count;
+};
+
 struct clk_parent_list {
 	struct clk **clks;
 	struct clk **parent_clks;
@@ -53,6 +59,7 @@ struct exynos_pm_domain {
 	struct generic_pm_domain pd;
 	struct clk_enable_list *clk_pd_on;
 	struct clk_enable_list *clk_pd_off;
+	struct clk_rate_list *clk_rate;
 	struct clk_parent_list *clk_parent;
 };
 
@@ -198,6 +205,49 @@ static int pd_init_parent_clocks(struct platform_device *pdev,
 	return 0;
 }
 
+static int pd_init_rate_clocks(struct platform_device *pdev,
+		struct device_node *np, struct exynos_pm_domain *pd)
+{
+	struct clk_rate_list *list;
+	char propname[32], clk_name[8];
+	int count, i;
+	struct clk *clk = ERR_PTR(-ENOENT);
+
+	list = devm_kzalloc(&pdev->dev, sizeof(*list), GFP_KERNEL);
+	if (!list)
+		return -ENOMEM;
+
+	pd->clk_rate = list;
+	snprintf(propname, sizeof(propname), "pd-rate-clock-names");
+
+	count = of_property_count_strings(np, propname);
+	if (!count || count > MAX_CLK_PER_DOMAIN)
+		return -EINVAL;
+
+	list->count = count;
+	list->clks = devm_kzalloc(&pdev->dev, sizeof(*list->clks) * count,
+				GFP_KERNEL);
+	if (!list->clks)
+		return -ENOMEM;
+
+	list->rates = devm_kzalloc(&pdev->dev, sizeof(list->rates) * count,
+				GFP_KERNEL);
+	if (!list->rates)
+		return -ENOMEM;
+
+	for (i = 0; i < count; i++) {
+		snprintf(clk_name, sizeof(clk_name), "clk%d", i);
+		clk = exynos_pd_clk_get(np, "pd-rate", clk_name);
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "%s clock not found\n", clk_name);
+			return -EINVAL;
+		}
+		list->clks[i] = clk;
+	}
+	dev_info(&pdev->dev, "pd rate clocks initialised\n");
+	return 0;
+}
+
 static void exynos_pd_poweron_prepare(struct exynos_pm_domain *pd)
 {
 	struct clk_enable_list *en_list;
@@ -220,6 +270,7 @@ static void exynos_pd_post_poweron(struct exynos_pm_domain *pd)
 {
 	struct clk_parent_list *p_list;
 	struct clk_enable_list *en_list;
+	struct clk_rate_list *rt_list;
 	int i;
 
 	p_list = pd->clk_parent;
@@ -229,6 +280,17 @@ static void exynos_pd_post_poweron(struct exynos_pm_domain *pd)
 			clk_set_parent(p_list->clks[i], p_list->parent_clks[i]);
 	}
 
+	rt_list = pd->clk_rate;
+	if (rt_list) {
+		/* restore the rate from the rate clock list */
+		for (i = 0; i < rt_list->count; i++) {
+			if (!rt_list->rates[i])
+				continue;
+			clk_set_rate(rt_list->clks[i], rt_list->rates[i]);
+			rt_list->rates[i] = 0;
+		}
+	}
+
 	en_list = pd->clk_pd_on;
 	if (!en_list)
 		return;
@@ -246,6 +308,7 @@ static void exynos_pd_poweroff_prepare(struct exynos_pm_domain *pd)
 {
 	struct clk_parent_list *p_list;
 	struct clk_enable_list *en_list;
+	struct clk_rate_list *rt_list;
 	int i;
 
 	en_list = pd->clk_pd_off;
@@ -259,6 +322,13 @@ static void exynos_pd_poweroff_prepare(struct exynos_pm_domain *pd)
 		}
 	}
 
+	rt_list = pd->clk_rate;
+	if (rt_list) {
+		/* save the rate from the rate clock list */
+		for (i = 0; i < rt_list->count; i++)
+			rt_list->rates[i] = clk_get_rate(rt_list->clks[i]);
+	}
+
 	p_list = pd->clk_parent;
 	if (!p_list)
 		return;
@@ -366,6 +436,10 @@ static int exynos_power_domain_probe(struct platform_device *pdev)
 			if (pd_init_parent_clocks(pdev, np, pd))
 				return -EINVAL;
 
+		if (of_find_property(np, "pd-rate-clocks", NULL))
+			if (pd_init_rate_clocks(pdev, np, pd))
+				return -EINVAL;
+
 		on = pd_ops->pd_status(pd->base);
 
 		pm_genpd_init(&pd->pd, NULL, !on);
-- 
1.7.9.5

