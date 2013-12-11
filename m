Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3LKXzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:55:42 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46400 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3LKXzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:55:37 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Thu, 12 Dec 2013 08:56:26 +0900
Message-Id: <20131211235626.12661.8865.sendpatchset@w520>
In-Reply-To: <20131211235616.12661.19702.sendpatchset@w520>
References: <20131211235616.12661.19702.sendpatchset@w520>
Subject: [PATCH v4 01/03] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add Kconfig entries for CMT, MTU2, TMU and STI to
drivers/clocksource/Kconfig. This will allow us to
get rid of duplicated entires in architecture code
such as arch/sh and arch/arm/mach-shmobile.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/Kconfig |   44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- 0001/drivers/clocksource/Kconfig
+++ work/drivers/clocksource/Kconfig	2013-12-12 08:41:55.000000000 +0900
@@ -134,3 +134,47 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+
+config SYS_SUPPORTS_CMT
+        bool
+
+config SYS_SUPPORTS_TMU
+        bool
+
+config SYS_SUPPORTS_MTU2
+        bool
+
+config SYS_SUPPORTS_STI
+        bool
+
+config SH_TIMER_CMT
+	bool "Renesas CMT timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_CMT
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the Compare Match Timer (CMT) hardware available in 16/32/48 bit
+	  variants on a wide range of Mobile and Automotive SoCs from Renesas.
+
+config SH_TIMER_MTU2
+	bool "Renesas MTU2 timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_MTU2
+	help
+	  This enables build of a clockevent driver for the Multi-Function
+	  Timer Pulse Unit 2 (TMU2) hardware available on SoCs from Renesas.
+	  This hardware comes with 16 bit timer registers.
+
+config SH_TIMER_TMU
+	bool "Renesas TMU timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_TMU
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the 32-bit Timer Unit (TMU) hardware available on a wide range
+	  SoCs from Renesas.
+
+config EM_TIMER_STI
+	bool "Renesas STI timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_STI
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the 48-bit System Timer (STI) hardware available on a SoCs
+	  such as EMEV2 from former NEC Electronics.
