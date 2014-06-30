Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaF3PcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:32:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:35310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaF3PcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:32:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,575,1400050800"; 
   d="scan'208";a="566078573"
From: Keith Busch <keith.busch@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: [PATCH] x86: ioapic: Fix irq_free_descs count
Date: Mon, 30 Jun 2014 09:31:11 -0600
Message-Id: <1404142271-18311-1-git-send-email-keith.busch@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Keith Busch <keith.busch@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 kernel/irq/irqdesc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 7339e42..1487a12 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -455,9 +455,9 @@ EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);
  */
 void irq_free_hwirqs(unsigned int from, int cnt)
 {
-	int i;
+	int i, j;
 
-	for (i = from; cnt > 0; i++, cnt--) {
+	for (i = from, j = cnt; j > 0; i++, j--) {
 		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
 		arch_teardown_hwirq(i);
 	}
-- 
1.7.10.4

