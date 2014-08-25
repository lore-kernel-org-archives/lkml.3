Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaHYOqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbaHYOqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:33 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 9/9] perf script: Add period as a default output column
Date: Mon, 25 Aug 2014 16:45:43 +0200
Message-Id: <1408977943-16594-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding period as a default output column in script command
fo hardware, software and raw events.

If PERF_SAMPLE_PERIOD sample type is defined in perf.data,
following will be displayed in perf script output:

  $ perf script
              ls  8034 57477.887209:     250000 task-clock:  ffffffff81361d72 memset ([kernel.kallsyms])
              ls  8034 57477.887464:     250000 task-clock:  ffffffff816f6d92 _raw_spin_unlock_irqrestore ([kernel.kallsyms])
              ls  8034 57477.887708:     250000 task-clock:  ffffffff811a94f0 do_munmap ([kernel.kallsyms])
              ls  8034 57477.887959:     250000 task-clock:        34080916c6 get_next_seq (/usr/lib64/libc-2.17.so)
              ls  8034 57477.888208:     250000 task-clock:        3408079230 _IO_doallocbuf (/usr/lib64/libc-2.17.so)
              ls  8034 57477.888717:     250000 task-clock:  ffffffff814242c8 n_tty_write ([kernel.kallsyms])
              ls  8034 57477.889285:     250000 task-clock:        3408076402 fwrite_unlocked (/usr/lib64/libc-2.17.so)

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-script.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7f08c8d4d633..cbe37df81085 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -82,7 +82,8 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
+			      PERF_OUTPUT_SYM | PERF_OUTPUT_DSO |
+			      PERF_OUTPUT_PERIOD,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -93,7 +94,8 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
+			      PERF_OUTPUT_SYM | PERF_OUTPUT_DSO |
+			      PERF_OUTPUT_PERIOD,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -112,7 +114,8 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
+			      PERF_OUTPUT_SYM | PERF_OUTPUT_DSO |
+			      PERF_OUTPUT_PERIOD,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
-- 
1.8.3.1

