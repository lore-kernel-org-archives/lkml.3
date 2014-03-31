Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaCaO3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:29:22 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56412 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaCaO3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:29:19 -0400
Date: Mon, 31 Mar 2014 16:29:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug change for v3.15
Message-ID: <20140331142915.GA11363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   # HEAD: 7743a536beda6225eef4a0758c5370f761fb0616 i386: Remove unneeded test of 'task' in dump_trace() (again)

A single trivial cleanup.

 Thanks,

	Ingo

------------------>
Steven Rostedt (1):
      i386: Remove unneeded test of 'task' in dump_trace() (again)


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
 
