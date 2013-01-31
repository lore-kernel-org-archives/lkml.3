Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3AaRcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:32:10 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60065
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab3AaRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/25] perf report: Add --group option
Date: Thu, 31 Jan 2013 14:25:21 -0300
Message-Id: <1359653128-10433-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-18-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt | 3 +++
 tools/perf/builtin-report.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 848a0dc..02284a0 100644
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
index ce518c4..9ef3842 100644
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
1.8.1.1.361.gec3ae6e

