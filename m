Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaD3E7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:59:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47142 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaD3E7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:42 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-ae-5360833cc4ac
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 04/12] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file.
Date: Wed, 30 Apr 2014 14:17:29 +0900
Message-id: <1398835057-3860-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zY12b5oRgg467GhbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8XNZ9uZLHa0rGZx4PJoae5h89i8pN6j
	b8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mtr+NzIV9IhXXJp0mKWB8ZtQFyMnh4SAicS7zrnM
	ELaYxIV769lAbCGBZYwSD0/6w9QsmLyeqYuRCyi+iFFi8Y2NrBBOG5PEmse7WUCq2AR0JZ68
	h5gkIpAtcaXxPjNIEbPAbkaJxsZ5YGOFBaIl9n7tZAexWQRUJb5sn8kIYvMKuEvs+TwdyOYA
	WqcgMWeSDUiYU8BDYuHt36wQF7lLNDT0MILMlBBYxy6x6vUcVog5AhLfJh9igeiVldh0AOob
	SYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJOz7djDePGB9iDEZaNxE
	ZinR5Hxg3OSVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsYep9yrj67O7xO79DjcW7t8ld0jL3m7bz+mOPkqbJ209WuXdKJb5um9Mnv47jJam8wU
	FfobtfiOj01FFddL+x/8r1JfbXY9MdVz+lLpNpk3as8uTUi4wNbH1XgmSqnXoe+V+tlpeUw7
	NSJXPttdLDZB6sVm4+OH7K78WL2iIk27/mfk3wKWrW5KLMUZiYZazEXFiQDdYxE7kQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV2b5oRgg30HlC2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xo+9/IVNAj
	XnFp0mGWBsZvQl2MnBwSAiYSCyavZ4KwxSQu3FvP1sXIxSEksIhRYvGNjawQThuTxJrHu1lA
	qtgEdCWevJ/LDGKLCGRLXGm8zwxSxCywm1GisXEeG0hCWCBaYu/XTnYQm0VAVeLL9pmMIDav
	gLvEns/TgWwOoHUKEnMm2YCEOQU8JBbe/s0KYgsBlTQ09DBOYORdwMiwilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4rp5J7WBc2WBxiFGAg1GJh1dga3ywEGtiWXFl7iFGCQ5mJRHe85UJ
	wUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD4z5vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7Ra
	BwoJpCeWpGanphakFsFsYeLglGpgPHdOckeVFmfGgwP+usIqreFLIwxCjjQldV7uEvNlvdH2
	2vPqHLt53U6cx3m4d/eXnJ9tpsVk6XFzXzjzxtmNK7lN0red/txyga05+JxQSf+TCwsXxOw5
	KWdolRXz2GCiyfq5gS0lmr+cf4UpaDp1Oq07aGazKkM/0/xmtVfy1IDgz8Vc9ixKLMUZiYZa
	zEXFiQB8XLRR7wIAAA==
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
index 9315bd8..a7b45db 100644
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

