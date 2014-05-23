Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaEWPQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaEWPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:16:03 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: Remove elide setup for SORT_MODE__MEMORY mode
Date: Fri, 23 May 2014 17:15:46 +0200
Message-Id: <1400858147-7155-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
References: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to setup elide of sort_dso sort entry again
with symbol_conf.dso_list list.

The only difference were list names of memory mode data,
which does not make much sense to me.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 901b9be..a1a5ba3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1411,19 +1411,6 @@ void sort__setup_elide(FILE *output)
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

