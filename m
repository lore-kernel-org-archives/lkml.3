Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab3DJD1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:27:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26446 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3DJD1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:27:14 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH v3 04/12] tracing: export ftrace_events
Date: Wed, 10 Apr 2013 11:26:25 +0800
Message-ID: <1365564393-10972-5-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

let modules can access ftrace_events

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace.h         |    1 -
 kernel/trace/trace_events.c  |    2 ++
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4b55272..f6a6e48 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -346,6 +346,7 @@ enum {
 #define EVENT_STORAGE_SIZE 128
 extern struct mutex event_storage_mutex;
 extern char event_storage[EVENT_STORAGE_SIZE];
+extern struct list_head ftrace_events;
 
 extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0a1f4be..8f4966b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -917,7 +917,6 @@ extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
 extern int event_trace_del_tracer(struct trace_array *tr);
 
 extern struct mutex event_mutex;
-extern struct list_head ftrace_events;
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 09ca479..7c52a51 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -34,6 +34,8 @@ char event_storage[EVENT_STORAGE_SIZE];
 EXPORT_SYMBOL_GPL(event_storage);
 
 LIST_HEAD(ftrace_events);
+EXPORT_SYMBOL_GPL(ftrace_events);
+
 static LIST_HEAD(ftrace_common_fields);
 
 #define GFP_TRACE (GFP_KERNEL | __GFP_ZERO)
-- 
1.7.9.7


