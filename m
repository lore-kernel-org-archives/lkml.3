Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbbA2GsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:48:16 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48223 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbA2GsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:48:14 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v5 12/13] pm: at91: remove the data member at91_xxx_standby() of struct ramc_ids
Date: Thu, 29 Jan 2015 14:44:00 +0800
Message-ID: <1422513840-27233-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
References: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the at91_xxx_standby() function is removed,
remove the data member of struct ramc_ids.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index ce15013..f915f4b 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -225,10 +225,10 @@ void at91_pm_set_standby(void (*at91_standby)(void))
 }
 
 static struct of_device_id ramc_ids[] = {
-	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
-	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
-	{ .compatible = "atmel,at91sam9g45-ddramc", .data = at91_ddr_standby },
-	{ .compatible = "atmel,sama5d3-ddramc", .data = at91_ddr_standby },
+	{ .compatible = "atmel,at91rm9200-sdramc" },
+	{ .compatible = "atmel,at91sam9260-sdramc" },
+	{ .compatible = "atmel,at91sam9g45-ddramc" },
+	{ .compatible = "atmel,sama5d3-ddramc" },
 	{ /*sentinel*/ }
 };
 
@@ -237,28 +237,17 @@ static void at91_dt_ramc(void)
 	struct device_node *np;
 	const struct of_device_id *of_id;
 	int idx = 0;
-	const void *standby = NULL;
 
 	for_each_matching_node_and_match(np, ramc_ids, &of_id) {
 		at91_ramc_base[idx] = of_iomap(np, 0);
 		if (!at91_ramc_base[idx])
 			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
 
-		if (!standby)
-			standby = of_id->data;
-
 		idx++;
 	}
 
 	if (!idx)
 		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
-
-	if (!standby) {
-		pr_warn("ramc no standby function available\n");
-		return;
-	}
-
-	at91_pm_set_standby(standby);
 }
 
 static void __init at91_pm_sram_init(void)
-- 
1.7.9.5

