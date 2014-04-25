Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaDYMPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaDYMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:04 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-db-535a51c63d7f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 03/10] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file.
Date: Fri, 25 Apr 2014 21:32:39 +0900
Message-id: <1398429166-5539-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+Zge6xwKhggyv3rC02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6Ma+dWMBbcFat4fekYcwPjGaEu
	Rk4OCQETiQ1L21khbDGJC/fWs3UxcnEICSxjlLjw/xMzTNG8Q7OZIRKLGCV23u9mhHDamCTa
	7qxnB6liE9CVePJ+LliHiEC2xJXG+2A2s8B7RonPh9W7GDk4hAWiJfbeSgIJswioSmzomc8I
	YvMKuEvMW3yFGaREQkBBYs4kG5Awp4CHxInlH9khVrUySpz/fZsFxJEQ2McuceD7BXaIQQIS
	3yYfYoFolpXYdADqaEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyQW
	+ncw3j1gfYgxGWjcRGYp0eR8YCzllcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbGyRFHajME9lWIRH/Km6Xjrmmnwqa6pXORZHqGc4do/hNPZYYy
	beMtF56UFH7k6tuRoh/k4tF3cMH2RQvEi14vCt1sZsJz4P3cZ56P9i8scTVqvHLn5zKjsuuT
	PF99ttf+8Lz1dndke87dqds4/81RXXnSX9fRZNkUtu5l3T80+RoC72evPtisxFKckWioxVxU
	nAgAaF0E+ZsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd1jgVHBBn9WmFlsnLGe1WLZpLts
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi0dYv7BaH37SzWqyf8ZrF4uaz7UwWO1pWszjw
	eLQ097B5bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYM66dW8FYcFes4vWlY8wNjGeEuhg5OSQETCTmHZrNDGGLSVy4t56ti5GLQ0hgEaPEzvvd
	jBBOG5NE25317CBVbAK6Ek/ezwXrEBHIlrjSeB/MZhZ4zyjx+bB6FyMHh7BAtMTeW0kgYRYB
	VYkNPfMZQWxeAXeJeYuvMIOUSAgoSMyZZAMS5hTwkDix/CM7xKpWRonzv2+zTGDkXcDIsIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjONKeSe9gXNVgcYhRgINRiYd3gmxksBBrYllxZe4h
	RgkOZiUR3g9+UcFCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA9MAnkl8YbGJmZGlkZmFkYm
	5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDidsWP10tLzot8uc+++8C75f7v+MfPn
	UzlPOEm07Nao+3XtW/zGS9eahJ/8YX2z8U794ZruN/NTjwblvvlXc2zCpbOnbx1gXL99r9Y+
	BjMFRedYq/QyA0Vbp4Sv8ntmh8y7cPC91iWPyg1u5wub10dd/lTxwHKOen8Gq+jjloBnyjLn
	kjbnr9ihxFKckWioxVxUnAgAZp8icPgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

While making PMU implementation to be device tree based, there are
few register offsets related with SYSREG present in regs-pmu.h, so
let's make a new header file "regs-sys.h" to keep all such SYSREG
related register offsets and remove them from "regs-pmu.h"

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
index 2388ee4..d6f405f 100644
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

