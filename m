Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967937Ab3DRKNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:13:24 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57312 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967926Ab3DRKNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 27/32] ARM: ux500: Stop registering DMA40 from platform data when DT is enabled
Date: Thu, 18 Apr 2013 11:12:09 +0100
Message-Id: <1366279934-30761-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the DMA40 has been DT:ed, there's no requirement to register it
using traditional methods. This is the penultimate device to be DT:ed.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index a15678d..eae3e3a 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -229,16 +229,6 @@ static struct device * __init u8500_of_init_devices(void)
 
 	db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
 
-	u8500_dma40_device.dev.parent = parent;
-
-	/*
-	 * Devices to be DT:ed:
-	 *   u8500_dma40_device  = todo
-	 *   db8500_pmu_device   = done
-	 *   db8500_prcmu_device = done
-	 */
-	platform_device_register(&u8500_dma40_device);
-
 	return parent;
 }
 
-- 
1.7.10.4

