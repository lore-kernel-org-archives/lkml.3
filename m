Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3KTLOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:14:09 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:54478 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751312Ab3KTLOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:14:05 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        Vinayak Kale <vkale@apm.com>
Subject: [PATCH V4 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
Date: Wed, 20 Nov 2013 16:43:40 +0530
Message-Id: <1384946021-22100-2-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384946021-22100-1-git-send-email-vkale@apm.com>
References: <1384946021-22100-1-git-send-email-vkale@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an accessor function for IRQ_PER_CPU flag.
The accessor function is useful to dertermine whether an IRQ is percpu or not.

Signed-off-by: Vinayak Kale <vkale@apm.com>
---
 include/linux/irqdesc.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 56fb646..26e2661 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -152,6 +152,14 @@ static inline int irq_balancing_disabled(unsigned int irq)
 	return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
 }
 
+static inline int irq_is_percpu(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	return desc->status_use_accessors & IRQ_PER_CPU;
+}
+
 static inline void
 irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
 {
-- 
1.7.9.5

