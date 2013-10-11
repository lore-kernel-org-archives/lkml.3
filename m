Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3JKI3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:29:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:1261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3JKI3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:29:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: remove init_machine() as default is suitable
Date: Fri, 11 Oct 2013 10:29:07 +0200
Message-ID: <1381480147-14190-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 883a106b0866ca8d75b5520bdb3ca1cf8e3730ba (ARM: default
machine descriptor for multiplatform) we can remove the SoC-specific
callback init_machine() to use the default code.
This cleans up the code and reduces the number of lines.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt-rm9200.c | 7 -------
 arch/arm/mach-at91/board-dt-sam9.c   | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 3fcb662..3a185fa 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -14,7 +14,6 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
-#include <linux/of_platform.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -36,11 +35,6 @@ static void __init at91rm9200_dt_init_irq(void)
 	of_irq_init(irq_of_match);
 }
 
-static void __init at91rm9200_dt_device_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
 static const char *at91rm9200_dt_board_compat[] __initdata = {
 	"atmel,at91rm9200",
 	NULL
@@ -52,6 +46,5 @@ DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91rm9200_dt_initialize,
 	.init_irq	= at91rm9200_dt_init_irq,
-	.init_machine	= at91rm9200_dt_device_init,
 	.dt_compat	= at91rm9200_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 8db3013..3dab868 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -13,7 +13,6 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
-#include <linux/of_platform.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -37,11 +36,6 @@ static void __init at91_dt_init_irq(void)
 	of_irq_init(irq_of_match);
 }
 
-static void __init at91_dt_device_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
 static const char *at91_dt_board_compat[] __initdata = {
 	"atmel,at91sam9",
 	NULL
@@ -54,6 +48,5 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
 	.init_irq	= at91_dt_init_irq,
-	.init_machine	= at91_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
 MACHINE_END
-- 
1.8.2.2

