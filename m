Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaALSkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaALSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:40:00 -0500
Date: Sun, 12 Jan 2014 10:39:43 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e8e684a58b9bddde3fdb1a65cd26eb7a3e1e746e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1388036284-32342-3-git-send-email-namhyung@kernel.org>
References: <1388036284-32342-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/tui:
  Split help message for perf top and report
Git-Commit-ID: e8e684a58b9bddde3fdb1a65cd26eb7a3e1e746e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:39:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8e684a58b9bddde3fdb1a65cd26eb7a3e1e746e
Gitweb:     http://git.kernel.org/tip/e8e684a58b9bddde3fdb1a65cd26eb7a3e1e746e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Dec 2013 14:37:58 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Dec 2013 11:22:02 -0300

perf ui/tui: Split help message for perf top and report

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
index a440e03..d43ec79 100644
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
