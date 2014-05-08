Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaEHHi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:38:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13991 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853AbaEHHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:38:25 -0400
X-IronPort-AV: E=Sophos;i="4.97,1009,1389715200"; 
   d="scan'208";a="30242077"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH RESEND] tracing: Use inline task_nice() to get rid of an open coded implementation of it.
Date: Thu, 8 May 2014 15:38:23 +0900
Message-ID: <1399531103-920-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20140318221533.45c479bd@gandalf.local.home>
References: <20140318221533.45c479bd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
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
index 737b0ef..f296adc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1015,7 +1015,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	else
 		max_data->uid = task_uid(tsk);
 
-	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	max_data->nice = task_nice(tsk);
 	max_data->policy = tsk->policy;
 	max_data->rt_priority = tsk->rt_priority;
 
-- 
1.8.2.1

