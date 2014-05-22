Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaEVMc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:32:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51129 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbaEVMZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:25:57 -0400
Date: Thu, 22 May 2014 05:25:02 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-dbdb22754fde671dc93d2fae06f8be113d47f2fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <20140509085311.GJ30445@twins.programming.kicks-ass.net>
References: <20140509085311.GJ30445@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Disallow sched_attr::sched_policy < 0
Git-Commit-ID: dbdb22754fde671dc93d2fae06f8be113d47f2fb
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

Commit-ID:  dbdb22754fde671dc93d2fae06f8be113d47f2fb
Gitweb:     http://git.kernel.org/tip/dbdb22754fde671dc93d2fae06f8be113d47f2fb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 9 May 2014 10:49:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 10:21:26 +0200

sched: Disallow sched_attr::sched_policy < 0

The scheduler uses policy=-1 to preserve the current policy state to
implement sys_sched_setparam(), this got exposed to userspace by
accident through sys_sched_setattr(), cure this.

Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140509085311.GJ30445@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f2205f0..cdefcf7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3662,6 +3662,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (retval)
 		return retval;
 
+	if (attr.sched_policy < 0)
+		return -EINVAL;
+
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
