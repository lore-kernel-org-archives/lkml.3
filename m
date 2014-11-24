Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaKXNOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:14:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41492 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaKXNOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:14:31 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-74-54732f34ddd0
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 04/12] soc: samsung: Re-structure PMU driver to create
 pd on/off handlers
Date: Mon, 24 Nov 2014 18:34:08 +0530
Message-id: <1416834256-11225-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSrWuiXxxicGCDkUXD1RCL+UfOsVo8
	u7WXyaJ3wVU2i6ebHzNZbHp8jdXi8q45bBafe48wWsw4v4/JYtHWL+wWZ05fYrU4/Kad1eL4
	2nAHXo9NqzrZPO5c28PmcehwB6PH5iX1HluutrN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0C
	V8ajRc8ZCya6VyyedoK1gXGFVRcjJ4eEgIlEz+o3zBC2mMSFe+vZuhi5OIQEljJKfDu3hQWm
	aMWceewQiemMEocedLODJIQEJjBJnLkTBmKzCRhL/Ny5HyjOwSEi4C2x/JoiSD2zwGomia3t
	H5hAaoQFkiSm9/9kA7FZBFQlDjz8BjaHV8Bd4uaeZ8wgvRICChJzJtmAhDkFPCReHGxhhtjb
	wihx6fFcVhBHQuAau8SHv4tYIQYJSHybfIgFollWYtMBqG8kJQ6uuMEygVF4ASPDKkbR1ILk
	guKk9CITveLE3OLSvHS95PzcTYzAiDn979mEHYz3DlgfYhTgYFTi4f2wsShEiDWxrLgy9xCj
	KdCGicxSosn5wLjMK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QD47I7XFwMzy7O+qN4++urLYf3TLF8tXjums2q9259+n1Q9pz7ft1Z/8933/mZIZfz
	8G2UzbzJx9VqjsTO6bvcoDA/UVhFOFwx7ssUPwH7pL6r3rYpL60P738YsO1pkv7s5wkzFvhU
	nXrCwmXT2HLT/OimuAYj1WMrHxpMMDc1W9CzPosx/GOSxw8lluKMREMt5qLiRAAWCgY2kwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQV0T/eIQgwsLNCwaroZYzD9yjtXi
	2a29TBa9C66yWTzd/JjJYtPja6wWl3fNYbP43HuE0WLG+X1MFou2fmG3OHP6EqvF4TftrBbH
	14Y78HpsWtXJ5nHn2h42j0OHOxg9Ni+p99hytZ3Fo2/LKkaPz5vkAtijGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jBmPFr0nLFgonvF4mknWBsYV1h1MXJySAiYSKyYM48d
	whaTuHBvPVsXIxeHkMB0RolDD7rBEkICE5gkztwJA7HZBIwlfu7cDxTn4BAR8JZYfk0RpJ5Z
	YDWTxNb2D0wgNcICSRLT+3+ygdgsAqoSBx5+A5vDK+AucXPPM2aQXgkBBYk5k2xAwpwCHhIv
	DrYwQ+xtYZS49Hgu6wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguPxmfQOxlUN
	FocYBTgYlXh4Z6wvChFiTSwrrsw9xCjBwawkwismVhwixJuSWFmVWpQfX1Sak1p8iNEU6KqJ
	zFKiyfnAVJFXEm9obGJuamxqaWJhYmapJM5742ZuiJBAemJJanZqakFqEUwfEwenVAMj1zun
	367JnjVSS/+5/zzfGbxG8Z6MRaaIR96mx4tnXDj92qJ3XntOw27V7llmi8ru7jOt4PR30k/l
	Eix+lyfxOTFtelbEi3OhbcddDLZc0518NPKqIu/8o+niAg0fVGNe9kzarthYv/bh1OvvH0QF
	fDjOIDrp9Zb9ata5smIB69TPFWbuDd6qxFKckWioxVxUnAgAr5nyRd0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves PD domain on/off implementation inside the PMU driver.
The handlers will be supplied via the MFD platform data. Power domains
are basically sparse memories in the Exynos PMU controllers, so with
this restructuring all the register access operations reside inside pmu
file.
This restructuring will be useful for SoC's where certain extra
operation need to implemented along with PD on/off operation or if
some PD registers are different. There is no functionality change for the
existing SoC's.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/soc/samsung/exynos-pmu.c            |   62 +++++++++++++++++++++++++++
 drivers/soc/samsung/pm_domains.c            |   50 ++++++++++++---------
 include/linux/soc/samsung/exynos-pmu.h      |   15 +++++++
 include/linux/soc/samsung/exynos-regs-pmu.h |    9 ++++
 4 files changed, 115 insertions(+), 21 deletions(-)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index da77c7e..e690f65 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -34,6 +34,7 @@ struct exynos_pmu_conf {
 struct exynos_pmu_data {
 	const struct exynos_pmu_conf *pmu_config;
 	const struct exynos_pmu_conf *pmu_config_extra;
+	struct exynos_pmu_pd_ops *pd_ops;
 
 	void (*pmu_init)(void);
 	void (*powerdown_conf)(enum sys_powerdown);
@@ -44,6 +45,7 @@ struct exynos_pmu_context {
 	struct device *dev;
 	const struct exynos_pmu_data *pmu_data;
 	struct mfd_cell cells[MFD_MAX];
+	struct pmu_dev_client_data mfd_data[MFD_MAX];
 };
 
 static void __iomem *pmu_base_addr;
@@ -880,6 +882,52 @@ void exynos_sys_powerup_conf(enum sys_powerdown mode)
 		pmu_data->powerup_conf(mode);
 }
 
+static int __exynos_pd_poweron_off(bool power_on, const char *pd_name,
+		void __iomem *pd_addr, int conf_val)
+{
+	unsigned int timeout, pwr;
+	char *op;
+
+	/* Wait max 1ms */
+	timeout = 10;
+	pwr = power_on ? conf_val : 0;
+
+	writel_relaxed(pwr, pd_addr + EXYNOS_PD_CONFIG);
+
+	while ((readl_relaxed(pd_addr + EXYNOS_PD_STATUS) & conf_val) != pwr) {
+		if (!timeout) {
+			op = (power_on) ? "enable" : "disable";
+			pr_err("Power domain %s %s failed\n", pd_name, op);
+			return -ETIMEDOUT;
+		}
+		timeout--;
+		cpu_relax();
+		usleep_range(80, 100);
+	}
+	return 0;
+}
+
+static int exynos_pd_poweron(const char *pd_name, void __iomem *pd_addr)
+{
+	return __exynos_pd_poweron_off(true, pd_name, pd_addr,
+					EXYNOS_INT_LOCAL_PWR_EN);
+}
+
+static int exynos_pd_poweroff(const char *pd_name, void __iomem *pd_addr)
+{
+	return __exynos_pd_poweron_off(false, pd_name, pd_addr,
+					EXYNOS_INT_LOCAL_PWR_EN);
+}
+
+static bool exynos_pd_status(void __iomem *pd_addr)
+{
+	unsigned int val;
+
+	val = readl_relaxed(pd_addr + EXYNOS_PD_STATUS) &
+				EXYNOS_INT_LOCAL_PWR_EN;
+	return  val ? true : false;
+}
+
 static void exynos5250_pmu_init(void)
 {
 	unsigned int value;
@@ -1154,29 +1202,40 @@ static void exynos7_pmu_init(void)
 	}
 }
 
+static struct exynos_pmu_pd_ops exynos_pd_ops = {
+	.pd_on		= exynos_pd_poweron,
+	.pd_off		= exynos_pd_poweroff,
+	.pd_status	= exynos_pd_status,
+};
+
 static const struct exynos_pmu_data exynos4210_pmu_data = {
 	.pmu_config	= exynos4210_pmu_config,
+	.pd_ops		= &exynos_pd_ops,
 };
 
 static const struct exynos_pmu_data exynos4212_pmu_data = {
 	.pmu_config	= exynos4x12_pmu_config,
+	.pd_ops		= &exynos_pd_ops,
 };
 
 static const struct exynos_pmu_data exynos4412_pmu_data = {
 	.pmu_config		= exynos4x12_pmu_config,
 	.pmu_config_extra	= exynos4412_pmu_config,
+	.pd_ops			= &exynos_pd_ops,
 };
 
 static const struct exynos_pmu_data exynos5250_pmu_data = {
 	.pmu_config	= exynos5250_pmu_config,
 	.pmu_init	= exynos5250_pmu_init,
 	.powerdown_conf	= exynos5_powerdown_conf,
+	.pd_ops		= &exynos_pd_ops,
 };
 
 static struct exynos_pmu_data exynos5420_pmu_data = {
 	.pmu_config	= exynos5420_pmu_config,
 	.pmu_init	= exynos5420_pmu_init,
 	.powerdown_conf	= exynos5420_powerdown_conf,
+	.pd_ops		= &exynos_pd_ops,
 };
 
 static const struct exynos_pmu_data exynos7_pmu_data = {
@@ -1259,6 +1318,9 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 	/* Initialize and invoke mfd clients */
 	cell = &pmu_context->cells[MFD_PD];
 	cell->name = "exynos-pmu-pd";
+	pmu_context->mfd_data[MFD_PD].ops = pmu_context->pmu_data->pd_ops;
+	cell->platform_data = &pmu_context->mfd_data[MFD_PD];
+	cell->pdata_size = sizeof(pmu_context->mfd_data[MFD_PD]);
 
 	ret = mfd_add_devices(&pdev->dev, pdev->id, pmu_context->cells, MFD_MAX,
 				NULL, 0, NULL);
diff --git a/drivers/soc/samsung/pm_domains.c b/drivers/soc/samsung/pm_domains.c
index 5cb5440..69bc8b1 100644
--- a/drivers/soc/samsung/pm_domains.c
+++ b/drivers/soc/samsung/pm_domains.c
@@ -22,10 +22,13 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/sched.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
-#define INT_LOCAL_PWR_EN	0x7
 #define MAX_CLK_PER_DOMAIN	4
 
+static struct exynos_pmu_pd_ops *pd_ops;
+
+
 /*
  * Exynos specific wrapper around the generic power domain
  */
@@ -43,8 +46,7 @@ static int exynos_pd_power(struct generic_pm_domain *domain, bool power_on)
 {
 	struct exynos_pm_domain *pd;
 	void __iomem *base;
-	u32 timeout, pwr;
-	char *op;
+	int ret = 0;
 
 	pd = container_of(domain, struct exynos_pm_domain, pd);
 	base = pd->base;
@@ -62,22 +64,13 @@ static int exynos_pd_power(struct generic_pm_domain *domain, bool power_on)
 		}
 	}
 
-	pwr = power_on ? INT_LOCAL_PWR_EN : 0;
-	__raw_writel(pwr, base);
-
-	/* Wait max 1ms */
-	timeout = 10;
+	if (power_on)
+		ret = pd_ops->pd_on(domain->name, base);
+	else
+		ret = pd_ops->pd_off(domain->name, base);
 
-	while ((__raw_readl(base + 0x4) & INT_LOCAL_PWR_EN) != pwr) {
-		if (!timeout) {
-			op = (power_on) ? "enable" : "disable";
-			pr_err("Power domain %s %s failed\n", domain->name, op);
-			return -ETIMEDOUT;
-		}
-		timeout--;
-		cpu_relax();
-		usleep_range(80, 100);
-	}
+	if (ret)
+		return ret;
 
 	/* Restore clocks after powering on a domain*/
 	if (power_on) {
@@ -92,7 +85,7 @@ static int exynos_pd_power(struct generic_pm_domain *domain, bool power_on)
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int exynos_pd_power_on(struct generic_pm_domain *domain)
@@ -108,10 +101,25 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
 static int exynos_power_domain_probe(struct platform_device *pdev)
 {
 	struct device_node *np;
+	struct pmu_dev_client_data *pdata = NULL;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data passed\n");
+		return -EINVAL;
+	}
+
+	pd_ops = pdata->ops;
+	if (!pd_ops || !pd_ops->pd_on || !pd_ops->pd_off ||
+						!pd_ops->pd_status) {
+		dev_err(&pdev->dev, "Invalid platform data\n");
+		return -EINVAL;
+	}
 
 	for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
 		struct exynos_pm_domain *pd;
-		int on, i;
+		int i;
+		bool on;
 
 		pd = devm_kzalloc(&pdev->dev, sizeof(*pd), GFP_KERNEL);
 		if (!pd)
@@ -147,7 +155,7 @@ static int exynos_power_domain_probe(struct platform_device *pdev)
 			clk_put(pd->oscclk);
 
 no_clk:
-		on = __raw_readl(pd->base + 0x4) & INT_LOCAL_PWR_EN;
+		on = pd_ops->pd_status(pd->base);
 
 		pm_genpd_init(&pd->pd, NULL, !on);
 		of_genpd_add_provider_simple(np, &pd->pd);
diff --git a/include/linux/soc/samsung/exynos-pmu.h b/include/linux/soc/samsung/exynos-pmu.h
index b497712..6774aea 100644
--- a/include/linux/soc/samsung/exynos-pmu.h
+++ b/include/linux/soc/samsung/exynos-pmu.h
@@ -19,6 +19,21 @@ enum sys_powerdown {
 	NUM_SYS_POWERDOWN,
 };
 
+struct exynos_pmu_pd_ops {
+	/*
+	 * pd name may be useful to carry out any operations specific
+	 * to the power domain. pd_addr provides the base address of the
+	 * power domain.
+	 */
+	int (*pd_on)(const char *pd_name, void __iomem *pd_addr);
+	int (*pd_off)(const char *pd_name, void __iomem *pd_addr);
+	bool (*pd_status)(void __iomem *pd_addr);
+};
+
+struct pmu_dev_client_data {
+	void *ops; /* void * may be useful for all types of mfd clients */
+};
+
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 extern void exynos_sys_powerup_conf(enum sys_powerdown mode);
 
diff --git a/include/linux/soc/samsung/exynos-regs-pmu.h b/include/linux/soc/samsung/exynos-regs-pmu.h
index 7cfadd3..c61f91a 100644
--- a/include/linux/soc/samsung/exynos-regs-pmu.h
+++ b/include/linux/soc/samsung/exynos-regs-pmu.h
@@ -146,6 +146,15 @@
 
 #define EXYNOS5_L2RSTDISABLE_VALUE		BIT(3)
 
+#define EXYNOS_INT_LOCAL_PWR_EN			0x7
+
+/*
+ *Power domain register offsets from the PD configuration register
+ */
+#define EXYNOS_PD_CONFIG			(0x0)
+#define EXYNOS_PD_STATUS			(0x4)
+#define EXYNOS_PD_OPTION			(0x8)
+
 #define S5P_PAD_RET_MAUDIO_OPTION		0x3028
 #define S5P_PAD_RET_GPIO_OPTION			0x3108
 #define S5P_PAD_RET_UART_OPTION			0x3128
-- 
1.7.9.5

