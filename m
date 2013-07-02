Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3GBT1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:27:51 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41390 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3GBT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:27:44 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 5/6] perf test: make terms a stack variable in test_term
Date: Tue,  2 Jul 2013 13:27:24 -0600
Message-Id: <1372793245-4136-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to malloc the memory for it.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/parse-events.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index ad950f5..344c844 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1246,24 +1246,20 @@ static int test_events(struct evlist_test *events, unsigned cnt)
 
 static int test_term(struct terms_test *t)
 {
-	struct list_head *terms;
+	struct list_head terms;
 	int ret;
 
-	terms = malloc(sizeof(*terms));
-	if (!terms)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(terms);
+	INIT_LIST_HEAD(&terms);
 
-	ret = parse_events_terms(terms, t->str);
+	ret = parse_events_terms(&terms, t->str);
 	if (ret) {
 		pr_debug("failed to parse terms '%s', err %d\n",
 			 t->str , ret);
 		return ret;
 	}
 
-	ret = t->check(terms);
-	parse_events__free_terms(terms);
+	ret = t->check(&terms);
+	parse_events__free_terms(&terms);
 
 	return ret;
 }
-- 
1.7.10.1

