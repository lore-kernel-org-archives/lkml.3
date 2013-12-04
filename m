Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab3LDUhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:37:48 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55892 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3LDUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:37:42 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Thu, 05 Dec 2013 05:38:27 +0900
Message-Id: <20131204203827.19090.98268.sendpatchset@w520>
In-Reply-To: <20131204203818.19090.92396.sendpatchset@w520>
References: <20131204203818.19090.92396.sendpatchset@w520>
Subject: [PATCH v3 01/03] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
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

 drivers/clocksource/Kconfig |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- 0001/drivers/clocksource/Kconfig
+++ work/drivers/clocksource/Kconfig	2013-12-04 22:14:29.000000000 +0900
@@ -134,3 +134,39 @@ config VF_PIT_TIMER
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
+	  This enables build of the CMT timer driver.
+
+config SH_TIMER_MTU2
+	bool "Renesas MTU2 timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_MTU2
+	help
+	  This enables build of the MTU2 timer driver.
+
+config SH_TIMER_TMU
+	bool "Renesas TMU timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_TMU
+	help
+	  This enables build of the TMU timer driver.
+
+config EM_TIMER_STI
+	bool "Renesas STI timer driver" if COMPILE_TEST
+	default SYS_SUPPORTS_STI
+	help
+	  This enables build of the STI timer driver.
