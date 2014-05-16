Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbaEPNhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbaEPNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:10 -0400
Date: Fri, 16 May 2014 06:36:13 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-3670802223e164f1089287d1c223d34d3c5dc3da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au, grant.likely@linaro.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        horms@verge.net.au, linux-kernel@vger.kernel.org, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154339.189047829@linutronix.de>
References: <20140507154339.189047829@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] sh: intc: Remove pointless irq_reserve_irqs()
  invocation
Git-Commit-ID: 3670802223e164f1089287d1c223d34d3c5dc3da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3670802223e164f1089287d1c223d34d3c5dc3da
Gitweb:     http://git.kernel.org/tip/3670802223e164f1089287d1c223d34d3c5dc3da
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:21 +0200

sh: intc: Remove pointless irq_reserve_irqs() invocation

The preceding call to irq_create_identity_mapping() marks the
interrupt as allocated already. Remove the leftover.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: linux-sh@vger.kernel.org
Link: http://lkml.kernel.org/r/20140507154339.189047829@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/sh/intc/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 8f32a13..81f2298 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -80,12 +80,6 @@ static void __init intc_register_irq(struct intc_desc *desc,
 	unsigned int data[2], primary;
 	unsigned long flags;
 
-	/*
-	 * Register the IRQ position with the global IRQ map, then insert
-	 * it in to the radix tree.
-	 */
-	irq_reserve_irq(irq);
-
 	raw_spin_lock_irqsave(&intc_big_lock, flags);
 	radix_tree_insert(&d->tree, enum_id, intc_irq_xlate_get(irq));
 	raw_spin_unlock_irqrestore(&intc_big_lock, flags);
