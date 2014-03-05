Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaCEMic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:38:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaCEMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:38:30 -0500
X-IronPort-AV: E=Sophos;i="4.97,592,1389715200"; 
   d="scan'208";a="9649258"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
        mingo@redhat.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] tracing: Use inline task_nice() to get rid of an open coded implementation of it.
Date: Wed, 5 Mar 2014 20:36:40 +0800
Message-Id: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 20:35:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 20:35:54,
	Serialize complete at 2014/03/05 20:35:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function task_nice() was reimplemented as inline function, we can use it here
to replace the open coded implementation.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 815c878..dba0e3d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1003,7 +1003,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	else
 		max_data->uid = task_uid(tsk);
 
-	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	max_data->nice = task_nice(tsk);
 	max_data->policy = tsk->policy;
 	max_data->rt_priority = tsk->rt_priority;
 
-- 
1.8.2.1

