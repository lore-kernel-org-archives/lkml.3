Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbbAGLdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:33:32 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61519 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbbAGLae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:30:34 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a0-54ad18d6dc5a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v12 1/9] ARM: OMAP2+: use common l2cache initialization code
Date: Wed, 07 Jan 2015 12:30:16 +0100
Message-id: <1420630224-8887-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
References: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xq7rXJNaGGBx7qGTxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJVxbu0StoJXMhX/NtxmaWDcJtHFyMkhIWAi0bP2OBuELSZx4d56IJuLQ0hg
	KaPEgXPLWSCcPiaJ5l3/wKrYBAwlut52gdkiAm4S/9YdAutgFpjGIrHpyHlmkISwgI/EzOW9
	YEUsAqoSUx+dZAWxeQXcJbpXfmSHWCcn8f/lCiYQm1PAQ+LO+WVgthBQzYKJK9kmMPIuYGRY
	xSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESGV92MC4+ZnWIUYCDUYmHt6BvTYgQa2JZcWXu
	IUYJDmYlEd43v4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGAPiOiqeaQk3ie98uVBt0rsPFanT
	HRStCpfUt75MVl93KU34R/5RNtvns0v2rrmyKzpgw5Z840OzH8RK3SsTmeD58bzTp58Z77ac
	/znPK3Ix/00jy+LLFYELGt40n+bznWC1WiBNKevngcjopqsfBTbxhrwxnFAsU/HE1zm7oXHV
	6ket31m6VyuxFGckGmoxFxUnAgB3gflVagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements generic DT L2C initialisation (the one from
init_IRQ in arch/arm/kernel/irq.c) for Omap4 and AM43 platforms and
kills the SoC specific stuff in arch/arm/mach-omap2/omap4-common.c.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Nishanth Menon <nm@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-generic.c |  6 ++++++
 arch/arm/mach-omap2/common.h        |  8 ++++++++
 arch/arm/mach-omap2/omap4-common.c  | 16 +---------------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 608079a1aba6..c5c480b76da5 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -171,6 +171,9 @@ static const char *const omap4_boards_compat[] __initconst = {
 };
 
 DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
+	.l2c_aux_val	= OMAP_L2C_AUX_CTRL,
+	.l2c_aux_mask	= 0xcf9fffff,
+	.l2c_write_sec	= omap4_l2c310_write_sec,
 	.reserve	= omap_reserve,
 	.smp		= smp_ops(omap4_smp_ops),
 	.map_io		= omap4_map_io,
@@ -214,6 +217,9 @@ static const char *const am43_boards_compat[] __initconst = {
 };
 
 DT_MACHINE_START(AM43_DT, "Generic AM43 (Flattened Device Tree)")
+	.l2c_aux_val	= OMAP_L2C_AUX_CTRL,
+	.l2c_aux_mask	= 0xcf9fffff,
+	.l2c_write_sec	= omap4_l2c310_write_sec,
 	.map_io		= am33xx_map_io,
 	.init_early	= am43xx_init_early,
 	.init_late	= am43xx_init_late,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 377eea849e7b..2610c9f8d29f 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -35,6 +35,7 @@
 #include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/proc-fns.h>
+#include <asm/hardware/cache-l2x0.h>
 
 #include "i2c.h"
 #include "serial.h"
@@ -94,11 +95,18 @@ extern void omap3_gptimer_timer_init(void);
 extern void omap4_local_timer_init(void);
 #ifdef CONFIG_CACHE_L2X0
 int omap_l2_cache_init(void);
+#define OMAP_L2C_AUX_CTRL	(L2C_AUX_CTRL_SHARED_OVERRIDE | \
+				 L310_AUX_CTRL_DATA_PREFETCH | \
+				 L310_AUX_CTRL_INSTR_PREFETCH)
+void omap4_l2c310_write_sec(unsigned long val, unsigned reg);
 #else
 static inline int omap_l2_cache_init(void)
 {
 	return 0;
 }
+
+#define OMAP_L2C_AUX_CTRL	0
+#define omap4_l2c310_write_sec	NULL
 #endif
 extern void omap5_realtime_timer_init(void);
 
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index b7cb44abe49b..fe99ceff2e2d 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -166,7 +166,7 @@ void __iomem *omap4_get_l2cache_base(void)
 	return l2cache_base;
 }
 
-static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
+void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 {
 	unsigned smc_op;
 
@@ -201,24 +201,10 @@ static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 
 int __init omap_l2_cache_init(void)
 {
-	u32 aux_ctrl;
-
 	/* Static mapping, never released */
 	l2cache_base = ioremap(OMAP44XX_L2CACHE_BASE, SZ_4K);
 	if (WARN_ON(!l2cache_base))
 		return -ENOMEM;
-
-	/* 16-way associativity, parity disabled, way size - 64KB (es2.0 +) */
-	aux_ctrl = L2C_AUX_CTRL_SHARED_OVERRIDE |
-		   L310_AUX_CTRL_DATA_PREFETCH |
-		   L310_AUX_CTRL_INSTR_PREFETCH;
-
-	outer_cache.write_sec = omap4_l2c310_write_sec;
-	if (of_have_populated_dt())
-		l2x0_of_init(aux_ctrl, 0xcf9fffff);
-	else
-		l2x0_init(l2cache_base, aux_ctrl, 0xcf9fffff);
-
 	return 0;
 }
 #endif
-- 
1.9.2

