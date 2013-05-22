Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3EVI2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:28:07 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48267 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3EVI1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:27:45 -0400
X-AuditID: 9c93017e-b7c8fae000000f00-19-519c817cda13
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 4/5] perf gtk/hists: Add a double-click handler for callchains
Date: Wed, 22 May 2013 17:27:37 +0900
Message-Id: <1369211258-3163-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If callchain is displayed, add "row-activated" signal handler for
handling double-click or pressing ENTER key action.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 34a09c09748c..4e96f7a9f6d1 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -175,6 +175,18 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
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
@@ -315,6 +327,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		}
 	}
 
+	g_signal_connect(view, "row-activated",
+			 G_CALLBACK(on_row_activated), NULL);
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
 
-- 
1.7.11.7

