Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329Ab3GSHro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:47:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:47:40 -0400
Date: Fri, 19 Jul 2013 00:47:21 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9515b2eb7670a98fb9bdd8ceeefeea6ffb9f53fc@git.kernel.org>
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
In-Reply-To: <1370323231-14022-13-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util:
  Get rid of unused header_page_* variables
Git-Commit-ID: 9515b2eb7670a98fb9bdd8ceeefeea6ffb9f53fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:47:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9515b2eb7670a98fb9bdd8ceeefeea6ffb9f53fc
Gitweb:     http://git.kernel.org/tip/9515b2eb7670a98fb9bdd8ceeefeea6ffb9f53fc
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:26 -0300

perf util: Get rid of unused header_page_* variables

They're not used anywhere and same information is kept in a pevent
already.  So let's get rid of them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 4 ----
 tools/perf/util/trace-event.h       | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4454835..0deae88 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -28,10 +28,6 @@
 #include "util.h"
 #include "trace-event.h"
 
-int header_page_size_size;
-int header_page_ts_size;
-int header_page_data_offset;
-
 bool latency_format;
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 11eb7fd..761c484 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -10,10 +10,6 @@ struct perf_sample;
 union perf_event;
 struct perf_tool;
 
-extern int header_page_size_size;
-extern int header_page_ts_size;
-extern int header_page_data_offset;
-
 extern bool latency_format;
 extern struct pevent *perf_pevent;
 
