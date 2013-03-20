Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3CTW4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:56:36 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50744 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3CTWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:35 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 05/11] ARM: vexpress: remove sp804 OF init
Date: Wed, 20 Mar 2013 17:54:05 -0500
Message-Id: <1363820051-24428-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove the vexpress specific setup for the sp804 timer now that
clocksource_of_init will do it.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/mach-vexpress/v2m.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 9fbfbe4..09e571d 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -428,20 +428,9 @@ void __init v2m_dt_init_early(void)
 
 static void __init v2m_dt_timer_init(void)
 {
-	struct device_node *node = NULL;
-
 	vexpress_clk_of_init();
 
 	clocksource_of_init();
-	do {
-		node = of_find_compatible_node(node, NULL, "arm,sp804");
-	} while (node && vexpress_get_site_by_node(node) != VEXPRESS_SITE_MB);
-	if (node) {
-		pr_info("Using SP804 '%s' as a clock & events source\n",
-				node->full_name);
-		v2m_sp804_init(of_iomap(node, 0),
-				irq_of_parse_and_map(node, 0));
-	}
 
 	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
 				24000000);
-- 
1.7.10.4

