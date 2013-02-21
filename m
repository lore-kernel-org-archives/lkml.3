Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3BUCer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:34:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64957 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3BUCeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:34:46 -0500
Message-ID: <51258796.7020704@huawei.com>
Date: Thu, 21 Feb 2013 10:33:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing/syscalls: Annotate field-defining functions with
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

These two functions are called during kernel boot only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/trace/trace_syscalls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5329e13..a70fa19 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -232,7 +232,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
 		kfree(call->print_fmt);
 }
 
-static int syscall_enter_define_fields(struct ftrace_event_call *call)
+static int __init syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
 	struct syscall_metadata *meta = call->data;
@@ -255,7 +255,7 @@ static int syscall_enter_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-static int syscall_exit_define_fields(struct ftrace_event_call *call)
+static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_exit trace;
 	int ret;
-- 
1.8.0.2
