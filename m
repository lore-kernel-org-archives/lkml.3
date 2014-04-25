Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaDYMsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:48:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12262 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaDYMsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:48:00 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-2d-535a597efe8f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, b.zolnierkie@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RFC PATCH v2 1/3] ARM: EXYNOS: Move PMU specific definitions from
 common.h
Date: Fri, 25 Apr 2014 22:05:29 +0900
Message-id: <1398431131-5946-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
 <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+ZgW5dZFSwwYMlKhYbZ6xntVg26S6b
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8X6Ga9ZLG4+285ksaNlNYsDt0dLcw+b
	x+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVMeNqL0vBRumKf/O+sTQwfhXrYuTkkBAw
	kWi5OJEZwhaTuHBvPVsXIxeHkMAyRomOS72sMEVP17YwQiQWMUrM6D7MBOG0MUl8XtcB1s4m
	oCvx5P1cMFtEIFviSuN9ZpAiZoGrjBInX7aDJYQFwiTe3jjDBGKzCKhKvG/vAVvBK+AuceHU
	P/YuRg6gdQoScybZgIQ5BTwkfjXNhlrWyijx918XmCMhsIldovPtPHaIQQIS3yYfYoFolpXY
	dADqH0mJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyQK+ncw3j1gfYgx
	GWjcRGYp0eR8YBTllcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQZGDiO+kyqeScrGIokG694uLdCREj/iXaPw9qzTZTXeM+vCOrKcG6au3719r8Zi
	81CN+G+rl0qKSnW4i4l/Dj96ZE5mdE9mp8uJZ0u9DQs7Sra721jNZDSefvKOQVaDRbDGuanu
	ZzK2zpyUzqt9tOD96ntKG4KCPA/zXedeYZVg5WmtzKI04aMSS3FGoqEWc1FxIgD4yOPZmAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAd26yKhgg5mL5C02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdov1M16zWNx8tp3JYkfLahYHbo+W5h42
	j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aM
	q70sBRulK/7N+8bSwPhVrIuRk0NCwETi6doWRghbTOLCvfVsXYxcHEICixglZnQfZoJw2pgk
	Pq/rYAapYhPQlXjyfi6YLSKQLXGl8T4zSBGzwFVGiZMv28ESwgJhEm9vnGECsVkEVCXet/ew
	gti8Au4SF079Y+9i5ABapyAxZ5INSJhTwEPiV9NsqGWtjBJ//3UxTWDkXcDIsIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOMaeSe1gXNlgcYhRgINRiYf3g1pksBBrYllxZe4hRgkOZiUR
	3g9+UcFCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA+M/7ySeENjEzMjSyMzCyMTc3PShJXE
	eQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYGyNjfn01D0nnc/w2Zvaap9D5yNu8+XIN658VDrx
	0LKKN0+eawTfC9jy89SdAunHqmqvXXgevj8j1NhY+5Pxpn6WgMEBp64XCZ6Xd+loLL9+7oe5
	oKwpe6L4x1q7g6IKuxTdnUMs279uSprmku4ZwF555vTlq9EX85XuLXf8YRN/RuXjkZUt8Uos
	xRmJhlrMRcWJAH4nWFz1AgAA
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

