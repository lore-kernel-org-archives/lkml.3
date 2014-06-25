Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaFYFvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:51:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaFYFvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:12 -0400
Date: Tue, 24 Jun 2014 22:50:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-96laa634vzfwlwxurevo40wp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Remove needless reassignments
Git-Commit-ID: 774135344fa8aa044290d030068f92e9a3aab8cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  774135344fa8aa044290d030068f92e9a3aab8cc
Gitweb:     http://git.kernel.org/tip/774135344fa8aa044290d030068f92e9a3aab8cc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Jun 2014 17:21:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:12 -0300

perf trace: Remove needless reassignments

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
index 5ab2f67..28c86e2 100644
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
