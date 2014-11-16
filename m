Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaKPMh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:37:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaKPMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:37:19 -0500
Date: Sun, 16 Nov 2014 04:36:46 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-4b6c51773d86883a2e80cffadbe4f178ac1babd8@git.kernel.org>
Cc: acme@kernel.org, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, khandual@linux.vnet.ibm.com,
        adrian.hunter@intel.com, eranian@google.com, peterz@infradead.org,
        standby24x7@gmail.com, linux-kernel@vger.kernel.org
Reply-To: acme@kernel.org, mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        peterz@infradead.org, tglx@linutronix.de, khandual@linux.vnet.ibm.com,
        adrian.hunter@intel.com, torvalds@linux-foundation.org,
        standby24x7@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1411559322-16548-6-git-send-email-eranian@google.com>
References: <1411559322-16548-6-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Add new -I option to sample interrupted machine state
Git-Commit-ID: 4b6c51773d86883a2e80cffadbe4f178ac1babd8
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

Commit-ID:  4b6c51773d86883a2e80cffadbe4f178ac1babd8
Gitweb:     http://git.kernel.org/tip/4b6c51773d86883a2e80cffadbe4f178ac1babd8
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 24 Sep 2014 13:48:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:42:02 +0100

perf record: Add new -I option to sample interrupted machine state

Add -I/--intr-regs option to capture machine state registers at
interrupt.

Add the corresponding man page description

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1411559322-16548-6-git-send-email-eranian@google.com
Cc: cebbert.lkml@gmail.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Documentation/perf-record.txt | 6 ++++++
 tools/perf/builtin-record.c              | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 398f8d5..af9a54e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -214,6 +214,12 @@ if combined with -a or -C options.
 After starting the program, wait msecs before measuring. This is useful to
 filter out the startup phase of the program, which is often very different.
 
+-I::
+--intr-regs::
+Capture machine state (registers) at interrupt, i.e., on counter overflows for
+each sample. List of captured registers depends on the architecture. This option
+is off by default.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 582c4da..8648c6d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -811,6 +811,8 @@ struct option __record_options[] = {
 		    "sample transaction flags (special events only)"),
 	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
 		    "use per-thread mmaps"),
+	OPT_BOOLEAN('I', "intr-regs", &record.opts.sample_intr_regs,
+		    "Sample machine registers on interrupt"),
 	OPT_END()
 };
 
