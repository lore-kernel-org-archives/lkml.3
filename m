Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162807Ab3LFXwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:52:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48379 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab3LFXMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markus Pargmann <mpa@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 019/152] ARM: OMAP2+: irq, AM33XX add missing register check
Date: Fri,  6 Dec 2013 15:09:03 -0800
Message-Id: <1386371476-2477-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 0bebda684857f76548ea48c8886785198701d8d3 upstream.

am33xx has a INTC_PENDING_IRQ3 register that is not checked for pending
interrupts. This patch adds AM33XX to the ifdef of SOCs that have to
check this register.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 3926f37..e022a86 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -233,7 +233,7 @@ static inline void omap_intc_handle_irq(void __iomem *base_addr, struct pt_regs
 			goto out;
 
 		irqnr = readl_relaxed(base_addr + 0xd8);
-#ifdef CONFIG_SOC_TI81XX
+#if IS_ENABLED(CONFIG_SOC_TI81XX) || IS_ENABLED(CONFIG_SOC_AM33XX)
 		if (irqnr)
 			goto out;
 		irqnr = readl_relaxed(base_addr + 0xf8);
-- 
1.8.3.2

