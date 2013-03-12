Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3CLE7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:59:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45867 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3CLE7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:59:33 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-3e-513eb6332179
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf trace: Get rid of a duplicate code
Date: Tue, 12 Mar 2013 13:59:20 +0900
Message-Id: <1363064360-7641-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Checking of sample.raw_data is duplicated and seems an artifact of
some git auto merging stuff.  Kill it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-trace.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f0c20ef0cd1c..49fedb51d569 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -527,13 +527,6 @@ again:
 				continue;
 			}
 
-			if (sample.raw_data == NULL) {
-				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
-				       perf_evsel__name(evsel), sample.tid,
-				       sample.cpu, sample.raw_size);
-				continue;
-			}
-
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
-- 
1.7.11.7

