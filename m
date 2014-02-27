Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaB0LXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:23:50 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44181 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbaB0LWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:22:43 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 6/9] ARM: at91: prepare common clk transition for sam9rl SoCs
Date: Thu, 27 Feb 2014 12:22:12 +0100
Message-Id: <1393500135-29636-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch encloses sam9rl old clk registration in
 #if defined(CONFIG_OLD_CLK_AT91)/#endif sections.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9rl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index d6ee8bb47213..db4ec02d2045 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -25,13 +25,14 @@
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 #include "pm.h"
 
 /* --------------------------------------------------------------------
  *  Clocks
  * -------------------------------------------------------------------- */
+#if defined(CONFIG_OLD_CLK_AT91)
+#include "clock.h"
 
 /*
  * The peripheral clocks.
@@ -254,6 +255,7 @@ static void __init at91sam9rl_register_clocks(void)
 	clk_register(&pck0);
 	clk_register(&pck1);
 }
+#endif
 
 /* --------------------------------------------------------------------
  *  GPIO
@@ -366,6 +368,8 @@ AT91_SOC_START(at91sam9rl)
 	.default_irq_priority = at91sam9rl_default_irq_priority,
 	.extern_irq = (1 << AT91SAM9RL_ID_IRQ0),
 	.ioremap_registers = at91sam9rl_ioremap_registers,
+#if defined(CONFIG_OLD_CLK_AT91)
 	.register_clocks = at91sam9rl_register_clocks,
+#endif
 	.init = at91sam9rl_initialize,
 AT91_SOC_END
-- 
1.8.3.2

