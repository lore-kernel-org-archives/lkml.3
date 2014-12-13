Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaLMQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:59:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45021 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaLMQ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:58:57 -0500
X-AuditID: cbfee68d-f79296d000004278-0f-548c704f5421
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, khilman@linaro.org, rjw@rjwysocki.net,
        len.brown@intel.com, ulf.hansson@linaro.org, tomasz.figa@gmail.com,
        kgene.kim@samsung.com, s.nawrocki@samsung.com, thomas.ab@samsung.com,
        pankaj.dubey@samsung.com, m.szyprowski@samsung.com,
        geert+renesas@glider.be, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v3 2/2] clk: samsung: Add PM runtime support for clocks.
Date: Sat, 13 Dec 2014 22:21:58 +0530
Message-id: <1418489518-7252-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkWte/oCfE4P9ecYuGqyEWc2dPYrTo
	XXCVzeLr4RWMFrOm7GWy2PT4GqvF5V1z2Cw+9x5htJhxfh+Txdojd9ktFm39wm5x5vQlVovD
	b9pZLTqWMVqs2vWH0eL42nAHAY+JZ3U9ds66y+6xeM9LJo871/aweWxeUu+x5Wo7i0ffllWM
	Hp83yQVwRHHZpKTmZJalFunbJXBlbFjxiL3gunrFobMrGBsYNyh2MXJySAiYSKxp6GWBsMUk
	Ltxbz9bFyMUhJLCUUaLz9iT2LkYOsKI5q1Ih4tMZJS5uucQC4Uxgklj79ylYN5uAscTPnfvZ
	QWwRAQ2JKV2P2UGKmAWmMEt0tC5iAkkIC/hIHN6+nw3EZhFQldjWtBgszivgJvF2/n5WiDPk
	JLbcegQ2iFPAXaJ/93SwGiGgmu3Lr7CCDJUQ+Mgu8e9kIxPEIAGJb5MPsUCcKiux6QAzxBxJ
	iYMrbrBMYBRewMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwrk7/e9a7g/H2AetDjAIc
	jEo8vBa93SFCrIllxZW5hxhNgTZMZJYSTc4HRm9eSbyhsZmRhamJqbGRuaWZkjivotTPYCGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mh++p2ZiJeaUpPBO2380+IXnWnaM50hOlvVTt3FwX
	353t8I7r796vu0Vezb+e2ZyuEn7llf+PFb9KfxVf3vXgmckk7f88D7KrFxY+f/WQKaW4pnt2
	7gqHxzVcU2Oa1oin6d8LPZ+8ovC6V7vP9PpdSzgOpXrYTnxz/oPK0U8/T5QFcKRPqXPpVWIp
	zkg01GIuKk4EAD9Z5eumAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQV3/gp4Qgzd/eSwaroZYzJ09idGi
	d8FVNouvh1cwWsyaspfJYtPja6wWl3fNYbP43HuE0WLG+X1MFmuP3GW3WLT1C7vFmdOXWC0O
	v2lntehYxmixatcfRovja8MdBDwmntX12DnrLrvH4j0vmTzuXNvD5rF5Sb3HlqvtLB59W1Yx
	enzeJBfAEdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdL6SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPDikfsBdfVKw6d
	XcHYwLhBsYuRg0NCwERizqrULkZOIFNM4sK99WxdjFwcQgLTGSUubrnEAuFMYJJY+/cpC0gV
	m4CxxM+d+9lBbBEBDYkpXY/ZQYqYBaYwS3S0LmICSQgL+Egc3r6fDcRmEVCV2Na0GCzOK+Am
	8Xb+flaIdXISW249AhvEKeAu0b97OliNEFDN9uVXWCcw8i5gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERy1z6R2MK5ssDjEKMDBqMTDa9HbHSLEmlhWXJl7iFGCg1lJhDcsqydEiDcl
	sbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OBCSWvJN7Q2MTc1NjU0sTCxMxSSZxXyb4tREggPbEk
	NTs1tSC1CKaPiYNTqoHRcaLq8iq+vrMHTwjNFC7n6v3wZWs0W2fhZMV5RzN2Wb2IE7MwPpge
	W1QY3usjkcIldDBR9MGipKXz9syIjr197fFOtdrv4W89Kj+vVeOx5Hp3fBbvy22Jtb/dYp2n
	iz7WC17R9uK436QfUktsw27tslj/m2PLYqGvfNz1cf89b1zLlpXRddypxFKckWioxVxUnAgA
	xl05gfACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PM runtime support for clocks associated with Power
Domain. The PM runtime suspend/resume handlers will be called when the
power domain associated with it, is turned on/off.

The registration of clocks happen in early initailisation. The probe
is later called to register the clock device with the power domain.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/clk/samsung/clk.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/samsung/clk.h | 11 ++++++
 2 files changed, 106 insertions(+)

diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index dd1f7c9..c517aa8 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -11,6 +11,10 @@
  * clock framework for Samsung platforms.
 */
 
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_domain.h>
+#include <linux/pm_runtime.h>
 #include <linux/syscore_ops.h>
 #include "clk.h"
 
@@ -370,6 +374,93 @@ static void samsung_clk_sleep_init(void __iomem *reg_base,
 		unsigned long nr_rdump) {}
 #endif
 
+static int samsung_cmu_runtime_suspend(struct device *dev)
+{
+	struct samsung_clock_pd_reg_cache *reg_cache;
+
+	reg_cache = dev_get_drvdata(dev);
+	samsung_clk_save(reg_cache->reg_base, reg_cache->rdump,
+			reg_cache->rd_num);
+	return 0;
+}
+
+static int samsung_cmu_runtime_resume(struct device *dev)
+{
+	struct samsung_clock_pd_reg_cache *reg_cache;
+
+	reg_cache = dev_get_drvdata(dev);
+	samsung_clk_restore(reg_cache->reg_base, reg_cache->rdump,
+			reg_cache->rd_num);
+	return 0;
+}
+
+#define MAX_CMU_DEVICE_MATCH	50
+static int samsung_cmu_count;
+static struct of_device_id samsung_cmu_match[MAX_CMU_DEVICE_MATCH];
+MODULE_DEVICE_TABLE(of, samsung_cmu_match);
+
+static void samsung_clk_pd_init(struct device_node *np, void __iomem *reg_base,
+				struct samsung_cmu_info *cmu)
+{
+	struct samsung_clock_pd_reg_cache *pd_reg_cache;
+	const char *name;
+
+	if (samsung_cmu_count == MAX_CMU_DEVICE_MATCH)
+		panic("Maximum clock device limit reached.\n");
+
+	if (of_property_read_string_index(np, "compatible", 0, &name))
+		panic("Invalid DT node.\n");
+
+	pd_reg_cache = kzalloc(sizeof(struct samsung_clock_pd_reg_cache),
+			GFP_KERNEL);
+	if (!pd_reg_cache)
+		panic("Could not allocate register reg_cache.\n");
+
+	pd_reg_cache->rdump = samsung_clk_alloc_reg_dump(cmu->pd_clk_regs,
+				cmu->nr_pd_clk_regs);
+	if (!pd_reg_cache->rdump)
+		panic("Could not allocate register dump storage.\n");
+
+	pd_reg_cache->reg_base = reg_base;
+	pd_reg_cache->rd_num = cmu->nr_pd_clk_regs;
+
+	/* Fill up the compatible string and data */
+	samsung_cmu_match[samsung_cmu_count].data = pd_reg_cache;
+	strcpy(samsung_cmu_match[samsung_cmu_count].compatible, name);
+	samsung_cmu_count++;
+}
+
+static int __init samsung_cmu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct of_device_id *match;
+
+	/* get the platform data */
+	match = (struct of_device_id *)of_match_node(samsung_cmu_match,
+							pdev->dev.of_node);
+	if (!match)
+		return 0;
+	platform_set_drvdata(pdev, (void *)match->data);
+	pm_runtime_enable(dev);
+	pm_genpd_dev_need_restore(dev,
+				GPD_DEV_RESTORE_FORCE | GPD_DEV_SUSPEND_INIT);
+	return 0;
+}
+
+static const struct dev_pm_ops samsung_cmu_pm_ops = {
+	SET_RUNTIME_PM_OPS(samsung_cmu_runtime_suspend,
+			samsung_cmu_runtime_resume, NULL)
+};
+
+static struct platform_driver samsung_cmu_driver = {
+	.driver = {
+		.name   = "exynos-clk",
+		.of_match_table = samsung_cmu_match,
+		.pm = &samsung_cmu_pm_ops,
+	},
+	.probe = samsung_cmu_probe,
+};
+
 /*
  * Common function which registers plls, muxes, dividers and gates
  * for each CMU. It also add CMU register list to register cache.
@@ -409,5 +500,9 @@ void __init samsung_cmu_register_one(struct device_node *np,
 		samsung_clk_sleep_init(reg_base, cmu->clk_regs,
 			cmu->nr_clk_regs);
 
+	if (cmu->pd_clk_regs)
+		samsung_clk_pd_init(np, reg_base, cmu);
+
 	samsung_clk_of_add_provider(np, ctx);
 }
+module_platform_driver(samsung_cmu_driver);
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index 3f471e9..c184ec1 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -331,6 +331,12 @@ struct samsung_clock_reg_cache {
 	unsigned int rd_num;
 };
 
+struct samsung_clock_pd_reg_cache {
+	void __iomem *reg_base;
+	struct samsung_clk_reg_dump *rdump;
+	unsigned int rd_num;
+};
+
 struct samsung_cmu_info {
 	/* list of pll clocks and respective count */
 	struct samsung_pll_clock *pll_clks;
@@ -356,6 +362,11 @@ struct samsung_cmu_info {
 	/* list and number of clocks registers */
 	unsigned long *clk_regs;
 	unsigned int nr_clk_regs;
+
+	/* list and number of clocks to be saved/restored during
+	 * power domain shutdown */
+	unsigned long *pd_clk_regs;
+	unsigned int nr_pd_clk_regs;
 };
 
 extern struct samsung_clk_provider *__init samsung_clk_init(
-- 
2.2.0

