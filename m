Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3EaL22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:28:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaL2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:28:21 -0400
Date: Fri, 31 May 2013 04:28:03 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-9c796ec8dbc8dbfe41ce35a1ccb1b59b47148daf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1365125198-8334-9-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Use sort__has_sym
Git-Commit-ID: 9c796ec8dbc8dbfe41ce35a1ccb1b59b47148daf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c796ec8dbc8dbfe41ce35a1ccb1b59b47148daf
Gitweb:     http://git.kernel.org/tip/9c796ec8dbc8dbfe41ce35a1ccb1b59b47148daf
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 26 Apr 2013 14:28:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:56 +0300

perf hists browser: Use sort__has_sym

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
