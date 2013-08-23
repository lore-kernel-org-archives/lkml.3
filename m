Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3HWMaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:30:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55631 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3HWMYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/40] ARM: ux500: Purge support for registering the RTC when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:21 +0100
Message-Id: <1377260620-18829-22-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/cpu-db8500.c     | 1 -
 arch/arm/mach-ux500/devices-common.h | 7 -------
 arch/arm/mach-ux500/devices-db8500.h | 3 ---
 3 files changed, 11 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 30024ff..ebac072 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -191,7 +191,6 @@ struct device * __init u8500_init_devices(void)
 
 	parent = db8500_soc_device_init();
 
-	db8500_add_rtc(parent);
 	db8500_add_gpios(parent);
 
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 030f5a0..360112e2 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -33,13 +33,6 @@ dbx500_add_uart(struct device *parent, const char *name, resource_size_t base,
 	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
 }
 
-static inline struct amba_device *
-dbx500_add_rtc(struct device *parent, resource_size_t base, int irq)
-{
-	return amba_apb_device_add(parent, "rtc-pl031", base, SZ_4K, irq,
-				0, NULL, 0);
-}
-
 struct nmk_gpio_platform_data;
 
 void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 9352400..0b523b5 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -26,9 +26,6 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
 }
 
-#define db8500_add_rtc(parent) \
-	dbx500_add_rtc(parent, U8500_RTC_BASE, IRQ_DB8500_RTC);
-
 #define db8500_add_ssp0(parent, pdata) \
 	db8500_add_ssp(parent, "ssp0", U8500_SSP0_BASE, \
 		       IRQ_DB8500_SSP0, pdata)
-- 
1.8.1.2

