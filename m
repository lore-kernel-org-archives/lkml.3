Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaDRKcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaDRKcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:32:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/5] perf tools: Fix pmu object compilation error
Date: Fri, 18 Apr 2014 12:31:55 +0200
Message-Id: <1397817119-15195-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
References: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying some patches got another shadowing error:

  CC       util/pmu.o
util/pmu.c: In function ‘pmu_alias_terms’:
util/pmu.c:287:35: error: declaration of ‘clone’ shadows a global declaration [-Werror=shadow]

Renaming clone to cloned.

Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397674818-27054-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 00a7dcb..7a811eb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -284,17 +284,17 @@ static int pmu_aliases(const char *name, struct list_head *head)
 static int pmu_alias_terms(struct perf_pmu_alias *alias,
 			   struct list_head *terms)
 {
-	struct parse_events_term *term, *clone;
+	struct parse_events_term *term, *cloned;
 	LIST_HEAD(list);
 	int ret;
 
 	list_for_each_entry(term, &alias->terms, list) {
-		ret = parse_events_term__clone(&clone, term);
+		ret = parse_events_term__clone(&cloned, term);
 		if (ret) {
 			parse_events__free_terms(&list);
 			return ret;
 		}
-		list_add_tail(&clone->list, &list);
+		list_add_tail(&cloned->list, &list);
 	}
 	list_splice(&list, terms);
 	return 0;
-- 
1.8.3.1

