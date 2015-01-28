Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbbA1BuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:50:09 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:12465 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933170AbbA1BuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:50:06 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v4 12/13] pm: at91: setup: remove the struct ramc_ids .data at91_xxx_standby members
Date: Wed, 28 Jan 2015 09:48:15 +0800
Message-ID: <1422409695-24645-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422409172-24178-1-git-send-email-wenyou.yang@atmel.com>
References: <1422409172-24178-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the at91_xxx_standby function is removed,
remove the struct ramc_ids .data members code.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/setup.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 4c18428..b8dba9f 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -362,10 +362,10 @@ void __init at91_ioremap_matrix(u32 base_addr)
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
 
@@ -374,28 +374,17 @@ static void at91_dt_ramc(void)
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
 
 void __init at91_dt_initialize(void)
-- 
1.7.9.5

