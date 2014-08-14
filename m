Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaHNIuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:50:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaHNIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:49:59 -0400
Date: Thu, 14 Aug 2014 01:49:41 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-42337a222c93cd22864f20ef9b157765ab1086a0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1407831366-28892-2-git-send-email-namhyung@kernel.org>
References: <1407831366-28892-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Handle 'z'
  key for toggle zeroing samples in TUI
Git-Commit-ID: 42337a222c93cd22864f20ef9b157765ab1086a0
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

Commit-ID:  42337a222c93cd22864f20ef9b157765ab1086a0
Gitweb:     http://git.kernel.org/tip/42337a222c93cd22864f20ef9b157765ab1086a0
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 17:16:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 17:29:37 -0300

perf top: Handle 'z' key for toggle zeroing samples in TUI

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
index 1818d12..4892480 100644
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
