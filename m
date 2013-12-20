Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3LTTVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:21:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3LTTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/35] perf annotate: Make symbol__inc_addr_samples private
Date: Fri, 20 Dec 2013 16:08:45 -0300
Message-Id: <1387566550-3524-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since it is now accessed just thru addr_map_symbol and hist_entry
wrappers.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gjoam7wcfrb03sp753gk1nfk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 4 ++--
 tools/perf/util/annotate.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 91e25269bb27..27ab7b59dbf4 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -486,8 +486,8 @@ static int __symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	return 0;
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
-			     int evidx, u64 addr)
+static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
+				    int evidx, u64 addr)
 {
 	struct annotation *notes;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 43727a9b93cd..b2aef59d6bb2 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -132,9 +132,6 @@ static inline struct annotation *symbol__annotation(struct symbol *sym)
 	return &a->annotation;
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
-			     int evidx, u64 addr);
-
 int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx);
 
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 addr);
-- 
1.8.1.4

