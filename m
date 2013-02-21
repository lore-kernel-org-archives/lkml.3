Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3BUCdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:33:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64178 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BUCdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:33:06 -0500
Message-ID: <51258723.2040301@huawei.com>
Date: Thu, 21 Feb 2013 10:32:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing/syscalls: Anotate some functions static
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/trace/trace_syscalls.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7609dd6..5329e13 100644
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
1.8.0.2
