Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaALShv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaALShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:48 -0500
Date: Sun, 12 Jan 2014 10:37:32 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-c239c25a82808ad2cbc795b69e621c4c24f154d6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <e9ddb5dac6f963169657218b12ceb3c2030f54e8.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <e9ddb5dac6f963169657218b12ceb3c2030f54e8.1387572416.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do not synthesize the treads of default guest.
Git-Commit-ID: c239c25a82808ad2cbc795b69e621c4c24f154d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:37:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c239c25a82808ad2cbc795b69e621c4c24f154d6
Gitweb:     http://git.kernel.org/tip/c239c25a82808ad2cbc795b69e621c4c24f154d6
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 20 Dec 2013 15:53:00 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Dec 2013 16:49:51 -0300

perf tools: Do not synthesize the treads of default guest.

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
index 2905771..45a76c6 100644
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
 
