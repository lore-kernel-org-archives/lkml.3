Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3BOQh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:37:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3BOQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:37:24 -0500
Date: Fri, 15 Feb 2013 08:35:48 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-c0e79be74907b4654b622601692e1a27fd1dbeb3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1360227734-375-7-git-send-email-namhyung@kernel.org>
References: <1360227734-375-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/annotate: Fail early if it can'
 t annotate
Git-Commit-ID: c0e79be74907b4654b622601692e1a27fd1dbeb3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:35:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0e79be74907b4654b622601692e1a27fd1dbeb3
Gitweb:     http://git.kernel.org/tip/c0e79be74907b4654b622601692e1a27fd1dbeb3
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 7 Feb 2013 18:02:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 14:59:28 -0300

perf gtk/annotate: Fail early if it can't annotate

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
