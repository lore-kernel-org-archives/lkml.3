Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaDONcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:32:53 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61961 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbaDONcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:50 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292483"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/8] sched & trace: Add a trace event for wait.
Date: Tue, 15 Apr 2014 21:32:50 +0900
Message-ID: <6d3aa5da995cfdb74b1d1c349c74a8c01ba9cdf6.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 include/trace/events/sched.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67e1bbf..7aa7d43a 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -51,6 +51,26 @@ TRACE_EVENT(sched_kthread_stop_ret,
 );
 
 /*
+ * Tracepoint for wait:
+ */
+TRACE_EVENT(sched_wait,
+
+	TP_PROTO(struct task_struct *p),
+
+	TP_ARGS(p),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid	)
+	),
+
+	TP_fast_assign(
+		__entry->pid	= p->pid;
+	),
+
+	TP_printk("pid=%d", __entry->pid)
+);
+
+/*
  * Tracepoint for waking up a task:
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
-- 
1.8.2.1

