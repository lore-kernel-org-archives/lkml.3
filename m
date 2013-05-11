Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3EKBIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:08:47 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50335 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab3EKBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:08:23 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] ARM: dove: move DT boards to SoC-centric clock init
Date: Sat, 11 May 2013 03:08:07 +0200
Message-Id: <1368234490-31416-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC centric clock init for Dove can be used by calling of_clk_init.
Use it and get rid of mvebu_clocks_init.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/Kconfig    |    3 +--
 arch/arm/mach-dove/board-dt.c |    3 +--
 arch/arm/mach-dove/common.c   |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index 36469d8..dff7b2f 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -22,8 +22,7 @@ config MACH_CM_A510
 
 config MACH_DOVE_DT
 	bool "Marvell Dove Flattened Device Tree"
-	select MVEBU_CLK_CORE
-	select MVEBU_CLK_GATING
+	select DOVE_CLK
 	select REGULATOR
 	select REGULATOR_FIXED_VOLTAGE
 	select USE_OF
diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index 0b14280..f3755ac 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -10,7 +10,6 @@
 
 #include <linux/init.h>
 #include <linux/clk-provider.h>
-#include <linux/clk/mvebu.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_data/usb-ehci-orion.h>
@@ -49,7 +48,7 @@ static void __init dove_legacy_clk_init(void)
 
 static void __init dove_of_clk_init(void)
 {
-	mvebu_clocks_init();
+	of_clk_init(NULL);
 	dove_legacy_clk_init();
 }
 
diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index e2b5da0..2a9443d 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/clk-provider.h>
-#include <linux/clk/mvebu.h>
 #include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/of.h>
-- 
1.7.10.4

