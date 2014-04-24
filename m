Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaDXIEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:04:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaDXIEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:04:02 -0400
Date: Thu, 24 Apr 2014 01:03:49 -0700
From: tip-bot for Masanari Iida <tipbot@zytor.com>
Message-ID: <tip-db66d756c74acb886c51f11b501c2fe622018a0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com
In-Reply-To: <1397753955-2914-1-git-send-email-standby24x7@gmail.com>
References: <1397753955-2914-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/docbook: Fix 'make htmldocs'
  warnings caused by missing description
Git-Commit-ID: db66d756c74acb886c51f11b501c2fe622018a0a
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

Commit-ID:  db66d756c74acb886c51f11b501c2fe622018a0a
Gitweb:     http://git.kernel.org/tip/db66d756c74acb886c51f11b501c2fe622018a0a
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Fri, 18 Apr 2014 01:59:15 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 09:28:32 +0200

sched/docbook: Fix 'make htmldocs' warnings caused by missing description

When 'flags' argument to sched_{set,get}attr() syscalls were
added in:

  6d35ab48090b ("sched: Add 'flags' argument to sched_{set,get}attr() syscalls")

no description for 'flags' was added. It causes the following warnings on "make htmldocs":

  Warning(/kernel/sched/core.c:3645): No description found for parameter 'flags'
  Warning(/kernel/sched/core.c:3789): No description found for parameter 'flags'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1397753955-2914-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..9fe2190 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3639,6 +3639,7 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
  * sys_sched_setattr - same as above, but with extended sched_attr
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
+ * @flags: for future extension.
  */
 SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 			       unsigned int, flags)
@@ -3783,6 +3784,7 @@ err_size:
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
  * @size: sizeof(attr) for fwd/bwd comp.
+ * @flags: for future extension.
  */
 SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 		unsigned int, size, unsigned int, flags)
