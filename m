Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBUCwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:52:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3567 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753332AbaBUCuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:07 -0500
Message-Id: <20140221025003.424440540@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 16/18] tracing/uprobes: Support mix of ftrace and perf
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0016-tracing-uprobes-Support-mix-of-ftrace-and-perf.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It seems there's no reason to prevent mixed used of ftrace and perf
for a single uprobe event.  At least the kprobes already support it.

Link: http://lkml.kernel.org/r/1389946120-19610-6-git-send-email-namhyung@kernel.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 01fcb0d..e447336 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -882,9 +882,6 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 	int ret;
 
 	if (file) {
-		if (tu->tp.flags & TP_FLAG_PROFILE)
-			return -EINTR;
-
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link)
 			return -ENOMEM;
@@ -893,12 +890,8 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 		list_add_tail_rcu(&link->list, &tu->tp.files);
 
 		tu->tp.flags |= TP_FLAG_TRACE;
-	} else {
-		if (tu->tp.flags & TP_FLAG_TRACE)
-			return -EINTR;
-
+	} else
 		tu->tp.flags |= TP_FLAG_PROFILE;
-	}
 
 	ret = uprobe_buffer_enable();
 	if (ret < 0)
-- 
1.8.5.3


