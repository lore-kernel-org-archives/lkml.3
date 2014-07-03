Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbaGCQPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:15:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759229AbaGCQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:29 -0400
Message-Id: <20140703161226.685605501@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 19/21] tracing: Improve message of empty set_graph_notrace file
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0019-tracing-Improve-message-of-empty-set_graph_notrace-f.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When there's no entry in set_graph_notrace, it'll print below message

  #### all functions enabled ####

While this is technically correct, it's better to print like below:

  #### no functions disabled ####

Link: http://lkml.kernel.org/p/1402590233-22321-3-git-send-email-namhyung@kernel.org

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 17885a27281c..ee245c0659a6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4089,7 +4089,12 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 
 	if (ptr == (unsigned long *)1) {
-		seq_printf(m, "#### all functions enabled ####\n");
+		struct ftrace_graph_data *fgd = m->private;
+
+		if (fgd->table == ftrace_graph_funcs)
+			seq_printf(m, "#### all functions enabled ####\n");
+		else
+			seq_printf(m, "#### no functions disabled ####\n");
 		return 0;
 	}
 
-- 
2.0.0


