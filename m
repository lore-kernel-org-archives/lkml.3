Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3FNQlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:41:06 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46947 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3FNQlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:41:01 -0400
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
Subject: [PATCH 1/7] genirq: add irq_get_trigger_type() to get IRQ flags
Date: Fri, 14 Jun 2013 18:40:43 +0200
Message-Id: <1371228049-27080-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that want to get the trigger edge/level type flags for a
given interrupt have to first call irq_get_irq_data(irq) to get
the struct irq_data and then irqd_get_trigger_type(irq_data) to
obtain the IRQ flags.

This is not only error prone but also unnecessary exposes the
struct irq_data to callers.

It's better to have an irq_get_trigger_type() function to obtain
the edge/level flags for an IRQ.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 include/linux/irq.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bc4e066..0e8e3a6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -579,6 +579,12 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 	return d->msi_desc;
 }
 
+static inline u32 irq_get_trigger_type(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? irqd_get_trigger_type(d) : 0;
+}
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
-- 
1.7.7.6

