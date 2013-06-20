Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176Ab3FTDij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:38:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935737Ab3FTDgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:41 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZHHD4BM4WNAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OoJK4RbATzEA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=B4tnyQ9U8ZYsp7WxcrkA:9 a=hPjdaMEvmhQA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033640.219304193@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 11/12] tracing/kprobes: Remove unnecessary checking of
 trace_probe_is_enabled
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-kprobes-Remove-unnecessary-checking-of-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Since tp->flags assignment was moved into function enable_trace_probe(),
there is no need to use trace_probe_is_enabled to check flags
in the same function.

Remove the unnecessary checking.

Link: http://lkml.kernel.org/r/51BA7B9E.3040807@huawei.com

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9f46e98..f237417 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -240,8 +240,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 	} else
 		tp->flags |= TP_FLAG_PROFILE;
 
-	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
-	    !trace_probe_has_gone(tp)) {
+	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
 		if (trace_probe_is_return(tp))
 			ret = enable_kretprobe(&tp->rp);
 		else
-- 
1.7.10.4


