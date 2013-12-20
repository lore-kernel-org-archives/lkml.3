Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3LTFNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:13:31 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50330 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3LTFLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:11:21 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-3f-52b3d1784d2b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/7] perf report: Use pr_*() functions if possible
Date: Fri, 20 Dec 2013 14:11:12 +0900
Message-Id: <1387516278-17024-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There're some places printing a message to stdout/err directly.  It
should be converted to use proper error printing functions instead.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8424053b399a..dcaab5e0bfa7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -251,8 +251,8 @@ static int process_sample_event(struct perf_tool *tool,
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
-		fprintf(stderr, "problem processing %d event, skipping it.\n",
-			event->header.type);
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
 		return -1;
 	}
 
@@ -650,7 +650,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		return -1;
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
-		fprintf(stderr, "Can't register callchain params\n");
+		pr_err("Can't register callchain params\n");
 		return -1;
 	}
 	return 0;
@@ -872,7 +872,7 @@ repeat:
 	}
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
-			fprintf(stderr, "branch and mem mode incompatible\n");
+			pr_err("branch and mem mode incompatible\n");
 			goto error;
 		}
 		sort__mode = SORT_MODE__MEMORY;
-- 
1.7.11.7

