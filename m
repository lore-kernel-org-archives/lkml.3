Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3FNVI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:08:27 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62782 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3FNVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:08:24 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 11/11] irqdomain: Include hwirq number in /proc/interrupts
Date: Fri, 14 Jun 2013 22:08:06 +0100
Message-Id: <1371244086-9189-12-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Add the hardware interrupt number to the output of /proc/interrupts.
It is often important to have access to the hardware interrupt number because
it identifies exactly how an interrupt signal is wired up to the interrupt
controller.  This is especially important when using irq_domains since irq
numbers get dynamically allocated in that case, and have no relation to the
actual hardware number.

Note: This output is currently conditional on whether or not the irq_domain
pointer is set; however hwirq could still be used without irq_domain.  It
may be worthwhile to always output the hwirq number regardless of the
domain pointer.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Olof Johansson <olof@lixom.net>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 19ed5c4..36f6ee1 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -462,6 +462,8 @@ int show_interrupts(struct seq_file *p, void *v)
 	} else {
 		seq_printf(p, " %8s", "None");
 	}
+	if (desc->irq_data.domain)
+		seq_printf(p, " %*d", prec, (int) desc->irq_data.hwirq);
 #ifdef CONFIG_GENERIC_IRQ_SHOW_LEVEL
 	seq_printf(p, " %-8s", irqd_is_level_type(&desc->irq_data) ? "Level" : "Edge");
 #endif
-- 
1.8.1.2

