Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3C0Jtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45188 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3C0Jte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:34 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 07/14] tracing: expose structure ftrace_event_field
Date: Wed, 27 Mar 2013 17:48:49 +0800
Message-ID: <1364377737-10540-9-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Currently event tracing field information is only stored in
struct ftrace_event_field, this structure is defined in
internal trace.h.
Move this ftrace_event_field into include/linux/ftrace_event.h,
then external modules can make use this structure to parse event
field(like ktap).

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/linux/ftrace_event.h |   10 ++++++++++
 kernel/trace/trace.h         |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 38c272a..c0de961 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -176,6 +176,16 @@ enum trace_reg {
 #endif
 };
 
+struct ftrace_event_field {
+	struct list_head	link;
+	const char		*name;
+	const char		*type;
+	int			filter_type;
+	int			offset;
+	int			size;
+	int			is_signed;
+};
+
 struct ftrace_event_call;
 
 struct ftrace_event_class {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0a1f4be..ff28b5a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -800,16 +800,6 @@ enum {
 	TRACE_EVENT_TYPE_RAW		= 2,
 };
 
-struct ftrace_event_field {
-	struct list_head	link;
-	const char		*name;
-	const char		*type;
-	int			filter_type;
-	int			offset;
-	int			size;
-	int			is_signed;
-};
-
 struct event_filter {
 	int			n_preds;	/* Number assigned */
 	int			a_preds;	/* allocated */
-- 
1.7.9.7


