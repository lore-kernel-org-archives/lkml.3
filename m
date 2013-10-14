Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3JNUp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:45:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38496 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab3JNUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 029/161] tools/perf/build: Split out feature check: 'backtrace'
Date: Mon, 14 Oct 2013 17:00:18 -0300
Message-Id: <1381780950-25642-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-ihnwe6cvglVkudyvcavP1wql@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                        |  3 ++-
 tools/perf/config/feature-checks/Makefile         |  4 ++++
 tools/perf/config/feature-checks/test-backtrace.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-backtrace.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 44affb5477c5..c0c83440de97 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -124,6 +124,7 @@ FEATURE_TESTS =				\
 	strlcpy				\
 	libbfd				\
 	on-exit				\
+	backtrace			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -448,7 +449,7 @@ ifndef NO_ON_EXIT
 endif
 
 ifndef NO_BACKTRACE
-  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DHAVE_BACKTRACE_SUPPORT),y)
+  ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 20f1b8c0f865..0e4dbc2d5c8a 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -22,6 +22,7 @@ FILES=					\
 	test-strlcpy			\
 	test-libbfd			\
 	test-on-exit			\
+	test-backtrace			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -124,6 +125,9 @@ test-libbfd:
 test-on-exit:
 	$(BUILD)
 
+test-backtrace:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
new file mode 100644
index 000000000000..5b79468bea2a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -0,0 +1,10 @@
+#include <execinfo.h>
+#include <stdio.h>
+
+int main(void)
+{
+	backtrace(NULL, 0);
+	backtrace_symbols(NULL, 0);
+
+	return 0;
+}
-- 
1.8.1.4

