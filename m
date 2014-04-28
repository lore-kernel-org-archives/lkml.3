Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaD1MCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:02:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45358 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbaD1MCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:02:19 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-8b-535e4349287c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, b.zolnierkie@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RESUBMIT RFC PATCH v2 1/3] ARM: EXYNOS: Move PMU specific definitions
 from common.h
Date: Mon, 28 Apr 2014 21:20:05 +0900
Message-id: <1398687607-4554-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+Zvq6nc1ywQd86TouNM9azWiybdJfN
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81os2vqF3WL9jNcsFjefbWey2NGymsWB26OluYfN
	Y/OSeo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmHG1l6Vgo3TFv3nfWBoYv4p1MXJySAiY
	SHxfvoARwhaTuHBvPVsXIxeHkMAyRokfnVtYYIom7NzBDpGYzihx8ONCVginjUni37+lYO1s
	AroST97PZQaxRQSyJa403mcGKWIWuMoocfJlO1hCWCBe4tO5RWANLAKqEnsOnWAHsXkF3CXe
	Lj0AZHMArVOQmDPJBiTMKeAhsfriEzYQWwiopGPBNWaIi7axSzw5zQUxRkDi2+RDLBCtshKb
	DkCVSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIRHQt4Px5gHrQ4zJ
	QOMmMkuJJucDIyivJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTAK3xbMinAT+xaVUeF/55RxqfTx5vkHQ7vfm2ec999j1doYlDKNofNP5saEw5kS
	rJwm0mEdhVo/r/JbzbzCdFfWKTxQ8uyTg/umve2p+rHIXjy+ZdOb3p/1XbOWmCw+t4NFcMby
	KyUi36vKjqeobn2evcf3SsnDw/1br3Y6+lea5fx6Gtj3XFOJpTgj0VCLuag4EQADycYalgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQV1P57hgg9PTmC02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdov1M16zWNx8tp3JYkfLahYHbo+W5h42
	j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aM
	q70sBRulK/7N+8bSwPhVrIuRk0NCwERiws4d7BC2mMSFe+vZuhi5OIQEpjNKHPy4kBXCaWOS
	+PdvKSNIFZuArsST93OZQWwRgWyJK433mUGKmAWuMkqcfNkOlhAWiJf4dG4RWAOLgKrEnkMn
	wFbwCrhLvF16AMjmAFqnIDFnkg1ImFPAQ2L1xSdsILYQUEnHgmvMExh5FzAyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIjrBn0jsYVzVYHGIU4GBU4uGNmBMbLMSaWFZcmXuIUYKDWUmE
	19MpLliINyWxsiq1KD++qDQntfgQYzLQUROZpUST84HRn1cSb2hsYmZkaWRmYWRibk6asJI4
	78FW60AhgfTEktTs1NSC1CKYLUwcnFINjKtj9dbERO8OvvP/lta74JMvvqf9m+RudXe74ta9
	4T85vJ59umY61/IFj6XF6QQLh5BuTZFjL+/kTjkU17dp2efqNbHNjJ1hn3XDnR/+mmk6ISLp
	f/4TSeH9eyX/66458NRXJTyg86mPc2iJt5jht1cflS48st66f9fTM/5dr2e+6rq486HthTlK
	LMUZiYZazEXFiQAKnjo49AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Younggun Jang <yg1004.jang@samsung.com>

This patch moves PMU specific definitions into a new file
as exynos-pmu.h. This will help in making PMU implementation
independent of common.h header.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h     |   17 -----------------
 arch/arm/mach-exynos/cpuidle.c    |    1 +
 arch/arm/mach-exynos/exynos-pmu.h |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |    2 +-
 5 files changed, 34 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index ad5128e..d848ede 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -38,24 +38,7 @@ extern struct smp_operations exynos_smp_ops;
 
 extern void exynos_cpu_die(unsigned int cpu);
 
-/* PMU(Power Management Unit) support */
-
-#define PMU_TABLE_END	0xFFFF
-
-enum sys_powerdown {
-	SYS_AFTR,
-	SYS_LPA,
-	SYS_SLEEP,
-	NUM_SYS_POWERDOWN,
-};
-
 extern unsigned long l2x0_regs_phys;
-struct exynos_pmu_conf {
-	unsigned int offset;
-	unsigned int val[NUM_SYS_POWERDOWN];
-};
-
-extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 
 extern struct regmap *get_exynos_pmuregmap(void);
 extern void __iomem *get_exynos_pmuaddr(void);
diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index 5dcdd46..ff3be9c 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -32,6 +32,7 @@
 
 #include "common.h"
 #include "regs-pmu.h"
+#include "exynos-pmu.h"
 
 #define REG_DIRECTGO_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
new file mode 100644
index 0000000..1cc857b
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS PMU Driver support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_PMU_H
+#define __EXYNOS_PMU_H
+
+#define PMU_TABLE_END	0xFFFF
+
+enum sys_powerdown {
+	SYS_AFTR,
+	SYS_LPA,
+	SYS_SLEEP,
+	NUM_SYS_POWERDOWN,
+};
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	unsigned int val[NUM_SYS_POWERDOWN];
+};
+
+extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+
+#endif /* __EXYNOS_PMU_H */
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index e4c10d4..103ab92 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -37,6 +37,7 @@
 #include "common.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
+#include "exynos-pmu.h"
 
 static struct regmap *pmu_regmap;
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index abcf753..d020557 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/mfd/syscon.h>
 
-#include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 
 enum exynos_pmu_id {
-- 
1.7.10.4

