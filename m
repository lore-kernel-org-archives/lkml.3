Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3IPOIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:08:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3IPOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:08:40 -0400
Date: Mon, 16 Sep 2013 07:07:36 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-13b62e46d5407c7d619aea1dc9c3e0991b631b57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mst@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20130916083036.GA1113@redhat.com>
References: <20130916083036.GA1113@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix comment for sched_info_depart
Git-Commit-ID: 13b62e46d5407c7d619aea1dc9c3e0991b631b57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 16 Sep 2013 07:07:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13b62e46d5407c7d619aea1dc9c3e0991b631b57
Gitweb:     http://git.kernel.org/tip/13b62e46d5407c7d619aea1dc9c3e0991b631b57
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Mon, 16 Sep 2013 11:30:36 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Sep 2013 11:18:34 +0200

sched: Fix comment for sched_info_depart

sched_info_depart seems to be only called from
sched_info_switch(), so only on involuntary task switch.

Fix the comment to match.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/20130916083036.GA1113@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/stats.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 5aef494..c7edee7 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -104,8 +104,9 @@ static inline void sched_info_queued(struct task_struct *t)
 }
 
 /*
- * Called when a process ceases being the active-running process, either
- * voluntarily or involuntarily.  Now we can calculate how long we ran.
+ * Called when a process ceases being the active-running process involuntarily
+ * due, typically, to expiring its time slice (this may also be called when
+ * switching to the idle task).  Now we can calculate how long we ran.
  * Also, if the process is still in the TASK_RUNNING state, call
  * sched_info_queued() to mark that it has now again started waiting on
  * the runqueue.
