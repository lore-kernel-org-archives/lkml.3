Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3LTFLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:11:23 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61586 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3LTFLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:11:22 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-41-52b3d178fea2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/7] perf report: Print session information only if --stdio is given
Date: Fri, 20 Dec 2013 14:11:13 +0900
Message-Id: <1387516278-17024-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Move those print functions under "if (use_browser == 0)" so that they
cannot interfere TUI output.  Maybe they can handle other UIs later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dcaab5e0bfa7..1a120da6b2cd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -482,15 +482,17 @@ static int __cmd_report(struct perf_report *rep)
 		desc);
 	}
 
-	if (verbose > 3)
-		perf_session__fprintf(session, stdout);
+	if (use_browser == 0) {
+		if (verbose > 3)
+			perf_session__fprintf(session, stdout);
 
-	if (verbose > 2)
-		perf_session__fprintf_dsos(session, stdout);
+		if (verbose > 2)
+			perf_session__fprintf_dsos(session, stdout);
 
-	if (dump_trace) {
-		perf_session__fprintf_nr_events(session, stdout);
-		return 0;
+		if (dump_trace) {
+			perf_session__fprintf_nr_events(session, stdout);
+			return 0;
+		}
 	}
 
 	nr_samples = 0;
-- 
1.7.11.7

