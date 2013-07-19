Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057Ab3GSHpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934572Ab3GSHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:45:47 -0400
Date: Fri, 19 Jul 2013 00:45:12 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-c549aca50134640537bf0fbae43c08fd5ff91932@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1372793245-4136-6-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-6-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Make terms a stack variable in test_term
Git-Commit-ID: c549aca50134640537bf0fbae43c08fd5ff91932
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:45:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c549aca50134640537bf0fbae43c08fd5ff91932
Gitweb:     http://git.kernel.org/tip/c549aca50134640537bf0fbae43c08fd5ff91932
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 2 Jul 2013 13:27:24 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:17 -0300

perf tests: Make terms a stack variable in test_term

No need to malloc the memory for it.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1372793245-4136-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 14 +++++---------
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
