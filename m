Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaJRHII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 03:08:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51674 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaJRHHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 03:07:52 -0400
Date: Sat, 18 Oct 2014 00:07:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-b7kuymbgf0zxi5viyjjtu5hk@git.kernel.org>
Cc: peterz@infradead.org, efault@gmx.de, mingo@kernel.org, bp@suse.de,
        adrian.hunter@intel.com, dzickus@redhat.com, tglx@linutronix.de,
        dsahern@gmail.com, jean.pihet@linaro.org, paulus@samba.org,
        hpa@zytor.com, eranian@google.com, fweisbec@gmail.com,
        jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com
Reply-To: peterz@infradead.org, efault@gmx.de, dsahern@gmail.com, bp@suse.de,
        mingo@kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        adrian.hunter@intel.com, fweisbec@gmail.com, eranian@google.com,
        hpa@zytor.com, jean.pihet@linaro.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, namhyung@kernel.org,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: No need to drag util/cgroup.h
Git-Commit-ID: f14d570785e6760284a9849f9bafd0a9825a1a25
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

Commit-ID:  f14d570785e6760284a9849f9bafd0a9825a1a25
Gitweb:     http://git.kernel.org/tip/f14d570785e6760284a9849f9bafd0a9825a1a25
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 17 Oct 2014 12:17:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Oct 2014 12:17:40 -0300

perf evsel: No need to drag util/cgroup.h

The only thing we need is a forward declaration for 'struct cgroup_sel',
that is inside 'struct perf_evsel'.

Include cgroup.h instead on the tools that support cgroups.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-b7kuymbgf0zxi5viyjjtu5hk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 1 +
 tools/perf/builtin-stat.c   | 1 +
 tools/perf/util/evsel.c     | 1 +
 tools/perf/util/evsel.h     | 3 ++-
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a6b2132..2583a9b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -15,6 +15,7 @@
 #include "util/parse-events.h"
 
 #include "util/callchain.h"
+#include "util/cgroup.h"
 #include "util/header.h"
 #include "util/event.h"
 #include "util/evlist.h"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b22c62f..055ce92 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 
 #include "perf.h"
 #include "builtin.h"
+#include "util/cgroup.h"
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 786ea55..2f9e680 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,6 +16,7 @@
 #include <sys/resource.h>
 #include "asm/bug.h"
 #include "callchain.h"
+#include "cgroup.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 1d5c754..163c560 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -7,7 +7,6 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 #include "xyarray.h"
-#include "cgroup.h"
 #include "symbol.h"
 
 struct perf_counts_values {
@@ -42,6 +41,8 @@ struct perf_sample_id {
 	u64			period;
 };
 
+struct cgroup_sel;
+
 /** struct perf_evsel - event selector
  *
  * @name - Can be set to retain the original event name passed by the user,
