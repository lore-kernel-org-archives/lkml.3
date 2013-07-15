Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3GOIli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:41:38 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:2254 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3GOIlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:41:37 -0400
Message-ID: <51E3B3A2.8080609@huawei.com>
Date: Mon, 15 Jul 2013 16:32:34 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing: use correct config guard CONFIG_STACK_TRACER
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use CONFIG_STACK_TRACER to guard readme text
of stack tracer related file, not CONFIG_STACKTRACE.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e71a8be..3d5a931 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3379,14 +3379,14 @@ static const char readme_msg[] =
 	"\n  snapshot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
 	"\t\t\t  Read the contents for more information\n"
 #endif
-#ifdef CONFIG_STACKTRACE
+#ifdef CONFIG_STACK_TRACER
 	"  stack_trace\t\t- Shows the max stack trace when active\n"
 	"  stack_max_size\t- Shows current max stack size that was traced\n"
 	"\t\t\t  Write into this file to reset the max size (trigger a new trace)\n"
 #ifdef CONFIG_DYNAMIC_FTRACE
 	"  stack_trace_filter\t- Like set_ftrace_filter but limits what stack_trace traces\n"
 #endif
-#endif /* CONFIG_STACKTRACE */
+#endif /* CONFIG_STACK_TRACER */
 ;

 static ssize_t
-- 
1.7.9.7


