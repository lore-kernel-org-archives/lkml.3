Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355Ab3GRUGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:06:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41528 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab3GRTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/76] perf util: Rename read_*() functions in trace-event-info.c
Date: Thu, 18 Jul 2013 16:49:18 -0300
Message-Id: <1374177003-3706-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.8.1.4

