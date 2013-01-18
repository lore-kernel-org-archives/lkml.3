Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3ARHQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:16:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3ARHQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:16:20 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ARM: shmobile: sh73a0: Use generic irqchip_init()
Date: Fri, 18 Jan 2013 08:16:12 +0100
Message-Id: <1358493373-28722-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:b+cDcvFfNmWEe3W9942ZPP+xWW+fs0h8/bkj7PXYnRp
 sEGzG5drtIOxyj42NnIC70A91tk2Sfv+o4bWvgX4wwWH58cBTI
 RBe5nlpVMd1tZrcZ1cF6oj1NLELG6IygQPdg3KCbiUEoQU9hCW
 iaGUQb9rNo14Q6oDUtD3aSoikdBvWBL/+/IxUi7fnhW39YPn4a
 h8Y3Cj2umWxnMnO+2LA92Uiex6Q6HBvj5CtDpubwiXrx/95Nej
 UQ5UysaHfjw0QNnFp+hlIi10sFxlY7Rs1K5488B3avgg5oG7iz
 WNrnoxM0yy9OP+MtyrqZ7/L1ycQS6f/tM7VZC6O53WdjL8Y1rN
 GS0NV6utDYzCRgYBQliX6MhzD/8eAHnwpJzFLZMFoFKJLFq+pw
 VtWo1K9vnQUtAhLE6Yvxx1SZpahbFGT1pg10u8OXEsVwbhWfLY
 AcXRK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm/hardware/gic.h header does no longer exist and the corresponding
functionality was moved to linux/irqchip.h and linux/irqchip/arm-gic.h
respectively. gic_handle_irq() and of_irq_init() are no longer available
either and have been replaced by irqchip_init().

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- split off kzm9g board changes into a separate patch

 arch/arm/mach-shmobile/intc-sh73a0.c  | 9 ++-------
 arch/arm/mach-shmobile/setup-sh73a0.c | 2 --
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-shmobile/intc-sh73a0.c b/arch/arm/mach-shmobile/intc-sh73a0.c
index fc7c8da..91faba6 100644
--- a/arch/arm/mach-shmobile/intc-sh73a0.c
+++ b/arch/arm/mach-shmobile/intc-sh73a0.c
@@ -21,9 +21,9 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/irq.h>
-#include <linux/of_irq.h>
 #include <linux/io.h>
 #include <linux/sh_intc.h>
+#include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic.h>
 #include <mach/intc.h>
 #include <mach/irqs.h>
@@ -462,14 +462,9 @@ void __init sh73a0_init_irq(void)
 }
 
 #ifdef CONFIG_OF
-static const struct of_device_id irq_of_match[] __initconst = {
-	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
-	{ },
-};
-
 void __init sh73a0_init_irq_dt(void)
 {
-	of_irq_init(irq_of_match);
+	irqchip_init();
 	gic_arch_extn.irq_set_wake = sh73a0_set_wake;
 }
 #endif
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index abf1eb0..2ecd668 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -36,7 +36,6 @@
 #include <mach/irqs.h>
 #include <mach/sh73a0.h>
 #include <mach/common.h>
-#include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
 #include <asm/mach/map.h>
 #include <asm/mach/arch.h>
@@ -892,7 +891,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
 	.init_early	= sh73a0_add_early_devices_dt,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= sh73a0_init_irq_dt,
-	.handle_irq	= gic_handle_irq,
 	.init_machine	= sh73a0_add_standard_devices_dt,
 	.init_time	= shmobile_timer_init,
 	.dt_compat	= sh73a0_boards_compat_dt,
-- 
1.8.1.1

