Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbaFCUia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863AbaFCUgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:45 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/9] perf tools: Remove elide setup for SORT_MODE__MEMORY mode
Date: Tue,  3 Jun 2014 22:36:13 +0200
Message-Id: <1401827776-4443-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to setup elide of sort_dso sort entry again
with symbol_conf.dso_list list.

The only difference were list names of memory mode data,
which does not make much sense to me.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1400858147-7155-2-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 254f583..2aba620 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1412,19 +1412,6 @@ void sort__setup_elide(FILE *output)
 		sort_entry__setup_elide(&sort_sym_to,
 					symbol_conf.sym_to_list,
 					"sym_to", output);
-	} else if (sort__mode == SORT_MODE__MEMORY) {
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"symbol_daddr", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"dso_daddr", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"mem", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"local_weight", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"tlb", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"snoop", output);
 	}
 
 	/*
-- 
1.8.3.1

