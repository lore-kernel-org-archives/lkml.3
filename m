Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147Ab3E3QDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:03:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50884 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934482Ab3E3QCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/66] perf hists browser: Use sort__has_sym
Date: Thu, 30 May 2013 19:00:46 +0300
Message-Id: <1369929699-8724-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The TUI hist browser had a similar variable has_symbols for the same
purpose.  Let's get rid of the duplication.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1365125198-8334-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cad8e37..a4268ca 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -25,7 +25,6 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	int		     print_seq;
 	bool		     show_dso;
-	bool		     has_symbols;
 };
 
 extern void hist_browser__init_hpp(void);
@@ -1155,10 +1154,6 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh = hist_browser__refresh;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		if (sort__mode == SORT_MODE__BRANCH)
-			browser->has_symbols = sort_sym_from.list.next != NULL;
-		else
-			browser->has_symbols = sort_sym.list.next != NULL;
 	}
 
 	return browser;
@@ -1386,7 +1381,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			 */
 			goto out_free_stack;
 		case 'a':
-			if (!browser->has_symbols) {
+			if (!sort__has_sym) {
 				ui_browser__warning(&browser->b, delay_secs * 2,
 			"Annotation is only available for symbolic views, "
 			"include \"sym*\" in --sort to use it.");
@@ -1485,7 +1480,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			continue;
 		}
 
-		if (!browser->has_symbols)
+		if (!sort__has_sym)
 			goto add_exit_option;
 
 		if (sort__mode == SORT_MODE__BRANCH) {
-- 
1.8.1.4

