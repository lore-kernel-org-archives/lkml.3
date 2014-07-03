Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbaGCOtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:49:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51752 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752244AbaGCOtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:49:50 -0400
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
Subject: [PATCH RESEND 02/18] AT91: setup: Switch to pr_fmt
Date: Thu,  3 Jul 2014 16:41:17 +0200
Message-Id: <1404398493-28907-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the printed messages are using the "AT91:" prefix in the setup.c file,
but not all of them. Moreover, those who add it hardcode it directly in the
message, while the pr_fmt macro makes it easier for us to support such a case.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/setup.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index f7a07a58ebb6..9c4c7fb323fb 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -5,6 +5,8 @@
  * Under GPLv2
  */
 
+#define pr_fmt(fmt)	"AT91: " fmt
+
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/mm.h>
@@ -37,7 +39,7 @@ void __init at91rm9200_set_type(int type)
 	else
 		at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
 
-	pr_info("AT91: filled in soc subtype: %s\n",
+	pr_info("filled in soc subtype: %s\n",
 		at91_get_soc_subtype(&at91_soc_initdata));
 }
 
@@ -66,7 +68,7 @@ void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
 	}
 	at91_ramc_base[id] = ioremap(addr, size);
 	if (!at91_ramc_base[id])
-		panic("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
+		panic(pr_fmt("Impossible to ioremap ramc.%d 0x%x\n"), id, addr);
 }
 
 static struct map_desc sram_desc[2] __initdata;
@@ -83,7 +85,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
 	desc->length = length;
 	desc->type = MT_MEMORY_RWX_NONCACHED;
 
-	pr_info("AT91: sram at 0x%lx of 0x%x mapped at 0x%lx\n",
+	pr_info("sram at 0x%lx of 0x%x mapped at 0x%lx\n",
 		base, length, desc->virtual);
 
 	iotable_init(desc, 1);
@@ -302,16 +304,16 @@ void __init at91_map_io(void)
 		soc_detect(AT91_BASE_DBGU1);
 
 	if (!at91_soc_is_detected())
-		panic("AT91: Impossible to detect the SOC type");
+		panic(pr_fmt("Impossible to detect the SOC type"));
 
-	pr_info("AT91: Detected soc type: %s\n",
+	pr_info("Detected soc type: %s\n",
 		at91_get_soc_type(&at91_soc_initdata));
 	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
-		pr_info("AT91: Detected soc subtype: %s\n",
+		pr_info("Detected soc subtype: %s\n",
 			at91_get_soc_subtype(&at91_soc_initdata));
 
 	if (!at91_soc_is_enabled())
-		panic("AT91: Soc not enabled");
+		panic(pr_fmt("Soc not enabled"));
 
 	if (at91_boot_soc.map_io)
 		at91_boot_soc.map_io();
@@ -328,7 +330,7 @@ void __init at91_ioremap_shdwc(u32 base_addr)
 {
 	at91_shdwc_base = ioremap(base_addr, 16);
 	if (!at91_shdwc_base)
-		panic("Impossible to ioremap at91_shdwc_base\n");
+		panic(pr_fmt("Impossible to ioremap at91_shdwc_base\n"));
 	pm_power_off = at91sam9_poweroff;
 }
 
@@ -338,7 +340,7 @@ void __init at91_ioremap_rstc(u32 base_addr)
 {
 	at91_rstc_base = ioremap(base_addr, 16);
 	if (!at91_rstc_base)
-		panic("Impossible to ioremap at91_rstc_base\n");
+		panic(pr_fmt("Impossible to ioremap at91_rstc_base\n"));
 }
 
 void __iomem *at91_matrix_base;
@@ -348,7 +350,7 @@ void __init at91_ioremap_matrix(u32 base_addr)
 {
 	at91_matrix_base = ioremap(base_addr, 512);
 	if (!at91_matrix_base)
-		panic("Impossible to ioremap at91_matrix_base\n");
+		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
 }
 
 #if defined(CONFIG_OF) && !defined(CONFIG_ARCH_AT91X40)
@@ -365,15 +367,15 @@ static void at91_dt_rstc(void)
 
 	np = of_find_matching_node(NULL, rstc_ids);
 	if (!np)
-		panic("unable to find compatible rstc node in dtb\n");
+		panic(pr_fmt("unable to find compatible rstc node in dtb\n"));
 
 	at91_rstc_base = of_iomap(np, 0);
 	if (!at91_rstc_base)
-		panic("unable to map rstc cpu registers\n");
+		panic(pr_fmt("unable to map rstc cpu registers\n"));
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function available\n");
+		panic(pr_fmt("rtsc no restart function available\n"));
 
 	arm_pm_restart = of_id->data;
 
@@ -394,17 +396,17 @@ static void at91_dt_ramc(void)
 
 	np = of_find_matching_node(NULL, ramc_ids);
 	if (!np)
-		panic("unable to find compatible ram controller node in dtb\n");
+		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
 
 	at91_ramc_base[0] = of_iomap(np, 0);
 	if (!at91_ramc_base[0])
-		panic("unable to map ramc[0] cpu registers\n");
+		panic(pr_fmt("unable to map ramc[0] cpu registers\n"));
 	/* the controller may have 2 banks */
 	at91_ramc_base[1] = of_iomap(np, 1);
 
 	of_id = of_match_node(ramc_ids, np);
 	if (!of_id)
-		pr_warn("AT91: ramc no standby function available\n");
+		pr_warn("ramc no standby function available\n");
 	else
 		at91_pm_set_standby(of_id->data);
 
@@ -450,23 +452,23 @@ static void at91_dt_shdwc(void)
 
 	np = of_find_matching_node(NULL, shdwc_ids);
 	if (!np) {
-		pr_debug("AT91: unable to find compatible shutdown (shdwc) controller node in dtb\n");
+		pr_debug("unable to find compatible shutdown (shdwc) controller node in dtb\n");
 		return;
 	}
 
 	at91_shdwc_base = of_iomap(np, 0);
 	if (!at91_shdwc_base)
-		panic("AT91: unable to map shdwc cpu registers\n");
+		panic(pr_fmt("unable to map shdwc cpu registers\n"));
 
 	wakeup_mode = at91_dtget_shdwc_wakeup_mode(np);
 	if (wakeup_mode < 0) {
-		pr_warn("AT91: shdwc unknown wakeup mode\n");
+		pr_warn("shdwc unknown wakeup mode\n");
 		goto end;
 	}
 
 	if (!of_property_read_u32(np, "atmel,wakeup-counter", &reg)) {
 		if (reg > AT91_SHDW_CPTWK0_MAX) {
-			pr_warn("AT91: shdwc wakeup counter 0x%x > 0x%x reduce it to 0x%x\n",
+			pr_warn("shdwc wakeup counter 0x%x > 0x%x reduce it to 0x%x\n",
 				reg, AT91_SHDW_CPTWK0_MAX, AT91_SHDW_CPTWK0_MAX);
 			reg = AT91_SHDW_CPTWK0_MAX;
 		}
-- 
2.0.1

