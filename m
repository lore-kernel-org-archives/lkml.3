Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaKXNSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:18:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14053 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaKXNSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:18:39 -0500
X-AuditID: cbfee68f-f791c6d000004834-12-5473302d0e62
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 08/12] soc: samsung: pm_domain: Add support for parent
 power domain
Date: Mon, 24 Nov 2014 18:34:12 +0530
Message-id: <1416834256-11225-8-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSpatrUBxi8Oi2gkXD1RCL+UfOsVo8
	u7WXyaJ3wVU2i6ebHzNZbHp8jdXi8q45bBafe48wWsw4v4/JYtHWL+wWZ05fYrU4/Kad1eL4
	2nAHXo9NqzrZPO5c28PmcehwB6PH5iX1HluutrN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0C
	V8bu6fdZCvZKVuz9eIipgXGnSBcjJ4eEgIlE+8+ZjBC2mMSFe+vZuhi5OIQEljJKnHx1hx2m
	qKdzM1RiOqPElOnPGSGcCUwSB+/fYwapYhMwlvi5cz9QBweHiIC3xPJriiA1zAKrmSS2tn9g
	AqkRFoiR2PPrDBtIDYuAqsTz01ogYV4Bd4nbe7uZQMISAgoScybZgIQ5BTwkXhxsYYZY1cIo
	cenxXFYQR0LgGrvE2+fL2UCqWAQEJL5NPsQC0SwrsekAM8TRkhIHV9xgmcAovICRYRWjaGpB
	ckFxUnqRsV5xYm5xaV66XnJ+7iZGYMSc/vesfwfj3QPWhxgFOBiVeHhnrC8KEWJNLCuuzD3E
	aAq0YSKzlGhyPjAu80riDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwNj459tCRTEBvkW6YZFqibcPPY9SOHBhhlC+5JFOKfvUY0vvfzl6MEBDKPRUwaui
	2pfzJAqmpsmFL3Scf1il/fOlNzO1tzjOv3Rvr8e0lrbY3a3nOTRY5G47PDq6mZXlm/7B50kH
	1X0m3TMyPt131Ove7VNtJhJJW5bXtfySfBzYdXnO11XSBeVKLMUZiYZazEXFiQBuDtvrkwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQV1dg+IQg2UbRC0aroZYzD9yjtXi
	2a29TBa9C66yWTzd/JjJYtPja6wWl3fNYbP43HuE0WLG+X1MFou2fmG3OHP6EqvF4TftrBbH
	14Y78HpsWtXJ5nHn2h42j0OHOxg9Ni+p99hytZ3Fo2/LKkaPz5vkAtijGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jBm7J5+n6Vgr2TF3o+HmBoYd4p0MXJySAiYSPR0bmaD
	sMUkLtxbD2RzcQgJTGeUmDL9OSOEM4FJ4uD9e8wgVWwCxhI/d+5n72Lk4BAR8JZYfk0RpIZZ
	YDWTxNb2D0wgNcICMRJ7fp1hA6lhEVCVeH5aCyTMK+AucXtvNxNIWEJAQWLOJBuQMKeAh8SL
	gy3MEKtaGCUuPZ7LOoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Hh8Jr2DcVWD
	xSFGAQ5GJR7eGeuLQoRYE8uKK3MPMUpwMCuJ8IqJFYcI8aYkVlalFuXHF5XmpBYfYjQFOmoi
	s5Rocj4wVeSVxBsam5ibGptamliYmFkqifPeuJkbIiSQnliSmp2aWpBaBNPHxMEp1cDI+zO8
	jP3uXaa4nU17LpyzWKjmd7Ra0dN+0efL0j0vmjM+lX/gdFa2v7R3sdQtlczjVl+nSGktS4rI
	4n2hlPG4J/T9la0Lp8S2btmxgENNK+vR8dSkzgOG9i45DM0LhSM4/69bszvz4G3uns701g++
	TyLjpT9dfXc4uTrKt0W2cl+oTOHXWy5KLMUZiYZazEXFiQB6ClOc3QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds supports for parent power domain. This will ensure
invoking of parent/child power domain on/off in a correct sequence.
In exynos7 SOC's, power domain controllers have parent and child
hierarchy.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../bindings/arm/exynos/power_domain.txt           |    2 +
 drivers/soc/samsung/pm_domains.c                   |   43 +++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index 00ebda1..0160bdc 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -24,6 +24,7 @@ Optional Properties:
 	- pclkN, clkN: Pairs of parent of input clock and input clock to the
 		devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
 		are supported currently.
+- parents: phandle of parent power domains.
 
 Node of a device using power domains must have a samsung,power-domain property
 defined with a phandle to respective power domain.
@@ -48,6 +49,7 @@ Example:
 	mfc_pd: power-domain@10044060 {
 		compatible = "samsung,exynos4210-pd", "samsung,exynos7-pd-mfc";
 		reg = <0x10044060 0x20>;
+		parents = <&pd_top>;
 		#power-domain-cells = <0>;
 	};
 
diff --git a/drivers/soc/samsung/pm_domains.c b/drivers/soc/samsung/pm_domains.c
index f4f2a6c..89e2fd5 100644
--- a/drivers/soc/samsung/pm_domains.c
+++ b/drivers/soc/samsung/pm_domains.c
@@ -25,10 +25,10 @@
 #include <linux/soc/samsung/exynos-pmu.h>
 
 #define MAX_CLK_PER_DOMAIN	4
+#define MAX_PARENT_POWER_DOMAIN	10
 
 static struct exynos_pmu_pd_ops *pd_ops;
 
-
 /*
  * Exynos specific wrapper around the generic power domain
  */
@@ -169,6 +169,47 @@ no_clk:
 		of_genpd_add_provider_simple(np, &pd->pd);
 	}
 
+	/* Assign the child power domains to their parents */
+	for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
+		struct device_node *parent_np;
+		int i;
+		struct generic_pm_domain *child_domain, *parent_domain;
+		const char *name;
+
+		if (of_property_read_string_index(np, "compatible", 1,
+					&name)) {
+			/* Second entry not found, use the node name*/
+			name = np->name;
+		}
+
+		child_domain = pm_genpd_lookup_name(name);
+		if (!child_domain)
+			continue;
+		/* search parents in device tree */
+		for (i = 0; i < MAX_PARENT_POWER_DOMAIN; i++) {
+			parent_np = of_parse_phandle(np, "parents", i);
+			if (!parent_np)
+				break;
+
+			if (of_property_read_string_index(parent_np,
+						"compatible", 1, &name)) {
+				/* Second entry not found, use the node name*/
+				name = parent_np->name;
+			}
+
+			parent_domain = pm_genpd_lookup_name(name);
+			if (!parent_domain)
+				break;
+			if (pm_genpd_add_subdomain(parent_domain, child_domain))
+				pr_warn("%s failed to add subdomain: %s\n",
+						parent_domain->name,
+						child_domain->name);
+			else
+				pr_info("%s has as child subdomain: %s.\n",
+						parent_domain->name,
+						child_domain->name);
+		}
+	}
 	return 0;
 }
 
-- 
1.7.9.5

