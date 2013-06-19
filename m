Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab3FSAGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:06:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35516 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab3FSAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 06/11] ARM: msm: Move mach/board.h contents to common.h
Date: Tue, 18 Jun 2013 17:04:36 -0700
Message-Id: <1371600281-6118-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The contents of mach/board.h are only used by files within
mach-msm so there is no need to export this file outside of the
mach-msm directory. Move the contents of the file to common.h to
allow us to compile MSM in the multi-platform kernel.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Florian, please ack so this can go through the MSM tree.

 arch/arm/mach-msm/board-dt-8660.c      |  1 -
 arch/arm/mach-msm/board-halibut.c      |  1 -
 arch/arm/mach-msm/board-mahimahi.c     |  2 +-
 arch/arm/mach-msm/board-msm7x30.c      |  1 -
 arch/arm/mach-msm/board-qsd8x50.c      |  1 -
 arch/arm/mach-msm/board-sapphire.c     |  2 +-
 arch/arm/mach-msm/board-trout.c        |  1 -
 arch/arm/mach-msm/board-trout.h        |  2 +-
 arch/arm/mach-msm/common.h             | 15 ++++++++++++++
 arch/arm/mach-msm/devices-msm7x30.c    |  2 +-
 arch/arm/mach-msm/devices-qsd8x50.c    |  2 +-
 arch/arm/mach-msm/include/mach/board.h | 38 ----------------------------------
 arch/arm/mach-msm/io.c                 |  3 +--
 drivers/video/msm/msm_fb.c             |  1 -
 14 files changed, 21 insertions(+), 51 deletions(-)
 delete mode 100644 arch/arm/mach-msm/include/mach/board.h

diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index f491b9b..2be074f 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -17,7 +17,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <mach/board.h>
 #include "common.h"
 
 static void __init msm8x60_init_late(void)
diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 803651a..a775298 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -29,7 +29,6 @@
 #include <asm/setup.h>
 
 #include <mach/irqs.h>
-#include <mach/board.h>
 #include <mach/msm_iomap.h>
 
 #include <linux/mtd/nand.h>
diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
index 30c3496..7d9981c 100644
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ b/arch/arm/mach-msm/board-mahimahi.c
@@ -28,12 +28,12 @@
 #include <asm/mach/map.h>
 #include <asm/setup.h>
 
-#include <mach/board.h>
 #include <mach/hardware.h>
 
 #include "board-mahimahi.h"
 #include "devices.h"
 #include "proc_comm.h"
+#include "common.h"
 
 static uint debug_uart;
 
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index db3d8c0..f9af5a4 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -30,7 +30,6 @@
 #include <asm/memory.h>
 #include <asm/setup.h>
 
-#include <mach/board.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
 
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index f14a73d..5f933bc 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -28,7 +28,6 @@
 #include <asm/io.h>
 #include <asm/setup.h>
 
-#include <mach/board.h>
 #include <mach/irqs.h>
 #include <mach/sirc.h>
 #include <mach/vreg.h>
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
index 7073011..3276051 100644
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@ -28,7 +28,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
 #include <mach/vreg.h>
-#include <mach/board.h>
 
 #include <asm/io.h>
 #include <asm/delay.h>
@@ -41,6 +40,7 @@
 #include "board-sapphire.h"
 #include "proc_comm.h"
 #include "devices.h"
+#include "common.h"
 
 void msm_init_irq(void);
 void msm_init_gpio(void);
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 64a46eb..ccf6621 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -25,7 +25,6 @@
 #include <asm/mach/map.h>
 #include <asm/setup.h>
 
-#include <mach/board.h>
 #include <mach/hardware.h>
 #include <mach/msm_iomap.h>
 
diff --git a/arch/arm/mach-msm/board-trout.h b/arch/arm/mach-msm/board-trout.h
index 651851c..b2379ed 100644
--- a/arch/arm/mach-msm/board-trout.h
+++ b/arch/arm/mach-msm/board-trout.h
@@ -4,7 +4,7 @@
 #ifndef __ARCH_ARM_MACH_MSM_BOARD_TROUT_H
 #define __ARCH_ARM_MACH_MSM_BOARD_TROUT_H
 
-#include <mach/board.h>
+#include "common.h"
 
 #define MSM_SMI_BASE		0x00000000
 #define MSM_SMI_SIZE		0x00800000
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 3776268..734e2fb 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -26,4 +26,19 @@ extern void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
 extern struct smp_operations msm_smp_ops;
 extern void msm_cpu_die(unsigned int cpu);
 
+struct msm_mmc_platform_data;
+
+extern void msm_add_devices(void);
+extern void msm_init_irq(void);
+extern void msm_init_gpio(void);
+extern int msm_add_sdcc(unsigned int controller,
+			struct msm_mmc_platform_data *plat,
+			unsigned int stat_irq, unsigned long stat_irq_flags);
+
+#if defined(CONFIG_MSM_SMD) && defined(CONFIG_DEBUG_FS)
+extern int smd_debugfs_init(void);
+#else
+static inline int smd_debugfs_init(void) { return 0; }
+#endif
+
 #endif
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index be45136..dbefcd8 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -21,10 +21,10 @@
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
-#include <mach/board.h>
 
 #include "devices.h"
 #include "smd_private.h"
+#include "common.h"
 
 #include <asm/mach/flash.h>
 
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 3fd8f88..87d8252 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -21,9 +21,9 @@
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
-#include <mach/board.h>
 
 #include "devices.h"
+#include "common.h"
 
 #include <asm/mach/flash.h>
 
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
deleted file mode 100644
index c34e246..0000000
--- a/arch/arm/mach-msm/include/mach/board.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* arch/arm/mach-msm/include/mach/board.h
- *
- * Copyright (C) 2007 Google, Inc.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __ASM_ARCH_MSM_BOARD_H
-#define __ASM_ARCH_MSM_BOARD_H
-
-#include <linux/types.h>
-#include <linux/platform_data/mmc-msm_sdcc.h>
-
-/* common init routines for use by arch/arm/mach-msm/board-*.c */
-
-void __init msm_add_devices(void);
-void __init msm_init_irq(void);
-void __init msm_init_gpio(void);
-int __init msm_add_sdcc(unsigned int controller,
-			struct msm_mmc_platform_data *plat,
-			unsigned int stat_irq, unsigned long stat_irq_flags);
-
-#if defined(CONFIG_MSM_SMD) && defined(CONFIG_DEBUG_FS)
-int smd_debugfs_init(void);
-#else
-static inline int smd_debugfs_init(void) { return 0; }
-#endif
-
-#endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 985f4aa..81fe144 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/export.h>
@@ -27,8 +28,6 @@
 #include <mach/msm_iomap.h>
 #include <asm/mach/map.h>
 
-#include <mach/board.h>
-
 #include "common.h"
 
 #define MSM_CHIP_DEVICE_TYPE(name, chip, mem_type) {			      \
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index ec08a9e..1374803 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -26,7 +26,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/platform_data/video-msm_fb.h>
-#include <mach/board.h>
 #include <linux/workqueue.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

