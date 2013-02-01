Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155Ab3BAK5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:57:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422658Ab3BAK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:57:04 -0500
Date: Fri, 1 Feb 2013 02:55:45 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-01d14f1615dfe1c6d040541501445967ac716009@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-18-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-18-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add --group option
Git-Commit-ID: 01d14f1615dfe1c6d040541501445967ac716009
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:55:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01d14f1615dfe1c6d040541501445967ac716009
Gitweb:     http://git.kernel.org/tip/01d14f1615dfe1c6d040541501445967ac716009
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:49 -0300

perf report: Add --group option

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
