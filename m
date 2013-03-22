Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3CVP2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:28:07 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58775 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480Ab3CVP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:28:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/5] ARM: ux500: Remove platform specific PRCMU and Clk initialisation
Date: Fri, 22 Mar 2013 15:27:43 +0000
Message-Id: <1363966065-2478-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the moment at least, every platform which executes though
ux500_init_irq requires the same clk and prcmu initialisation.
So let's call those functions without clause.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 537870d..1fc3608 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -68,13 +68,8 @@ void __init ux500_init_irq(void)
 	 * Init clocks here so that they are available for system timer
 	 * initialization.
 	 */
-	if (cpu_is_u8500_family() || cpu_is_u9540())
-		db8500_prcmu_early_init();
-
-	if (cpu_is_u8500_family() || cpu_is_u9540())
-		u8500_clk_init();
-	else if (cpu_is_u8540())
-		u8540_clk_init();
+	db8500_prcmu_early_init();
+	u8500_clk_init();
 }
 
 void __init ux500_init_late(void)
-- 
1.7.10.4

