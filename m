Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaGCOUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50865 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078AbaGCOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 07/18] AT91: DT: Remove the old-style reset probing
Date: Thu,  3 Jul 2014 16:14:43 +0200
Message-Id: <1404396906-25194-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the reset code is a driver of its own, just let the usual DT probing
mecanism do its job, and remove the code entirely in this case.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/setup.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index cc520596f23b..71003e40f01c 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -354,34 +354,6 @@ void __init at91_ioremap_matrix(u32 base_addr)
 }
 
 #if defined(CONFIG_OF) && !defined(CONFIG_ARCH_AT91X40)
-static struct of_device_id rstc_ids[] = {
-	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9_alt_restart },
-	{ .compatible = "atmel,at91sam9g45-rstc", .data = at91sam9g45_restart },
-	{ /*sentinel*/ }
-};
-
-static void at91_dt_rstc(void)
-{
-	struct device_node *np;
-	const struct of_device_id *of_id;
-
-	np = of_find_matching_node(NULL, rstc_ids);
-	if (!np)
-		panic(pr_fmt("unable to find compatible rstc node in dtb\n"));
-
-	at91_rstc_base = of_iomap(np, 0);
-	if (!at91_rstc_base)
-		panic(pr_fmt("unable to map rstc cpu registers\n"));
-
-	of_id = of_match_node(rstc_ids, np);
-	if (!of_id)
-		panic(pr_fmt("rtsc no restart function available\n"));
-
-	arm_pm_restart = of_id->data;
-
-	of_node_put(np);
-}
-
 static struct of_device_id ramc_ids[] = {
 	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
 	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
@@ -507,7 +479,6 @@ void __init at91rm9200_dt_initialize(void)
 
 void __init at91_dt_initialize(void)
 {
-	at91_dt_rstc();
 	at91_dt_ramc();
 	at91_dt_shdwc();
 
-- 
2.0.1

