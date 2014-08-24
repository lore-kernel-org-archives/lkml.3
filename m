Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaHXO57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:57:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaHXO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:57:57 -0400
Date: Sun, 24 Aug 2014 07:57:13 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-36e15dd4027a9b088264758fea292b6e876b5cdd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1408522080-26556-4-git-send-email-namhyung@kernel.org>
References: <1408522080-26556-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Get rid of unused 'remaining'
  variable
Git-Commit-ID: 36e15dd4027a9b088264758fea292b6e876b5cdd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36e15dd4027a9b088264758fea292b6e876b5cdd
Gitweb:     http://git.kernel.org/tip/36e15dd4027a9b088264758fea292b6e876b5cdd
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 20 Aug 2014 17:07:58 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 20 Aug 2014 12:14:11 -0300

perf hists browser: Get rid of unused 'remaining' variable

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
index 4892480..2f34c6b 100644
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
