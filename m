Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3HWMYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:38 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37424 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3HWMYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/40] ARM: ux500: Stop registering Pinctrl when booting with ATAG support
Date: Fri, 23 Aug 2013 13:23:22 +0100
Message-Id: <1377260620-18829-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to remove all ATAG support from ux500 and rely solely on
Device Tree booting. This patch is part of that endeavour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c     |  1 -
 arch/arm/mach-ux500/devices-common.h | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index ebac072..33264f5 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -159,7 +159,6 @@ static void __init db8500_add_gpios(struct device *parent)
 
 	dbx500_add_gpios(parent, ARRAY_AND_SIZE(db8500_gpio_base),
 			 IRQ_DB8500_GPIO0, &pdata);
-	dbx500_add_pinctrl(parent, "pinctrl-db8500", U8500_PRCMU_BASE);
 }
 
 static const char *db8500_read_soc_id(void)
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 360112e2..7167b69 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -38,22 +38,4 @@ struct nmk_gpio_platform_data;
 void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
 		      int irq, struct nmk_gpio_platform_data *pdata);
 
-static inline void
-dbx500_add_pinctrl(struct device *parent, const char *name,
-		   resource_size_t base)
-{
-	struct resource res[] = {
-		DEFINE_RES_MEM(base, SZ_8K),
-	};
-	struct platform_device_info pdevinfo = {
-		.parent = parent,
-		.name = name,
-		.id = -1,
-		.res = res,
-		.num_res = ARRAY_SIZE(res),
-	};
-
-	platform_device_register_full(&pdevinfo);
-}
-
 #endif
-- 
1.8.1.2

