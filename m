Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3D3SqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:46:12 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27181 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3SqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:46:10 -0400
Message-ID: <1367347569.1784.3.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] softirq: use _RET_IP_
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Apr 2013 11:46:09 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

Use the already defined macro to pass the function return address.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 kernel/softirq.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 14d7758..8cd0d58 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -127,8 +127,7 @@ static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
 
 void local_bh_disable(void)
 {
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_DISABLE_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(local_bh_disable);
@@ -139,7 +138,7 @@ static void __local_bh_enable(unsigned int cnt)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (softirq_count() == cnt)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+		trace_softirqs_on(_RET_IP_);
 	sub_preempt_count(cnt);
 }
 
@@ -184,7 +183,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 
 void local_bh_enable(void)
 {
-	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	_local_bh_enable_ip(_RET_IP_);
 }
 EXPORT_SYMBOL(local_bh_enable);
 
@@ -223,8 +222,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
-- 
1.7.11.7



