Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3HWM1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:27:43 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43184 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3HWMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/40] ARM: ux500: Don't register Synaptics RMI4 TS when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:31 +0100
Message-Id: <1377260620-18829-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to remove all ATAG support from ux500 and rely solely on
Device Tree booting. This patch is part of that endeavour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-u8500uib.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
index 6f6553e..43c9ff1 100644
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
@@ -4,25 +4,11 @@
  * Board data for the U8500 UIB, also known as the New UIB
  * License terms: GNU General Public License (GPL), version 2
  */
-#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/interrupt.h>
-
-#include "irqs.h"
 
 #include "board-mop500.h"
 
-static struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
-	{
-		I2C_BOARD_INFO("synaptics_rmi4_i2c", 0x4B),
-		.irq = NOMADIK_GPIO_TO_IRQ(84),
-	},
-};
-
 void __init mop500_u8500uib_init(void)
 {
-	mop500_uib_i2c_add(3, mop500_i2c3_devices_u8500,
-			ARRAY_SIZE(mop500_i2c3_devices_u8500));
 }
-- 
1.8.1.2

