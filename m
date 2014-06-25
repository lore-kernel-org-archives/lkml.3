Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbaFYMt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:49:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20221 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbaFYMt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:49:27 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-69-53aac555dfeb
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 3/6] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file
Date: Wed, 25 Jun 2014 18:15:39 +0530
Message-id: <1403700342-9678-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSpRt6dFWwwcuN8hbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXx7jdLwVyximXX5rE1ME4Q6mLk5JAQMJH4
	vuskK4QtJnHh3nq2LkYuDiGBpYwSi7tPMHcxcoAVNZ3VhYhPZ5R4v2QHK4QzgUli2qrJLCDd
	bAK6Ek/ez2UGsUUEsiX6b69mASliFjjFKDF78zR2kISwQITEzDfPwIpYBFQlbt09zQZi8wq4
	SzzufM8GsU1BYs4kG5Awp4CHxKNFN8DmCwGVdDT8ZQeZKSGwiV3iT/snqDkCEt8mH2KB6JWV
	2HSAGeIbSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMPxP/3s2cQfj
	/QPWhxiTgcZNZJYSTc4Hxk9eSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTCuiDY0ydV2P/S7+ItMF2d7Q+A7zuOiovvD8t6avFhqtnb9lNluLM42
	ygobpYWjW9tLlwSdXnJNvv76lEua1bNsTX81zN57KvCBQ77eX0fuZ0di5LjVwqSNDCbcWris
	Ytt8ZpOKRy/nCEm+0uDfutqzn/XgYVVDxofFzC0PNBQfXr94SDPkbIASS3FGoqEWc1FxIgDb
	rci5lQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQd3Qo6uCDf7MFLdYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGe9+
	sxTMFatYdm0eWwPjBKEuRg4OCQETiaazul2MnECmmMSFe+vZuhi5OIQEpjNKvF+ygxXCmcAk
	MW3VZBaQKjYBXYkn7+cyg9giAtkS/bdXs4AUMQucYpSYvXkaO0hCWCBCYuabZ2BFLAKqErfu
	nmYDsXkF3CUed75ng9isIDFnkg1ImFPAQ+LRohtg84WASjoa/rJPYORdwMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4up5J7WBc2WBxiFGAg1GJh/fC7JXBQqyJZcWVuYcYJTiYlUR4
	3fevChbiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGDk55XEGxqbmJsam1qaWJiYWSqJ8x5o
	tQ4UEkhPLEnNTk0tSC2C6WPi4JRqYJTquzzXfObDjInicd+uq201e3h489Le0A7H49//Wudu
	YbHw/zHr2oRFFaK/GD0zgzNF2pQ6Gd7JP+fbXDDnSL9gS4ty0d/qtTFd7qaSzf2Rh7f+b1wf
	tX9C5AY/zqs/WGxirkxe+m/x18p6p8uX9py7tnAWy8z5Ew7ab/vYJrdkCd+9aRkdp64osRRn
	JBpqMRcVJwIAFlwJeMQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While making PMU implementation to be device tree based, there are
few register offsets related with SYSREG present in regs-pmu.h, so
let's make a new header file "regs-sys.h" to keep all such SYSREG
related register offsets and remove them from "regs-pmu.h"

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/exynos.c   |    1 +
 arch/arm/mach-exynos/pm.c       |    1 +
 arch/arm/mach-exynos/regs-pmu.h |    3 ---
 arch/arm/mach-exynos/regs-sys.h |   22 ++++++++++++++++++++++
 4 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index e54d885..4a69b3f 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -29,6 +29,7 @@
 #include "common.h"
 #include "mfc.h"
 #include "regs-pmu.h"
+#include "regs-sys.h"
 
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 202ca73..f127c0c 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -35,6 +35,7 @@
 
 #include "common.h"
 #include "regs-pmu.h"
+#include "regs-sys.h"
 
 /**
  * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 1d13b08..790af14 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -15,7 +15,6 @@
 #include <mach/map.h>
 
 #define S5P_PMUREG(x)				(S5P_VA_PMU + (x))
-#define S5P_SYSREG(x)				(S3C_VA_SYS + (x))
 
 #define S5P_CENTRAL_SEQ_CONFIGURATION		S5P_PMUREG(0x0200)
 
@@ -188,8 +187,6 @@
 
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
1.7.9.5

