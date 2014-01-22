Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaAVJoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:44:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6561 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbaAVJoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:44:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,698,1384272000"; 
   d="scan'208";a="9444062"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] tracing: Use task_nice() in function __update_max_tr() to get the nice value of task.
Date: Wed, 22 Jan 2014 17:41:45 -0500
Message-Id: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/22 17:42:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/22 17:42:39,
	Serialize complete at 2014/01/22 17:42:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already a function named task_nice in sched.h to get the nice value
of task_struct. We can use it in __update_max_tr() rather than calculate it
manually.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d20cd9..ec149b4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -970,7 +970,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	else
 		max_data->uid = task_uid(tsk);
 
-	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	max_data->nice = task_nice(tsk);
 	max_data->policy = tsk->policy;
 	max_data->rt_priority = tsk->rt_priority;
 
-- 
1.8.2.1

