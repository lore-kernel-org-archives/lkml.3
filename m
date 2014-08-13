Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaHMWxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:53:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:55485 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbaHMWur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:47 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/41] perf top: Handle 'z' key for toggle zeroing samples in TUI
Date: Wed, 13 Aug 2014 19:48:16 -0300
Message-Id: <1407970107-24540-31-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The perf top TUI lacks 'z' key support to toggle sample zeroing.
Add it.

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407831366-28892-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 1818d1275d02..4892480e8298 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -10,6 +10,7 @@
 #include "../../util/pstack.h"
 #include "../../util/sort.h"
 #include "../../util/util.h"
+#include "../../util/top.h"
 #include "../../arch/common.h"
 
 #include "../browser.h"
@@ -1532,6 +1533,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"P             Print histograms to perf.hist.N\n"
 	"t             Zoom into current Thread\n"
 	"V             Verbose (DSO names in callchains, etc)\n"
+	"z             Toggle zeroing of samples\n"
 	"/             Filter symbol by name";
 
 	if (browser == NULL)
@@ -1632,6 +1634,13 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
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
1.9.3

