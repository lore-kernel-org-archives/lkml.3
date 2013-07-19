Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342Ab3GSHrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:47:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:47:49 -0400
Date: Fri, 19 Jul 2013 00:47:31 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-47390ae2afb6695c56810a9fc74fb930266addd0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370323231-14022-14-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-14-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Adopt latency_format variable
Git-Commit-ID: 47390ae2afb6695c56810a9fc74fb930266addd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:47:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47390ae2afb6695c56810a9fc74fb930266addd0
Gitweb:     http://git.kernel.org/tip/47390ae2afb6695c56810a9fc74fb930266addd0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:28 -0300

perf script: Adopt latency_format variable

It's the only user of the variable, so move it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-14-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c         | 1 +
 tools/perf/util/trace-event-parse.c | 2 --
 tools/perf/util/trace-event.h       | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 92d4658..3de8979 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -24,6 +24,7 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static bool			latency_format;
 static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0deae88..fe7a27d 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -28,8 +28,6 @@
 #include "util.h"
 #include "trace-event.h"
 
-bool latency_format;
-
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian)
 {
 	struct pevent *pevent = pevent_alloc();
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 761c484..ed30c9c 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -10,7 +10,6 @@ struct perf_sample;
 union perf_event;
 struct perf_tool;
 
-extern bool latency_format;
 extern struct pevent *perf_pevent;
 
 enum {
