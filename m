Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936398Ab3DHPXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:23:32 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53057 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936310Ab3DHPXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:23:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/5] ARM: ux500: Move DMA40 platform data includes file out to include/
Date: Mon,  8 Apr 2013 16:23:07 +0100
Message-Id: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin names for DB8500 based platforms need to be moved out of
ux500 platform data and into the new proper location in include/
linux/platform_data/. This way we an reference them from other
external locations, such as the main DMA50 driver(s).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-audio.c                            |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c                              |    2 +-
 arch/arm/mach-ux500/board-mop500.c                                  |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                                    |    2 +-
 arch/arm/mach-ux500/devices-db8500.c                                |    2 +-
 drivers/dma/ste_dma40.c                                             |    1 +
 .../linux/platform_data/dma-ste-dma40-db8500.h                      |    3 +--
 7 files changed, 7 insertions(+), 7 deletions(-)
 rename arch/arm/mach-ux500/ste-dma40-db8500.h => include/linux/platform_data/dma-ste-dma40-db8500.h (98%)

diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index 7209db7..1f8c6e4 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -9,13 +9,13 @@
 #include <linux/gpio.h>
 #include <linux/platform_data/pinctrl-nomadik.h>
 #include <linux/platform_data/dma-ste-dma40.h>
+#include <linux/platform_data/dma-ste-dma40-db8500.h>
 
 #include <mach/devices.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/msp.h>
 
-#include "ste-dma40-db8500.h"
 #include "board-mop500.h"
 #include "devices-db8500.h"
 #include "pins-db8500.h"
diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 7f2cb6c..e4c0a74 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -12,6 +12,7 @@
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/dma-ste-dma40.h>
+#include <linux/platform_data/dma-ste-dma40-db8500.h>
 
 #include <asm/mach-types.h>
 #include <mach/devices.h>
@@ -19,7 +20,6 @@
 
 #include "devices-db8500.h"
 #include "board-mop500.h"
-#include "ste-dma40-db8500.h"
 
 /*
  * v2 has a new version of this block that need to be forced, the number found
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 87d2d7b..dd95399 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -38,6 +38,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/pinctrl-nomadik.h>
 #include <linux/platform_data/dma-ste-dma40.h>
+#include <linux/platform_data/dma-ste-dma40-db8500.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -48,7 +49,6 @@
 #include <mach/irqs.h>
 #include <linux/platform_data/crypto-ux500.h>
 
-#include "ste-dma40-db8500.h"
 #include "devices-db8500.h"
 #include "board-mop500.h"
 #include "board-mop500-regulators.h"
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index e027865..8553e14 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -22,6 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/regulator/machine.h>
 #include <linux/platform_data/pinctrl-nomadik.h>
+#include <linux/platform_data/dma-ste-dma40-db8500.h>
 #include <linux/random.h>
 
 #include <asm/pmu.h>
@@ -35,7 +36,6 @@
 #include <mach/irqs.h>
 
 #include "devices-db8500.h"
-#include "ste-dma40-db8500.h"
 
 #include "board-mop500.h"
 #include "id.h"
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index afa5b04..a7c0e521 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -13,6 +13,7 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
 #include <linux/platform_data/dma-ste-dma40.h>
+#include <linux/platform_data/dma-ste-dma40-db8500.h>
 #include <linux/mfd/dbx500-prcmu.h>
 
 #include <mach/hardware.h>
@@ -20,7 +21,6 @@
 #include <mach/irqs.h>
 
 #include "devices-db8500.h"
-#include "ste-dma40-db8500.h"
 
 static struct resource dma40_resources[] = {
 	[0] = {
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1734fee..35f97d2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -20,6 +20,7 @@
 #include <linux/amba/bus.h>
 #include <linux/regulator/consumer.h>
 #include <linux/platform_data/dma-ste-dma40.h>
+#include <linux/platform_data/dma-ste-dma40-db8500.h>
 
 #include "dmaengine.h"
 #include "ste_dma40_ll.h"
diff --git a/arch/arm/mach-ux500/ste-dma40-db8500.h b/include/linux/platform_data/dma-ste-dma40-db8500.h
similarity index 98%
rename from arch/arm/mach-ux500/ste-dma40-db8500.h
rename to include/linux/platform_data/dma-ste-dma40-db8500.h
index a616419..f538917 100644
--- a/arch/arm/mach-ux500/ste-dma40-db8500.h
+++ b/include/linux/platform_data/dma-ste-dma40-db8500.h
@@ -1,8 +1,7 @@
 /*
- * arch/arm/mach-ux500/ste_dma40_db8500.h
  * DB8500-SoC-specific configuration for DMA40
  *
- * Copyright (C) ST-Ericsson 2007-2010
+ * Copyright (C) ST-Ericsson 2007-2013
  * License terms: GNU General Public License (GPL) version 2
  * Author: Per Friden <per.friden@stericsson.com>
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
-- 
1.7.10.4

