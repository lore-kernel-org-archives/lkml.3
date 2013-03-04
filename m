Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3CDR0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:26:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267Ab3CDR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:17 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5DXE0VfaIUkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fHpte-MBFbgA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=PHpoTpGJIJKG0C60QpcA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172615.548061112@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 2/6] tracing: Annotate event field-defining functions with __init
References: <20130304172005.362537932@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Annotate-event-field-defining-functions-with.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

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

Link: http://lkml.kernel.org/r/5125877D.5000201@huawei.com

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h      |    2 +-
 kernel/trace/trace_export.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 17a77fc..a536f66 100644
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
1.7.10.4


