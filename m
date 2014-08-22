Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaHVQ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:29:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:33628 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588AbaHVQ3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:29:51 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/16] perf hists browser: Get rid of unused 'remaining' variable
Date: Fri, 22 Aug 2014 13:29:15 -0300
Message-Id: <1408724968-3441-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It seems that the 'remaining' variable is not used by any real code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408522080-26556-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4892480e8298..2f34c6b6d5dc 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -488,14 +488,13 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 {
 	struct rb_node *node;
 	int first_row = row, width, offset = level * LEVEL_OFFSET_STEP;
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
@@ -506,8 +505,6 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 		int first = true;
 		int extra_offset = 0;
 
-		remaining -= cumul;
-
 		list_for_each_entry(chain, &child->val, list) {
 			char bf[1024], *alloc_str;
 			const char *str;
@@ -1084,7 +1081,7 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 {
 	struct rb_node *node;
 	int offset = level * LEVEL_OFFSET_STEP;
-	u64 new_total, remaining;
+	u64 new_total;
 	int printed = 0;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
@@ -1092,7 +1089,6 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 	else
 		new_total = total;
 
-	remaining = new_total;
 	node = rb_first(&chain_node->rb_root);
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
@@ -1103,8 +1099,6 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 		int first = true;
 		int extra_offset = 0;
 
-		remaining -= cumul;
-
 		list_for_each_entry(chain, &child->val, list) {
 			char bf[1024], *alloc_str;
 			const char *str;
-- 
1.9.3

