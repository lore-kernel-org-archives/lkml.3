Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbbALSmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:42:33 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56627 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755688AbbALSm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:27 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 7/7] ARM: at91: remove useless at91rm9200_set_type()
Date: Mon, 12 Jan 2015 19:42:16 +0100
Message-Id: <1421088136-10172-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all rm9200 board files have been removed, there is no user of
at91rm9200_set_type() left. Remove it

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/generic.h |  1 -
 arch/arm/mach-at91/setup.c   | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index c10c2ddaae6d..54f3837a0a4d 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -21,7 +21,6 @@ extern void __init at91_init_sram(int bank, unsigned long base,
 				  unsigned int length);
 
  /* Processors */
-extern void __init at91rm9200_set_type(int type);
 extern void __init at91_dt_initialize(void);
 
  /* Timer */
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index acb8d7724609..e3c21b458bb8 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -31,17 +31,6 @@ struct at91_init_soc __initdata at91_boot_soc;
 struct at91_socinfo at91_soc_initdata;
 EXPORT_SYMBOL(at91_soc_initdata);
 
-void __init at91rm9200_set_type(int type)
-{
-	if (type == ARCH_REVISON_9200_PQFP)
-		at91_soc_initdata.subtype = AT91_SOC_RM9200_PQFP;
-	else
-		at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
-
-	pr_info("filled in soc subtype: %s\n",
-		at91_get_soc_subtype(&at91_soc_initdata));
-}
-
 void __iomem *at91_ramc_base[2];
 EXPORT_SYMBOL_GPL(at91_ramc_base);
 
-- 
2.1.0

