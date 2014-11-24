Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaKXNUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:20:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28506 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaKXNUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:20:34 -0500
X-AuditID: cbfee68e-f79b46d000002b74-22-547330a08297
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 10/12] drivers: soc: samsung: Add support for clock
 enabling in power domain
Date: Mon, 24 Nov 2014 18:34:14 +0530
Message-id: <1416834256-11225-10-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSrbvAoDjE4NNHPouGqyEW84+cY7V4
	dmsvk0XvgqtsFk83P2ay2PT4GqvF5V1z2Cw+9x5htJhxfh+TxaKtX9gtzpy+xGpx+E07q8Xx
	teEOvB6bVnWyedy5tofN49DhDkaPzUvqPbZcbWfx6NuyitHj8ya5APYoLpuU1JzMstQifbsE
	row93y+yFOxzqPjbepKlgXGLSRcjJ4eEgInElhu9zBC2mMSFe+vZuhi5OIQEljJKfP9wiwWm
	aGrvGVaIxHRGiRU9U6CqJjBJtK9qZAKpYhMwlvi5cz97FyMHh4iAt8Tya4ogNcwCq5kktrZ/
	AKsRFkiVWHl1MTuIzSKgKrFjwnawel4BD4kn0+VATAkBBYk5k2xAKjiBoi8OtjBDrGphlLj0
	eC7YERICl9glli2YzQwxR0Di2+RDLBDNshKbDkB9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UX
	GekVJ+YWl+al6yXn525iBEbM6X/P+nYw3jxgfYhRgINRiYf3w8aiECHWxLLiytxDjKZAGyYy
	S4km5wPjMq8k3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsaaD5oXf9jH8Fk7SG2JeyS52uyl4tpN59Ns+D8YeZSbpW13W39VqyTkWKHWC72G1W+Fz5U1
	TzEMjjgy6SaT540l6+ImFDfs/Hf5m1Ddlkm2y+6xntKXtlx1hpmHbePzV1cL32vbLRL4bt0W
	6CJ41GDfm79NL0xF1W62Wr0J8tgVVjnpdnFn4wMlluKMREMt5qLiRADD4KT0kwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQd0FBsUhBtPnsVg0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2PP9IkvBPoeKv60nWRoYt5h0MXJySAiYSEztPcMK
	YYtJXLi3nq2LkYtDSGA6o8SKnilQzgQmifZVjUwgVWwCxhI/d+5n72Lk4BAR8JZYfk0RpIZZ
	YDWTxNb2D2A1wgKpEiuvLmYHsVkEVCV2TNgOVs8r4CHxZLociCkhoCAxZ5INSAUnUPTFwRZm
	iFUtjBKXHs9lncDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDw+k97BuKrB4hCj
	AAejEg/vjPVFIUKsiWXFlbmHGCU4mJVEeMXEikOEeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0
	OR+YKvJK4g2NTcxNjU0tTSxMzCyVxHlv3MwNERJITyxJzU5NLUgtgulj4uCUamA0/ttupf86
	R7++rTCDydfW8Jfa/S+M6jutREpnfDid83sS4+njN0znMM4RULfOfr1buervlTsak7IjNs1r
	6g2916rdrsArsWpmd9a7jld1KX12wfVLjpfcfLVjUcXyd7ZVZ/82xEglneDluvm8YHtCqkvS
	ulfKj81a6099T1r77e8uz/QnN/4qsRRnJBpqMRcVJwIANvvw6N0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While turning power domain to on/off, some clocks need to be enabled
in the Exynos7 SOC. This patch adds the framework for enabling those
clocks before on/off and restoring it back after the operation. Also
these list of clocks may be different for on/off operation so not using
the generic pm domain suspend/resume interface.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../bindings/arm/exynos/power_domain.txt           |   12 ++
 drivers/soc/samsung/pm_domains.c                   |  138 +++++++++++++++++++-
 2 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index 8d913b9..c48769e 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -24,6 +24,14 @@ Optional Properties:
 	- pclkN, clkN: Pairs of parent of input clock and input clock to the
 	devices in this power domain.
 	Maximum of 10 sets (N = 0 to 9) are supported.
+- pd-on-en-clocks: List of clock handles. These clocks are required to enabled
+	before turning on a power domain.
+- pd-on-en-clock-names: clocks can be specified as,
+	- clkN: N can vary between 0-30.
+- pd-off-en-clocks: List of clock handles. These clocks are required to enabled
+	before turning off a power domain.
+- pd-off-en-clock-names: clocks can be specified as,
+	- clkN: N can vary between 0-30.
 - parents: phandle of parent power domains.
 
 Node of a device using power domains must have a samsung,power-domain property
@@ -43,6 +51,10 @@ Example:
 		pd-parent-clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MOUT_SW_ACLK333>,
 			<&clock CLK_MOUT_USER_ACLK333>;
 		pd-parent-clock-names = "tclk0", "pclk0", "clk0";
+		pd-on-en-clocks = <&clock CLK_IP1>, <&clock CLK_IP2>,
+		pd-on-en-clock-names = "clk0", "clk1";
+		pd-off-en-clocks = <&clock CLK_IP1>, <&clock CLK_IP2>,
+		pd-off-en-clock-names = "clk0", "clk1";
 		#power-domain-cells = <0>;
 	};
 
diff --git a/drivers/soc/samsung/pm_domains.c b/drivers/soc/samsung/pm_domains.c
index 96196f8..5407eb7 100644
--- a/drivers/soc/samsung/pm_domains.c
+++ b/drivers/soc/samsung/pm_domains.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/pm_domain.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
@@ -29,6 +30,12 @@
 
 static struct exynos_pmu_pd_ops *pd_ops;
 
+struct clk_enable_list {
+	struct clk **clks;
+	unsigned int count;
+	unsigned int en_status;
+};
+
 struct clk_parent_list {
 	struct clk **clks;
 	struct clk **parent_clks;
@@ -44,6 +51,8 @@ struct exynos_pm_domain {
 	char const *name;
 	bool is_off;
 	struct generic_pm_domain pd;
+	struct clk_enable_list *clk_pd_on;
+	struct clk_enable_list *clk_pd_off;
 	struct clk_parent_list *clk_parent;
 };
 
@@ -72,6 +81,55 @@ static struct clk *exynos_pd_clk_get(struct device_node *np,
 	return clk;
 }
 
+static int pd_init_enable_clocks(struct platform_device *pdev,
+		struct device_node *np, bool on, struct exynos_pm_domain *pd)
+{
+	struct clk_enable_list *list;
+	char propname[32], clk_name[8];
+	int count, i;
+	struct clk *clk = ERR_PTR(-ENOENT);
+
+	list = devm_kzalloc(&pdev->dev, sizeof(*list), GFP_KERNEL);
+	if (!list)
+		return -ENOMEM;
+
+	if (on) {
+		pd->clk_pd_on = list;
+		snprintf(propname, sizeof(propname), "pd-on-en-clock-names");
+	} else {
+		pd->clk_pd_off = list;
+		snprintf(propname, sizeof(propname), "pd-off-en-clock-names");
+	}
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
+	if (on)
+		snprintf(propname, sizeof(propname), "pd-on-en");
+	else
+		snprintf(propname, sizeof(propname), "pd-off-en");
+
+	for (i = 0; i < count; i++) {
+		snprintf(clk_name, sizeof(clk_name), "clk%d", i);
+		clk = exynos_pd_clk_get(np, propname, clk_name);
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "%s clock not found\n", clk_name);
+			return -EINVAL;
+		}
+		list->clks[i] = clk;
+	}
+	dev_info(&pdev->dev, "pd %s enable clocks initialised\n",
+				on ? "on" : "off");
+	return 0;
+}
+
 static int pd_init_parent_clocks(struct platform_device *pdev,
 		struct device_node *np, struct exynos_pm_domain *pd)
 {
@@ -140,25 +198,67 @@ static int pd_init_parent_clocks(struct platform_device *pdev,
 	return 0;
 }
 
+static void exynos_pd_poweron_prepare(struct exynos_pm_domain *pd)
+{
+	struct clk_enable_list *en_list;
+	int i;
+
+	en_list = pd->clk_pd_on;
+	if (!en_list)
+		return;
+
+	/* Enable the necessary clocks not enabled and update the status */
+	for (i = 0; i < en_list->count; i++) {
+		if (__clk_is_enabled(en_list->clks[i]))
+			continue;
+		clk_enable(en_list->clks[i]);
+		en_list->en_status |= (1 << i);
+	}
+}
+
 static void exynos_pd_post_poweron(struct exynos_pm_domain *pd)
 {
 	struct clk_parent_list *p_list;
+	struct clk_enable_list *en_list;
 	int i;
 
 	p_list = pd->clk_parent;
-	if (!p_list)
+	if (p_list) {
+		/* Set the parents clocks correctly */
+		for (i = 0; i < p_list->count; i++)
+			clk_set_parent(p_list->clks[i], p_list->parent_clks[i]);
+	}
+
+	en_list = pd->clk_pd_on;
+	if (!en_list)
 		return;
 
-	/* Set the parents clocks correctly */
-	for (i = 0; i < p_list->count; i++)
-		clk_set_parent(p_list->clks[i], p_list->parent_clks[i]);
+	/* Disable the clocks enabled during power off preperation */
+	for (i = 0; i < en_list->count; i++) {
+		if (!(en_list->en_status & (1 << i)))
+			continue;
+		clk_disable(en_list->clks[i]);
+		en_list->en_status &= ~(1 << i);
+	}
 }
 
 static void exynos_pd_poweroff_prepare(struct exynos_pm_domain *pd)
 {
 	struct clk_parent_list *p_list;
+	struct clk_enable_list *en_list;
 	int i;
 
+	en_list = pd->clk_pd_off;
+	if (en_list) {
+		/* Enable the clocks not enabled and update the status */
+		for (i = 0; i < en_list->count; i++) {
+			if (__clk_is_enabled(en_list->clks[i]))
+				continue;
+			clk_enable(en_list->clks[i]);
+			en_list->en_status |= (1 << i);
+		}
+	}
+
 	p_list = pd->clk_parent;
 	if (!p_list)
 		return;
@@ -168,12 +268,31 @@ static void exynos_pd_poweroff_prepare(struct exynos_pm_domain *pd)
 		clk_set_parent(p_list->clks[i], p_list->trans_clks[i]);
 }
 
+static void exynos_pd_post_poweroff(struct exynos_pm_domain *pd)
+{
+	struct clk_enable_list *en_list;
+	int i;
+
+	en_list = pd->clk_pd_off;
+	if (!en_list)
+		return;
+
+	/* Disable the clocks enabled during power off preperation */
+	for (i = 0; i < en_list->count; i++) {
+		if (!(en_list->en_status & (1 << i)))
+			continue;
+		clk_disable(en_list->clks[i]);
+		en_list->en_status &= ~(1 << i);
+	}
+}
+
 static int exynos_pd_power_on(struct generic_pm_domain *domain)
 {
 	int ret = 0;
 	struct exynos_pm_domain *pd;
 
 	pd = container_of(domain, struct exynos_pm_domain, pd);
+	exynos_pd_poweron_prepare(pd);
 	ret = pd_ops->pd_on(domain->name, pd->base);
 	if (ret)
 		return ret;
@@ -189,6 +308,9 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
 	pd = container_of(domain, struct exynos_pm_domain, pd);
 	exynos_pd_poweroff_prepare(pd);
 	ret = pd_ops->pd_off(domain->name, pd->base);
+	if (ret)
+		return ret;
+	exynos_pd_post_poweroff(pd);
 	return ret;
 }
 
@@ -232,6 +354,14 @@ static int exynos_power_domain_probe(struct platform_device *pdev)
 		pd->pd.power_off = exynos_pd_power_off;
 		pd->pd.power_on = exynos_pd_power_on;
 
+		if (of_find_property(np, "pd-on-en-clocks", NULL))
+			if (pd_init_enable_clocks(pdev, np, true, pd))
+				return -EINVAL;
+
+		if (of_find_property(np, "pd-off-en-clocks", NULL))
+			if (pd_init_enable_clocks(pdev, np, false, pd))
+				return -EINVAL;
+
 		if (of_find_property(np, "pd-parent-clocks", NULL))
 			if (pd_init_parent_clocks(pdev, np, pd))
 				return -EINVAL;
-- 
1.7.9.5

