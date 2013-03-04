Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3CDR0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:26:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3CDR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:18 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Zn14S0Ndon8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2Rohm2fEs2QA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=2O6cZUrYPlWD74PgEMAA:9 a=hPjdaMEvmhQA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172616.171323661@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 6/6] tracing: Fix some section mismatch warnings
References: <20130304172005.362537932@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-some-section-mismatch-warnings.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

As we've added __init annotation to field-defining functions, we should
add __refdata annotation to event_call variables, which reference those
functions.

Link: http://lkml.kernel.org/r/51343C1F.2050502@huawei.com

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h        |    2 +-
 kernel/trace/trace_export.c   |    2 +-
 kernel/trace/trace_syscalls.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a536f66..bbf09c2 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -572,7 +572,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 _TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
-static struct ftrace_event_class __used event_class_##call = {		\
+static struct ftrace_event_class __used __refdata event_class_##call = { \
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4f6a91c..d21a746 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -168,7 +168,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
 			 regfn)						\
 									\
-struct ftrace_event_class event_class_ftrace_##call = {			\
+struct ftrace_event_class __refdata event_class_ftrace_##call = {	\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 00b5c3e..1cd37ff 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -479,7 +479,7 @@ struct trace_event_functions exit_syscall_print_funcs = {
 	.trace		= print_syscall_exit,
 };
 
-struct ftrace_event_class event_class_syscall_enter = {
+struct ftrace_event_class __refdata event_class_syscall_enter = {
 	.system		= "syscalls",
 	.reg		= syscall_enter_register,
 	.define_fields	= syscall_enter_define_fields,
@@ -487,7 +487,7 @@ struct ftrace_event_class event_class_syscall_enter = {
 	.raw_init	= init_syscall_trace,
 };
 
-struct ftrace_event_class event_class_syscall_exit = {
+struct ftrace_event_class __refdata event_class_syscall_exit = {
 	.system		= "syscalls",
 	.reg		= syscall_exit_register,
 	.define_fields	= syscall_exit_define_fields,
-- 
1.7.10.4


