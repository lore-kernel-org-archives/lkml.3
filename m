Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3EJKVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:21:44 -0400
Received: from mout.gmx.net ([212.227.17.22]:64678 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3EJKVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:21:43 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX1/vI88IWAvv7+74MXGmFx98rnyA4GoLwKlxEsvVV5
	avMplz2/tnPAcU
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, balbi@ti.com,
        Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/1] genirq: outline lazy disable in kerneldoc of irq_disable function.
Date: Fri, 10 May 2013 12:21:30 +0200
Message-Id: <1368181290-1583-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.7.10.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comment based on changelog of d209a699a0b975ad

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 kernel/irq/chip.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cbd97ce..4e3c439 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -213,6 +213,19 @@ void irq_enable(struct irq_desc *desc)
 	irq_state_clr_masked(desc);
 }
 
+/**
+ * irq_disable - mask interupt disabled
+ * @desc:		irq descriptor which should be disabled
+ *
+ * If the chip does not implement the irq_disable callback, we
+ * use a lazy disable approach. That means we mark the interrupt
+ * disabled, but leave the hardware unmasked. That's an
+ * optimization because we avoid the hardware access for the
+ * common case where no interrupt happens after we marked it
+ * disabled. If an interrupt happens, then the interrupt flow
+ * handler masks the line at the hardware level and marks it
+ * pending.
+ */
 void irq_disable(struct irq_desc *desc)
 {
 	irq_state_set_disabled(desc);
-- 
1.7.10.4

