Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3EKBIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:08:52 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46512 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3EKBIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:08:25 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] ARM: kirkwood: move DT boards to SoC-centric clock init
Date: Sat, 11 May 2013 03:08:08 +0200
Message-Id: <1368234490-31416-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC centric clock init for Kirkwood can be used by calling of_clk_init.
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
 arch/arm/mach-kirkwood/Kconfig    |    3 +--
 arch/arm/mach-kirkwood/board-dt.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
index 7509a89..79ee9f2 100644
--- a/arch/arm/mach-kirkwood/Kconfig
+++ b/arch/arm/mach-kirkwood/Kconfig
@@ -134,13 +134,12 @@ comment "Device tree entries"
 
 config ARCH_KIRKWOOD_DT
 	bool "Marvell Kirkwood Flattened Device Tree"
+	select KIRKWOOD_CLK
 	select POWER_SUPPLY
 	select POWER_RESET
 	select POWER_RESET_GPIO
 	select REGULATOR
 	select REGULATOR_FIXED_VOLTAGE
-	select MVEBU_CLK_CORE
-	select MVEBU_CLK_GATING
 	select USE_OF
 	help
 	  Say 'Y' here if you want your kernel to support the
diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index e9647b8..2f695e5 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -15,7 +15,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/clk-provider.h>
-#include <linux/clk/mvebu.h>
 #include <linux/kexec.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -77,7 +76,7 @@ static void __init kirkwood_legacy_clk_init(void)
 
 static void __init kirkwood_of_clk_init(void)
 {
-	mvebu_clocks_init();
+	of_clk_init(NULL);
 	kirkwood_legacy_clk_init();
 }
 
-- 
1.7.10.4

