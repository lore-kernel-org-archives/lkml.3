Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3HVQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:34:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3HVQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:34:21 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=z4I01019TLYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Vu_iWteS_ssA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=PHpoTpGJIJKG0C60QpcA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130822163420.330586243@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 22 Aug 2013 12:32:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 2/5] tracing/syscalls: Annotate raw_init function with __init
References: <20130822163225.773134216@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-syscalls-Annotate-raw_init-function-with-__i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

init_syscall_trace() can only be called during kernel bootup only, so we can
mark it and the functions it calls as __init.

Link: http://lkml.kernel.org/r/51528E89.6080508@huawei.com

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8fd0365..559329d 100644
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
 
@@ -459,7 +459,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static int init_syscall_trace(struct ftrace_event_call *call)
+static int __init init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 	int num;
-- 
1.7.10.4


