Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3FNQl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:41:28 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47022 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3FNQlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:41:12 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 7/7] irqdomain: use irq_get_trigger_type() to get IRQ flags
Date: Fri, 14 Jun 2013 18:40:49 +0200
Message-Id: <1371228049-27080-8-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_desc_get_irq_data(virq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 54a4d522..ff3eebb 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -698,7 +698,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
-	    type != (irqd_get_trigger_type(irq_get_irq_data(virq))))
+	    type != irq_get_trigger_type(virq))
 		irq_set_irq_type(virq, type);
 	return virq;
 }
-- 
1.7.7.6

