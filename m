Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FDJWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:22:23 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44362 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3FDJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:22:21 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-e4-51adb1cad5a7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/6] perf gtk/hists: Make column headers resizable
Date: Tue,  4 Jun 2013 18:22:15 +0900
Message-Id: <1370337737-30812-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes it's annoying to see when some symbols have very wierd long
names.  So it might be a good idea to make column size changable.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index fa9f8a09233e..b4a0dd2404a2 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -250,11 +250,16 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
-	if (symbol_conf.use_callchain && sort__has_sym) {
+	for (col_idx = 0; col_idx < nr_cols; col_idx++) {
 		GtkTreeViewColumn *column;
 
-		column = gtk_tree_view_get_column(GTK_TREE_VIEW(view), sym_col);
-		gtk_tree_view_set_expander_column(GTK_TREE_VIEW(view), column);
+		column = gtk_tree_view_get_column(GTK_TREE_VIEW(view), col_idx);
+		gtk_tree_view_column_set_resizable(column, TRUE);
+
+		if (col_idx == sym_col) {
+			gtk_tree_view_set_expander_column(GTK_TREE_VIEW(view),
+							  column);
+		}
 	}
 
 	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
-- 
1.7.11.7

