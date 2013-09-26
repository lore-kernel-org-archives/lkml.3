Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3IZQ74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:59:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3IZQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:59:50 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-06-524468050f3e
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        devicetree@vger.kernel.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, t.stanislaws@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RFC 1/3] ARM: s5pv210: Add board file for boot using Device Tree
Date: Thu, 26 Sep 2013 18:59:27 +0200
Message-id: <1380214769-7685-2-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1380214769-7685-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380214769-7685-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jQV3WDJcgg5OLhS02zljPajH/yDlW
	i3OvVjJa/Hh9gc2id8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVncvsxrcXrNKWaLtUfuslss
	vX6RyWLC9LUsFodXHGCyOPymndXi1cE2Fov1M16zWMxrf8nqIOyxZt4aRo+W5h42jwWfr7B7
	rFz+hc1j85J6j4Pv9jB59G1ZxejxeZOcx8a5oQGcUVw2Kak5mWWpRfp2CVwZO5pLCw4qVfx8
	9J25gfG5TBcjJ4eEgInEtsbl7BC2mMSFe+vZuhi5OIQEpjNKbJ/dC+W0M0k0frvICFLFJmAu
	MfHZJhYQW0RAUqKp4Q8zSBGzwCQWiV9L3rKBJIQFvCTWHn4ONJaDg0VAVeJdjxRImFfAV2J3
	/1+obQoSPy+fACvnFPCTuDuthxXEFgKqOd/7mnUCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMHh/kx6B+OqBotDjAIcjEo8vBeYnYOEWBPLiitzDzFKcDArifCuj3UJEuJNSays
	Si3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDI6XVSytqzQ/C1ZP7m
	7Q6J816dS/jkfGrR0Y9thcvU6wxX5M7TLVvUbMl6e8vtXTyTv4se/WChe2wlS15jkFrtOV/b
	Q/f7Tkqs3PVQKLF0z8pjFcfOSwl5RR3VKldKrReZPl1ai1NvSeeOySoxp1Zkhe1JFpd91yDN
	d+vXr2utWcvcJ4mlZM5QYinOSDTUYi4qTgQAIwOkLHMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds board file that will be used to boot S5PV210/S5PC110-based
boards using Device Tree.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig           | 14 +++++
 arch/arm/mach-s5pv210/Makefile          |  2 +-
 arch/arm/mach-s5pv210/mach-s5pv210-dt.c | 92 +++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-s5pv210/mach-s5pv210-dt.c

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index abad41f..be7a056 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -201,6 +201,20 @@ config MACH_TORBRECK
 	help
 	  Machine support for aESOP Torbreck
 
+config MACH_S5PV210_DT
+	bool "Samsung S5PV210/S5PC110 machine using Device Tree"
+	select CLKSRC_OF
+	select CPU_S5PV210
+	select PINCTRL
+	select PINCTRL_S5PV210
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
index 0c67fe2..46277d0 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_MACH_GONI)		+= mach-goni.o
 obj-$(CONFIG_MACH_SMDKC110)	+= mach-smdkc110.o
 obj-$(CONFIG_MACH_SMDKV210)	+= mach-smdkv210.o
 obj-$(CONFIG_MACH_TORBRECK)	+= mach-torbreck.o
-
+obj-$(CONFIG_MACH_S5PV210_DT)	+= mach-s5pv210-dt.o
 # device support
 
 obj-y				+= dev-audio.o
diff --git a/arch/arm/mach-s5pv210/mach-s5pv210-dt.c b/arch/arm/mach-s5pv210/mach-s5pv210-dt.c
new file mode 100644
index 0000000..f7e5fa8
--- /dev/null
+++ b/arch/arm/mach-s5pv210/mach-s5pv210-dt.c
@@ -0,0 +1,92 @@
+
+/*
+ * Samsung's S5PV210/S5PC110 flattened device tree enabled machine
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/irqchip.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/system_misc.h>
+
+#include <plat/cpu.h>
+#include <plat/watchdog-reset.h>
+
+#include <mach/map.h>
+
+#include "common.h"
+
+/*
+ * IO mapping for shared system controller IP.
+ *
+ * FIXME: Make remaining drivers use dynamic mapping.
+ */
+static struct map_desc s5pv210_dt_iodesc[] __initdata = {
+	{
+		.virtual = (unsigned long)S3C_VA_SYS,
+		.pfn = __phys_to_pfn(S5PV210_PA_SYSCON),
+		.length = SZ_64K,
+		.type = MT_DEVICE,
+	},
+};
+
+static void __init s5pv210_dt_map_io(void)
+{
+	debug_ll_io_init();
+	iotable_init(s5pv210_dt_iodesc, ARRAY_SIZE(s5pv210_dt_iodesc));
+}
+
+static void __init s5pv210_dt_init_irq(void)
+{
+	void __iomem *chipid_base;
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "samsung,s5pv210-chipid");
+	if (!np)
+		panic("%s: Unable to find device node!", __func__);
+
+	chipid_base = of_iomap(np, 0);
+	if (!chipid_base)
+		panic("Unable get a chipid!");
+
+	s5p_init_cpu(chipid_base);
+	iounmap(chipid_base);
+
+	if (!soc_is_s5pv210())
+		panic("SoC is not S5PV210/S5PC110!");
+
+	of_clk_init(NULL);
+	irqchip_init();
+};
+
+static void __init s5pv210_dt_init_machine(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static char const *s5pv210_dt_compat[] __initdata = {
+	"samsung,s5pc110",
+	"samsung,s5pv210",
+	NULL
+};
+
+DT_MACHINE_START(S3C6400_DT, "Samsung S5PV210/S5PC110 (Flattened Device Tree)")
+	/* Maintainer: Mateusz Krawczuk <m.krawczuk@partner.samsung.com> */
+	.dt_compat  = s5pv210_dt_compat,
+	.map_io    = s5pv210_dt_map_io,
+	.init_irq  = s5pv210_dt_init_irq,
+	.init_machine  = s5pv210_dt_init_machine,
+	.restart        = s5pv210_restart,
+MACHINE_END
-- 
1.8.1.2

