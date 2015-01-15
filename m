Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbbAOO7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:59:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54356 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753591AbbAOO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:59:40 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 8/8] ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c
Date: Thu, 15 Jan 2015 15:59:31 +0100
Message-Id: <1421333971-7581-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move at91rm9200_idle() along with at91sam9_idle() in clk/at91/pmc.c.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Michael Turquette <mturquette@linaro.org>
---
 arch/arm/mach-at91/at91rm9200.c | 9 ---------
 arch/arm/mach-at91/generic.h    | 1 +
 drivers/clk/at91/pmc.c          | 9 +++++++++
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index fc7c26138037..3be1963f5c56 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -21,14 +21,6 @@
 #include "soc.h"
 #include "generic.h"
 
-static void at91rm9200_idle(void)
-{
-	/*
-	 * Disable the processor clock.  The processor will be automatically
-	 * re-enabled by an interrupt or by a reset.
-	 */
-	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-}
 
 static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
@@ -49,7 +41,6 @@ static void __init at91rm9200_initialize(void)
 	arm_pm_restart = at91rm9200_restart;
 }
 
-
 AT91_SOC_START(at91rm9200)
 	.init = at91rm9200_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 1823a779182d..44fc725edcf1 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -25,6 +25,7 @@ extern void __init at91_dt_initialize(void);
 extern void at91rm9200_timer_init(void);
 
 /* idle */
+extern void at91rm9200_idle(void);
 extern void at91sam9_idle(void);
 
 /* Matrix */
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 386999b4f8eb..f07c8152e5cc 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -27,6 +27,15 @@
 void __iomem *at91_pmc_base;
 EXPORT_SYMBOL_GPL(at91_pmc_base);
 
+void at91rm9200_idle(void)
+{
+	/*
+	 * Disable the processor clock.  The processor will be automatically
+	 * re-enabled by an interrupt or by a reset.
+	 */
+	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
+}
+
 void at91sam9_idle(void)
 {
 	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-- 
2.1.0

