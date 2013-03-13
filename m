Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3CMFHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:07:39 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:64048 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3CMFHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:07:37 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/4] perf: remove unused print_event function
Date: Tue, 12 Mar 2013 23:07:25 -0600
Message-Id: <1363151248-16674-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/trace-event-parse.c |   24 ------------------------
 tools/perf/util/trace-event.h       |    3 ---
 2 files changed, 27 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 3aabcd6..8450bec 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -196,30 +196,6 @@ void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
 	event_format__print(event, cpu, data, size);
 }
 
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
index a55fd37..99f621f 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -34,9 +34,6 @@ void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm);
-
 int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys);
-- 
1.7.10.1

