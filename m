Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3EUGOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:14:46 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52766 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3EUGOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:42 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-88-519b10d1357a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/7] perf gtk/hists: Use GtkTreeStore instead of GtkListStore
Date: Tue, 21 May 2013 15:14:33 +0900
Message-Id: <1369116878-12489-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The GtkTreeStore can save items in a tree-like way.  This is a
preparation for supporting hierachical output in the hist browser.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 6f259b3d14e2..ba59d5d63d74 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -130,7 +130,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
 	struct sort_entry *se;
-	GtkListStore *store;
+	GtkTreeStore *store;
 	struct rb_node *nd;
 	GtkWidget *view;
 	int col_idx;
@@ -155,7 +155,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 		col_types[nr_cols++] = G_TYPE_STRING;
 	}
 
-	store = gtk_list_store_newv(nr_cols, col_types);
+	store = gtk_tree_store_newv(nr_cols, col_types);
 
 	view = gtk_tree_view_new();
 
@@ -193,7 +193,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 		if (h->filtered)
 			continue;
 
-		gtk_list_store_append(store, &iter);
+		gtk_tree_store_append(store, &iter, NULL);
 
 		col_idx = 0;
 
@@ -203,7 +203,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 			else
 				fmt->entry(&hpp, h);
 
-			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 
 		list_for_each_entry(se, &hist_entry__sort_list, list) {
@@ -213,7 +213,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 			se->se_snprintf(h, s, ARRAY_SIZE(s),
 					hists__col_len(hists, se->se_width_idx));
 
-			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 	}
 
-- 
1.7.11.7

