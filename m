Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaAWQr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:47:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaAWQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:47:25 -0500
Date: Thu, 23 Jan 2014 08:46:34 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-215393bc1fab3d61a5a296838bdffce22f27ffda@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        markus@trippelsdorf.de, dipankar@in.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        markus@trippelsdorf.de, dipankar@in.ibm.com, tglx@linutronix.de
In-Reply-To: <20140122102435.GH31570@twins.programming.kicks-ass.net>
References: <20140122102435.GH31570@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/preempt/x86:
  Fix voluntary preempt for x86
Git-Commit-ID: 215393bc1fab3d61a5a296838bdffce22f27ffda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 08:46:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  215393bc1fab3d61a5a296838bdffce22f27ffda
Gitweb:     http://git.kernel.org/tip/215393bc1fab3d61a5a296838bdffce22f27ffda
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 22 Jan 2014 11:24:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 23 Jan 2014 14:48:35 +0100

sched/preempt/x86: Fix voluntary preempt for x86

The #ifdef CONFIG_PREEMPT is both not needed and wrong.

Its not required because asm/preempt.h should provide
{set,clear}_preempt_need_resched() regardless and its wrong because
for voluntary preempt we still rely on PREEMPT_NEED_RESCHED.

Reported-and-Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Fixes: 8cb75e0c4ec9 ("sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding")
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140122102435.GH31570@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/preempt.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 59749fc..de83b4e 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -134,7 +134,6 @@ do { \
 #undef preempt_check_resched
 #endif
 
-#ifdef CONFIG_PREEMPT
 #define preempt_set_need_resched() \
 do { \
 	set_preempt_need_resched(); \
@@ -144,10 +143,6 @@ do { \
 	if (tif_need_resched()) \
 		set_preempt_need_resched(); \
 } while (0)
-#else
-#define preempt_set_need_resched() do { } while (0)
-#define preempt_fold_need_resched() do { } while (0)
-#endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
