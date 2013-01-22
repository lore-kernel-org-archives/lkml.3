Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3AVJL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:11:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3AVJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:11:24 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-7a-50fe57b4c272
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/19] perf report: Add --group option
Date: Tue, 22 Jan 2013 18:09:45 +0900
Message-Id: <1358845787-1350-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add --group option to enable event grouping.  When enabled, all the
group members information will be shown together with the leader.

  $ perf report --group
  ...
  # group: {ref-cycles,cycles}
  # ========
  #
  # Samples: 7K of event 'anon group { ref-cycles, cycles }'
  # Event count (approx.): 6876107743
  #
  #         Overhead  Command      Shared Object                      Symbol
  # ................  .......  .................  ..........................
  #
      99.84%  99.76%  noploop  noploop            [.] main
       0.07%   0.00%  noploop  ld-2.15.so         [.] strcmp
       0.03%   0.00%  noploop  [kernel.kallsyms]  [k] timerqueue_del
       0.03%   0.03%  noploop  [kernel.kallsyms]  [k] sched_clock_cpu
       0.02%   0.00%  noploop  [kernel.kallsyms]  [k] account_user_time
       0.01%   0.00%  noploop  [kernel.kallsyms]  [k] __alloc_pages_nodemask
       0.00%   0.00%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe
       0.00%   0.11%  noploop  [kernel.kallsyms]  [k] _raw_spin_lock
       0.00%   0.06%  noploop  [kernel.kallsyms]  [k] find_get_page
       0.00%   0.02%  noploop  [kernel.kallsyms]  [k] rcu_check_callbacks
       0.00%   0.02%  noploop  [kernel.kallsyms]  [k] __current_kernel_time

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 3 +++
 tools/perf/builtin-report.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 848a0dcb6dfd..02284a0067f0 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -203,6 +203,9 @@ OPTIONS
 --objdump=<path>::
         Path to objdump binary.
 
+--group::
+	Show event group information together.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ce518c48a525..9ef38424f7c3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -668,6 +668,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
+		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
-- 
1.7.11.7

