Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBCLpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:45:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbaBCLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:45:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 3/3] perf tools: Add readable output for callchain debug
Date: Mon,  3 Feb 2014 12:44:43 +0100
Message-Id: <1391427883-13443-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
References: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding people readable output for callchain debug,
to get following '-v' output:

  $ perf record -v -g ls
  callchain: type DWARF
  callchain: stack dump size 4096
  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 4 +++-
 tools/perf/perf.h           | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3f7ec8a..679758f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -741,7 +741,9 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 
 static void callchain_debug(struct record_opts *opts)
 {
-	pr_debug("callchain: type %d\n", opts->call_graph);
+	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
+
+	pr_debug("callchain: type %s\n", str[opts->call_graph]);
 
 	if (opts->call_graph == CALLCHAIN_DWARF)
 		pr_debug("callchain: stack dump size %d\n",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 6dabc15..c30e1ae 100644
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
1.8.3.1

