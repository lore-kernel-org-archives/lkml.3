Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3CVP2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:28:04 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50926 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585Ab3CVP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:28:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/5] ARM: ux500: Allow the ccu8540 to register its serial devices without pdata
Date: Fri, 22 Mar 2013 15:27:42 +0000
Message-Id: <1363966065-2478-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The u8540 doesn't have DMA support yet, so in order to enable
serial and receive post-bootconsole output, we cannot supply the same
platform data as we would for the u8500.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 4fade16..c22550d 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -611,6 +611,13 @@ static void __init mop500_uart_init(struct device *parent)
 	db8500_add_uart2(parent, &uart2_plat);
 }
 
+static void __init ccu8540_uart_init(struct device *parent)
+{
+	db8500_add_uart0(parent, NULL);
+	db8500_add_uart1(parent, NULL);
+	db8500_add_uart2(parent, NULL);
+}
+
 static void __init u8500_cryp1_hash1_init(struct device *parent)
 {
 	db8500_add_cryp1(parent, &u8500_cryp1_platform_data);
@@ -662,6 +669,18 @@ static void __init mop500_init_machine(void)
 	regulator_has_full_constraints();
 }
 
+static void __init ccu8540_init_machine(void)
+{
+	struct device *parent = NULL;
+
+	parent = u8500_init_devices(&ab8500_platdata);
+
+	ccu8540_uart_init(parent);
+
+	/* This board has full regulator constraints */
+	regulator_has_full_constraints();
+}
+
 static void __init snowball_init_machine(void)
 {
 	struct device *parent = NULL;
@@ -745,7 +764,7 @@ MACHINE_START(U8540, "ST-Ericsson U8540 Platform ccu8540")
 	.map_io		= u8500_map_io,
 	.init_irq	= ux500_init_irq,
 	.init_time	= ux500_timer_init,
-	.init_machine	= mop500_init_machine,
+	.init_machine	= ccu8540_init_machine,
 	.init_late	= ux500_init_late,
 MACHINE_END
 
-- 
1.7.10.4

