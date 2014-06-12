Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaFLQYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:24:06 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33705 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaFLQYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:24:02 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing: Improve message of empty set_graph_notrace file
Date: Fri, 13 Jun 2014 01:23:51 +0900
Message-Id: <1402590233-22321-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
References: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's no entry in set_graph_notrace, it'll print below message

  #### all functions enabled ####

While this is technically correct, it's better to print like below:

  #### no functions disabled ####

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f08edd7125c6..b375cf2cd786 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3833,7 +3833,12 @@ static int g_show(struct seq_file *m, void *v)
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
1.7.9.2

