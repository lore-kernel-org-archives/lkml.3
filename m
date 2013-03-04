Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3CDR0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:26:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab3CDR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:17 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=N4PrwOj3AWUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gql8tggquDkA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=PHpoTpGJIJKG0C60QpcA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172615.687616810@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 3/6] tracing/syscalls: Annotate field-defining functions with __init
References: <20130304172005.362537932@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-syscalls-Annotate-field-defining-functions-w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

These two functions are called during kernel boot only.

Link: http://lkml.kernel.org/r/51258796.7020704@huawei.com

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a842783..00b5c3e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -261,7 +261,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
 		kfree(call->print_fmt);
 }
 
-static int syscall_enter_define_fields(struct ftrace_event_call *call)
+static int __init syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
 	struct syscall_metadata *meta = call->data;
@@ -284,7 +284,7 @@ static int syscall_enter_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-static int syscall_exit_define_fields(struct ftrace_event_call *call)
+static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_exit trace;
 	int ret;
-- 
1.7.10.4


