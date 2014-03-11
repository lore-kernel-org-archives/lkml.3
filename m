Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaCKMj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbaCKMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:22 -0400
Date: Tue, 11 Mar 2014 05:39:05 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-7743a536beda6225eef4a0758c5370f761fb0616@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        heukelum@fastmail.fm, jesper.juhl@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        heukelum@fastmail.fm, jesper.juhl@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20140307105242.79a0befd@gandalf.local.home>
References: <20140307105242.79a0befd@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] i386: Remove unneeded test of 'task'
  in dump_trace() (again)
Git-Commit-ID: 7743a536beda6225eef4a0758c5370f761fb0616
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

Commit-ID:  7743a536beda6225eef4a0758c5370f761fb0616
Gitweb:     http://git.kernel.org/tip/7743a536beda6225eef4a0758c5370f761fb0616
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Fri, 7 Mar 2014 10:52:42 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:02:31 +0100

i386: Remove unneeded test of 'task' in dump_trace() (again)

Commit 028a690a1ebc8b "i386: Remove unneeded test of 'task' in
dump_trace()" correctly removed the unneeded 'task != NULL'
check because it would be set to current if it was NULL.

Commit 2bc5f927d489 "i386: split out dumpstack code from
traps_32.c" moved the code from traps_32.c to its own file
dump_stack.c for preparation of the i386 / x86_64 merge.

Commit 8a541665b906 "dumpstack: x86: various small unification
steps" worked to make i386 and x86_64 dump_stack logic similar.
But this actually reverted the correct change from
028a690a1ebc8b.

Commit d0caf292505d "x86/dumpstack: Remove unneeded check in
dump_trace()" removed the unneeded "task != NULL" check for
x86_64 but left that same unneeded check for i386, that was
added because x86_64 had it!

This chain of events ironically had i386 add back the unneeded
task != NULL check because x86_64 did it, and then the fix for
x86_64 was fixed by Dan. And even more ironically, it was Dan's
smatch bot that told me that a change to dump_stack_32 I made
may be wrong if current can be NULL (it can't), as there was a
check for it by assigning task to current, and then checking if
task is NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Link: http://lkml.kernel.org/r/20140307105242.79a0befd@gandalf.local.home
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/dumpstack_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f2a1770..a21d49c 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -30,7 +30,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long dummy;
 
 		stack = &dummy;
-		if (task && task != current)
+		if (task != current)
 			stack = (unsigned long *)task->thread.sp;
 	}
 
