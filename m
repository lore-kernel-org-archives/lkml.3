Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFEOej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:34:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaFEOeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:34:37 -0400
Date: Thu, 5 Jun 2014 07:33:38 -0700
From: tip-bot for Richard Weinberger <tipbot@zytor.com>
Message-ID: <tip-b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, richard@nod.at,
        tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, richard@nod.at,
        tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <1401741514-7045-1-git-send-email-richard@nod.at>
References: <1401741514-7045-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix sched_policy < 0 comparison
Git-Commit-ID: b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3
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

Commit-ID:  b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3
Gitweb:     http://git.kernel.org/tip/b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Mon, 2 Jun 2014 22:38:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:07:43 +0200

sched: Fix sched_policy < 0 comparison

attr.sched_policy is u32, therefore a comparison against < 0 is never true.
Fix this by casting sched_policy to int.

This issue was reported by coverity CID 1219934.

Fixes: dbdb22754fde ("sched: Disallow sched_attr::sched_policy < 0")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1401741514-7045-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 86f3890..540542b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3685,7 +3685,7 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (retval)
 		return retval;
 
-	if (attr.sched_policy < 0)
+	if ((int)attr.sched_policy < 0)
 		return -EINVAL;
 
 	rcu_read_lock();
