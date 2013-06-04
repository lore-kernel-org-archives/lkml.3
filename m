Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3FDJXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:23:01 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59281 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3FDJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:22:22 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-e5-51adb1ca9087
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/6] perf gtk/hists: Add a double-click handler for callchains
Date: Tue,  4 Jun 2013 18:22:16 +0900
Message-Id: <1370337737-30812-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If callchain is displayed, add "row-activated" signal handler for
handling double-click or pressing ENTER key action.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index b4a0dd2404a2..3a5d01319988 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -187,6 +187,18 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 	}
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
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 				 float min_pcnt)
 {
@@ -314,6 +326,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		}
 	}
 
+	g_signal_connect(view, "row-activated",
+			 G_CALLBACK(on_row_activated), NULL);
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
 
-- 
1.7.11.7

