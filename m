Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3DEB1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:27:04 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50216 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3DEB0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:26:47 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-18-515e2853029d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 8/8] perf hist browser: Use sort__has_sym
Date: Fri,  5 Apr 2013 10:26:38 +0900
Message-Id: <1365125198-8334-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The TUI hist browser had a similar variable has_symbols for the same
purpose.  Let's get rid of the duplication.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cad8e37f05d9..a4268cab1921 100644
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
1.7.11.7

