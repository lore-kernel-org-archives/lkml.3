Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaJOKDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:03:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaJOKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:03:39 -0400
Date: Wed, 15 Oct 2014 03:02:14 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-cb7wkk4a3jpoovzim914ih3c@git.kernel.org>
Cc: efault@gmx.de, paulus@samba.org, eranian@google.com, peterz@infradead.org,
        fweisbec@gmail.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        acme@redhat.com, dsahern@gmail.com, jean.pihet@linaro.org,
        adrian.hunter@intel.com, mingo@kernel.org, dzickus@redhat.com,
        bp@suse.de
Reply-To: efault@gmx.de, paulus@samba.org, eranian@google.com,
        peterz@infradead.org, fweisbec@gmail.com, hpa@zytor.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        dsahern@gmail.com, acme@redhat.com, jolsa@redhat.com,
        jean.pihet@linaro.org, adrian.hunter@intel.com, mingo@kernel.org,
        dzickus@redhat.com, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Stop updating hists stats, not used
Git-Commit-ID: b3f25b6e04495ace0851cf0b88514f41c7807af6
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

Commit-ID:  b3f25b6e04495ace0851cf0b88514f41c7807af6
Gitweb:     http://git.kernel.org/tip/b3f25b6e04495ace0851cf0b88514f41c7807af6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Oct 2014 11:40:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Oct 2014 11:46:35 -0300

perf sched: Stop updating hists stats, not used

Not used here, remove to reduce perf_evsel/hists structs interaction.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cb7wkk4a3jpoovzim914ih3c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9c9287f..891c393 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1431,9 +1431,6 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 {
 	int err = 0;
 
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_samples(&evsel->hists, true);
-
 	if (evsel->handler != NULL) {
 		tracepoint_handler f = evsel->handler;
 		err = f(tool, evsel, sample, machine);
