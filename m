Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3LTTRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:17:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3LTTQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:16:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/35] perf report: Print session information only if --stdio is given
Date: Fri, 20 Dec 2013 16:09:09 -0300
Message-Id: <1387566550-3524-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Move those print functions under "if (use_browser == 0)" so that they
don't interfere with TUI output.

Maybe they can handle other UIs later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1387516278-17024-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0c9ec3e3f0fc..bf8dd2e893e4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -469,15 +469,17 @@ static int __cmd_report(struct report *rep)
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
1.8.1.4

