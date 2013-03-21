Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3CUL3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:29:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3CUL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:28:59 -0400
Date: Thu, 21 Mar 2013 04:27:48 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-eba7181d56da7e8198f0c70e3d7074bab47a5910@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363151248-16674-3-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unused tracing functions
Git-Commit-ID: eba7181d56da7e8198f0c70e3d7074bab47a5910
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:27:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eba7181d56da7e8198f0c70e3d7074bab47a5910
Gitweb:     http://git.kernel.org/tip/eba7181d56da7e8198f0c70e3d7074bab47a5910
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Mar 2013 23:07:26 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:07 -0300

perf tools: Remove unused tracing functions

Leftovers from before libtraceevent integration.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1363151248-16674-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 37 -------------------------------------
 tools/perf/util/trace-event.h       |  4 ----
 2 files changed, 41 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 3aabcd6..4454835 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -183,43 +183,6 @@ void event_format__print(struct event_format *event,
 	trace_seq_do_printf(&s);
 }
 
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
-{
-	int type = trace_parse_common_type(pevent, data);
-	struct event_format *event = pevent_find_event(pevent, type);
-
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
-
-	event_format__print(event, cpu, data, size);
-}
-
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm)
-{
-	struct pevent_record record;
-	struct trace_seq s;
-	int pid;
-
-	pevent->latency_format = latency_format;
-
-	record.ts = nsecs;
-	record.cpu = cpu;
-	record.size = size;
-	record.data = data;
-	pid = pevent_data_pid(pevent, &record);
-
-	if (!pevent_pid_is_registered(pevent, pid))
-		pevent_register_comm(pevent, comm, pid);
-
-	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
-	trace_seq_do_printf(&s);
-	printf("\n");
-}
-
 void parse_proc_kallsyms(struct pevent *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index a55fd37..28ccde8 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -30,13 +30,9 @@ enum {
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm);
-
 int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys);
