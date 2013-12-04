Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3LDKLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:11:12 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:46941 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755416Ab3LDKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:10:17 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        sboyd@codeaurora.org, marc.zyngier@arm.com,
        Vinayak Kale <vkale@apm.com>, Chris Smith <chris.smith@st.com>
Subject: [PATCH V7 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
Date: Wed,  4 Dec 2013 15:39:50 +0530
Message-Id: <1386151791-4881-2-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386151791-4881-1-git-send-email-vkale@apm.com>
References: <1386151791-4881-1-git-send-email-vkale@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an accessor function for IRQ_PER_CPU flag.
The accessor function is useful to determine whether an IRQ is percpu or not.

This patch is based on an older patch posted by Chris Smith here [1].
There is a minor change w.r.t. Chris's original patch: The accessor function
is renamed as 'irq_is_percpu' instead of 'irq_is_per_cpu'.

[1]: http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html

Signed-off-by: Chris Smith <chris.smith@st.com>
Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
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

