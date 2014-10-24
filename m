Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaJXL7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:59:54 -0400
Received: from down.free-electrons.com ([37.187.137.238]:38817 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933173AbaJXL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:59:45 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/17] irqchip: irq-armada-370-xp: use proper return value for ->set_affinity()
Date: Fri, 24 Oct 2014 13:59:16 +0200
Message-Id: <1414151970-6626-4-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->set_affinity() hook of 'struct irq_chip' is supposed to return
one of IRQ_SET_MASK_OK or IRQ_SET_MASK_OK_NOCOPY. However, the code
currently simply returns 0. This patch fixes that by using
IRQ_SET_MASK_OK, which tells the IRQ core that it is responsible for
updating irq_data.affinity.

Note that this patch does not cause any change to the compiled code,
as IRQ_SET_MASK_OK has the value 0. This is therefore just a simple
cleanup.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/irq-armada-370-xp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 3e238cd..9e630f2 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -265,7 +265,7 @@ static int armada_xp_set_affinity(struct irq_data *d,
 	writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
 	raw_spin_unlock(&irq_controller_lock);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 #endif
 
-- 
2.0.0

