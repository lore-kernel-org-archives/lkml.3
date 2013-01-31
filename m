Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3AaRaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:30:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3AaRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/25] perf gtk/browser: Trim column header string when event group enabled
Date: Thu, 31 Jan 2013 14:25:18 -0300
Message-Id: <1359653128-10433-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When event group feature is enabled, each column header is expanded to
match with the whole group column width.  But this is not needed for
GTK+ browser since ti usually use variable-width fonts.  So trim it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-15-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index c87a98c..caa554b 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -170,7 +170,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 		fmt->header(&hpp);
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, s,
+							    -1, ltrim(s),
 							    renderer, "markup",
 							    col_idx++, NULL);
 	}
-- 
1.8.1.1.361.gec3ae6e

