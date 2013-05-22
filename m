Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3EVIhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:37:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58689 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3EVIh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:37:29 -0400
X-AuditID: 9c930179-b7c07ae000000e33-2e-519c83c66483
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH v2 5/5] perf gtk/hists: Make column headers resizable
Date: Wed, 22 May 2013 17:37:12 +0900
Message-Id: <1369211832-3642-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369211258-3163-6-git-send-email-namhyung@kernel.org>
References: <1369211258-3163-6-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes it's annoying to see when some symbols have very wierd long
names.  So it might be a good idea to make column size changable.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
There was a warning when callchains were not used.

 tools/perf/ui/gtk/hists.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 4e96f7a9f6d1..00f718094978 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -327,6 +327,13 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		}
 	}
 
+	for (col_idx = 0; col_idx < nr_cols; col_idx++) {
+		GtkTreeViewColumn *column;
+
+		column = gtk_tree_view_get_column(GTK_TREE_VIEW(view), col_idx);
+		gtk_tree_view_column_set_resizable(column, TRUE);
+	}
+
 	g_signal_connect(view, "row-activated",
 			 G_CALLBACK(on_row_activated), NULL);
 	gtk_container_add(GTK_CONTAINER(window), view);
-- 
1.7.11.7

