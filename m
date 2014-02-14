Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBND7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:59:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47860 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaBND7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:11 -0500
Date: Thu, 13 Feb 2014 19:58:44 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-b35f8305339f1ba3070fe606c6ef0d86ef093dee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1391845930-28580-6-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-6-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage: Make trace_hardirq visible
Git-Commit-ID: b35f8305339f1ba3070fe606c6ef0d86ef093dee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:58:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b35f8305339f1ba3070fe606c6ef0d86ef093dee
Gitweb:     http://git.kernel.org/tip/b35f8305339f1ba3070fe606c6ef0d86ef093dee
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:02 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:13:07 -0800

asmlinkage: Make trace_hardirq visible

Can be called from assembler code.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-6-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/locking/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c8b6753c..aa3bf15 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2557,7 +2557,7 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
 	debug_atomic_inc(hardirqs_on_events);
 }
 
-void trace_hardirqs_on_caller(unsigned long ip)
+__visible void trace_hardirqs_on_caller(unsigned long ip)
 {
 	time_hardirqs_on(CALLER_ADDR0, ip);
 
@@ -2610,7 +2610,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long ip)
+__visible void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
