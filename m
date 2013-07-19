Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535Ab3GSHtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:49:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965303Ab3GSHtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:49:14 -0400
Date: Fri, 19 Jul 2013 00:48:56 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-450f390ad2538c5e35d830fa5c624708a77dce0a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370337737-30812-6-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/hists:
  Add a double-click handler for callchains
Git-Commit-ID: 450f390ad2538c5e35d830fa5c624708a77dce0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:49:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  450f390ad2538c5e35d830fa5c624708a77dce0a
Gitweb:     http://git.kernel.org/tip/450f390ad2538c5e35d830fa5c624708a77dce0a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 18:22:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:43 -0300

perf gtk/hists: Add a double-click handler for callchains

If callchain is displayed, add "row-activated" signal handler for
handling double-click or pressing ENTER key action.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370337737-30812-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index b4a0dd2..3a5d013 100644
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
 
