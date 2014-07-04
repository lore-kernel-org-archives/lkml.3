Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbaGDRtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:49:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25458 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759510AbaGDRtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:00 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c9-53b6e909a5d6
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 08/19] ARM: s5pv210: Add board file for boot using Device Tree
Date: Fri, 04 Jul 2014 19:48:08 +0200
Message-id: <1404496099-26708-9-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7qcL7cFGzTet7b4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i1a4/jA5cHr9/TWL02Dnr
	LrvHplWdbB6bl9R7XDnRxOrRt2UVo8f2a/OYPT5vkgvgiOKySUnNySxLLdK3S+DKWDYhqeC5
	XMWCpq/sDYyvJbsYOTkkBEwknk78zQZhi0lcuLceyObiEBJYyihx8Mt8Zginj0liz991jCBV
	bAJqEp8bHoF1iAioSnxuW8DexcjBwSxwm0miVRgkLCzgJ/FyzTsmEJsFqOT74TNgNq+Ak8Sn
	p28YIZbJSfRue8MMYnMKOEtMXHcBrEYIqObP//ksExh5FzAyrGIUTS1NLihOSs810itOzC0u
	zUvXS87P3cQICcavOxiXHrM6xCjAwajEw9vQsi1YiDWxrLgy9xCjBAezkgjvn1VAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYxn+Ko0eN4e2DrjnP2X1kNrZ0qV+R7O0XrlqHbcpVYn68XZDOlA
	/5h5UZJXGhur5m40up3A5sYgtv/1Zhf3sC1vZrnm/a1TNt36wrDp2EYfvfQ07VcvIl9fMOmJ
	+nL89apTgen+/mknptUwfj71skVtuzzzgdrHGd+8g16cL3MRMpilwcfiwqrEUpyRaKjFXFSc
	CADcE/WJJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

This patch adds board file that will be used to boot S5PV210/S5PC110-based
boards using Device Tree.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[t.figa: Rebased and cleaned-up a bit.]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig   | 14 +++++++++
 arch/arm/mach-s5pv210/Makefile  |  2 +-
 arch/arm/mach-s5pv210/s5pv210.c | 68 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-s5pv210/s5pv210.c

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index f60f286..ed492cf 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -194,6 +194,20 @@ config MACH_TORBRECK
 	help
 	  Machine support for aESOP Torbreck
 
+config MACH_S5PV210_DT
+	bool "Samsung S5PV210/S5PC110 machine using Device Tree"
+	select CLKSRC_OF
+	select CPU_S5PV210
+	select PINCTRL
+	select PINCTRL_EXYNOS
+	select USE_OF
+	help
+	  Machine support for Samsung S5PV210/S5PC110 machines with Device Tree
+	  enabled.
+	  Select this if a fdt blob is available for your S5PV210 SoC based
+	  board.
+	  Note: This is under development and not all peripherals can be
+	  supported with this machine file.
 endmenu
 
 endif
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 08358bb..8d87b10 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_MACH_GONI)		+= mach-goni.o
 obj-$(CONFIG_MACH_SMDKC110)	+= mach-smdkc110.o
 obj-$(CONFIG_MACH_SMDKV210)	+= mach-smdkv210.o
 obj-$(CONFIG_MACH_TORBRECK)	+= mach-torbreck.o
-
+obj-$(CONFIG_MACH_S5PV210_DT)	+= s5pv210.o
 # device support
 
 obj-y				+= dev-audio.o
diff --git a/arch/arm/mach-s5pv210/s5pv210.c b/arch/arm/mach-s5pv210/s5pv210.c
new file mode 100644
index 0000000..c244ccb
--- /dev/null
+++ b/arch/arm/mach-s5pv210/s5pv210.c
@@ -0,0 +1,68 @@
+/*
+ * Samsung's S5PC110/S5PV210 flattened device tree enabled machine.
+ *
+ * Copyright (c) 2013-2014 Samsung Electronics Co., Ltd.
+ * Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/system_misc.h>
+
+#include <plat/map-base.h>
+#include <mach/regs-clock.h>
+
+static int __init s5pv210_fdt_map_sys(unsigned long node, const char *uname,
+					int depth, void *data)
+{
+	struct map_desc iodesc;
+	const __be32 *reg;
+	int len;
+
+	if (!of_flat_dt_is_compatible(node, "samsung,s5pv210-clock"))
+		return 0;
+
+	reg = of_get_flat_dt_prop(node, "reg", &len);
+	if (reg == NULL || len != (sizeof(unsigned long) * 2))
+		return 0;
+
+	iodesc.pfn = __phys_to_pfn(be32_to_cpu(reg[0]));
+	iodesc.length = be32_to_cpu(reg[1]) - 1;
+	iodesc.virtual = (unsigned long)S3C_VA_SYS;
+	iodesc.type = MT_DEVICE;
+	iotable_init(&iodesc, 1);
+
+	return 1;
+}
+
+static void __init s5pv210_dt_map_io(void)
+{
+	debug_ll_io_init();
+
+	of_scan_flat_dt(s5pv210_fdt_map_sys, NULL);
+}
+
+static void s5pv210_dt_restart(enum reboot_mode mode, const char *cmd)
+{
+	__raw_writel(0x1, S5P_SWRESET);
+}
+
+static char const *s5pv210_dt_compat[] __initconst = {
+	"samsung,s5pc110",
+	"samsung,s5pv210",
+	NULL
+};
+
+DT_MACHINE_START(S5PV210_DT, "Samsung S5PC110/S5PV210-based board")
+	.dt_compat = s5pv210_dt_compat,
+	.map_io = s5pv210_dt_map_io,
+	.restart = s5pv210_dt_restart,
+MACHINE_END
-- 
1.9.3

