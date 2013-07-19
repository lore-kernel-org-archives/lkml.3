Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935350Ab3GSHsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:47:59 -0400
Date: Fri, 19 Jul 2013 00:47:40 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-077f159d0402ac90a3ea9975f4089a042e0be065@git.kernel.org>
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
In-Reply-To: <1370323231-14022-15-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-15-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util: Rename read_*()
  functions in trace-event-info.c
Git-Commit-ID: 077f159d0402ac90a3ea9975f4089a042e0be065
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:47:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  077f159d0402ac90a3ea9975f4089a042e0be065
Gitweb:     http://git.kernel.org/tip/077f159d0402ac90a3ea9975f4089a042e0be065
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:30 -0300

perf util: Rename read_*() functions in trace-event-info.c

It's confusing to have same name for two difference functions which does
something opposite way.  Since what they do in this file is read *AND*
writing some of tracing metadata files, rename them to record_*() looks
better to me.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-15-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index a42624a..a800f2b 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -101,7 +101,7 @@ out:
 	return err;
 }
 
-static int read_header_files(void)
+static int record_header_files(void)
 {
 	char *path;
 	struct stat st;
@@ -240,7 +240,7 @@ out:
 	return err;
 }
 
-static int read_ftrace_files(struct tracepoint_path *tps)
+static int record_ftrace_files(struct tracepoint_path *tps)
 {
 	char *path;
 	int ret;
@@ -269,7 +269,7 @@ static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
 	return false;
 }
 
-static int read_event_files(struct tracepoint_path *tps)
+static int record_event_files(struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -344,7 +344,7 @@ out:
 	return err;
 }
 
-static int read_proc_kallsyms(void)
+static int record_proc_kallsyms(void)
 {
 	unsigned int size;
 	const char *path = "/proc/kallsyms";
@@ -362,7 +362,7 @@ static int read_proc_kallsyms(void)
 	return record_file(path, 4);
 }
 
-static int read_ftrace_printk(void)
+static int record_ftrace_printk(void)
 {
 	unsigned int size;
 	char *path;
@@ -539,19 +539,19 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 	err = tracing_data_header();
 	if (err)
 		goto out;
-	err = read_header_files();
+	err = record_header_files();
 	if (err)
 		goto out;
-	err = read_ftrace_files(tps);
+	err = record_ftrace_files(tps);
 	if (err)
 		goto out;
-	err = read_event_files(tps);
+	err = record_event_files(tps);
 	if (err)
 		goto out;
-	err = read_proc_kallsyms();
+	err = record_proc_kallsyms();
 	if (err)
 		goto out;
-	err = read_ftrace_printk();
+	err = record_ftrace_printk();
 
 out:
 	/*
