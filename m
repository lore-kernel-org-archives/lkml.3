Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaCCBO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:14:29 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60797 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCCBO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:14:26 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-fa-5313d76fa3a7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 12/13] perf ui/tui: Add 'F' hotkey to toggle percentage output
Date: Mon,  3 Mar 2014 10:14:13 +0900
Message-Id: <1393809254-4480-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'F' hotkey to toggle relative and absolute percentage of filtered
entries.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index bf6cc9f2a059..756621b52493 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1389,6 +1389,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"C             Collapse all callchains\n"			\
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
+	"F             Toggle percentage of filtered entries\n"		\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
@@ -1494,6 +1495,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (env->arch)
 				tui__header_window(env);
 			continue;
+		case 'F':
+			symbol_conf.filter_relative ^= 1;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
-- 
1.7.11.7

