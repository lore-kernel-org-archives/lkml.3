Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3ITVhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:37:14 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59124 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:37:12 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/26] ARM: nomadik: remove mtu initalization from .init_time
Date: Fri, 20 Sep 2013 23:37:00 +0200
Message-Id: <1379713020-7287-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-2-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nomadik clock initialization is properly done in clk-nomadik since
patch "clk: nomadik: set all timers to use 2.4 MHz TIMCLK".
Therefore, this patch removes now redundant mtu initialization from
.init_time callback.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- adapt to clk-nomadik changes and just remove mtu init (Suggested by
  Linus Walleij
- reword commit message and description accordingly

Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-nomadik/cpu-8815.c |   26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 13e0df9..0fcb149 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -113,36 +113,10 @@ static void cpu8815_restart(enum reboot_mode mode, const char *cmd)
 	writel(1, srcbase + 0x18);
 }
 
-/* Initial value for SRC control register: all timers use MXTAL/8 source */
-#define SRC_CR_INIT_MASK	0x00007fff
-#define SRC_CR_INIT_VAL		0x2aaa8000
-
 static void __init cpu8815_timer_init_of(void)
 {
-	struct device_node *mtu;
-	void __iomem *base;
-	int irq;
-	u32 src_cr;
-
 	/* We need this to be up now */
 	nomadik_clk_init();
-
-	mtu = of_find_node_by_path("/mtu@101e2000");
-	if (!mtu)
-		return;
-	base = of_iomap(mtu, 0);
-	if (WARN_ON(!base))
-		return;
-	irq = irq_of_parse_and_map(mtu, 0);
-
-	pr_info("Remapped MTU @ %p, irq: %d\n", base, irq);
-
-	/* Configure timer sources in "system reset controller" ctrl reg */
-	src_cr = readl(base);
-	src_cr &= SRC_CR_INIT_MASK;
-	src_cr |= SRC_CR_INIT_VAL;
-	writel(src_cr, base);
-
 	clocksource_of_init();
 }
 
-- 
1.7.10.4

