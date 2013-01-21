Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3AUVRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:17:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3AUVRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:30 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9M3qzYPXggsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ztnLV4vLDVAA:10 a=QyXUC8HyAAAA:8 a=2fI_1bGreRXKKz6Lyv8A:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Z-dSymqPRmjn_ZaJ:21 a=s4WAr9l-bKdMQQ9N:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211728.041717571@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 05/13 -next] tracing/syscalls: Make local functions static
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-syscalls-Make-local-functions-static.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

Some functions in the syscall tracing is used only locally to
the file, but they are labeled global. Convert them to static functions.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7609dd6..5329e13e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -77,7 +77,7 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
-enum print_line_t
+static enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags,
 		    struct trace_event *event)
 {
@@ -130,7 +130,7 @@ end:
 	return TRACE_TYPE_HANDLED;
 }
 
-enum print_line_t
+static enum print_line_t
 print_syscall_exit(struct trace_iterator *iter, int flags,
 		   struct trace_event *event)
 {
@@ -270,7 +270,7 @@ static int syscall_exit_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
+static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
@@ -305,7 +305,7 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
+static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 {
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
@@ -337,7 +337,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-int reg_event_syscall_enter(struct ftrace_event_call *call)
+static int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -356,7 +356,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	return ret;
 }
 
-void unreg_event_syscall_enter(struct ftrace_event_call *call)
+static void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int num;
 
@@ -371,7 +371,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-int reg_event_syscall_exit(struct ftrace_event_call *call)
+static int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -390,7 +390,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	return ret;
 }
 
-void unreg_event_syscall_exit(struct ftrace_event_call *call)
+static void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int num;
 
@@ -459,7 +459,7 @@ unsigned long __init __weak arch_syscall_addr(int nr)
 	return (unsigned long)sys_call_table[nr];
 }
 
-int __init init_ftrace_syscalls(void)
+static int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	unsigned long addr;
-- 
1.7.10.4


