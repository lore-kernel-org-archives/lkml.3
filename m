Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3FGNiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3FGNhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:37:32 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/3] perf tests: Make TEST_ASSERT_VAL global
Date: Fri,  7 Jun 2013 15:37:03 +0200
Message-Id: <1370612223-19188-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1370612223-19188-1-git-send-email-jolsa@redhat.com>
References: <1370612223-19188-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making TEST_ASSERT_VAL global as it's used in multiple
objects.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
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
-- 
1.7.11.7

