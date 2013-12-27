Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3L0Urc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:47:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3L0UrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 40/49] perf tools: Do not synthesize the treads of default guest.
Date: Fri, 27 Dec 2013 17:46:56 -0300
Message-Id: <1388177225-17349-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

As the default guest is designed to handle orphan kernel symboles with
--guestkallsysms and --guestmodules, it has no user space.

So we should skip synthesizing threads if machine is default guest.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/e9ddb5dac6f963169657218b12ceb3c2030f54e8.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2905771a1f49..45a76c69a9ed 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -133,6 +133,9 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 		goto out;
 	}
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
 		 machine->root_dir, pid);
 
@@ -183,6 +186,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	FILE *fp;
 	int rc = 0;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	snprintf(filename, sizeof(filename), "%s/proc/%d/maps",
 		 machine->root_dir, pid);
 
@@ -409,6 +415,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
 	proc = opendir(proc_path);
 
-- 
1.8.1.4

