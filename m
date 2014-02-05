Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaBEUGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:54862 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaBEUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 089/213] wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task
Date: Wed, 5 Feb 2014 15:00:44 -0500
Message-ID: <1391630568-49251-90-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9067ac85d533651b98c2ff903182a20cbb361fcb upstream.

wake_up_process() should never wakeup a TASK_STOPPED/TRACED task.
Change it to use TASK_NORMAL and add the WARN_ON().

TASK_ALL has no other users, probably can be killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[PG: kernel/sched/core.c --> kernel/sched.c on 2.6.34]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e24d139ff694..ddcb8aeb2f59 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2492,7 +2492,8 @@ out:
  */
 int wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_ALL, 0);
+	WARN_ON(task_is_stopped_or_traced(p));
+	return try_to_wake_up(p, TASK_NORMAL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
-- 
1.8.5.2

