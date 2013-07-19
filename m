Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621Ab3GSHnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:43:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267Ab3GSHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:43:42 -0400
Date: Fri, 19 Jul 2013 00:43:19 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-450ac18d8f8076f0c522af1afb8519614a3b32f5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1370612223-19188-3-git-send-email-jolsa@redhat.com>
References: <1370612223-19188-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Make TEST_ASSERT_VAL global
Git-Commit-ID: 450ac18d8f8076f0c522af1afb8519614a3b32f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:43:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  450ac18d8f8076f0c522af1afb8519614a3b32f5
Gitweb:     http://git.kernel.org/tip/450ac18d8f8076f0c522af1afb8519614a3b32f5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 7 Jun 2013 15:37:03 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:45:52 -0300

perf tests: Make TEST_ASSERT_VAL global

Making TEST_ASSERT_VAL global as it's used in multiple objects.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370612223-19188-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dso-data.c     | 8 --------
 tools/perf/tests/parse-events.c | 8 --------
 tools/perf/tests/tests.h        | 8 ++++++++
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 5eaffa2..dffe055 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -10,14 +10,6 @@
 #include "symbol.h"
 #include "tests.h"
 
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
 static char *test_file(int size)
 {
 	static char buf_templ[] = "/tmp/test-XXXXXX";
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 0275bab..ad950f5 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -7,14 +7,6 @@
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
 			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
 
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index dd7feae..07a92f9 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -1,6 +1,14 @@
 #ifndef TESTS_H
 #define TESTS_H
 
+#define TEST_ASSERT_VAL(text, cond)					 \
+do {									 \
+	if (!(cond)) {							 \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1;						 \
+	}								 \
+} while (0)
+
 enum {
 	TEST_OK   =  0,
 	TEST_FAIL = -1,
