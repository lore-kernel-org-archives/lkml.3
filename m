Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaEJGih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25975 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaEJGi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:26 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-b3-536dc96055bd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 03/11] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file.
Date: Sat, 10 May 2014 15:56:30 +0900
Message-id: <1399704998-13321-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t8zA93Ek7nBBntvM1ksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyjh9tZOtoEe8Yt3r34wNjN+Euhg5OSQETCSu/NjK
	DGGLSVy4t56ti5GLQ0hgGaNEx4FbzDBFaw5eZ4ZITGeUWHfgLDuE08YkMWneJDaQKjYBXYkn
	7+eCdYgIZEtcabwP1sEssJtRorFxHliRsEC0xLdpN8GKWARUJbadvQoW5xXwkLgyaQ9TFyMH
	0DoFiTmTbEDCnAKeEl+/LmYCsYWASh50LwWbKSGwjl1iX3s3O8QcAYlvkw+xQPTKSmw6AHW1
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kREvj9OxjvHrA+xJgMNG4i
	s5Rocj4wcvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA+PUii8OV9tjX8x2v6nR1fqE71Xz+6UOe33/RVfHHYgPKzlUqLZJYefNOJ03/w68zV2j
	9/mKfuubL1PDL1lIencHNKa23nSRrT8eV1XW7HTrxJelC0PO7Ir588T6UpbSz4AFe48Yff1/
	tkt01bLLt3ckBx4P3LaF4+cBCfuewlkdbocavXctiypUYinOSDTUYi4qTgQAxRAX4pICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2Ek7nBBlvWWlosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx+monW0GP
	eMW6178ZGxi/CXUxcnJICJhIrDl4nRnCFpO4cG89WxcjF4eQwHRGiXUHzrJDOG1MEpPmTWID
	qWIT0JV48n4uWIeIQLbElcb7zCBFzAK7GSUaG+eBFQkLREt8m3YTrIhFQFVi29mrYHFeAQ+J
	K5P2MHUxcgCtU5CYM8kGJMwp4Cnx9etiJhBbCKjkQfdS5gmMvAsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBMfVM6kdjCsbLA4xCnAwKvHwFrzNCRZiTSwrrsw9xCjBwawkwrviYG6w
	EG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDYz6vJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaB
	QgLpiSWp2ampBalFMFuYODilGhhNTqvsPbl7Xo3gz8nF7Ysdnpu03Pwj1t36qmaF1r9ajQjN
	4/Nygu4cV9/++GhQffo6v4+dG84yhflc+LtCiO8Tr9+zp8pVC/uEjq451FU1mcd68bknZjK3
	HnqGM52fP9Vh9aEz0Q+f23YuM/eNz1ht+NKI54dBzA67phuNfNdVMvo2yOYqnJiqxFKckWio
	xVxUnAgAgzfBe+8CAAA=
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/exynos.c   |    1 +
 arch/arm/mach-exynos/pm.c       |    1 +
 arch/arm/mach-exynos/regs-pmu.h |    3 ---
 arch/arm/mach-exynos/regs-sys.h |   22 ++++++++++++++++++++++
 4 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 288e414..e4a4be0 100644
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
index b380d48..f445c49 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -36,6 +36,7 @@
 
 #include "common.h"
 #include "regs-pmu.h"
+#include "regs-sys.h"
 
 /**
  * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 6c1d2db..b68b5cc 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -15,7 +15,6 @@
 #include <mach/map.h>
 
 #define S5P_PMUREG(x)				(S5P_VA_PMU + (x))
-#define S5P_SYSREG(x)				(S3C_VA_SYS + (x))
 
 #define S5P_CENTRAL_SEQ_CONFIGURATION		S5P_PMUREG(0x0200)
 
@@ -178,8 +177,6 @@
 
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

