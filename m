Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285Ab3BNVqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:46:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57483 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994Ab3BNVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf gtk/annotate: Fail early if it can't annotate
Date: Thu, 14 Feb 2013 18:44:19 -0300
Message-Id: <1360878263-12694-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Don't need to setup a browser window if annotate cannot work.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/annotate.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 2fe056b..7d8dc58 100644
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
1.8.1.1.361.gec3ae6e

