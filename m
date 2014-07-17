Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaGQLA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:00:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGQLAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:00:24 -0400
Date: Thu, 17 Jul 2014 03:59:22 -0700
From: tip-bot for Andreas Gruenbacher <tipbot@zytor.com>
Message-ID: <tip-acf59377267b5a74818e76873d0670b0ca6cf2fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        andreas.gruenbacher@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, andreas.gruenbacher@gmail.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1405451452-3824-1-git-send-email-andreas.gruenbacher@gmail.com>
References: <1405451452-3824-1-git-send-email-andreas.gruenbacher@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/lockdep: Only ask for /proc/
 lock_stat output when available
Git-Commit-ID: acf59377267b5a74818e76873d0670b0ca6cf2fe
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

Commit-ID:  acf59377267b5a74818e76873d0670b0ca6cf2fe
Gitweb:     http://git.kernel.org/tip/acf59377267b5a74818e76873d0670b0ca6cf2fe
Author:     Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
AuthorDate: Tue, 15 Jul 2014 21:10:52 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 Jul 2014 11:48:15 +0200

locking/lockdep: Only ask for /proc/lock_stat output when available

When lockdep turns itself off, the following message is logged:

  Please attach the output of /proc/lock_stat to the bug report

Omit this message when CONFIG_LOCK_STAT is off, and /proc/lock_stat
doesn't exist.

Signed-off-by: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1405451452-3824-1-git-send-email-andreas.gruenbacher@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/lockdep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..88d0d44 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -384,7 +384,9 @@ static void print_lockdep_off(const char *bug_msg)
 {
 	printk(KERN_DEBUG "%s\n", bug_msg);
 	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
+#ifdef CONFIG_LOCK_STAT
 	printk(KERN_DEBUG "Please attach the output of /proc/lock_stat to the bug report\n");
+#endif
 }
 
 static int save_trace(struct stack_trace *trace)
