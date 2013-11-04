Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3KDUV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:21:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3KDUVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:21:55 -0500
Date: Mon, 4 Nov 2013 12:21:20 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-091a4ef5a94d46d26a05f0c32d2f64800ed91306@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, namhyung@gmail.com, adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1383313899-15987-10-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-10-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Update "sample parsing"
  test for PERF_SAMPLE_TRANSACTION
Git-Commit-ID: 091a4ef5a94d46d26a05f0c32d2f64800ed91306
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:21:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  091a4ef5a94d46d26a05f0c32d2f64800ed91306
Gitweb:     http://git.kernel.org/tip/091a4ef5a94d46d26a05f0c32d2f64800ed91306
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:37 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:47:24 -0300

perf test: Update "sample parsing" test for PERF_SAMPLE_TRANSACTION

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
index 61c9da2..1b67720 100644
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
