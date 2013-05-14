Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3ENVP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:15:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:51582 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395Ab3ENVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:15:56 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX18X3ct5JhsXUTojQbdJXs4gtWi3XG09qZ5o2tYMi8
	JGPYDzcnST6p9z
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [RESEND][PATCH 1/1] genirq: outline lazy disable in kerneldoc of irq_disable function.
Date: Tue, 14 May 2013 23:15:44 +0200
Message-Id: <1368566144-13548-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.7.10.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comment taken from changelog of d209a699a0b975ad

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 kernel/irq/chip.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cbd97ce..ba1f076 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -213,6 +213,16 @@ void irq_enable(struct irq_desc *desc)
 	irq_state_clr_masked(desc);
 }
 
+/**
+ *	irq_disable - disable interrupt generation
+ *	@desc:	irq descriptor which should be disabled
+ *
+ *	If the chip does not implement the irq_disable callback, we
+ *	use a lazy disable approach. That means we mark the interrupt
+ *	disabled, but leave the hardware unmasked. If an interrupt
+ *	happens, then the interrupt flow handler masks the line at the
+ *	hardware level and marks it pending.
+ */
 void irq_disable(struct irq_desc *desc)
 {
 	irq_state_set_disabled(desc);
-- 
1.7.10.4

