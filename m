Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030958Ab3HITvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:51:41 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:62760 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877Ab3HITvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:51:39 -0400
Message-ID: <201308091951.r79JpcmF030990@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 15:41:09 -0400
Subject: [PATCH] tile: fix panic with large IRQ number
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "available_irqs" value needs to actually reflect the IRQs
available, not just start as an all-ones mask, since we only
have 32 IRQs available even on a 64-bit platform.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index c90de6c..0e6c521 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -55,7 +55,8 @@ static DEFINE_PER_CPU(int, irq_depth);
 
 /* State for allocating IRQs on Gx. */
 #if CHIP_HAS_IPI()
-static unsigned long available_irqs = ~(1UL << IRQ_RESCHEDULE);
+static unsigned long available_irqs = ((1UL << NR_IRQS) - 1) &
+				      (~(1UL << IRQ_RESCHEDULE));
 static DEFINE_SPINLOCK(available_irqs_lock);
 #endif
 
-- 
1.8.3.1

