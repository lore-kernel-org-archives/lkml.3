Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401Ab3GSHsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935322Ab3GSHsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:48:36 -0400
Date: Fri, 19 Jul 2013 00:48:18 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f1d9a530553eed9e598d1597a2a348f01810dd4a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370337737-30812-2-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/hists:
  Use GtkTreeStore instead of GtkListStore
Git-Commit-ID: f1d9a530553eed9e598d1597a2a348f01810dd4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:48:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1d9a530553eed9e598d1597a2a348f01810dd4a
Gitweb:     http://git.kernel.org/tip/f1d9a530553eed9e598d1597a2a348f01810dd4a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 18:22:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:36 -0300

perf gtk/hists: Use GtkTreeStore instead of GtkListStore

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
 
