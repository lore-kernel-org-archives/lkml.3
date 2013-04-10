Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936776Ab3DJD3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:29:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28116 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934893Ab3DJD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:27:21 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH v3 06/12] tracing: expose structure ftrace_event_field
Date: Wed, 10 Apr 2013 11:26:27 +0800
Message-ID: <1365564393-10972-7-git-send-email-jovi.zhangwei@huawei.com>
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
index f6a6e48..ee4dc8d 100644
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
index 8f4966b..89da073 100644
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


