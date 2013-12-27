Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3L0Uu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:50:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35698 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3L0UrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 45/49] perf ui/tui: Split help message for perf top and report
Date: Fri, 27 Dec 2013 17:47:01 -0300
Message-Id: <1388177225-17349-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some hotkeys don't work for perf top so split help messages for them.

It'll be helpful to a future modification.  Also sort the message by
alphabetical order of the hotkey.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1388036284-32342-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 49 ++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a440e03cd8c2..d43ec79ea4e3 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1400,6 +1400,35 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char script_opt[64];
 	int delay_secs = hbt ? hbt->refresh : 0;
 
+#define HIST_BROWSER_HELP_COMMON					\
+	"h/?/F1        Show this window\n"				\
+	"UP/DOWN/PGUP\n"						\
+	"PGDN/SPACE    Navigate\n"					\
+	"q/ESC/CTRL+C  Exit browser\n\n"				\
+	"For multiple event sessions:\n\n"				\
+	"TAB/UNTAB     Switch events\n\n"				\
+	"For symbolic views (--sort has sym):\n\n"			\
+	"->            Zoom into DSO/Threads & Annotate current symbol\n" \
+	"<-            Zoom out\n"					\
+	"a             Annotate current symbol\n"			\
+	"C             Collapse all callchains\n"			\
+	"d             Zoom into current DSO\n"				\
+	"E             Expand all callchains\n"				\
+
+	/* help messages are sorted by lexical order of the hotkey */
+	const char report_help[] = HIST_BROWSER_HELP_COMMON
+	"P             Print histograms to perf.hist.N\n"
+	"r             Run available scripts\n"
+	"s             Switch to another data file in PWD\n"
+	"t             Zoom into current Thread\n"
+	"V             Verbose (DSO names in callchains, etc)\n"
+	"/             Filter symbol by name";
+	const char top_help[] = HIST_BROWSER_HELP_COMMON
+	"P             Print histograms to perf.hist.N\n"
+	"t             Zoom into current Thread\n"
+	"V             Verbose (DSO names in callchains, etc)\n"
+	"/             Filter symbol by name";
+
 	if (browser == NULL)
 		return -1;
 
@@ -1488,25 +1517,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case 'h':
 		case '?':
 			ui_browser__help_window(&browser->b,
-					"h/?/F1        Show this window\n"
-					"UP/DOWN/PGUP\n"
-					"PGDN/SPACE    Navigate\n"
-					"q/ESC/CTRL+C  Exit browser\n\n"
-					"For multiple event sessions:\n\n"
-					"TAB/UNTAB Switch events\n\n"
-					"For symbolic views (--sort has sym):\n\n"
-					"->            Zoom into DSO/Threads & Annotate current symbol\n"
-					"<-            Zoom out\n"
-					"a             Annotate current symbol\n"
-					"C             Collapse all callchains\n"
-					"E             Expand all callchains\n"
-					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread\n"
-					"r             Run available scripts('perf report' only)\n"
-					"s             Switch to another data file in PWD ('perf report' only)\n"
-					"P             Print histograms to perf.hist.N\n"
-					"V             Verbose (DSO names in callchains, etc)\n"
-					"/             Filter symbol by name");
+				is_report_browser(hbt) ? report_help : top_help);
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
-- 
1.8.1.4

