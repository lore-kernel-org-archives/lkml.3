Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3KAPxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3KAPxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:53:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Allow multiple cpus record for -p option
Date: Fri,  1 Nov 2013 16:52:45 +0100
Message-Id: <1383321165-25252-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't create default CPU map for task related
target, like:

  $ perf record -p <pid>

This makes record command to disable inherited events.
which is not desired behaviour (we have special option
for that (-i) anyway).

Fixing this by creating default CPU map for task related
processes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0582f67..52bb127 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -804,7 +804,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 		return -1;
 
 	if (perf_target__has_task(target))
-		evlist->cpus = cpu_map__dummy_new();
+		evlist->cpus = cpu_map__new(target->cpu_list);
 	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
 	else
-- 
1.7.11.7

