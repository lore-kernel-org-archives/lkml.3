Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaANQk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:40:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaANQjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:43 -0500
Date: Tue, 14 Jan 2014 08:39:17 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a18382b68f8bf1a8d43e3cb08b3479cb768913ea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-4-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make perf_event__synthesize_mmap_events global
Git-Commit-ID: a18382b68f8bf1a8d43e3cb08b3479cb768913ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:39:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a18382b68f8bf1a8d43e3cb08b3479cb768913ea
Gitweb:     http://git.kernel.org/tip/a18382b68f8bf1a8d43e3cb08b3479cb768913ea
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:20 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:24 -0300

perf tools: Make perf_event__synthesize_mmap_events global

Making perf_event__synthesize_mmap_events global, it will be used in
following patch from test code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 12 ++++++------
 tools/perf/util/event.h |  7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 45a76c6..1fc1c2f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -175,12 +175,12 @@ out:
 	return tgid;
 }
 
-static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
-					      union perf_event *event,
-					      pid_t pid, pid_t tgid,
-					      perf_event__handler_t process,
-					      struct machine *machine,
-					      bool mmap_data)
+int perf_event__synthesize_mmap_events(struct perf_tool *tool,
+				       union perf_event *event,
+				       pid_t pid, pid_t tgid,
+				       perf_event__handler_t process,
+				       struct machine *machine,
+				       bool mmap_data)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 30fec99..faf6e21 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -266,6 +266,13 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
+int perf_event__synthesize_mmap_events(struct perf_tool *tool,
+				       union perf_event *event,
+				       pid_t pid, pid_t tgid,
+				       perf_event__handler_t process,
+				       struct machine *machine,
+				       bool mmap_data);
+
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
