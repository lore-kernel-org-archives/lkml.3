Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3AWJZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:25:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37021 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab3AWJZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:25:42 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <khilman@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>
CC: <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 1/4] arch: arm: gpmc: gpmc migration support
Date: Wed, 23 Jan 2013 14:56:13 +0530
Message-ID: <1358933176-12409-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358933176-12409-1-git-send-email-avinashphilip@ti.com>
References: <1358933176-12409-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent GPMC driver conversion, usage of gpmc_save/restore_context
can done from gpmc driver itself. Hence removes the usage from pm34xx.c.
Also removes the conditional compilation primitives ARCH_OMAP3 for
gpmc_save/restore_context.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-omap2/gpmc.c   |    2 --
 arch/arm/mach-omap2/pm34xx.c |    5 -----
 2 files changed, 7 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index cbf4e0d..aed958a 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1426,7 +1426,6 @@ static irqreturn_t gpmc_handle_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_ARCH_OMAP3
 static struct omap3_gpmc_regs gpmc_context;
 
 void omap3_gpmc_save_context(void)
@@ -1491,4 +1490,3 @@ void omap3_gpmc_restore_context(void)
 		}
 	}
 }
-#endif /* CONFIG_ARCH_OMAP3 */
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 60fbf0a..cab4c5d 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -43,7 +43,6 @@
 #include "common.h"
 #include "cm3xxx.h"
 #include "cm-regbits-34xx.h"
-#include "gpmc.h"
 #include "prm-regbits-34xx.h"
 #include "prm3xxx.h"
 #include "pm.h"
@@ -84,8 +83,6 @@ static void omap3_core_save_context(void)
 
 	/* Save the Interrupt controller context */
 	omap_intc_save_context();
-	/* Save the GPMC context */
-	omap3_gpmc_save_context();
 	/* Save the system control module context, padconf already save above*/
 	omap3_control_save_context();
 	omap_dma_global_context_save();
@@ -95,8 +92,6 @@ static void omap3_core_restore_context(void)
 {
 	/* Restore the control module context, padconf restored by h/w */
 	omap3_control_restore_context();
-	/* Restore the GPMC context */
-	omap3_gpmc_restore_context();
 	/* Restore the interrupt controller context */
 	omap_intc_restore_context();
 	omap_dma_global_context_restore();
-- 
1.7.9.5

