Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaDQQ72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:59:28 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34355 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaDQQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:59:23 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] sch: Fix warning on make htmldocs caused by missing description
Date: Fri, 18 Apr 2014 01:59:15 +0900
Message-Id: <1397753955-2914-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.2.468.g3f0c02a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 'flags' argument to sched_{set,get}attr() syscalls were added in
commit 6d35ab48090b10, no description for 'flags' were added.
It causes warning on "make htmldocs".

Warning(/kernel/sched/core.c:3645): No description found for parameter 'flags'
Warning(/kernel/sched/core.c:3789): No description found for parameter 'flags'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
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
-- 
1.9.2.468.g3f0c02a

