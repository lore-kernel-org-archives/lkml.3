Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3COFs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:48:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61292 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3COFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:48:56 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-d9-5142b646347e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/6] perf evsel: Cleanup perf_evsel__exit()
Date: Fri, 15 Mar 2013 14:48:49 +0900
Message-Id: <1363326533-3310-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use perf_evsel__free_* because they do the same thing and ensures the
pointer has NULL value at the end.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dc16231f7a5d..7fde9fb79966 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -673,9 +673,8 @@ void perf_evsel__free_counts(struct perf_evsel *evsel)
 void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
-	xyarray__delete(evsel->fd);
-	xyarray__delete(evsel->sample_id);
-	free(evsel->id);
+	perf_evsel__free_fd(evsel);
+	perf_evsel__free_id(evsel);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
-- 
1.7.11.7

