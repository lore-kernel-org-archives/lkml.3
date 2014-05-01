Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaEASz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaEASzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:55:54 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH] watchdog: print all locks on a softlock
Date: Thu,  1 May 2014 14:55:35 -0400
Message-Id: <1398970535-6880-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU hits a softlockup this patch will also have it print the
information about all locks being held on the system.  This might help
determine if a lock is being held too long leading to this problem.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ben Zhang <benzh@chromium.org>
---
 kernel/watchdog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 516203e..a027240 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -322,6 +322,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			current->comm, task_pid_nr(current));
 		print_modules();
 		print_irqtrace_events(current);
+		debug_show_all_locks();
 		if (regs)
 			show_regs(regs);
 		else
-- 
1.9.0

