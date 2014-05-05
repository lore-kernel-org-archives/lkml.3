Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaEEMf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbaEEMeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:09 -0400
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
Subject: [PATCH 06/10] perf tools: Move sample data structures from perf.h
Date: Mon,  5 May 2014 14:33:35 +0200
Message-Id: <1399293219-8732-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Into util/event.h header where all sample data structures
are defined.

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
 tools/perf/perf.h        | 24 ------------------------
 tools/perf/util/event.h  | 24 ++++++++++++++++++++++++
 tools/perf/util/symbol.h |  1 +
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 1bf9537..cf8f228 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -214,30 +214,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 
 #define MAX_NR_CPUS			256
 
-struct ip_callchain {
-	u64 nr;
-	u64 ips[0];
-};
-
-struct branch_flags {
-	u64 mispred:1;
-	u64 predicted:1;
-	u64 in_tx:1;
-	u64 abort:1;
-	u64 reserved:60;
-};
-
-struct branch_entry {
-	u64				from;
-	u64				to;
-	struct branch_flags flags;
-};
-
-struct branch_stack {
-	u64				nr;
-	struct branch_entry	entries[0];
-};
-
 extern const char *input_name;
 extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 38457d4..d970232 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -112,6 +112,30 @@ struct sample_read {
 	};
 };
 
+struct ip_callchain {
+	u64 nr;
+	u64 ips[0];
+};
+
+struct branch_flags {
+	u64 mispred:1;
+	u64 predicted:1;
+	u64 in_tx:1;
+	u64 abort:1;
+	u64 reserved:60;
+};
+
+struct branch_entry {
+	u64			from;
+	u64			to;
+	struct branch_flags	flags;
+};
+
+struct branch_stack {
+	u64			nr;
+	struct branch_entry	entries[0];
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ae94e00..33ede53 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,6 +12,7 @@
 #include <byteswap.h>
 #include <libgen.h>
 #include "build-id.h"
+#include "event.h"
 
 #ifdef HAVE_LIBELF_SUPPORT
 #include <libelf.h>
-- 
1.8.3.1

