Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbaIEOPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:15:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60586 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932504AbaIEOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:15:48 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91: rm9200: fix clock registration
Date: Fri,  5 Sep 2014 16:15:33 +0200
Message-Id: <1409926533-7853-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually register clocks from device tree when using the common clock
framework.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-dt-rm9200.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 61ea21445664..a598481a3570 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -14,6 +14,7 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
+#include <linux/clk-provider.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -24,13 +25,21 @@
 #include "at91_aic.h"
 #include "generic.h"
 
+static void __init rm9200_dt_timer_init(void)
+{
+#if defined(CONFIG_COMMON_CLK)
+	of_clk_init(NULL);
+#endif
+	at91rm9200_timer_init();
+}
+
 static const char *at91rm9200_dt_board_compat[] __initdata = {
 	"atmel,at91rm9200",
 	NULL
 };
 
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
-	.init_time      = at91rm9200_timer_init,
+	.init_time      = rm9200_dt_timer_init,
 	.map_io		= at91_map_io,
 	.init_early	= at91rm9200_dt_initialize,
 	.dt_compat	= at91rm9200_dt_board_compat,
-- 
1.9.1

