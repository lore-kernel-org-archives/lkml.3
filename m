Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab3BNXi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:38:59 -0500
Received: from mail-gg0-f201.google.com ([209.85.161.201]:36016 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab3BNXii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:38:38 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/5] coredump: cleanup the waiting for coredump_finish code
Date: Thu, 14 Feb 2013 15:38:14 -0800
Message-Id: <1360885096-21207-3-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360885096-21207-1-git-send-email-msb@chromium.org>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the for loop with a simple if.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/exit.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b4df219..f215198 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -479,12 +479,9 @@ static void exit_mm(struct task_struct * tsk)
 		if (atomic_dec_and_test(&core_state->nr_threads))
 			complete(&core_state->startup);
 
-		for (;;) {
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (self.task) /* see coredump_finish() */
 			schedule();
-		}
 		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
-- 
1.8.1

