Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161092AbaDPSql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbaDPSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:41:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/11] perf ui/tui: Add 'F' hotkey to toggle percentage output
Date: Wed, 16 Apr 2014 20:41:34 +0200
Message-Id: <1397673699-25824-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
References: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Add 'F' hotkey to toggle relative and absolute percentage of filtered
entries.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397145720-8063-7-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7ad1147..4d41698 100644
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
1.8.3.1

