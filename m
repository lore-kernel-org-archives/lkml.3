Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab3HHL0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:26:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:35773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965259Ab3HHL0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,838,1367996400"; 
   d="scan'208";a="383802886"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4/8] perf mem: remove unused symbol filter member
Date: Thu,  8 Aug 2013 14:32:23 +0300
Message-Id: <1375961547-30267-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Member 'annotate_init' of struct perf_mem is unused.
Remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-mem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index a8ff6d2..f96168c 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -14,7 +14,6 @@ static const char	*mem_operation		= MEM_OPERATION_LOAD;
 struct perf_mem {
 	struct perf_tool	tool;
 	char const		*input_name;
-	symbol_filter_t		annotate_init;
 	bool			hide_unresolved;
 	bool			dump_raw;
 	const char		*cpu_list;
@@ -70,7 +69,7 @@ dump_raw_samples(struct perf_tool *tool,
 	const char *fmt;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
-				mem->annotate_init) < 0) {
+				NULL) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
 		return -1;
-- 
1.7.11.7

