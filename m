Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBRVJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:09:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBRVJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/32] perf record: Add readable output for callchain debug
Date: Tue, 18 Feb 2014 18:08:26 -0300
Message-Id: <1392757731-32619-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding people readable output for callchain debug, to get following '-v'
output:

  $ perf record -v -g ls
  callchain: type DWARF
  callchain: stack dump size 4096
  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391427883-13443-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 4 +++-
 tools/perf/perf.h           | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be9e8bc0c4aa..7b8f0e6068b3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -735,7 +735,9 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 
 static void callchain_debug(struct record_opts *opts)
 {
-	pr_debug("callchain: type %d\n", opts->call_graph);
+	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
+
+	pr_debug("callchain: type %s\n", str[opts->call_graph]);
 
 	if (opts->call_graph == CALLCHAIN_DWARF)
 		pr_debug("callchain: stack dump size %d\n",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2078f334617c..6898ad0e199f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -251,7 +251,8 @@ void pthread__unblock_sigwinch(void);
 enum perf_call_graph_mode {
 	CALLCHAIN_NONE,
 	CALLCHAIN_FP,
-	CALLCHAIN_DWARF
+	CALLCHAIN_DWARF,
+	CALLCHAIN_MAX
 };
 
 struct record_opts {
-- 
1.8.1.4

