Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaHTIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:09:07 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60607 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaHTIIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:08:04 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] perf hists browser: Get rid of unused 'remaining' variable
Date: Wed, 20 Aug 2014 17:07:58 +0900
Message-Id: <1408522080-26556-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
References: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the 'remaining' variable is not used by any real code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2abb0c5cbbaa..d42d8a8f3810 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -511,14 +511,13 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 {
 	struct rb_node *node;
 	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
-	u64 new_total, remaining;
+	u64 new_total;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
 		new_total = chain_node->children_hit;
 	else
 		new_total = total;
 
-	remaining = new_total;
 	node = rb_first(&chain_node->rb_root);
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
@@ -529,8 +528,6 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 		int first = true;
 		int extra_offset = 0;
 
-		remaining -= cumul;
-
 		list_for_each_entry(chain, &child->val, list) {
 			char bf[1024], *alloc_str;
 			const char *str;
@@ -1086,7 +1083,7 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 {
 	struct rb_node *node;
 	int offset = level * LEVEL_OFFSET_STEP;
-	u64 new_total, remaining;
+	u64 new_total;
 	int printed = 0;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
@@ -1094,7 +1091,6 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 	else
 		new_total = total;
 
-	remaining = new_total;
 	node = rb_first(&chain_node->rb_root);
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
@@ -1105,8 +1101,6 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 		int first = true;
 		int extra_offset = 0;
 
-		remaining -= cumul;
-
 		list_for_each_entry(chain, &child->val, list) {
 			char bf[1024], *alloc_str;
 			const char *str;
-- 
2.0.0

