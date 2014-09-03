Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaICG3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:29:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:47558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaICG3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,455,1406617200"; 
   d="scan'208";a="567549058"
From: Chen LinX <linx.z.chen@intel.com>
To: rostedt@goodmis.org, mingo@redhat.com
Cc: yanmin_zhang@linux.intel.com, linux-kernel@vger.kernel.org,
        Chen LinX <linx.z.chen@intel.com>
Subject: [PATCH] ftrace: The set_graph_function and set_graph_notrace file mode should be 0644 instead of 0444
Date: Wed,  3 Sep 2014 14:31:09 +0800
Message-Id: <1409725869-4501-1-git-send-email-linx.z.chen@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen LinX <linx.z.chen@intel.com>
---
 kernel/trace/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5916a8e..00e7b9a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4406,10 +4406,10 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	ftrace_create_filter_files(&global_ops, d_tracer);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	trace_create_file("set_graph_function", 0444, d_tracer,
+	trace_create_file("set_graph_function", 0644, d_tracer,
 				    NULL,
 				    &ftrace_graph_fops);
-	trace_create_file("set_graph_notrace", 0444, d_tracer,
+	trace_create_file("set_graph_notrace", 0644, d_tracer,
 				    NULL,
 				    &ftrace_graph_notrace_fops);
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
1.9.1

