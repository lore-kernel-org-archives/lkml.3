Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaGAJfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33624 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932075AbaGAJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 08/14] AT91: PIT: Use pr_fmt
Date: Tue,  1 Jul 2014 11:33:21 +0200
Message-Id: <1404207208-14513-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the panic messages hardcode the same prefix. Define the pr_fmt macro to
unify its definition.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam926x_time.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 641e860e83e7..0abdcb36c555 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt)	"AT91: PIT: " fmt
+
 #include <linux/clk.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
@@ -208,7 +210,7 @@ static void __init at91sam926x_pit_common_init(void)
 	/* Set up irq handler */
 	ret = setup_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
 	if (ret)
-		panic("AT91: PIT: Unable to setup IRQ\n");
+		panic(pr_fmt("Unable to setup IRQ\n"));
 
 	/* Set up and register clockevents */
 	pit_clkevt.mult = div_sc(pit_rate, NSEC_PER_SEC, pit_clkevt.shift);
@@ -222,7 +224,7 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
 
 	pit_base_addr = of_iomap(node, 0);
 	if (!pit_base_addr)
-		panic("AT91: PIT: Could not map PIT address\n");
+		panic(pr_fmt("Could not map PIT address\n"));
 
 	mck = of_clk_get(node, 0);
 	if (IS_ERR(mck))
@@ -230,12 +232,12 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
 		mck = clk_get(NULL, "mck");
 
 	if (IS_ERR(mck))
-		panic("AT91: PIT: Unable to get mck clk\n");
+		panic(pr_fmt("Unable to get mck clk\n"));
 
 	/* Get the interrupts property */
 	irq = irq_of_parse_and_map(node, 0);
 	if (!irq)
-		panic("AT91: PIT: Unable to get IRQ from DT\n");
+		panic(pr_fmt("Unable to get IRQ from DT\n"));
 
 	at91sam926x_pit_irq.irq = irq;
 
@@ -248,7 +250,7 @@ void __init at91sam926x_pit_init(void)
 {
 	mck = clk_get(NULL, "mck");
 	if (IS_ERR(mck))
-		panic("AT91: PIT: Unable to get mck clk\n");
+		panic(pr_fmt("Unable to get mck clk\n"));
 
 	at91sam926x_pit_irq.irq = NR_IRQS_LEGACY + AT91_ID_SYS;
 
@@ -263,5 +265,5 @@ void __init at91sam926x_ioremap_pit(u32 addr)
 	pit_base_addr = ioremap(addr, 16);
 
 	if (!pit_base_addr)
-		panic("Impossible to ioremap PIT\n");
+		panic(pr_fmt("Impossible to ioremap PIT\n"));
 }
-- 
2.0.0

