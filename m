Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbaDNHjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:39:04 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64898 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaDNHjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:39:01 -0400
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH] arm64:init: Move of_clk_init to time_init
Date: Mon, 14 Apr 2014 16:38:53 +0900
Message-Id: <1397461133-12143-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock providers should be initialized before clocksource_of_init.
If not, Clock source initialization can be fail to get the clock.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm64/kernel/setup.c |    1 -
 arch/arm64/kernel/time.c  |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 720853f..93e7df89 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -393,7 +393,6 @@ void __init setup_arch(char **cmdline_p)
 
 static int __init arm64_device_init(void)
 {
-	of_clk_init(NULL);
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 	return 0;
 }
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 29c39d5..8799242 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/clocksource.h>
+#include <linux/clk-provider.h>
 
 #include <clocksource/arm_arch_timer.h>
 
@@ -64,7 +65,7 @@ EXPORT_SYMBOL(profile_pc);
 void __init time_init(void)
 {
 	u32 arch_timer_rate;
-
+	of_clk_init(NULL);
 	clocksource_of_init();
 
 	arch_timer_rate = arch_timer_get_rate();
-- 
1.7.9.5

