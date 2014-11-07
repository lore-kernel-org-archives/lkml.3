Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaKGGrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:47:22 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55652 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaKGGpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:45:16 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, jason@lakedaemon.net, linux-sh@vger.kernel.org
Cc: arnd@arndb.de, f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: [PATCH V4 09/14] irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
Date: Thu,  6 Nov 2014 22:44:24 -0800
Message-Id: <1415342669-30640-10-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mask should have been 0xffff_ffff, not 0x0fff_ffff.

The change should not have an effect on current users (STB) because bits
31:27 are unused.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 22d3fa1..b70679f8 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -171,7 +171,7 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	}
 
 	gc = irq_get_domain_generic_chip(data->domain, 0);
-	gc->unused = 0xfffffff & ~data->irq_map_mask;
+	gc->unused = 0xffffffff & ~data->irq_map_mask;
 	gc->reg_base = data->base;
 	gc->private = data;
 	ct = gc->chip_types;
-- 
2.1.1

