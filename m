Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604Ab3GSOOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:14:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3GSOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:50 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=71gmXnZhIG8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=A0kfDPaWHc0A:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=6kcgh8hLkRGSLAEeN_MA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141448.406433972@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next-3.11][PATCH 01/12] tracing: Use correct config guard CONFIG_STACK_TRACER
References: <20130719141224.703522101@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Use-correct-config-guard-CONFIG_STACK_TRACER.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

We should use CONFIG_STACK_TRACER to guard readme text
of stack tracer related file, not CONFIG_STACKTRACE.

Link: http://lkml.kernel.org/r/51E3B3A2.8080609@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0cd500b..25b91af 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3537,14 +3537,14 @@ static const char readme_msg[] =
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
1.7.10.4


