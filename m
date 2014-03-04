Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaCDQml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:42:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41591 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaCDQmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:37 -0500
Date: Tue, 4 Mar 2014 08:42:02 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a21748c93544901448777b5fa2abe1194c02c6dc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, peterz@infradead.org, linux-am33-list@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, peterz@infradead.org, linux-am33-list@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20140223212737.751487689@linutronix.de>
References: <20140223212737.751487689@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mn10300: Use the core irq stats function
Git-Commit-ID: a21748c93544901448777b5fa2abe1194c02c6dc
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

Commit-ID:  a21748c93544901448777b5fa2abe1194c02c6dc
Gitweb:     http://git.kernel.org/tip/a21748c93544901448777b5fa2abe1194c02c6dc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:53 +0100

mn10300: Use the core irq stats function

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: mn10300 <linux-am33-list@redhat.com>
Link: http://lkml.kernel.org/r/20140223212737.751487689@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/mn10300-watchdog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index db64a71..a2d8e69 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -142,7 +142,7 @@ void watchdog_interrupt(struct pt_regs *regs, enum exception_code excep)
 	NMICR = NMICR_WDIF;
 
 	nmi_count(smp_processor_id())++;
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 
 	for_each_online_cpu(cpu) {
 
