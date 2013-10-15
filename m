Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab3JOFZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:25:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3JOFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:25:10 -0400
Date: Mon, 14 Oct 2013 22:23:44 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-5283ec23a02e8afdc984c7f5f07e2a2662d4934a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1379003976-5839-3-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unused trace-event-* code
Git-Commit-ID: 5283ec23a02e8afdc984c7f5f07e2a2662d4934a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:23:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5283ec23a02e8afdc984c7f5f07e2a2662d4934a
Gitweb:     http://git.kernel.org/tip/5283ec23a02e8afdc984c7f5f07e2a2662d4934a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 12 Sep 2013 18:39:34 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:15:28 -0300

perf tools: Remove unused trace-event-* code

Removing unused trace-event-* code.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1379003976-5839-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 36 ------------------------------------
 tools/perf/util/trace-event.h       |  9 ---------
 2 files changed, 45 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index e9e1c03..6681f71 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -120,42 +120,6 @@ raw_field_value(struct event_format *event, const char *name, void *data)
 	return val;
 }
 
-void *raw_field_ptr(struct event_format *event, const char *name, void *data)
-{
-	struct format_field *field;
-
-	field = pevent_find_any_field(event, name);
-	if (!field)
-		return NULL;
-
-	if (field->flags & FIELD_IS_DYNAMIC) {
-		int offset;
-
-		offset = *(int *)(data + field->offset);
-		offset &= 0xffff;
-
-		return data + offset;
-	}
-
-	return data + field->offset;
-}
-
-int trace_parse_common_type(struct pevent *pevent, void *data)
-{
-	struct pevent_record record;
-
-	record.data = data;
-	return pevent_data_type(pevent, &record);
-}
-
-int trace_parse_common_pid(struct pevent *pevent, void *data)
-{
-	struct pevent_record record;
-
-	record.data = data;
-	return pevent_data_pid(pevent, &record);
-}
-
 unsigned long long read_size(struct event_format *event, void *ptr, int size)
 {
 	return pevent_read_number(event->pevent, ptr, size);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index fafe1a4..04df631 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -11,8 +11,6 @@ union perf_event;
 struct perf_tool;
 struct thread;
 
-extern struct pevent *perf_pevent;
-
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
@@ -23,26 +21,19 @@ int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys);
 
-struct pevent_record *trace_peek_data(struct pevent *pevent, int cpu);
-
 unsigned long long
 raw_field_value(struct event_format *event, const char *name, void *data);
-void *raw_field_ptr(struct event_format *event, const char *name, void *data);
 
 void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
 
 ssize_t trace_report(int fd, struct pevent **pevent, bool repipe);
 
-int trace_parse_common_type(struct pevent *pevent, void *data);
-int trace_parse_common_pid(struct pevent *pevent, void *data);
-
 struct event_format *trace_find_next_event(struct pevent *pevent,
 					   struct event_format *event);
 unsigned long long read_size(struct event_format *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
-struct pevent_record *trace_read_data(struct pevent *pevent, int cpu);
 int read_tracing_data(int fd, struct list_head *pattrs);
 
 struct tracing_data {
