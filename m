Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaKXNTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:19:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28434 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaKXNTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:19:35 -0500
X-AuditID: cbfee68e-f79b46d000002b74-71-54733064f23b
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 09/12] drivers: soc: pm_domain: Modify the parent clocks
 bindings
Date: Mon, 24 Nov 2014 18:34:13 +0530
Message-id: <1416834256-11225-9-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSpZtiUBxicP6lhUXD1RCL+UfOsVo8
	u7WXyaJ3wVU2i6ebHzNZbHp8jdXi8q45bBafe48wWsw4v4/JYtHWL+wWZ05fYrU4/Kad1eL4
	2nAHXo9NqzrZPO5c28PmcehwB6PH5iX1HluutrN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0C
	V8bp7t8sBe1+FSee9TE3MK6y72Lk5JAQMJHYMv8dM4QtJnHh3nq2LkYuDiGBpYwS2+43sMIU
	fW2/ywyRmM4osWLudhYIZwKTxK5b/UwgVWwCxhI/d+5n72Lk4BAR8JZYfk0RpIZZYDWTxNb2
	D2A1wgJREv+XbgBbxyKgKvHm/3wwm1fAXeLksVeMIL0SAgoScybZgIQ5BTwkXhxsgVrcwihx
	6fFcVhBHQuASu8T9hQ+ZIAYJSHybfIgFollWYtMBqHckJQ6uuMEygVF4ASPDKkbR1ILkguKk
	9CIjveLE3OLSvHS95PzcTYzAmDn971nfDsabB6wPMQpwMCrx8H7YWBQixJpYVlyZe4jRFGjD
	RGYp0eR8YGTmlcQbGpsZWZiamBobmVuaKYnzJkj9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAaBbGK2Dvf33W933Vacr37idc4OipFO0+v1PXQcPz8J/L3913Cx1wuPyGreBgXszWqtIH
	uiVPWH+vN1Cc6FQZ+mC+cYWqdPvBy692qngzLQ5htZ/R4NrpzrbUY/fufZrPNS6+/5m9o2Im
	gxlz4YrvTKseyi95+5vnZbrL1vOH2wMnBlS7192oU2Ipzkg01GIuKk4EAIjdqoqUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd0Ug+IQg8XzdS0aroZYzD9yjtXi
	2a29TBa9C66yWTzd/JjJYtPja6wWl3fNYbP43HuE0WLG+X1MFou2fmG3OHP6EqvF4TftrBbH
	14Y78HpsWtXJ5nHn2h42j0OHOxg9Ni+p99hytZ3Fo2/LKkaPz5vkAtijGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jBmnO7+zVLQ7ldx4lkfcwPjKvsuRk4OCQETia/td5kh
	bDGJC/fWs3UxcnEICUxnlFgxdzsLhDOBSWLXrX4mkCo2AWOJnzv3s3cxcnCICHhLLL+mCFLD
	LLCaSWJr+wewGmGBKIn/SzeATWURUJV4838+mM0r4C5x8tgrRpBeCQEFiTmTbEDCnAIeEi8O
	tjBD7GphlLj0eC7rBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/KZ9A7GVQ0W
	hxgFOBiVeHhnrC8KEWJNLCuuzD3EKMHBrCTCKyZWHCLEm5JYWZValB9fVJqTWnyI0RToqonM
	UqLJ+cBkkVcSb2hsYm5qbGppYmFiZqkkznvjZm6IkEB6YklqdmpqQWoRTB8TB6dUAyNn0Nxt
	RquzPrBExb+/Z3dd9FrW24ZpPl/anxbtbdvcOtsycFuCyTS7ll8TGwTut29b//n2ZuayLaUu
	exZtKjae22ln0nR4x2Wg2PPHjLsvlCw6Oo+xIbhFku3+S7OHX6STJM7siqkydAxb+vrE4f3R
	x6X4t56UiH8v2i39zDhrqvfhO8p+G5RYijMSDbWYi4oTAcdlhYLeAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the parent clock bindings to make it more generic.
The current bindings limits the transient parent clocks to just one
clock as "oscclk". This patch extends it to allow any clock as
intermediate parent clock.
The reparent clock sets are of form tclkX, pclkX, clkX where X:0-9.
Because of this change only exynos5420 SoC DT bindings are affected.
The complete example is shown in the DT documentation section.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../bindings/arm/exynos/power_domain.txt           |   18 +-
 drivers/soc/samsung/pm_domains.c                   |  199 +++++++++++++-------
 2 files changed, 145 insertions(+), 72 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index 0160bdc..8d913b9 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -13,17 +13,17 @@ Required Properties:
 
 Optional Properties:
 - compatible: This is a second compatible name and gives the complete Power
-	Domain name like "samsung,exynos7-pd-mfc".
-- clocks: List of clock handles. The parent clocks of the input clocks to the
-	devices in this power domain are set to oscclk before power gating
+	Domain name like "samsung,exynos7-pd-mfc"
+- pd-parent-clocks: List of clock handles. The parent clocks of the input clocks to
+	the devices in this power domain are set to tclk before power gating
 	and restored back after powering on a domain. This is required for
 	all domains which are powered on and off and not required for unused
 	domains.
-- clock-names: The following clocks can be specified:
-	- oscclk: Oscillator clock.
+- pd-parent-clock-names: The following clocks can be specified:
+	- tclkN: Transient/Temporary parent clock.
 	- pclkN, clkN: Pairs of parent of input clock and input clock to the
-		devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
-		are supported currently.
+	devices in this power domain.
+	Maximum of 10 sets (N = 0 to 9) are supported.
 - parents: phandle of parent power domains.
 
 Node of a device using power domains must have a samsung,power-domain property
@@ -40,9 +40,9 @@ Example:
 	mfc_pd: power-domain@10044060 {
 		compatible = "samsung,exynos4210-pd";
 		reg = <0x10044060 0x20>;
-		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MOUT_SW_ACLK333>,
+		pd-parent-clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MOUT_SW_ACLK333>,
 			<&clock CLK_MOUT_USER_ACLK333>;
-		clock-names = "oscclk", "pclk0", "clk0";
+		pd-parent-clock-names = "tclk0", "pclk0", "clk0";
 		#power-domain-cells = <0>;
 	};
 
diff --git a/drivers/soc/samsung/pm_domains.c b/drivers/soc/samsung/pm_domains.c
index 89e2fd5..96196f8 100644
--- a/drivers/soc/samsung/pm_domains.c
+++ b/drivers/soc/samsung/pm_domains.c
@@ -24,11 +24,18 @@
 #include <linux/sched.h>
 #include <linux/soc/samsung/exynos-pmu.h>
 
-#define MAX_CLK_PER_DOMAIN	4
+#define MAX_CLK_PER_DOMAIN	30
 #define MAX_PARENT_POWER_DOMAIN	10
 
 static struct exynos_pmu_pd_ops *pd_ops;
 
+struct clk_parent_list {
+	struct clk **clks;
+	struct clk **parent_clks;
+	struct clk **trans_clks;
+	unsigned int count;
+};
+
 /*
  * Exynos specific wrapper around the generic power domain
  */
@@ -37,65 +44,152 @@ struct exynos_pm_domain {
 	char const *name;
 	bool is_off;
 	struct generic_pm_domain pd;
-	struct clk *oscclk;
-	struct clk *clk[MAX_CLK_PER_DOMAIN];
-	struct clk *pclk[MAX_CLK_PER_DOMAIN];
+	struct clk_parent_list *clk_parent;
 };
 
-static int exynos_pd_power(struct generic_pm_domain *domain, bool power_on)
+static struct clk *exynos_pd_clk_get(struct device_node *np,
+			char *initial_property,	char *clk_name)
 {
-	struct exynos_pm_domain *pd;
-	void __iomem *base;
-	int ret = 0;
+	struct of_phandle_args clkspec;
+	struct clk *clk;
+	int rc, index;
+	char name[32];
+
+	sprintf(name, "%s-clock-names", initial_property);
+	index = of_property_match_string(np, name, clk_name);
+	if (index < 0)
+		return ERR_PTR(-EINVAL);
+
+	sprintf(name, "%s-clocks", initial_property);
+
+	rc = of_parse_phandle_with_args(np, name, "#clock-cells", index,
+					&clkspec);
+	if (rc)
+		return ERR_PTR(rc);
+
+	clk = of_clk_get_from_provider(&clkspec);
+	of_node_put(clkspec.np);
+	return clk;
+}
 
-	pd = container_of(domain, struct exynos_pm_domain, pd);
-	base = pd->base;
+static int pd_init_parent_clocks(struct platform_device *pdev,
+		struct device_node *np, struct exynos_pm_domain *pd)
+{
+	struct clk_parent_list *list;
+	char clk_name[8];
+	int count, i;
+	struct clk *clk = ERR_PTR(-ENOENT);
+
+	list = devm_kzalloc(&pdev->dev, sizeof(*list), GFP_KERNEL);
+	if (!list)
+		return -ENOMEM;
+
+	pd->clk_parent = list;
+
+	/*
+	 * Each clock re-parenting data set contains 3 elements- tclkX, pclkX
+	 * and clkX, where X can vary between 0-9.
+	 */
+	count = of_property_count_strings(np, "pd-parent-clock-names");
+	if (!count || (count % 3) || count > MAX_CLK_PER_DOMAIN)
+		return -EINVAL;
 
-	/* Set oscclk before powering off a domain*/
-	if (!power_on) {
-		int i;
+	list->count = count / 3;
+
+	list->clks = devm_kzalloc(&pdev->dev,
+			sizeof(*list->clks) * list->count, GFP_KERNEL);
+	if (!list->clks)
+		return -ENOMEM;
+
+	list->parent_clks = devm_kzalloc(&pdev->dev,
+			sizeof(*list->parent_clks) * list->count, GFP_KERNEL);
+	if (!list->parent_clks)
+		return -ENOMEM;
+
+	list->trans_clks = devm_kzalloc(&pdev->dev,
+			sizeof(*list->trans_clks) * list->count, GFP_KERNEL);
+	if (!list->trans_clks)
+		return -ENOMEM;
+
+	for (i = 0; i < list->count; i++) {
+		snprintf(clk_name, sizeof(clk_name), "tclk%d", i);
+		clk = exynos_pd_clk_get(np, "pd-parent", clk_name);
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "%s clock not found\n", clk_name);
+			return -EINVAL;
+		}
+		list->trans_clks[i] = clk;
 
-		for (i = 0; i < MAX_CLK_PER_DOMAIN; i++) {
-			if (IS_ERR(pd->clk[i]))
-				break;
-			if (clk_set_parent(pd->clk[i], pd->oscclk))
-				pr_err("%s: error setting oscclk as parent to clock %d\n",
-						pd->name, i);
+		snprintf(clk_name, sizeof(clk_name), "pclk%d", i);
+		clk = exynos_pd_clk_get(np, "pd-parent", clk_name);
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "%s clock not found\n", clk_name);
+			return -EINVAL;
 		}
+		list->parent_clks[i] = clk;
+
+		snprintf(clk_name, sizeof(clk_name), "clk%d", i);
+		clk = exynos_pd_clk_get(np, "pd-parent", clk_name);
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "%s clock not found\n", clk_name);
+			return -EINVAL;
+		}
+		list->clks[i] = clk;
 	}
+	dev_info(&pdev->dev, "pd parent clocks initialised\n");
+	return 0;
+}
 
-	if (power_on)
-		ret = pd_ops->pd_on(domain->name, base);
-	else
-		ret = pd_ops->pd_off(domain->name, base);
+static void exynos_pd_post_poweron(struct exynos_pm_domain *pd)
+{
+	struct clk_parent_list *p_list;
+	int i;
 
-	if (ret)
-		return ret;
+	p_list = pd->clk_parent;
+	if (!p_list)
+		return;
 
-	/* Restore clocks after powering on a domain*/
-	if (power_on) {
-		int i;
+	/* Set the parents clocks correctly */
+	for (i = 0; i < p_list->count; i++)
+		clk_set_parent(p_list->clks[i], p_list->parent_clks[i]);
+}
 
-		for (i = 0; i < MAX_CLK_PER_DOMAIN; i++) {
-			if (IS_ERR(pd->clk[i]))
-				break;
-			if (clk_set_parent(pd->clk[i], pd->pclk[i]))
-				pr_err("%s: error setting parent to clock%d\n",
-						pd->name, i);
-		}
-	}
+static void exynos_pd_poweroff_prepare(struct exynos_pm_domain *pd)
+{
+	struct clk_parent_list *p_list;
+	int i;
 
-	return ret;
+	p_list = pd->clk_parent;
+	if (!p_list)
+		return;
+
+	/* Reparent the clocks to the transient clocks before power off */
+	for (i = 0; i < p_list->count; i++)
+		clk_set_parent(p_list->clks[i], p_list->trans_clks[i]);
 }
 
 static int exynos_pd_power_on(struct generic_pm_domain *domain)
 {
-	return exynos_pd_power(domain, true);
+	int ret = 0;
+	struct exynos_pm_domain *pd;
+
+	pd = container_of(domain, struct exynos_pm_domain, pd);
+	ret = pd_ops->pd_on(domain->name, pd->base);
+	if (ret)
+		return ret;
+	exynos_pd_post_poweron(pd);
+	return ret;
 }
 
 static int exynos_pd_power_off(struct generic_pm_domain *domain)
 {
-	return exynos_pd_power(domain, false);
+	int ret = 0;
+	struct exynos_pm_domain *pd;
+
+	pd = container_of(domain, struct exynos_pm_domain, pd);
+	exynos_pd_poweroff_prepare(pd);
+	ret = pd_ops->pd_off(domain->name, pd->base);
+	return ret;
 }
 
 static int exynos_power_domain_probe(struct platform_device *pdev)
@@ -118,7 +212,6 @@ static int exynos_power_domain_probe(struct platform_device *pdev)
 
 	for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
 		struct exynos_pm_domain *pd;
-		int i;
 		bool on;
 		const char *name;
 
@@ -139,30 +232,10 @@ static int exynos_power_domain_probe(struct platform_device *pdev)
 		pd->pd.power_off = exynos_pd_power_off;
 		pd->pd.power_on = exynos_pd_power_on;
 
-		pd->oscclk = of_clk_get_by_name(np, "oscclk");
-		if (IS_ERR(pd->oscclk))
-			goto no_clk;
-
-		for (i = 0; i < MAX_CLK_PER_DOMAIN; i++) {
-			char clk_name[8];
-
-			snprintf(clk_name, sizeof(clk_name), "clk%d", i);
-			pd->clk[i] = of_clk_get_by_name(np, clk_name);
-			if (IS_ERR(pd->clk[i]))
-				break;
-			snprintf(clk_name, sizeof(clk_name), "pclk%d", i);
-			pd->pclk[i] = of_clk_get_by_name(np, clk_name);
-			if (IS_ERR(pd->pclk[i])) {
-				clk_put(pd->clk[i]);
-				pd->clk[i] = ERR_PTR(-EINVAL);
-				break;
-			}
-		}
-
-		if (IS_ERR(pd->clk[0]))
-			clk_put(pd->oscclk);
+		if (of_find_property(np, "pd-parent-clocks", NULL))
+			if (pd_init_parent_clocks(pdev, np, pd))
+				return -EINVAL;
 
-no_clk:
 		on = pd_ops->pd_status(pd->base);
 
 		pm_genpd_init(&pd->pd, NULL, !on);
-- 
1.7.9.5

