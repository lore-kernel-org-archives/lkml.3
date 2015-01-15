Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbbAOV7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:59:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755905AbbAOV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:59:42 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 06/17] ARM: at91: remove unused at91_ioremap_matrix and header
Date: Thu, 15 Jan 2015 22:58:09 +0100
Message-Id: <1421359100-8930-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91_ioremap_matrix and the at91_matrix.h header are not used anymore, remove
them.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/generic.h                  |  4 ----
 arch/arm/mach-at91/include/mach/at91_matrix.h | 23 -----------------------
 arch/arm/mach-at91/setup.c                    | 10 ----------
 3 files changed, 37 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_matrix.h

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 44fc725edcf1..1e60faec2eba 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -28,10 +28,6 @@ extern void at91rm9200_timer_init(void);
 extern void at91rm9200_idle(void);
 extern void at91sam9_idle(void);
 
-/* Matrix */
-extern void at91_ioremap_matrix(u32 base_addr);
-
-
 #ifdef CONFIG_PM
 extern void __init at91_rm9200_pm_init(void);
 extern void __init at91_sam9260_pm_init(void);
diff --git a/arch/arm/mach-at91/include/mach/at91_matrix.h b/arch/arm/mach-at91/include/mach/at91_matrix.h
deleted file mode 100644
index f8996c954131..000000000000
--- a/arch/arm/mach-at91/include/mach/at91_matrix.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
- *
- * Under GPLv2
- */
-
-#ifndef __MACH_AT91_MATRIX_H__
-#define __MACH_AT91_MATRIX_H__
-
-#ifndef __ASSEMBLY__
-extern void __iomem *at91_matrix_base;
-
-#define at91_matrix_read(field) \
-	__raw_readl(at91_matrix_base + field)
-
-#define at91_matrix_write(field, value) \
-	__raw_writel(value, at91_matrix_base + field)
-
-#else
-.extern at91_matrix_base
-#endif
-
-#endif /* __MACH_AT91_MATRIX_H__ */
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 4c184285d38f..88649dee830e 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -351,16 +351,6 @@ void __init at91_alt_map_io(void)
 		at91_boot_soc.map_io();
 }
 
-void __iomem *at91_matrix_base;
-EXPORT_SYMBOL_GPL(at91_matrix_base);
-
-void __init at91_ioremap_matrix(u32 base_addr)
-{
-	at91_matrix_base = ioremap(base_addr, 512);
-	if (!at91_matrix_base)
-		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
-}
-
 static struct of_device_id ramc_ids[] = {
 	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
 	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
-- 
2.1.0

