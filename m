Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbaDBHeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:34:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63643 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbaDBHeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:15 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-f1-533bbd6801df
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 03/10] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file
Date: Wed, 02 Apr 2014 16:50:54 +0900
Message-id: <1396425058-4012-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t8zA92MvdbBBl8f61ksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1iR8tqFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	issmJTUnsyy1SN8ugSujqWECa8ELsYqDk3ayNzBeF+pi5OSQEDCRaPjVyQRhi0lcuLeerYuR
	i0NIYBmjxMpNf1hgiprW3GaCSCxilHi+/AQzhNPGJPGwdRdYO5uArsST93OZQWwRgWyJS7Nu
	sYAUMQvMY5TYdbaTDSQhLBAu8fP8bbAGFgFViTOzNrOD2LwC7hLL1r5k7GLkAFqnIDFnkg1I
	mFPAQ+J+SwtYiRBQydwbO1lBZkoIzGOX+LjoOjvEHAGJb5MPsUD0ykpsOsAMcbWkxMEVN1gm
	MAovYGRYxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRES5L07GG8fsD7EmAw0biKzlGhyPjBK
	8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkemJ
	a/DVP9UJ9294BF7InWbfpH5jn8rh/WuPMd9g8Xt3WeLBgfmCG6rFFnuFFhusc5Lr95bUea66
	Q3el1vyGDT0dDotde94ovvrgd9ciUdTy44Xg/Xcmts5ZvvB6m8nM5oXHvmlZrj745MMOqSu7
	OqbNXt1/9djbL11Zf2e4LF5qzBepdqL4R4YSS3FGoqEWc1FxIgD+IJSPiAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd2MvdbBBt+Pa1osm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1iR8tqFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRlPDBNaCF2IVByftZG9gvC7U
	xcjJISFgItG05jYThC0mceHeerYuRi4OIYFFjBLPl59ghnDamCQetu4Cq2IT0JV48n4uM4gt
	IpAtcWnWLRaQImaBeYwSu852soEkhAXCJX6ehxjLIqAqcWbWZnYQm1fAXWLZ2peMXYwcQOsU
	JOZMsgEJcwp4SNxvaQErEQIqmXtjJ+sERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3
	MYJj6JnUDsaVDRaHGAU4GJV4eA+ctwoWYk0sK67MPcQowcGsJMLLOck6WIg3JbGyKrUoP76o
	NCe1+BBjMtBRE5mlRJPzgfGdVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2MTfd175vG1hiwmR+pS9PZ0saXzm9Z5JUquyT7aGTQk1leN5mtlz5/nb88OLYx
	r0XsdGOG23z5M5Of/DkeuUgjyfBik8aJWT3T1HRulbDwBGytefx1g6xe6cV8h4UbArjvqPBx
	9bTktjfFrXzxvs00PlEyLsGpVGrm7k3Jk7tWy5w1+/iJe74SS3FGoqEWc1FxIgCPWb1R5QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

While making PMU (Power Mengement Unit) implementation device tree based,
there are few offsets related with SYSREG present in regs-pmu.h, so let's
make a new header file "regs-sys.h" to keep all such SYSREG related
register definition and remove them from "regs-pmu.h"

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c   |    1 +
 arch/arm/mach-exynos/pm.c       |    1 +
 arch/arm/mach-exynos/regs-pmu.h |    3 ---
 arch/arm/mach-exynos/regs-sys.h |   22 ++++++++++++++++++++++
 4 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b567361..57bd1cd 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -31,6 +31,7 @@
 #include "common.h"
 #include "mfc.h"
 #include "regs-pmu.h"
+#include "regs-sys.h"
 
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 15af0ce..723c988 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -35,6 +35,7 @@
 
 #include "common.h"
 #include "regs-pmu.h"
+#include "regs-sys.h"
 
 /**
  * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 4f6a256..4ee706d 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -15,7 +15,6 @@
 #include <mach/map.h>
 
 #define S5P_PMUREG(x)				(S5P_VA_PMU + (x))
-#define S5P_SYSREG(x)				(S3C_VA_SYS + (x))
 
 #define S5P_CENTRAL_SEQ_CONFIGURATION		S5P_PMUREG(0x0200)
 
@@ -180,8 +179,6 @@
 
 /* For EXYNOS5 */
 
-#define EXYNOS5_SYS_I2C_CFG					S5P_SYSREG(0x0234)
-
 #define EXYNOS5_AUTO_WDTRESET_DISABLE				S5P_PMUREG(0x0408)
 #define EXYNOS5_MASK_WDTRESET_REQUEST				S5P_PMUREG(0x040C)
 
diff --git a/arch/arm/mach-exynos/regs-sys.h b/arch/arm/mach-exynos/regs-sys.h
new file mode 100644
index 0000000..84332b0
--- /dev/null
+++ b/arch/arm/mach-exynos/regs-sys.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *             http://www.samsung.com
+ *
+ * EXYNOS - system register definition
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ASM_ARCH_REGS_SYS_H
+#define __ASM_ARCH_REGS_SYS_H __FILE__
+
+#include <mach/map.h>
+
+#define S5P_SYSREG(x)                          (S3C_VA_SYS + (x))
+
+/* For EXYNOS5 */
+#define EXYNOS5_SYS_I2C_CFG                    S5P_SYSREG(0x0234)
+
+#endif /* __ASM_ARCH_REGS_SYS_H */
-- 
1.7.10.4

