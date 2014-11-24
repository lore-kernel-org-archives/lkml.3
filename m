Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaKXNLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:11:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27553 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaKXNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:11:44 -0500
X-AuditID: cbfee691-f79b86d000004a5a-8a-54732e8e615e
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 01/12] arm: exynos: Add platform driver support for
 power domain driver
Date: Mon, 24 Nov 2014 18:34:05 +0530
Message-id: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWrdPrzjE4HefhkXD1RCL+UfOsVo8
	u7WXyaJ3wVU2i6ebHzNZbHp8jdXi8q45bBafe48wWsw4v4/JYtHWL+wWZ05fYrU4/Kad1eL4
	2nAHXo9NqzrZPO5c28PmcehwB6PH5iX1HluutrN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0C
	V8bbXetYCrZKVFw4K9TA+E+4i5GDQ0LARKLpXkIXIyeQKSZx4d56ti5GLg4hgaWMEvevrmSH
	SJhI7D85ASoxnVHi4+LJUM4EJonbd48wglSxCRhL/Ny5nx1kqoiAt8Tya4ogNcwCq5kktrZ/
	YAKpERZIkJh8rwFsKouAqkTrk4dgvbwC7hIvzrczQ1ykIDFnkg1ImBMofObVEhaQsJCAm8Ti
	JjWQkRIC59glJvVfZoYYIyDxbfIhFohWWYlNB5ghbpaUOLjiBssERuEFjAyrGEVTC5ILipPS
	i0z1ihNzi0vz0vWS83M3MQJj5fS/ZxN3MN4/YH2IUYCDUYmHd8b6ohAh1sSy4srcQ4ymQBsm
	MkuJJucDIzKvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbG9rcvK8xOSbu7inh2XFAXcfihG/FjnVir6JqIvZZN20p2tGr4MEjfKW3SvX+j3POp6Zv/
	PvtLN7VfCnf47Xxu3Uy/ck1lnUMts1pCgp0ev/JmC1YuP55/fVXxon2rA+pStz5/J3OrwLNm
	p5ibvHiYwLu1ETyBaxdITJw9m8Phn7RQ598HCWZKLMUZiYZazEXFiQAicJsjkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd0+veIQg/7Z8hYNV0Ms5h85x2rx
	7NZeJoveBVfZLJ5ufsxksenxNVaLy7vmsFl87j3CaDHj/D4mi0Vbv7BbnDl9idXi8Jt2Vovj
	a8MdeD02repk87hzbQ+bx6HDHYwem5fUe2y52s7i0bdlFaPH501yAexRDYw2GamJKalFCql5
	yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDHKimUJeaUAoUCEouLlfTt
	ME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz3u5ax1KwVaLiwlmhBsZ/wl2MnBwSAiYS+09OYIOw
	xSQu3FsPZHNxCAlMZ5T4uHgylDOBSeL23SOMIFVsAsYSP3fuZ+9i5OAQEfCWWH5NEaSGWWA1
	k8TW9g9MIDXCAgkSk+81sIPYLAKqEq1PHoL18gq4S7w4384M0ishoCAxZ5INSJgTKHzm1RIW
	kLCQgJvE4ia1CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx+Iz6R2MqxosDjEK
	cDAq8fDOWF8UIsSaWFZcmXuIUYKDWUmEV0ysOESINyWxsiq1KD++qDQntfgQoynQTROZpUST
	84FpIq8k3tDYxNzU2NTSxMLEzFJJnPfGzdwQIYH0xJLU7NTUgtQimD4mDk6pBkYnV+0zKyZv
	Onatx2P/tr2W1ruS74mqlhq2yb6yEF7clKFo/d/w7wz1y8VX4vLtbpd2Wh3fVO9U6i15dX/b
	59zeDYFaiXmztd41PT2e+tF00s2N0Y6aprOMT7gK+FUnCaxLSi692cd3oidYpo6lLval/rHH
	ra2abKt/GVo1ZHt7SRgtmfXiohJLcUaioRZzUXEiAILoyr3bAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Exynos Power Domain driver initialization
implementation in following way:

   - Added platform driver support and probe function where Exynos PM
     Domain driver will finally register itself as MFD PMU client driver.
     In this way,all the Exynos power domains are probed once and registered
     with the power domain subsystem.
   - Existing DT bindings are used.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c |   40 +++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index 20f2671..5cb5440 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -105,25 +105,17 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
 	return exynos_pd_power(domain, false);
 }
 
-static __init int exynos4_pm_init_power_domain(void)
+static int exynos_power_domain_probe(struct platform_device *pdev)
 {
-	struct platform_device *pdev;
 	struct device_node *np;
 
 	for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
 		struct exynos_pm_domain *pd;
 		int on, i;
-		struct device *dev;
 
-		pdev = of_find_device_by_node(np);
-		dev = &pdev->dev;
-
-		pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-		if (!pd) {
-			pr_err("%s: failed to allocate memory for domain\n",
-					__func__);
+		pd = devm_kzalloc(&pdev->dev, sizeof(*pd), GFP_KERNEL);
+		if (!pd)
 			return -ENOMEM;
-		}
 
 		pd->pd.name = kstrdup(np->name, GFP_KERNEL);
 		pd->name = pd->pd.name;
@@ -131,7 +123,7 @@ static __init int exynos4_pm_init_power_domain(void)
 		pd->pd.power_off = exynos_pd_power_off;
 		pd->pd.power_on = exynos_pd_power_on;
 
-		pd->oscclk = clk_get(dev, "oscclk");
+		pd->oscclk = of_clk_get_by_name(np, "oscclk");
 		if (IS_ERR(pd->oscclk))
 			goto no_clk;
 
@@ -139,11 +131,11 @@ static __init int exynos4_pm_init_power_domain(void)
 			char clk_name[8];
 
 			snprintf(clk_name, sizeof(clk_name), "clk%d", i);
-			pd->clk[i] = clk_get(dev, clk_name);
+			pd->clk[i] = of_clk_get_by_name(np, clk_name);
 			if (IS_ERR(pd->clk[i]))
 				break;
 			snprintf(clk_name, sizeof(clk_name), "pclk%d", i);
-			pd->pclk[i] = clk_get(dev, clk_name);
+			pd->pclk[i] = of_clk_get_by_name(np, clk_name);
 			if (IS_ERR(pd->pclk[i])) {
 				clk_put(pd->clk[i]);
 				pd->clk[i] = ERR_PTR(-EINVAL);
@@ -163,4 +155,22 @@ no_clk:
 
 	return 0;
 }
-arch_initcall(exynos4_pm_init_power_domain);
+
+static const struct platform_device_id exynos_power_domain_id[] = {
+	{ "exynos-pmu-pd"},
+	{ },
+};
+
+static struct platform_driver exynos_power_domain_driver = {
+	.driver  = {
+		.name   = "exynos-pd",
+	},
+	.probe = exynos_power_domain_probe,
+	.id_table = exynos_power_domain_id,
+};
+
+static int __init exynos_power_domain_init(void)
+{
+	return platform_driver_register(&exynos_power_domain_driver);
+}
+postcore_initcall(exynos_power_domain_init);
-- 
1.7.9.5

