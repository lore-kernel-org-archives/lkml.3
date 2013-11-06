Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3KFKGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:06:16 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64365 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3KFKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:06:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/7] ARM: ux500: Remove unused call to register AMBA devices
Date: Wed,  6 Nov 2013 10:05:46 +0000
Message-Id: <1383732348-18576-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Makefile  |  2 +-
 arch/arm/mach-ux500/devices.c | 26 --------------------------
 arch/arm/mach-ux500/setup.h   |  3 ---
 3 files changed, 1 insertion(+), 30 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/devices.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index e34c010..a4f58bb 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel, U8500 machine.
 #
 
-obj-y				:= cpu.o devices.o id.o timer.o pm.o
+obj-y				:= cpu.o id.o timer.o pm.o
 obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
 obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o
 obj-$(CONFIG_MACH_MOP500)	+= board-mop500-regulators.o \
diff --git a/arch/arm/mach-ux500/devices.c b/arch/arm/mach-ux500/devices.c
deleted file mode 100644
index 0f9e52b..0000000
--- a/arch/arm/mach-ux500/devices.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/amba/bus.h>
-
-#include "setup.h"
-
-#include "db8500-regs.h"
-
-void __init amba_add_devices(struct amba_device *devs[], int num)
-{
-	int i;
-
-	for (i = 0; i < num; i++) {
-		struct amba_device *d = devs[i];
-		amba_device_register(d, &iomem_resource);
-	}
-}
diff --git a/arch/arm/mach-ux500/setup.h b/arch/arm/mach-ux500/setup.h
index bdb3564..e5682da 100644
--- a/arch/arm/mach-ux500/setup.h
+++ b/arch/arm/mach-ux500/setup.h
@@ -27,9 +27,6 @@ extern void __init ux500_init_irq(void);
 
 extern struct device *ux500_soc_device_init(const char *soc_id);
 
-struct amba_device;
-extern void __init amba_add_devices(struct amba_device *devs[], int num);
-
 extern void ux500_timer_init(void);
 
 #define __IO_DEV_DESC(x, sz)	{		\
-- 
1.8.1.2

