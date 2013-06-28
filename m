Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3F1MPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:15:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3F1MPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:15:48 -0400
Date: Fri, 28 Jun 2013 05:15:33 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-d2e08473f2488d53a71c2f53455f934ec6c44c53@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, davidlohr.bueso@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidlohr.bueso@hp.com, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1367347569.1784.3.camel@buesod1.americas.hpqcorp.net>
References: <1367347569.1784.3.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] softirq: Use _RET_IP_
Git-Commit-ID: d2e08473f2488d53a71c2f53455f934ec6c44c53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 05:15:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2e08473f2488d53a71c2f53455f934ec6c44c53
Gitweb:     http://git.kernel.org/tip/d2e08473f2488d53a71c2f53455f934ec6c44c53
Author:     Davidlohr Bueso <davidlohr.bueso@hp.com>
AuthorDate: Tue, 30 Apr 2013 11:46:09 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 14:10:57 +0200

softirq: Use _RET_IP_

Use the already defined macro to pass the function return address.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1367347569.1784.3.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b5197dc..a5f8836 100644
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
