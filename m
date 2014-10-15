Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaJOKFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:05:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaJOKE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:04:58 -0400
Date: Wed, 15 Oct 2014 03:04:01 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-0rg7ji1jnbm6q6gj35j37jby@git.kernel.org>
Cc: dzickus@redhat.com, bp@suse.de, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        dsahern@gmail.com, jean.pihet@linaro.org, adrian.hunter@intel.com,
        jolsa@redhat.com, fweisbec@gmail.com, efault@gmx.de, acme@redhat.com,
        paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: fweisbec@gmail.com, jolsa@redhat.com, efault@gmx.de,
        dsahern@gmail.com, jean.pihet@linaro.org, adrian.hunter@intel.com,
        tglx@linutronix.de, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, eranian@google.com, hpa@zytor.com, dzickus@redhat.com,
        bp@suse.de, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Move the callchain_param extern to callchain.h
Git-Commit-ID: 8f651eae186f4dfb1740988623c83ba03dcf3a76
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

Commit-ID:  8f651eae186f4dfb1740988623c83ba03dcf3a76
Gitweb:     http://git.kernel.org/tip/8f651eae186f4dfb1740988623c83ba03dcf3a76
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Oct 2014 16:12:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:51 -0300

perf callchain: Move the callchain_param extern to callchain.h

It was lost in hist.h, move it to where it belongs, callchain.h, as
there are places that gets hist.h by means of evsel.h, and since evsel.h
is being untangled from hist.h...

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
Link: http://lkml.kernel.org/n/tip-0rg7ji1jnbm6q6gj35j37jby@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c                            | 1 +
 tools/perf/util/callchain.h                            | 2 ++
 tools/perf/util/evsel.c                                | 1 +
 tools/perf/util/hist.h                                 | 2 --
 tools/perf/util/scripting-engines/trace-event-python.c | 1 +
 5 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 44c6f3d..a6b2132 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/callchain.h"
 #include "util/header.h"
 #include "util/event.h"
 #include "util/evlist.h"
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2a1f5a4..94cfefd 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -65,6 +65,8 @@ struct callchain_param {
 	enum chain_key		key;
 };
 
+extern struct callchain_param callchain_param;
+
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0580b13..a083764 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,6 +15,7 @@
 #include <linux/perf_event.h>
 #include <sys/resource.h>
 #include "asm/bug.h"
+#include "callchain.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a039cd2..ebfc258 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -8,8 +8,6 @@
 #include "color.h"
 #include "ui/progress.h"
 
-extern struct callchain_param callchain_param;
-
 struct hist_entry;
 struct addr_location;
 struct symbol;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 56ba07c..496f21c 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -28,6 +28,7 @@
 
 #include "../../perf.h"
 #include "../debug.h"
+#include "../callchain.h"
 #include "../evsel.h"
 #include "../util.h"
 #include "../event.h"
