Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaJFJcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:32:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13221 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaJFJb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:31:57 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-bc-5432618a47a0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v9 2/2] ARM: EXYNOS: Move PMU specific definitions from common.h
Date: Mon, 06 Oct 2014 14:56:42 +0530
Message-id: <1412587602-7763-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412587602-7763-1-git-send-email-pankaj.dubey@samsung.com>
References: <1412587602-7763-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkWrcr0SjE4MR1ZYveBVfZLDY9vsZq
	cXnXHDaLGef3MVncvsxr8enof1aLRVu/sFt0LGO0WLXrD6PFzWfbmRy4PFqae9g8ds66y+6x
	eUm9R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGU8W/+NteCUfMXn/lfsDYxrpLoYOTkkBEwk
	5k3bxw5hi0lcuLeerYuRi0NIYCmjxJ6t+1lhig7u+coKkVgElFi7kAnCmcAkMWfaNCaQKjYB
	XYkn7+cyg9giAtkSP75NZgGxmQV2M0q8/SwGYgsLBEj8+jkJbCqLgKrEkbnXgWwODl4Bd4n3
	R+RATAkBBYk5k2xAKjgFPCRevD0ENl0IqGL/2lmMIGslBNaxSxz+so0NYoyAxLfJh1ggemUl
	Nh1ghrhZUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIDP7T/55N2MF4
	74D1IUYBDkYlHt7IHYYhQqyJZcWVuYcYTYE2TGSWEk3OB8ZYXkm8obGZkYWpiamxkbmlmZI4
	72upn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE2zXe5+fPwj7liJyemftQa7f4a3sk3N
	yUpk3LCi/J7r5YX3BCtiZU10Ps79Lmux03tGIseBF6VxFYcX53labQmVbZCX4zi+zFuF68lc
	c5ZPu4QDPrKenflXeIcIe6F49oR7ujmflx5sMpBu0thU+9K+c1rAzJ9Zs+eblDzwONLicm6D
	YfZzQyWW4oxEQy3mouJEAIqKsH95AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd2uRKMQg1t9Uha9C66yWWx6fI3V
	4vKuOWwWM87vY7K4fZnX4tPR/6wWi7Z+YbfoWMZosWrXH0aLm8+2MzlwebQ097B57Jx1l91j
	85J6j74tqxg9Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvM
	TbVVcvEJ0HXLzAG6SUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8Wz9
	N9aCU/IVn/tfsTcwrpHqYuTkkBAwkTi45ysrhC0mceHeerYuRi4OIYFFjBJ71i5kgnAmMEnM
	mTaNCaSKTUBX4sn7ucwgtohAtsSPb5NZQGxmgd2MEm8/i4HYwgIBEr9+TgKbyiKgKnFk7nUg
	m4ODV8Bd4v0RORBTQkBBYs4kG5AKTgEPiRdvD4FNFwKq2L92FuMERt4FjAyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYJj65nUDsaVDRaHGAU4GJV4eCN2GIYIsSaWFVfmHmKU4GBWEuFN
	jzcKEeJNSaysSi3Kjy8qzUktPsRoCnTTRGYp0eR8YNznlcQbGpuYmxqbWppYmJhZKonzHmi1
	DhQSSE8sSc1OTS1ILYLpY+LglGpgzHBwWR2ypeJN+BuN9xclrHUtHrXxlCiu3ff33QOjuesn
	NYuIOQhW9LZNPyPx0MAs87uqAcOd3sYdTGufxFxhNFbiCuBxfv5tFft9rqalV1V7lIObZ7w3
	O9V+wUBK/dbc0+7eT/z+3reTWhh48snqH18mmOwKulroLD63RWju66Uqk3z+bU9IVGIpzkg0
	1GIuKk4EAA4pBeDDAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves PMU specific definitions into a new file
as exynos-pmu.h.
This will help in reducing dependency of common.h in pmu.c.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h     |   17 -----------------
 arch/arm/mach-exynos/exynos-pmu.h |   24 ++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |   20 +++++++++++++++++++-
 arch/arm/mach-exynos/suspend.c    |    1 +
 5 files changed, 45 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index d4d09bc..431be1b 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -139,23 +139,6 @@ extern void exynos_cpu_resume_ns(void);
 
 extern struct smp_operations exynos_smp_ops;
 
-/* PMU(Power Management Unit) support */
-
-#define PMU_TABLE_END	(-1U)
-
-enum sys_powerdown {
-	SYS_AFTR,
-	SYS_LPA,
-	SYS_SLEEP,
-	NUM_SYS_POWERDOWN,
-};
-
-struct exynos_pmu_conf {
-	unsigned int offset;
-	unsigned int val[NUM_SYS_POWERDOWN];
-};
-
-extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 extern void exynos_cpu_power_down(int cpu);
 extern void exynos_cpu_power_up(int cpu);
 extern int  exynos_cpu_power_state(int cpu);
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
new file mode 100644
index 0000000..a2ab0d5
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -0,0 +1,24 @@
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
+enum sys_powerdown {
+	SYS_AFTR,
+	SYS_LPA,
+	SYS_SLEEP,
+	NUM_SYS_POWERDOWN,
+};
+
+extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+
+#endif /* __EXYNOS_PMU_H */
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 4f10fa6..86f3ecd 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -26,6 +26,7 @@
 #include <plat/pm-common.h>
 
 #include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 1f5aaa7..1993e08 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -13,9 +13,16 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
-#include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 
+#define PMU_TABLE_END	(-1U)
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	unsigned int val[NUM_SYS_POWERDOWN];
+};
+
 struct exynos_pmu_data {
 	const struct exynos_pmu_conf *pmu_config;
 	const struct exynos_pmu_conf *pmu_config_extra;
@@ -29,8 +36,19 @@ struct exynos_pmu_context {
 	const struct exynos_pmu_data *pmu_data;
 };
 
+static void __iomem *pmu_base_addr;
 static struct exynos_pmu_context *pmu_context;
 
+static inline void pmu_raw_writel(u32 val, u32 offset)
+{
+	writel_relaxed(val, pmu_base_addr + offset);
+}
+
+static inline u32 pmu_raw_readl(u32 offset)
+{
+	return readl_relaxed(pmu_base_addr + offset);
+}
+
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f5d9773..079d999 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -33,6 +33,7 @@
 #include "common.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
+#include "exynos-pmu.h"
 
 #define S5P_CHECK_SLEEP 0x00000BAD
 
-- 
1.7.9.5

