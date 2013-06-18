Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3FRIwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:52:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64250 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab3FRIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:52:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/3] ARM: ux500: Remove mop500_snowball_ethernet_clock_enable()
Date: Tue, 18 Jun 2013 09:51:59 +0100
Message-Id: <1371545519-27119-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mop500_snowball_ethernet_clock_enable() provided a means to enable a
clock which was used for the SMSC911x Ethernet device on Snowball. It
was merely a stand-in until the driver was common clk compliant. Now
that it is, this can be removed for both DT and ATAGs booting.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 11 -----------
 arch/arm/mach-ux500/board-mop500.h |  1 -
 arch/arm/mach-ux500/cpu-db8500.c   |  1 -
 3 files changed, 13 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 238b237..f7a1feb 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -419,15 +419,6 @@ static void mop500_prox_deactivate(struct device *dev)
 }
 #endif
 
-void mop500_snowball_ethernet_clock_enable(void)
-{
-	struct clk *clk;
-
-	clk = clk_get_sys("fsmc", NULL);
-	if (!IS_ERR(clk))
-		clk_prepare_enable(clk);
-}
-
 #ifdef CONFIG_ATAGS
 static struct cryp_platform_data u8500_cryp1_platform_data = {
 		.mem_to_engine = {
@@ -644,8 +635,6 @@ static void __init snowball_init_machine(void)
 	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
-	mop500_snowball_ethernet_clock_enable();
-
 	u8500_cryp1_hash1_init(parent);
 
 	/* This board has full regulator constraints */
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 6f0bfcb..d6fab16 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -105,7 +105,6 @@ void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
 void mop500_audio_init(struct device *parent);
-void mop500_snowball_ethernet_clock_enable(void);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 084f104..1472dde 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -300,7 +300,6 @@ static void __init u8500_init_machine(void)
 		mop500_pinmaps_init();
 	else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
 		snowball_pinmaps_init();
-		mop500_snowball_ethernet_clock_enable();
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
 		hrefv60_pinmaps_init();
 	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
-- 
1.8.1.2

