Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415Ab3DOFMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:12:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43369 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab3DOFLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:11:44 -0400
X-AuditID: 9c930179-b7bd8ae000004629-e0-516b8c0d5b0e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/10] perf util: Rename read_*() functions in trace-event-info.c
Date: Mon, 15 Apr 2013 14:11:36 +0900
Message-Id: <1366002698-10728-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
References: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's confusing to have same name for two difference functions which
does something opposite way.  Since what they do in this file is read
*AND* writing some of tracing metadata files, rename them to
record_*() looks better to me.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3917eb9a8479..9648175e2a1c 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -160,7 +160,7 @@ out:
 	return err;
 }
 
-static int read_header_files(void)
+static int record_header_files(void)
 {
 	char *path;
 	struct stat st;
@@ -299,7 +299,7 @@ out:
 	return err;
 }
 
-static int read_ftrace_files(struct tracepoint_path *tps)
+static int record_ftrace_files(struct tracepoint_path *tps)
 {
 	char *path;
 	int ret;
@@ -328,7 +328,7 @@ static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
 	return false;
 }
 
-static int read_event_files(struct tracepoint_path *tps)
+static int record_event_files(struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -403,7 +403,7 @@ out:
 	return err;
 }
 
-static int read_proc_kallsyms(void)
+static int record_proc_kallsyms(void)
 {
 	unsigned int size;
 	const char *path = "/proc/kallsyms";
@@ -421,7 +421,7 @@ static int read_proc_kallsyms(void)
 	return record_file(path, 4);
 }
 
-static int read_ftrace_printk(void)
+static int record_ftrace_printk(void)
 {
 	unsigned int size;
 	char *path;
@@ -583,19 +583,19 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
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
1.7.11.7

