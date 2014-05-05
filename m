Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaEEMeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:34:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaEEMeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:12 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/10] perf tools: Move perf_call_graph_mode enum from perf.h
Date: Mon,  5 May 2014 14:33:36 +0200
Message-Id: <1399293219-8732-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Into util/callchain.h header where all callchain related
structures should be.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h           | 7 -------
 tools/perf/util/callchain.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index cf8f228..d51a994 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -222,13 +222,6 @@ void pthread__unblock_sigwinch(void);
 
 #include "util/target.h"
 
-enum perf_call_graph_mode {
-	CALLCHAIN_NONE,
-	CALLCHAIN_FP,
-	CALLCHAIN_DWARF,
-	CALLCHAIN_MAX
-};
-
 struct record_opts {
 	struct target target;
 	int	     call_graph;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index dda4cf8..bde2b0c 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -7,6 +7,13 @@
 #include "event.h"
 #include "symbol.h"
 
+enum perf_call_graph_mode {
+	CALLCHAIN_NONE,
+	CALLCHAIN_FP,
+	CALLCHAIN_DWARF,
+	CALLCHAIN_MAX
+};
+
 enum chain_mode {
 	CHAIN_NONE,
 	CHAIN_FLAT,
-- 
1.8.3.1

