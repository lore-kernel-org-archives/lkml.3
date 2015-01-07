Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbbAGFjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:39:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9208 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbAGFjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:39:11 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f4-54acc67cab2d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene@kernel.org, linux@arm.linux.org.uk, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 1/6] ARM: EXYNOS: Move pmu specific headers under
 "linux/soc/samsung"
Date: Wed, 07 Jan 2015 11:01:23 +0530
Message-id: <1420608688-10459-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
References: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkWrfm2JoQgxf/NC0aroZY/J10jN1i
	44z1rBb9j18zW2x6fI3V4vKuOWwWM87vY7K4fZnXYtHWL+wWHcsYHbg8Wpp72Dx+/5rE6LFp
	VSebx+Yl9R59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVcbBrLkvBabWKxwt2sjUw/pXvYuTg
	kBAwkTjzX6SLkRPIFJO4cG89WxcjF4eQwFJGiTctd1ghEiYSh79cZIdITGeUuPl6KyOEM4FJ
	Yv7MV2BVbAK6Ek/ez2UGsUUEsiX6b69mASliFtjEKPG6+xRYkbBAlMTrzzOYQGwWAVWJDwd7
	2UBsXgEPiaVPrkGtk5PYcusRO4jNKeAp8Wzqf7C4EFDN74YPYJslBLaxS1x+sIIRYpCAxLfJ
	h1gg/pGV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGAmn
	/z2bsIPx3gHrQ4wCHIxKPLwFfWtChFgTy4orcw8xmgJtmMgsJZqcD4y3vJJ4Q2MzIwtTE1Nj
	I3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MBqkH7B6qnfqrLvq8v0LV95+
	vM/NxbFk5ZRfC9jTjHbMMX6uOFfiQuLsE9cOzPwzc+3u3plOWTY5149MbEyzyDv9ZatNy978
	p9LP7vsc/Nj06v71WrvvRdUW33axp5vd36S3Kmj11Jk1T/7M6fxS+frLqVqjJUeLJWqOSx5a
	6tq3/YbKTHW1jOpCJZbijERDLeai4kQAx3QKUn8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd2aY2tCDPbekbVouBpi8XfSMXaL
	jTPWs1r0P37NbLHp8TVWi8u75rBZzDi/j8ni9mVei0Vbv7BbdCxjdODyaGnuYfP4/WsSo8em
	VZ1sHpuX1Hv0bVnF6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIa
	xoyDXXNZCk6rVTxesJOtgfGvfBcjJ4eEgInE4S8X2SFsMYkL99azdTFycQgJTGeUuPl6KyOE
	M4FJYv7MV6wgVWwCuhJP3s9lBrFFBLIl+m+vZgEpYhbYxCjxuvsUWJGwQJTE688zmEBsFgFV
	iQ8He9lAbF4BD4mlT66xQqyTk9hy6xHYak4BT4lnU/+DxYWAan43fGCcwMi7gJFhFaNoakFy
	QXFSeq6RXnFibnFpXrpecn7uJkZwpD2T3sG4qsHiEKMAB6MSD29B35oQIdbEsuLK3EOMEhzM
	SiK8Vp1AId6UxMqq1KL8+KLSnNTiQ4ymQFdNZJYSTc4HJoG8knhDYxNzU2NTSxMLEzNLJXFe
	Jfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQZG1mX9ehXnw7WYUnw23i0yDH9jukgx1GdXv8JsXouZ
	q/Su8n1smPTmY+yj0w8K2+7s+OJ4+tR5rq+/FyfK63xunnZv7fOPf+WkpsqYKz0+rL5bQP31
	venP180tenvNw9Excvq/I3d7D9sIL/6V9kw0bjKf7wfmzf875h9c8rXl9gKhl/vrrZUtVyux
	FGckGmoxFxUnAgCP5MvgygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Daniel Kachhap <amit.daniel@samsung.com>

Moving Exynos PMU specific header file into "include/linux/soc/samsung"
thus updated affected files under "mach-exynos" to use new location of
these header files.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/exynos.c                                       | 2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                                  | 2 +-
 arch/arm/mach-exynos/platsmp.c                                      | 2 +-
 arch/arm/mach-exynos/pm.c                                           | 4 ++--
 arch/arm/mach-exynos/pmu.c                                          | 6 ++----
 arch/arm/mach-exynos/suspend.c                                      | 4 ++--
 {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h    | 0
 .../regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h       | 0
 8 files changed, 9 insertions(+), 11 deletions(-)
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (100%)
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (100%)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 2c84439..bb5c5ce 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/irqchip.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -31,7 +32,6 @@
 
 #include "common.h"
 #include "mfc.h"
-#include "regs-pmu.h"
 
 void __iomem *pmu_base_addr;
 
diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
index b0d3c2e..c5e17b0 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -16,12 +16,12 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cputype.h>
 #include <asm/cp15.h>
 #include <asm/mcpm.h>
 
-#include "regs-pmu.h"
 #include "common.h"
 
 #define EXYNOS5420_CPUS_PER_CLUSTER	4
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 7a1ebfe..d6e7f49 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -20,6 +20,7 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -30,7 +31,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 extern void exynos4_secondary_startup(void);
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index dfc8594..6acc97c 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -18,6 +18,8 @@
 #include <linux/cpu_pm.h>
 #include <linux/io.h>
 #include <linux/err.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #include <asm/firmware.h>
 #include <asm/smp_scu.h>
@@ -28,8 +30,6 @@
 #include <plat/pm-common.h>
 
 #include "common.h"
-#include "exynos-pmu.h"
-#include "regs-pmu.h"
 
 static inline void __iomem *exynos_boot_vector_addr(void)
 {
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index c15761c..7eb5b0b 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -16,10 +16,8 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-
-
-#include "exynos-pmu.h"
-#include "regs-pmu.h"
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #define PMU_TABLE_END	(-1U)
 
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index 342797b..310b89d 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -21,6 +21,8 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
 #include <linux/regulator/machine.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -33,8 +35,6 @@
 #include <plat/regs-srom.h>
 
 #include "common.h"
-#include "regs-pmu.h"
-#include "exynos-pmu.h"
 
 #define S5P_CHECK_SLEEP 0x00000BAD
 
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/include/linux/soc/samsung/exynos-pmu.h
similarity index 100%
rename from arch/arm/mach-exynos/exynos-pmu.h
rename to include/linux/soc/samsung/exynos-pmu.h
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/include/linux/soc/samsung/exynos-regs-pmu.h
similarity index 100%
rename from arch/arm/mach-exynos/regs-pmu.h
rename to include/linux/soc/samsung/exynos-regs-pmu.h
-- 
2.2.0

