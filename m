Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaEHMss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:48:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28368 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaEHMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:48:16 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-02-536b7d0f204c
From: Tomasz Figa <t.figa@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 3/3] ARM: exynos: Move to generic power domain bindings
Date: Thu, 08 May 2014 14:45:09 +0200
Message-id: <1399553109-6487-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1399553109-6487-1-git-send-email-t.figa@samsung.com>
References: <1399553109-6487-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0hTYRzGe899q1Onk8mriMFAqUgrM3oTu9ink/QhkIii0qnzkk5lJyUL
	U1KDZpt+0DXMy8SMsZTlSry0ac3pKC8ZmyusBamhlhIoMkOznH77/R9+8H/gYXB+BQ9mMnNu
	KVQ58mwZJSWG1p2eiF1FWQlHzANS1K43k6jRMUqiyvkmEpU2mymkMYxTaLnfCFBttQ1DlikP
	iVw9dRRa0jgA0n/oxdAXF4vmV2dp1Obw0qjl00cMed8PUKjqcRuBOhpGAaps0mCo3Oag0cpw
	BYF+vn1AILP+F4FMPWsAOdsunw0SWhtagVBW+ogSXFoNJnTXemmh2TqHCRbTQ0r46rFSQl99
	Ky28fFosaF+ZgDDZXAYE43MfLSxZQoX2+ksXd16VxqYqsjMLFKrDp5OkGb2VNjzPF357cGwc
	LwHT+9SAYSAXDV26u2og2cBAOPbNTKmBlOG5FgAX33QSW4cWg76BBeC3KC4cLpVMUn4O4EJg
	jbuP9Es4Z6bh5LB+U9rDxcOuaR3hZ4ILg16XbTNnuTjY2T8Ltt6Fwn9zRszfQsKdgyZbhD/m
	N5TGigW6CrAGsM0E9iryU/LE5HRlVKQoV4r5OemRKblKC9haa7kLtAzG2AHHANkO1hCSkcCT
	8gKxUGkHkMFlAay7MCuBZ1PlhXcUqtxEVX62QrQDjJEEl4Ck7tfkWjzv/oGe1fiGpjpkhs+m
	KL7zgmSReRcHV6N/b9+dfOjPqWO6Bqc1uj9MPH9PX3BlfW6mt9yQyFqrlU/O5N04fnOtaIqb
	8VzXuQe7D5xIMxr/diymMW5WH+QMVHsn0MnvWmdsKf5iv33ifl3MSO1sXVJ1ZPG1zJHURBkh
	ZsiPHsRVovw/9AI2oosCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves Exynos power domain code to use the new generic power
domain look-up framework introduced by previous patch, allowing the new
code to be compiled with CONFIG_ARCH_EXYNOS selected as well.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 .../bindings/arm/exynos/power_domain.txt           | 12 ++--
 arch/arm/mach-exynos/pm_domains.c                  | 81 +---------------------
 kernel/power/Kconfig                               |  2 +-
 3 files changed, 7 insertions(+), 88 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index 5216b41..60f26a8 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -8,6 +8,8 @@ Required Properties:
     * samsung,exynos4210-pd - for exynos4210 type power domain.
 - reg: physical base address of the controller and length of memory mapped
     region.
+- #power-domain-cells: number of cells in power domain specifier;
+    must be 0.
 
 Node of a device using power domains must have a samsung,power-domain property
 defined with a phandle to respective power domain.
@@ -17,12 +19,8 @@ Example:
 	lcd0: power-domain-lcd0 {
 		compatible = "samsung,exynos4210-pd";
 		reg = <0x10023C00 0x10>;
+		#power-domain-cells = <0>;
 	};
 
-Example of the node using power domain:
-
-	node {
-		/* ... */
-		samsung,power-domain = <&lcd0>;
-		/* ... */
-	};
+See Documentation/devicetree/bindings/power/power_domain.txt for description
+of consumer-side bindings.
diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index fe6570e..9cad3c6 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -73,89 +73,14 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
 	return exynos_pd_power(domain, false);
 }
 
-static void exynos_add_device_to_domain(struct exynos_pm_domain *pd,
-					 struct device *dev)
-{
-	int ret;
-
-	dev_dbg(dev, "adding to power domain %s\n", pd->pd.name);
-
-	while (1) {
-		ret = pm_genpd_add_device(&pd->pd, dev);
-		if (ret != -EAGAIN)
-			break;
-		cond_resched();
-	}
-
-	pm_genpd_dev_need_restore(dev, true);
-}
-
-static void exynos_remove_device_from_domain(struct device *dev)
-{
-	struct generic_pm_domain *genpd = dev_to_genpd(dev);
-	int ret;
-
-	dev_dbg(dev, "removing from power domain %s\n", genpd->name);
-
-	while (1) {
-		ret = pm_genpd_remove_device(genpd, dev);
-		if (ret != -EAGAIN)
-			break;
-		cond_resched();
-	}
-}
-
-static void exynos_read_domain_from_dt(struct device *dev)
-{
-	struct platform_device *pd_pdev;
-	struct exynos_pm_domain *pd;
-	struct device_node *node;
-
-	node = of_parse_phandle(dev->of_node, "samsung,power-domain", 0);
-	if (!node)
-		return;
-	pd_pdev = of_find_device_by_node(node);
-	if (!pd_pdev)
-		return;
-	pd = platform_get_drvdata(pd_pdev);
-	exynos_add_device_to_domain(pd, dev);
-}
-
-static int exynos_pm_notifier_call(struct notifier_block *nb,
-				    unsigned long event, void *data)
-{
-	struct device *dev = data;
-
-	switch (event) {
-	case BUS_NOTIFY_BIND_DRIVER:
-		if (dev->of_node)
-			exynos_read_domain_from_dt(dev);
-
-		break;
-
-	case BUS_NOTIFY_UNBOUND_DRIVER:
-		exynos_remove_device_from_domain(dev);
-
-		break;
-	}
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block platform_nb = {
-	.notifier_call = exynos_pm_notifier_call,
-};
-
 static __init int exynos4_pm_init_power_domain(void)
 {
-	struct platform_device *pdev;
 	struct device_node *np;
 
 	for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
 		struct exynos_pm_domain *pd;
 		int on;
 
-		pdev = of_find_device_by_node(np);
-
 		pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 		if (!pd) {
 			pr_err("%s: failed to allocate memory for domain\n",
@@ -168,17 +93,13 @@ static __init int exynos4_pm_init_power_domain(void)
 		pd->base = of_iomap(np, 0);
 		pd->pd.power_off = exynos_pd_power_off;
 		pd->pd.power_on = exynos_pd_power_on;
-		pd->pd.of_node = np;
-
-		platform_set_drvdata(pdev, pd);
 
 		on = __raw_readl(pd->base + 0x4) & S5P_INT_LOCAL_PWR_EN;
 
 		pm_genpd_init(&pd->pd, NULL, !on);
+		of_genpd_add_provider(np, of_genpd_xlate_simple, &pd->pd);
 	}
 
-	bus_register_notifier(&platform_bus_type, &platform_nb);
-
 	return 0;
 }
 arch_initcall(exynos4_pm_init_power_domain);
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 45aa98e..b17588c 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -308,7 +308,7 @@ config PM_GENERIC_DOMAINS_RUNTIME
 
 config PM_GENERIC_DOMAINS_OF
 	def_bool y
-	depends on PM_GENERIC_DOMAINS && OF && !ARCH_EXYNOS
+	depends on PM_GENERIC_DOMAINS && OF
 
 config CPU_PM
 	bool
-- 
1.9.2

