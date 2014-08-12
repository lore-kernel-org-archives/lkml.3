Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaHLIQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:16:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56223 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbaHLIQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:16:09 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf top: Handle 'z' key for toggle zeroing samples in TUI
Date: Tue, 12 Aug 2014 17:16:06 +0900
Message-Id: <1407831366-28892-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf top TUI lacks 'z' key support to toggle sample zeroing.
Add it.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 045c1e16ac59..381c085a41b8 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -10,6 +10,7 @@
 #include "../../util/pstack.h"
 #include "../../util/sort.h"
 #include "../../util/util.h"
+#include "../../util/top.h"
 #include "../../arch/common.h"
 
 #include "../browser.h"
@@ -1530,6 +1531,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"P             Print histograms to perf.hist.N\n"
 	"t             Zoom into current Thread\n"
 	"V             Verbose (DSO names in callchains, etc)\n"
+	"z             Toggle zeroing of samples\n"
 	"/             Filter symbol by name";
 
 	if (browser == NULL)
@@ -1630,6 +1632,13 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case 'F':
 			symbol_conf.filter_relative ^= 1;
 			continue;
+		case 'z':
+			if (!is_report_browser(hbt)) {
+				struct perf_top *top = hbt->arg;
+
+				top->zero = !top->zero;
+			}
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
-- 
2.0.0

