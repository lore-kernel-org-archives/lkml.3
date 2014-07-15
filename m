Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaGOAc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:32:57 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:41992 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaGOAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:32:01 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH v2 5/5] perf record: add new -I option to sample interrupted machine state
Date: Tue, 15 Jul 2014 02:31:44 +0200
Message-Id: <1405384304-26816-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405384304-26816-1-git-send-email-eranian@google.com>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -I/--intr-regs option to capture machine state registers at
interrupt.

Add the corresponding man page description

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-record.txt |    6 ++++++
 tools/perf/builtin-record.c              |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d460049..1a36259 100644
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
index 378b85b..ed2e65b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -876,6 +876,8 @@ const struct option record_options[] = {
 		    "sample transaction flags (special events only)"),
 	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
 		    "use per-thread mmaps"),
+	OPT_BOOLEAN('I', "intr-regs", &record.opts.sample_intr_regs,
+		    "Sample machine registers on interrupt"),
 	OPT_END()
 };
 
-- 
1.7.9.5

