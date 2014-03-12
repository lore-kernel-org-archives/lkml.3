Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaCLKcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:32:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40872 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbaCLKce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:32:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,636,1389715200"; 
   d="scan'208";a="9683574"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3 Resend] tracing: Use inline task_nice() to get rid of an open coded implementation of it.
Date: Wed, 12 Mar 2014 18:26:42 +0800
Message-Id: <6188b0062bdba8e3170b09c88fac6004a8f6fa7c.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 18:26:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 18:26:34,
	Serialize complete at 2014/03/12 18:26:34
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

