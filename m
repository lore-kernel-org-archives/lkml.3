Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3BUCeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:34:21 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41172 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3BUCeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:34:20 -0500
Message-ID: <5125877D.5000201@huawei.com>
Date: Thu, 21 Feb 2013 10:33:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing: Annotate event field-defining functions with
 __init
References: <51258723.2040301@huawei.com>
In-Reply-To: <51258723.2040301@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those functions are called either during kernel boot or module init.

Before:

$ dmesg | grep 'Freeing unused kernel memory'
Freeing unused kernel memory: 1208k freed
Freeing unused kernel memory: 1360k freed
Freeing unused kernel memory: 1960k freed

After:

$ dmesg | grep 'Freeing unused kernel memory'
Freeing unused kernel memory: 1236k freed
Freeing unused kernel memory: 1388k freed
Freeing unused kernel memory: 1960k freed

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/trace/ftrace.h      | 2 +-
 kernel/trace/trace_export.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 20b6005..dc18af3 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -324,7 +324,7 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
-static int notrace							\
+static int notrace __init						\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e039906..4f6a91c 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -129,7 +129,7 @@ static void __always_unused ____ftrace_check_##name(void)		\
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
-int									\
+static int __init							\
 ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 {									\
 	struct struct_name field;					\
-- 
1.8.0.2
