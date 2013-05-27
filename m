Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3E0OgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:36:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37020 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab3E0OgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:36:00 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 01/14] ARM: OMAP2+: separate out OMAP4 restart
Date: Mon, 27 May 2013 20:05:19 +0530
Message-ID: <5f0f6150bbb195bb338feaa2db45580301061635.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out OMAP4 restart and have it similar to other platforms, in
a different file. Main motive is to reuse omap4-common on platforms
other than OMAP4, like AM43x, even if OMAP4 is deselected (otherwise
would have caused build breakage).

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/Makefile        |  2 ++
 arch/arm/mach-omap2/omap4-common.c  | 16 ----------------
 arch/arm/mach-omap2/omap4-restart.c | 27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/mach-omap2/omap4-restart.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 55a9d67..0fac8f4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -58,6 +58,8 @@ obj-$(CONFIG_SOC_OMAP2420)		+= omap2-restart.o
 obj-$(CONFIG_SOC_OMAP2430)		+= omap2-restart.o
 obj-$(CONFIG_SOC_AM33XX)		+= am33xx-restart.o
 obj-$(CONFIG_ARCH_OMAP3)		+= omap3-restart.o
+obj-$(CONFIG_ARCH_OMAP4)		+= omap4-restart.o
+obj-$(CONFIG_SOC_OMAP5)			+= omap4-restart.o
 
 # Pin multiplexing
 obj-$(CONFIG_SOC_OMAP2420)		+= mux2420.o
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 13b27ff..38cd3a6 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -339,19 +339,3 @@ int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
 	return 0;
 }
 #endif
-
-/**
- * omap44xx_restart - trigger a software restart of the SoC
- * @mode: the "reboot mode", see arch/arm/kernel/{setup,process}.c
- * @cmd: passed from the userspace program rebooting the system (if provided)
- *
- * Resets the SoC.  For @cmd, see the 'reboot' syscall in
- * kernel/sys.c.  No return value.
- */
-void omap44xx_restart(char mode, const char *cmd)
-{
-	/* XXX Should save 'cmd' into scratchpad for use after reboot */
-	omap4_prminst_global_warm_sw_reset(); /* never returns */
-	while (1);
-}
-
diff --git a/arch/arm/mach-omap2/omap4-restart.c b/arch/arm/mach-omap2/omap4-restart.c
new file mode 100644
index 0000000..f90e02e
--- /dev/null
+++ b/arch/arm/mach-omap2/omap4-restart.c
@@ -0,0 +1,27 @@
+/*
+ * omap4-restart.c - Common to OMAP4 and OMAP5
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include "prminst44xx.h"
+
+/**
+ * omap44xx_restart - trigger a software restart of the SoC
+ * @mode: the "reboot mode", see arch/arm/kernel/{setup,process}.c
+ * @cmd: passed from the userspace program rebooting the system (if provided)
+ *
+ * Resets the SoC.  For @cmd, see the 'reboot' syscall in
+ * kernel/sys.c.  No return value.
+ */
+void omap44xx_restart(char mode, const char *cmd)
+{
+	/* XXX Should save 'cmd' into scratchpad for use after reboot */
+	omap4_prminst_global_warm_sw_reset(); /* never returns */
+	while (1)
+		;
+}
-- 
1.7.12

