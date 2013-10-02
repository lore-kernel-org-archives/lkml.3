Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3JBMjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:39:37 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:45719 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JBMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:39:34 -0400
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: linux-kernel@vger.kernel.org
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Holger Brunck <holger.brunck@keymile.com>,
        linux-arm-kernel@lists.infradead.org, Simon Guinot <sguinot@lacie.com>
Subject: [PATCH] orion-gpio: enable IRQ_GC_MASK_CACHE_PER_TYPE
Date: Wed,  2 Oct 2013 14:39:28 +0200
Message-Id: <1380717568-11517-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable handling of separate mask registers for Orion SoC GPIOs,
fixing indeed the regression introduced by e59347a
"arm: orion: Use generic irq chip".

Reported-by: Joey Oravec <joravec@drewtech.com>
Signed-off-by: Holger Brunck <holger.brunck@keymile.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Simon Guinot <sguinot@lacie.com>
---
#Cc: <stable@vger.kernel.org> # 3.0.x cfeaa93 genirq: Generic chip: Remove the local cur_regs() function
#Cc: <stable@vger.kernel.org> # 3.0.x 899f0e6 genirq: Generic chip: Add support for per chip type mask cache
#Cc: <stable@vger.kernel.org> # 3.0.x af80b0f genirq: Generic chip: Handle separate mask registers
#Cc: <stable@vger.kernel.org> # 3.0.x
 arch/arm/plat-orion/gpio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index ebc0934..0b9f7c3 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -583,7 +583,8 @@ void __init orion_gpio_init(struct device_node *np,
 	ct->handler = handle_edge_irq;
 	ct->chip.name = ochip->chip.label;
 
-	irq_setup_generic_chip(gc, IRQ_MSK(ngpio), IRQ_GC_INIT_MASK_CACHE,
+	irq_setup_generic_chip(gc, IRQ_MSK(ngpio), IRQ_GC_INIT_MASK_CACHE |
+			       IRQ_GC_MASK_CACHE_PER_TYPE,
 			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
 
 	/* Setup irq domain on top of the generic chip. */
-- 
1.8.0.1

