Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965389Ab3GRUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:09:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41514 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3GRTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/76] perf gtk/hists: Use GtkTreeStore instead of GtkListStore
Date: Thu, 18 Jul 2013 16:49:22 -0300
Message-Id: <1374177003-3706-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The GtkTreeStore can save items in a tree-like way.  This is a
preparation for supporting callgraphs in the hist browser.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370337737-30812-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 9708dd5..cb6a9b4 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -131,7 +131,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
 	struct sort_entry *se;
-	GtkListStore *store;
+	GtkTreeStore *store;
 	struct rb_node *nd;
 	GtkWidget *view;
 	int col_idx;
@@ -156,7 +156,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		col_types[nr_cols++] = G_TYPE_STRING;
 	}
 
-	store = gtk_list_store_newv(nr_cols, col_types);
+	store = gtk_tree_store_newv(nr_cols, col_types);
 
 	view = gtk_tree_view_new();
 
@@ -199,7 +199,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		if (percent < min_pcnt)
 			continue;
 
-		gtk_list_store_append(store, &iter);
+		gtk_tree_store_append(store, &iter, NULL);
 
 		col_idx = 0;
 
@@ -209,7 +209,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			else
 				fmt->entry(&hpp, h);
 
-			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 
 		list_for_each_entry(se, &hist_entry__sort_list, list) {
@@ -219,7 +219,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			se->se_snprintf(h, s, ARRAY_SIZE(s),
 					hists__col_len(hists, se->se_width_idx));
 
-			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 	}
 
-- 
1.8.1.4

