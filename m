Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbaFSVOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:34124 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506AbaFSVOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:20 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/11] perf trace: Remove needless reassignments
Date: Thu, 19 Jun 2014 18:13:45 -0300
Message-Id: <1403212433-2714-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The thread->priv value is already obtained a few lines earlier from the
thread__trace() call. Leftovers from before thread__trace().

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-96laa634vzfwlwxurevo40wp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5ab2f674fed2..28c86e21fad9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1629,7 +1629,6 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 		return -1;
 
 	args = perf_evsel__sc_tp_ptr(evsel, args, sample);
-	ttrace = thread->priv;
 
 	if (ttrace->entry_str == NULL) {
 		ttrace->entry_str = malloc(1024);
@@ -1687,8 +1686,6 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		++trace->stats.vfs_getname;
 	}
 
-	ttrace = thread->priv;
-
 	ttrace->exit_time = sample->time;
 
 	if (ttrace->entry_time) {
-- 
1.9.3

