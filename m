Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3KYNIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:08:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3KYNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markus Pargmann <mpa@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 47/78] ARM: OMAP2+: irq, AM33XX add missing register check
Date: Mon, 25 Nov 2013 13:06:34 +0000
Message-Id: <1385384825-21681-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 0bebda684857f76548ea48c8886785198701d8d3 upstream.

am33xx has a INTC_PENDING_IRQ3 register that is not checked for pending
interrupts. This patch adds AM33XX to the ifdef of SOCs that have to
check this register.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 6038a8c..4137499 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -232,7 +232,7 @@ static inline void omap_intc_handle_irq(void __iomem *base_addr, struct pt_regs
 			goto out;
 
 		irqnr = readl_relaxed(base_addr + 0xd8);
-#ifdef CONFIG_SOC_TI81XX
+#if IS_ENABLED(CONFIG_SOC_TI81XX) || IS_ENABLED(CONFIG_SOC_AM33XX)
 		if (irqnr)
 			goto out;
 		irqnr = readl_relaxed(base_addr + 0xf8);
-- 
1.8.3.2

