Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3BGJCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:02:49 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45999 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3BGJCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:02:41 -0500
X-AuditID: 9c930179-b7c24ae00000119c-0c-51136da7f257
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 6/7] perf gtk/annotate: Fail early if it can't annotate
Date: Thu,  7 Feb 2013 18:02:13 +0900
Message-Id: <1360227734-375-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360227734-375-1-git-send-email-namhyung@kernel.org>
References: <1360227734-375-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Don't need to setup a browser window if annotate cannot work.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/annotate.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 2fe056b0096c..7d8dc581a545 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -97,14 +97,6 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 	int i;
 	char s[512];
 
-	if (map->dso->annotate_warned)
-		return -1;
-
-	if (symbol__annotate(sym, map, 0) < 0) {
-		ui__error("%s", ui_helpline__current);
-		return -1;
-	}
-
 	notes = symbol__annotation(sym);
 
 	for (i = 0; i < MAX_ANN_COLS; i++) {
@@ -155,6 +147,14 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 	GtkWidget *scrolled_window;
 	GtkWidget *tab_label;
 
+	if (map->dso->annotate_warned)
+		return -1;
+
+	if (symbol__annotate(sym, map, 0) < 0) {
+		ui__error("%s", ui_helpline__current);
+		return -1;
+	}
+
 	if (perf_gtk__is_active_context(pgctx)) {
 		window = pgctx->main_window;
 		notebook = pgctx->notebook;
-- 
1.7.11.7

