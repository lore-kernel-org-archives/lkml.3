Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3IRMPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:24 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46534 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab3IRMPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/41] ARM: ux500: Call appropriate clock initialisation based on DT or !DT booting
Date: Wed, 18 Sep 2013 13:14:28 +0100
Message-Id: <1379506478-16625-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ux500 platform will soon be converted to Device Tree only. When that
happens the old clock initialisation will be ripped out. In the meantime
however, we have to make a decision and call the appropriate
initialisation code manually.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index e6fb023..3c211d2 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -70,9 +70,17 @@ void __init ux500_init_irq(void)
 	if (cpu_is_u8500_family()) {
 		prcmu_early_init(U8500_PRCMU_BASE, SZ_8K - 1);
 		ux500_pm_init(U8500_PRCMU_BASE, SZ_8K - 1);
-		u8500_clk_init(U8500_CLKRST1_BASE, U8500_CLKRST2_BASE,
-			       U8500_CLKRST3_BASE, U8500_CLKRST5_BASE,
-			       U8500_CLKRST6_BASE);
+
+		if (of_have_populated_dt())
+			u8500_of_clk_init(U8500_CLKRST1_BASE,
+					  U8500_CLKRST2_BASE,
+					  U8500_CLKRST3_BASE,
+					  U8500_CLKRST5_BASE,
+					  U8500_CLKRST6_BASE);
+		else
+			u8500_clk_init(U8500_CLKRST1_BASE, U8500_CLKRST2_BASE,
+				       U8500_CLKRST3_BASE, U8500_CLKRST5_BASE,
+				       U8500_CLKRST6_BASE);
 	} else if (cpu_is_u9540()) {
 		prcmu_early_init(U8500_PRCMU_BASE, SZ_8K - 1);
 		ux500_pm_init(U8500_PRCMU_BASE, SZ_8K - 1);
-- 
1.8.1.2

