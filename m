Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbbACQtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:49:40 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:49993 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbACQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:49:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: mach-versatile: core:  Remove unused function
Date: Sat,  3 Jan 2015 17:52:39 +0100
Message-Id: <1420303959-12898-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function versatile_leds_event() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-versatile/core.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 08fb8c8..6ea09fe 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -728,43 +728,6 @@ struct of_dev_auxdata versatile_auxdata_lookup[] __initdata = {
 };
 #endif
 
-#ifdef CONFIG_LEDS
-#define VA_LEDS_BASE (__io_address(VERSATILE_SYS_BASE) + VERSATILE_SYS_LED_OFFSET)
-
-static void versatile_leds_event(led_event_t ledevt)
-{
-	unsigned long flags;
-	u32 val;
-
-	local_irq_save(flags);
-	val = readl(VA_LEDS_BASE);
-
-	switch (ledevt) {
-	case led_idle_start:
-		val = val & ~VERSATILE_SYS_LED0;
-		break;
-
-	case led_idle_end:
-		val = val | VERSATILE_SYS_LED0;
-		break;
-
-	case led_timer:
-		val = val ^ VERSATILE_SYS_LED1;
-		break;
-
-	case led_halted:
-		val = 0;
-		break;
-
-	default:
-		break;
-	}
-
-	writel(val, VA_LEDS_BASE);
-	local_irq_restore(flags);
-}
-#endif	/* CONFIG_LEDS */
-
 void versatile_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
-- 
1.7.10.4

