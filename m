Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBXIJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:09:46 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45829 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaBXIJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:09:44 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 7/8] perf ui/tui: Add 'F' hotkey to toggle percentage output
Date: Mon, 24 Feb 2014 17:09:27 +0900
Message-Id: <1393229368-31412-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'F' hotkey to toggle relative and absolute percentage of filtered
entries.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index c4251af43bd2..9818232e28ef 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1433,6 +1433,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"C             Collapse all callchains\n"			\
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
+	"F             Toggle percentage of filtered entries\n"		\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
@@ -1538,6 +1539,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
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

