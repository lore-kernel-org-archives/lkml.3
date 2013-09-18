Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3IRRyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:44 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42842 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3IRRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:17 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/26] ARM: sti: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:55 +0200
Message-Id: <1379526839-14798-23-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks. To get rid of it, move l2cc init to
.init_machine hook instead.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: Stuart Menefy <stuart.menefy@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel@stlinux.com
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-sti/board-dt.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 8fe6f0c..1217fb5 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -7,9 +7,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 #include <linux/irq.h>
+#include <linux/of_platform.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/arch.h>
 
@@ -28,11 +27,10 @@ void __init stih41x_l2x0_init(void)
 	l2x0_of_init(aux_ctrl, L2X0_AUX_CTRL_MASK);
 }
 
-static void __init stih41x_timer_init(void)
+static void __init stih41x_machine_init(void)
 {
-	of_clk_init(NULL);
-	clocksource_of_init();
 	stih41x_l2x0_init();
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
 static const char *stih41x_dt_match[] __initdata = {
@@ -42,7 +40,7 @@ static const char *stih41x_dt_match[] __initdata = {
 };
 
 DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
-	.init_time	= stih41x_timer_init,
+	.init_machine	= stih41x_machine_init,
 	.smp		= smp_ops(sti_smp_ops),
 	.dt_compat	= stih41x_dt_match,
 MACHINE_END
-- 
1.7.10.4

