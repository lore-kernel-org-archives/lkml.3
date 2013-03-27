Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3C0GRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:17:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25275 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3C0GRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:17:43 -0400
Message-ID: <51528E89.6080508@huawei.com>
Date: Wed, 27 Mar 2013 14:15:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/syscalls: Annotate raw_init function with __init
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_syscall_trace() can be called during kernel bootup only, so we can
mark it and the functions it calls as __init.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/trace/trace_syscalls.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..1de2ba6 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -200,8 +200,8 @@ extern char *__bad_type_size(void);
 		#type, #name, offsetof(typeof(trace), name),		\
 		sizeof(trace.name), is_signed_type(type)
 
-static
-int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
+static int __init
+__set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
 {
 	int i;
 	int pos = 0;
@@ -228,7 +228,7 @@ int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
 	return pos;
 }
 
-static int set_syscall_print_fmt(struct ftrace_event_call *call)
+static int __init set_syscall_print_fmt(struct ftrace_event_call *call)
 {
 	char *print_fmt;
 	int len;
@@ -253,7 +253,7 @@ static int set_syscall_print_fmt(struct ftrace_event_call *call)
 	return 0;
 }
 
-static void free_syscall_print_fmt(struct ftrace_event_call *call)
+static void __init free_syscall_print_fmt(struct ftrace_event_call *call)
 {
 	struct syscall_metadata *entry = call->data;
 
@@ -446,7 +446,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static int init_syscall_trace(struct ftrace_event_call *call)
+static int __init init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 	int num;
-- 
1.8.0.2
