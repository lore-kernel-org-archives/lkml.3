Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaCDQmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:42:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCDQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:08 -0500
Date: Tue, 4 Mar 2014 08:41:38 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-87a69ad6409b2c7a95e2e6e4ddbc380046cb7730@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20140223212737.635609567@linutronix.de>
References: <20140223212737.635609567@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] sparc: Use the core irq stats function
Git-Commit-ID: 87a69ad6409b2c7a95e2e6e4ddbc380046cb7730
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

Commit-ID:  87a69ad6409b2c7a95e2e6e4ddbc380046cb7730
Gitweb:     http://git.kernel.org/tip/87a69ad6409b2c7a95e2e6e4ddbc380046cb7730
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:15 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:53 +0100

sparc: Use the core irq stats function

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20140223212737.635609567@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sparc/kernel/time_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index c3d82b5..24e8b87 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -733,7 +733,7 @@ void __irq_entry timer_interrupt(int irq, struct pt_regs *regs)
 	irq_enter();
 
 	local_cpu_data().irq0_irqs++;
-	kstat_incr_irqs_this_cpu(0, irq_to_desc(0));
+	kstat_incr_irq_this_cpu(0);
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
