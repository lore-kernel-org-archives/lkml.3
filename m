Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbaGOTLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:11:51 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48130 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaGOTLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:11:49 -0400
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [PATCH] lockdep: Only ask for /proc/lock_stat output when available
Date: Tue, 15 Jul 2014 21:10:52 +0200
Message-Id: <1405451452-3824-1-git-send-email-andreas.gruenbacher@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When lockdep turns itself off, the following message is logged:

  Please attach the output of /proc/lock_stat to the bug report

Omit this message when CONFIG_LOCK_STAT is off, and /proc/lock_stat
doesn't exist.

Signed-off-by: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
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
-- 
1.8.3.1

