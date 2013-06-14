Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab3FNCUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:20:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:29119 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3FNCUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:20:01 -0400
Message-ID: <51BA7B9E.3040807@huawei.com>
Date: Fri, 14 Jun 2013 10:10:38 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/kprobes: remove unnecessary checking of, trace_probe_is_enabled
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since tp->flags assignment was moved into function enable_trace_probe,
so there have no need to use trace_probe_is_enabled to check flags
in same function.

Remove the unnecessary checking.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
1.7.9.7


