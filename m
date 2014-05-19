Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaESNHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:07:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaESNHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:07:36 -0400
Date: Mon, 19 May 2014 06:06:41 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-438367fbfe307f2c26ee8e490f1fb9eacb6b6b02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <20140509085311.GJ30445@twins.programming.kicks-ass.net>
References: <20140509085311.GJ30445@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Disallow sched_attr::sched_policy < 0
Git-Commit-ID: 438367fbfe307f2c26ee8e490f1fb9eacb6b6b02
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

Commit-ID:  438367fbfe307f2c26ee8e490f1fb9eacb6b6b02
Gitweb:     http://git.kernel.org/tip/438367fbfe307f2c26ee8e490f1fb9eacb6b6b02
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 9 May 2014 10:49:03 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:47:33 +0900

sched: Disallow sched_attr::sched_policy < 0

The scheduler uses policy=-1 to preserve the current policy state to
implement sys_sched_setparam(), this got exposed to userspace by
accident through sys_sched_setattr(), cure this.

Cc: stable@vger.kernel.org
Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140509085311.GJ30445@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
