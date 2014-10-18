Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaJRHIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 03:08:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51695 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJRHIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 03:08:15 -0400
Date: Sat, 18 Oct 2014 00:07:43 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e8564b710c6df2c3aeb56c507c22f4bcfa4c0b2d@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, tommy24@gatech.edu, dsahern@gmail.com,
        tglx@linutronix.de, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, eranian@google.com, cjashfor@linux.vnet.ibm.com,
        andi@firstfloor.org, mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        acme@redhat.com, jolsa@kernel.org
Reply-To: a.p.zijlstra@chello.nl, tommy24@gatech.edu, dsahern@gmail.com,
        namhyung@kernel.org, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, eranian@google.com,
        andi@firstfloor.org, mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        acme@redhat.com, jolsa@kernel.org
In-Reply-To: <1408977943-16594-10-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-10-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script:
  Add period as a default output column
Git-Commit-ID: e8564b710c6df2c3aeb56c507c22f4bcfa4c0b2d
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

Commit-ID:  e8564b710c6df2c3aeb56c507c22f4bcfa4c0b2d
Gitweb:     http://git.kernel.org/tip/e8564b710c6df2c3aeb56c507c22f4bcfa4c0b2d
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 25 Aug 2014 16:45:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Oct 2014 15:22:19 -0300

perf script: Add period as a default output column

Adding period as a default output column in script command fo hardware,
software and raw events.

If PERF_SAMPLE_PERIOD sample type is defined in perf.data, following
will be displayed in perf script output:

  $ perf script
              ls  8034 57477.887209:     250000 task-clock:  ffffffff81361d72 memset ([kernel.kallsyms])
              ls  8034 57477.887464:     250000 task-clock:  ffffffff816f6d92 _raw_spin_unlock_irqrestore ([kernel.kallsyms])
              ls  8034 57477.887708:     250000 task-clock:  ffffffff811a94f0 do_munmap ([kernel.kallsyms])
              ls  8034 57477.887959:     250000 task-clock:        34080916c6 get_next_seq (/usr/lib64/libc-2.17.so)
              ls  8034 57477.888208:     250000 task-clock:        3408079230 _IO_doallocbuf (/usr/lib64/libc-2.17.so)
              ls  8034 57477.888717:     250000 task-clock:  ffffffff814242c8 n_tty_write ([kernel.kallsyms])
              ls  8034 57477.889285:     250000 task-clock:        3408076402 fwrite_unlocked (/usr/lib64/libc-2.17.so)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408977943-16594-10-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 0659dff..9708a12 100644
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
