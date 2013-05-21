Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3EUGPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:15:13 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52766 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3EUGOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:45 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-8c-519b10d1cf6b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 6/7] perf gtk/hists: Add a double-click handler for hierarchy mode
Date: Tue, 21 May 2013 15:14:37 +0900
Message-Id: <1369116878-12489-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If hierarchy mode is enabled, add "row-activated" signal handler for
handling double-click or pressing ENTER key action.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index fb4b5ff00319..e161317236fe 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -220,6 +220,18 @@ static void perf_gtk__add_entries_hierarchy(struct hists *hists,
 	__perf_gtk__add_entries_hierarchy(hists, root, store, NULL, hpp, se);
 }
 
+static void on_row_activated(GtkTreeView *view, GtkTreePath *path,
+			     GtkTreeViewColumn *col __maybe_unused,
+			     gpointer user_data __maybe_unused)
+{
+	bool expanded = gtk_tree_view_row_expanded(view, path);
+
+	if (expanded)
+		gtk_tree_view_collapse_row(view, path);
+	else
+		gtk_tree_view_expand_row(view, path, FALSE);
+}
+
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 {
 	struct perf_hpp_fmt *fmt;
@@ -322,6 +334,9 @@ add:
 						  expander_col);
 
 		perf_gtk__add_entries_hierarchy(hists, &hpp, store);
+
+		g_signal_connect(view, "row-activated",
+				 G_CALLBACK(on_row_activated), NULL);
 	}
 
 	gtk_container_add(GTK_CONTAINER(window), view);
-- 
1.7.11.7

