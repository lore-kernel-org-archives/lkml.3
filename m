Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaEERuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:50:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53146 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaEERuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:50:00 -0400
Date: Mon, 5 May 2014 10:48:59 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0776eb59354f8b848e5738a612c272d8f48de9bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-7-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-7-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move sample data structures from perf.h
Git-Commit-ID: 0776eb59354f8b848e5738a612c272d8f48de9bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0776eb59354f8b848e5738a612c272d8f48de9bf
Gitweb:     http://git.kernel.org/tip/0776eb59354f8b848e5738a612c272d8f48de9bf
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:41:45 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:47:40 +0200

perf tools: Move sample data structures from perf.h

Into util/event.h header where all sample data structures
are defined.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-7-git-send-email-jolsa@kernel.org
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
