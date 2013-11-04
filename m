Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3KDSBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:01:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37965 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3KDR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/29] perf test: Update "sample parsing" test for PERF_SAMPLE_TRANSACTION
Date: Mon,  4 Nov 2013 14:58:53 -0300
Message-Id: <1383587947-17419-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

In fact the "sample parsing" test does not automatically check new
sample type bits - they must be added to the comparison logic.

Doing that shows that the test fails because the functions
perf_event__synthesize_sample() and perf_event__sample_event_size() have
not been updated with PERF_SAMPLE_TRANSACTION either.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-10-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sample-parsing.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 61c9da2eb3a9..1b677202638d 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -121,6 +121,9 @@ static bool samples_same(const struct perf_sample *s1,
 	if (type & PERF_SAMPLE_DATA_SRC)
 		COMP(data_src);
 
+	if (type & PERF_SAMPLE_TRANSACTION)
+		COMP(transaction);
+
 	return true;
 }
 
@@ -165,6 +168,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		.cpu		= 110,
 		.raw_size	= sizeof(raw_data),
 		.data_src	= 111,
+		.transaction	= 112,
 		.raw_data	= (void *)raw_data,
 		.callchain	= &callchain.callchain,
 		.branch_stack	= &branch_stack.branch_stack,
@@ -273,7 +277,8 @@ int test__sample_parsing(void)
 
 	/*
 	 * Fail the test if it has not been updated when new sample format bits
-	 * were added.
+	 * were added.  Please actually update the test rather than just change
+	 * the condition below.
 	 */
 	if (PERF_SAMPLE_MAX > PERF_SAMPLE_TRANSACTION << 1) {
 		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
-- 
1.8.1.4

