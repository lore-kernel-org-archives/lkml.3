Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaDYMPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaDYMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:08 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f7-535a51ca3f6f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 10/10] ARM: EXYNOS: Add device tree based initialization
 support for PMU.
Date: Fri, 25 Apr 2014 21:32:46 +0900
Message-id: <1398429166-5539-11-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+Zse6pwKhgg53v+Cw2zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6My9dmMxassKu4ekOigXGxSRcj
	J4eEgInEvadzGCFsMYkL99azdTFycQgJLGOUaL4zkwWmqLF9GhNEYhGjxJX9N1ghnDYmiSO9
	K8Cq2AR0JZ68n8sMYosIZEtcabwPZjMLvGeU+HxYHcQWFoiT2LvkJBOIzSKgKrH053kwm1fA
	Q6Jh+Tmg1RxA2xQk5kyyAQlzAoVPLP/IDrGrlVHi/O/bLCCOhMA2dommPxNZIQYJSHybfIgF
	ollWYtMBZoirJSUOrrjBMoFReAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkFjo3cF4
	+4D1IcZkoHETmaVEk/OBsZRXEm9obGZkYWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYzCBb+mnciaKHjemXO6YcLB58t5PlYsFJeTNbY7WxJ5KXR7wbPiUL1P
	V50+l0m+N4td+2Gawm1dvms1/xX1XQxmtKnN+lcvU8obvnjVprQj58rS3tQfe1919O3f81We
	irw/m2/q6nPN2F9Son/91g2Wop1vfY0OLX7IKvVp8bkZu07ci9/swCqvxFKckWioxVxUnAgA
	QU5vt5sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd1TgVHBBuf+cVhsnLGe1WLZpLts
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi0dYv7BaH37SzWqyf8ZrF4uaz7UwWO1pWszjw
	eLQ097B5bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYMy5fm81YsMKu4uoNiQbGxSZdjJwcEgImEo3t05ggbDGJC/fWs3UxcnEICSxilLiy/wYr
	hNPGJHGkdwULSBWbgK7Ek/dzmUFsEYFsiSuN98FsZoH3jBKfD6uD2MICcRJ7l5wEm8oioCqx
	9Od5MJtXwEOiYfk5oA0cQNsUJOZMsgEJcwKFTyz/yA6xq5VR4vzv2ywTGHkXMDKsYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAiOtGfSOxhXNVgcYhTgYFTi4Z0gGxksxJpYVlyZe4hRgoNZ
	SYT3g19UsBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJLiSbnA5NAXkm8obGJmZGlkZmFkYm5OWnC
	SuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwtnP49Heb+TZ3v/6m3b47XUlr15qT0t2xuzKc
	Zi5emfPP6OLPtAWHe7T/M6dkagjdEWSJUbpyILF/jd3BaXfennz0+6Zo/OazTGFnOzTefZ1g
	6jeX573NJObNwhaHuhjT95w88/pSyrHJV9WvZ2YemWCwyNXElmnZPhX1yXo2ea936ixe/zvk
	sRJLcUaioRZzUXEiANFvBKv4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree based initialization for PMU and modifies
PMU initialization implementation in following way:

1: Let's initialize PMU based on device tree compatibility string.
2: Obtain PMU regmap handle using "syscon_early_regmap_lookup_by_phandle"
so that we can reduce dependency over machine header files.
3: Separate each SoC's PMU initialization function and bind this initialization
function with PMU compatibility string.
4 : It also removes uses of soc_is_exynosXXXX() thus making PMU implementation
independent of "plat/cpu.h".

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |  182 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 138 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 67116a5..abcf753 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -9,17 +9,31 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/regmap.h>
-
-#include <plat/cpu.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/mfd/syscon.h>
 
 #include "common.h"
 #include "regs-pmu.h"
 
+enum exynos_pmu_id {
+	PMU_EXYNOS4210,
+	PMU_EXYNOS4X12,
+	PMU_EXYNOS4412,
+	PMU_EXYNOS5250,
+};
+
+struct exynos_pmu_data {
+	enum exynos_pmu_id	pmu_id;
+	struct regmap		*pmu_regmap;
+};
+
+struct exynos_pmu_data		*pmu_data;
 static const struct exynos_pmu_conf *exynos_pmu_config;
-static struct regmap *pmu_regmap;
+typedef void (*exynos_pmu_init_t)(void);
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
@@ -348,28 +362,31 @@ static void exynos5_init_pmu(void)
 	 * Enable both SC_FEEDBACK and SC_COUNTER
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
-		regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i], &tmp);
+		regmap_read(pmu_data->pmu_regmap,
+				exynos5_list_both_cnt_feed[i], &tmp);
 		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
 			EXYNOS5_USE_SC_COUNTER);
-		regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i], tmp);
+		regmap_write(pmu_data->pmu_regmap,
+				exynos5_list_both_cnt_feed[i], tmp);
 	}
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
 	 */
-	regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
+	regmap_read(pmu_data->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
 	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
+	regmap_write(pmu_data->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
 
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
-		tmp = regmap_read(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
-				&tmp);
+		tmp = regmap_read(pmu_data->pmu_regmap,
+				exynos5_list_diable_wfi_wfe[i], &tmp);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i], tmp);
+		regmap_write(pmu_data->pmu_regmap,
+				exynos5_list_diable_wfi_wfe[i], tmp);
 	}
 }
 
@@ -377,52 +394,129 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 
-	if (soc_is_exynos5250())
+	if (pmu_data->pmu_id == PMU_EXYNOS5250)
 		exynos5_init_pmu();
 
 	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
-		regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
+		regmap_write(pmu_data->pmu_regmap, exynos_pmu_config[i].offset,
 				exynos_pmu_config[i].val[mode]);
 
-	if (soc_is_exynos4412()) {
+	if (pmu_data->pmu_id == PMU_EXYNOS4412) {
 		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
-			regmap_write(pmu_regmap, exynos4412_pmu_config[i].offset,
+			regmap_write(pmu_data->pmu_regmap,
+					exynos4412_pmu_config[i].offset,
 					exynos4412_pmu_config[i].val[mode]);
 	}
 }
 
-static int __init exynos_pmu_init(void)
+static void exynos4210_pmu_init(void)
 {
-	unsigned int value;
-
 	exynos_pmu_config = exynos4210_pmu_config;
-	pmu_regmap = get_exynos_pmuregmap();
-
-	if (soc_is_exynos4210()) {
-		exynos_pmu_config = exynos4210_pmu_config;
-		pr_info("EXYNOS4210 PMU Initialize\n");
-	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
-		exynos_pmu_config = exynos4x12_pmu_config;
-		pr_info("EXYNOS4x12 PMU Initialize\n");
-	} else if (soc_is_exynos5250()) {
-		/*
-		 * When SYS_WDTRESET is set, watchdog timer reset request
-		 * is ignored by power management unit.
-		 */
-		regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &value);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, value);
-
-		regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &value);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, value);
-
-		exynos_pmu_config = exynos5250_pmu_config;
-		pr_info("EXYNOS5250 PMU Initialize\n");
-	} else {
-		pr_info("EXYNOS: PMU not supported\n");
+	pmu_data->pmu_id = PMU_EXYNOS4210;
+
+	pr_info("EXYNOS4210 PMU Initialize\n");
+}
+
+static void exynos4x12_pmu_init(void)
+{
+	exynos_pmu_config = exynos4x12_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS4X12;
+
+	pr_info("EXYNOS4x12 PMU Initialize\n");
+}
+
+static void exynos4412_pmu_init(void)
+{
+	exynos_pmu_config = exynos4x12_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS4412;
+
+	pr_info("EXYNOS4412 PMU Initialize\n");
+}
+
+static void exynos5250_pmu_init(void)
+{
+	unsigned int tmp;
+
+	/*
+	 * When SYS_WDTRESET is set, watchdog timer reset request
+	 * is ignored by power management unit.
+	 */
+	regmap_read(pmu_data->pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &tmp);
+	tmp &= ~EXYNOS5_SYS_WDTRESET;
+	regmap_write(pmu_data->pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, tmp);
+
+	regmap_read(pmu_data->pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &tmp);
+	tmp &= ~EXYNOS5_SYS_WDTRESET;
+	regmap_write(pmu_data->pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, tmp);
+
+	exynos_pmu_config = exynos5250_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS5250;
+
+	pr_info("EXYNOS5250 PMU Initialize\n");
+}
+
+/*
+ * PMU platform driver and devicetree bindings.
+ */
+static struct of_device_id exynos_pmu_of_device_ids[] = {
+	{
+		.compatible = "samsung,exynos4210-pmu",
+		.data = (void *)exynos4210_pmu_init
+	},
+	{
+		.compatible = "samsung,exynos4212-pmu",
+		.data = (void *)exynos4x12_pmu_init
+	},
+	{
+		.compatible = "samsung,exynos4412-pmu",
+		.data = (void *)exynos4412_pmu_init
+	},
+	{
+		.compatible = "samsung,exynos5250-pmu",
+		.data = (void *)exynos5250_pmu_init
+	},
+	{},
+};
+
+static int exynos_pmu_probe(struct device_node *np)
+{
+	const struct of_device_id *match;
+	exynos_pmu_init_t exynos_pmu_init;
+
+	pmu_data = kzalloc(sizeof(struct exynos_pmu_data), GFP_KERNEL);
+	if (!pmu_data) {
+		pr_err("exynos_pmu driver probe failed\n");
+		return -ENOMEM;
 	}
 
+	match = of_match_node(exynos_pmu_of_device_ids, np);
+	if (!match) {
+		pr_err("fail to get matching of_match struct\n");
+		return -EINVAL;
+	}
+
+	exynos_pmu_init = match->data;
+
+	pmu_data->pmu_regmap = syscon_early_regmap_lookup_by_phandle(np,
+			"samsung,syscon-phandle");
+	if (IS_ERR(pmu_data->pmu_regmap)) {
+		pr_err("failed to find exynos_pmu_regmap\n");
+		return PTR_ERR(pmu_data->pmu_regmap);
+	}
+
+	exynos_pmu_init();
+
 	return 0;
+};
+
+static int __init exynos_pmu_of_init(void)
+{
+	int ret = 0;
+	struct device_node *np;
+
+	for_each_matching_node_and_match(np, exynos_pmu_of_device_ids, NULL)
+		ret = exynos_pmu_probe(np);
+
+	return ret ? ret:0;
 }
-arch_initcall(exynos_pmu_init);
+arch_initcall(exynos_pmu_of_init);
-- 
1.7.10.4

