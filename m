Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaGGDxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:53:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17537 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaGGDxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:41 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-b4-53ba19c38f02
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 3/6] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file
Date: Mon, 07 Jul 2014 09:20:53 +0530
Message-id: <1404705056-11965-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSp3tYclewQcMiQYtlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1jcfLadyYHbo6W5h81j
	85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mro2vmUrWCuWMX8C7+ZGxgnCHUxcnJICJhI
	LPn1lBHCFpO4cG89WxcjF4eQwFJGiRkPPzDDFH09d4AFIjGdUeLV5RWMEM4EJom/U5vZQKrY
	BHQlnryfC9YhIpAt0X97NVgHs8ApRonZm6exgySEBSIk2lbdBtvHIqAq8W/PNrA4r4CHxIZb
	T4FsDqB1ChJzJtmAhDkFPCWWfJgENlMIqOTuuUNgiyUENrFLLNzYwAQxR0Di2+RDLBC9shKb
	DkBdLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBMbA6X/P+nYw3jxg
	fYgxGWjcRGYp0eR8YAzllcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQZGDp+fNX822t6c9v+5lNPieRHFLlPbP3F/VN1x8OhT+TOL7UwWTN6tUZH+
	vPesje5tYcGM3CJLl6UPHL6UbVhWHmY/Z9KJzM8XM65/ucacWHDp+1vbX81fIv95h+36EJ8r
	0t2rIb/j/Mqm5BvbRLkP+u7n/rsuZ9aKl7F7Dac1vX6+w2LeqfcnBZVYijMSDbWYi4oTASkM
	vTmXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd3DkruCDf7v4rBYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGV07
	n7IVzBWrmH/hN3MD4wShLkZODgkBE4mv5w6wQNhiEhfurWfrYuTiEBKYzijx6vIKRghnApPE
	36nNbCBVbAK6Ek/ez2UGsUUEsiX6b69mASliFjjFKDF78zR2kISwQIRE26rbjCA2i4CqxL89
	28DivAIeEhtuPQWyOYDWKUjMmWQDEuYU8JRY8mES2EwhoJK75w4xTmDkXcDIsIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOMKeSe1gXNlgcYhRgINRiYf3wKqdwUKsiWXFlbmHGCU4mJVE
	eM+4AYV4UxIrq1KL8uOLSnNSiw8xmgIdNZFZSjQ5Hxj9eSXxhsYm5qbGppYmFiZmlkrivAda
	rQOFBNITS1KzU1MLUotg+pg4OKUaGC8yVe26OuVAlOnU6vBLZyd9chFPDJHfHSGs6rr1iMZR
	jaCv7kHxP97W/drlfP/HAn6ZLXmGW2p9pESXBv+csUgyx/z2lbvfVK2+aUzft0CES/zMpIfP
	prhnNbzd9l5ktYqm6RfD5UsXSIY080tV8fHNlrhrItrMz5sWVNWwap7o+TsfjlsnbFBiKc5I
	NNRiLipOBADo8idjxgIAAA==
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
index 47170eb..186f35d 100644
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
index e1c06b6..e6fa6cf 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -15,7 +15,6 @@
 #include <mach/map.h>
 
 #define S5P_PMUREG(x)				(S5P_VA_PMU + (x))
-#define S5P_SYSREG(x)				(S3C_VA_SYS + (x))
 
 #define S5P_CENTRAL_SEQ_CONFIGURATION		S5P_PMUREG(0x0200)
 
@@ -190,8 +189,6 @@
 
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

