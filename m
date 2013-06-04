Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3FDJW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:22:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44362 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FDJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:22:22 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-e6-51adb1ca4a42
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/6] perf gtk/hists: Set rules hint for the hist browser
Date: Tue,  4 Jun 2013 18:22:17 +0900
Message-Id: <1370337737-30812-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The 'rules' means that every second line of the tree view has a shaded
background, which makes it easier to see which cell belongs to which
row in the tree view.  It can be useful for a tree view that has a lot
of rows.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 3a5d01319988..32549035f50d 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -326,6 +326,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		}
 	}
 
+	gtk_tree_view_set_rules_hint(GTK_TREE_VIEW(view), TRUE);
+
 	g_signal_connect(view, "row-activated",
 			 G_CALLBACK(on_row_activated), NULL);
 	gtk_container_add(GTK_CONTAINER(window), view);
-- 
1.7.11.7

