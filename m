Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaCKWnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:43:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53926 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbaCKWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:10 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 12/17] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
Date: Tue, 11 Mar 2014 23:40:48 +0100
Message-Id: <1394577653-8615-12-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add Kconfig entries for CMT, MTU2, TMU and STI to
drivers/clocksource/Kconfig. This will allow us to
get rid of duplicated entires in architecture code
such as arch/sh and arch/arm/mach-shmobile.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/Kconfig |   44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cd6950f..4f754a9 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -140,3 +140,47 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+
+config SYS_SUPPORTS_SH_CMT
+        bool
+
+config SYS_SUPPORTS_SH_MTU2
+        bool
+
+config SYS_SUPPORTS_SH_TMU
+        bool
+
+config SYS_SUPPORTS_EM_STI
+        bool
+
+config SH_TIMER_CMT
+	bool "Renesas CMT timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_SH_CMT
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the Compare Match Timer (CMT) hardware available in 16/32/48-bit
+	  variants on a wide range of Mobile and Automotive SoCs from Renesas.
+
+config SH_TIMER_MTU2
+	bool "Renesas MTU2 timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_SH_MTU2
+	help
+	  This enables build of a clockevent driver for the Multi-Function
+	  Timer Pulse Unit 2 (TMU2) hardware available on SoCs from Renesas.
+	  This hardware comes with 16 bit-timer registers.
+
+config SH_TIMER_TMU
+	bool "Renesas TMU timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_SH_TMU
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the 32-bit Timer Unit (TMU) hardware available on a wide range
+	  SoCs from Renesas.
+
+config EM_TIMER_STI
+	bool "Renesas STI timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_EM_STI
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the 48-bit System Timer (STI) hardware available on a SoCs
+	  such as EMEV2 from former NEC Electronics.
-- 
1.7.9.5

