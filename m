Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3BETul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:50:41 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:38133 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756770Ab3BETt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:27 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, <arm@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 12/14] ARM: ux500: use real AB8500 IRQ numbers instead of virtual ones
Date: Tue, 5 Feb 2013 20:48:33 +0100
Message-ID: <1360093715-6348-13-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Any devices wishing to use the AB8500's GPIO IRQs were forced to
request virtual IRQs from the gpio-ab8500 driver. Now that
responsibility has been passed back to the AB8500 core driver,
devices can request real IRQ numbers instead. This patch removes
any traces of the old virtual IRQ conversion handlers, which will
force any drivers requesting IRQs to use real IRQS.

Cc: arm@kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Requesting an ACK from the ARM SoC maintainers on this patch.
---
 arch/arm/mach-ux500/include/mach/irqs-board-mop500.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
index 7d34c52..d526dd8 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
@@ -38,15 +38,7 @@
 #define MOP500_STMPE1601_IRQ_END	\
 	MOP500_STMPE1601_IRQ(STMPE_NR_INTERNAL_IRQS)
 
-/* AB8500 virtual gpio IRQ */
-#define AB8500_VIR_GPIO_NR_IRQS			16
-
-#define MOP500_AB8500_VIR_GPIO_IRQ_BASE		\
-	MOP500_STMPE1601_IRQ_END
-#define MOP500_AB8500_VIR_GPIO_IRQ_END		\
-	(MOP500_AB8500_VIR_GPIO_IRQ_BASE + AB8500_VIR_GPIO_NR_IRQS)
-
-#define MOP500_NR_IRQS		MOP500_AB8500_VIR_GPIO_IRQ_END
+#define MOP500_NR_IRQS		MOP500_STMPE1601_IRQ_END
 
 #define MOP500_IRQ_END		MOP500_NR_IRQS
 
-- 
1.7.11.3

