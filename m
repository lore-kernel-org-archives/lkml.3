Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbaFCRNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:13:25 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:33948 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932841AbaFCRNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:13:23 -0400
X-Yandex-Uniq: 2c9d5c2e-49dc-481a-82c1-ca235d706673
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        jovi.zhangwei@huawei.com, namhyung.kim@lge.com,
        tom.zanussi@linux.intel.com, stfomichev@yandex-team.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: let user specify tracing_thresh after selecting function_graph
Date: Tue,  3 Jun 2014 21:12:49 +0400
Message-Id: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, tracing_thresh works only if we specify it before selecting
function_graph tracer. If we do the opposite, tracing_thresh will change
it's value, but it will not be applied.
To fix it, we need to always register handlers which take tracing_thresh into
account.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 kernel/trace/trace_functions_graph.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index deff11200261..a894031986a3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -433,12 +433,8 @@ static int graph_trace_init(struct trace_array *tr)
 	int ret;
 
 	set_graph_array(tr);
-	if (tracing_thresh)
-		ret = register_ftrace_graph(&trace_graph_thresh_return,
-					    &trace_graph_thresh_entry);
-	else
-		ret = register_ftrace_graph(&trace_graph_return,
-					    &trace_graph_entry);
+	ret = register_ftrace_graph(&trace_graph_thresh_return,
+				    &trace_graph_thresh_entry);
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();
-- 
1.8.3.2

