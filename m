Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3JIGcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:32:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3JIGap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:30:45 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-59-5254f7f7cce3
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 2/5] thermal: exynos: Provide separate TMU data for
 Exynos4412
Date: Wed, 09 Oct 2013 08:29:51 +0200
Message-id: <1381300194-13134-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd0f30OCDCYuZrNouBpisXHGelaL
	+UfOsVqs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVsFmdO
	X2K1ePKwj81i/YzXLA78Hov3vGTyWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQC2KC6blNSc
	zLLUIn27BK6Mn+2PWQuWaFb83/CGrYGxRbmLkZNDQsBE4tyjp4wQtpjEhXvr2UBsIYHpjBKL
	Lqt3MXIB2V1MEvvWHWMBSbAJ6El8vvuUCcQWEciQOHVpNhNIEbPAX2aJ69MgioQFgiWu9u8A
	s1kEVCXe3Z7CDGLzCrhJHJ+4jQ1im7zE0/t9YDangLvEwTvv2CG2NTNKPLq4iWUCI+8CRoZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHh+kxqB+PKBotDjAIcjEo8vA/4Q4KEWBPLiitz
	DzFKcDArifDmLQQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi
	4JRqYGQ/Gxtje/11z1xubqGTX6/eucKZnr73czzb7PREzcSK5aWXGzTX1Jwpcir/1qwmfzXX
	/0Yjx7ekidxrd93rXHVvkv+2wo82ivMubE1u+HdnYR3D6dcJgjy2luflSo56NCpd+n7zKu/q
	rBnyU9w+GuyJS1l6uKtsp9M8qQXFkneelJW9ztmY/1GJpTgj0VCLuag4EQBIa3W6UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till now Exynos5250 and Exynos4412 had the same definitions for TMU
data. Following commit changes that, by introducing separate
exynos4412_default_tmu_data structure.

Since Exynos4412 was chronologically first, the corresponding name for
TMU registers and default data was renamed.

Additionally, new SOC_ARCH_EXYNOS4412 type has been defined.

Moreover, the SOC_ARCH_EXYNOS name has been changed to SOC_ARCH_EXYNOS5250.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes for v2:
- Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
- Fix coding style for tmu_data elements definition

 drivers/thermal/samsung/exynos_tmu.c      |    9 +++++----
 drivers/thermal/samsung/exynos_tmu.h      |    3 ++-
 drivers/thermal/samsung/exynos_tmu_data.c |   28 ++++++++++++++++++++++------
 drivers/thermal/samsung/exynos_tmu_data.h |    9 ++++++++-
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b43afda..1312b34 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -488,7 +488,7 @@ static const struct of_device_id exynos_tmu_match[] = {
 	},
 	{
 		.compatible = "samsung,exynos4412-tmu",
-		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
+		.data = (void *)EXYNOS4412_TMU_DRV_DATA,
 	},
 	{
 		.compatible = "samsung,exynos5250-tmu",
@@ -629,9 +629,10 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (pdata->type == SOC_ARCH_EXYNOS ||
-		pdata->type == SOC_ARCH_EXYNOS4210 ||
-				pdata->type == SOC_ARCH_EXYNOS5440)
+	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
+	    pdata->type == SOC_ARCH_EXYNOS4412 ||
+	    pdata->type == SOC_ARCH_EXYNOS5250 ||
+	    pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
 	else {
 		ret = -EINVAL;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index b364c9e..b42ece4 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -41,7 +41,8 @@ enum calibration_mode {
 
 enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
-	SOC_ARCH_EXYNOS,
+	SOC_ARCH_EXYNOS4412,
+	SOC_ARCH_EXYNOS5250,
 	SOC_ARCH_EXYNOS5440,
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 9002499..d8de5c1 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -90,8 +90,8 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 };
 #endif
 
-#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
-static const struct exynos_tmu_registers exynos5250_tmu_registers = {
+#if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
+static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
@@ -128,7 +128,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
 	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
 };
 
-#define EXYNOS5250_TMU_DATA \
+#define EXYNOS4412_TMU_DATA \
 	.threshold_falling = 10, \
 	.trigger_levels[0] = 85, \
 	.trigger_levels[1] = 103, \
@@ -162,15 +162,31 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
 		.temp_level = 103, \
 	}, \
 	.freq_tab_count = 2, \
-	.type = SOC_ARCH_EXYNOS, \
-	.registers = &exynos5250_tmu_registers, \
+	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
 			TMU_SUPPORT_EMUL_TIME)
+#endif
 
+#if defined(CONFIG_SOC_EXYNOS4412)
+struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
+	.tmu_data = {
+		{
+			EXYNOS4412_TMU_DATA,
+			.type = SOC_ARCH_EXYNOS4412,
+		},
+	},
+	.tmu_count = 1,
+};
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS5250)
 struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 	.tmu_data = {
-		{ EXYNOS5250_TMU_DATA },
+		{
+			EXYNOS4412_TMU_DATA,
+			.type = SOC_ARCH_EXYNOS5250,
+		},
 	},
 	.tmu_count = 1,
 };
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index dc7feb5..b130b1e 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -138,7 +138,14 @@ extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
 #define EXYNOS4210_TMU_DRV_DATA (NULL)
 #endif
 
-#if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412))
+#if defined(CONFIG_SOC_EXYNOS4412)
+extern struct exynos_tmu_init_data const exynos4412_default_tmu_data;
+#define EXYNOS4412_TMU_DRV_DATA (&exynos4412_default_tmu_data)
+#else
+#define EXYNOS4412_TMU_DRV_DATA (NULL)
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS5250)
 extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
 #define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
 #else
-- 
1.7.10.4

