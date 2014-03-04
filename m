Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaCDQma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:42:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCDQm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:27 -0500
Date: Tue, 4 Mar 2014 08:41:51 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-770144ea7beb3e0537277a96b104ba1daa965f76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        peterz@infradead.org, xen-devel@lists.xenproject.org,
        david.vrabel@citrix.com, tglx@linutronix.de
In-Reply-To: <20140223212737.869264085@linutronix.de>
References: <20140223212737.869264085@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Xen: Use the core irq stats function
Git-Commit-ID: 770144ea7beb3e0537277a96b104ba1daa965f76
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

Commit-ID:  770144ea7beb3e0537277a96b104ba1daa965f76
Gitweb:     http://git.kernel.org/tip/770144ea7beb3e0537277a96b104ba1daa965f76
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:53 +0100

x86: Xen: Use the core irq stats function

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
Cc: x86 <x86@kernel.org>
Link: http://lkml.kernel.org/r/20140223212737.869264085@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/xen/spinlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 581521c..4d3acc3 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -183,7 +183,7 @@ __visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 
 	local_irq_save(flags);
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 out:
 	cpumask_clear_cpu(cpu, &waiting_cpus);
 	w->lock = NULL;
