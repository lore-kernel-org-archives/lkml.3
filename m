Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3JGL6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:21 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35844 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3JGL6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:14 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 28/50] tools/perf/build: Split out feature check: 'backtrace'
Date: Mon,  7 Oct 2013 13:56:21 +0200
Message-Id: <1381147003-2574-29-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 55ce63c..e190f9c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -123,6 +123,7 @@ FEATURE_TESTS =				\
 	libpython-version		\
 	libbfd				\
 	on-exit				\
+	backtrace			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -436,7 +437,7 @@ ifndef NO_ON_EXIT
 endif
 
 ifndef NO_BACKTRACE
-  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DHAVE_BACKTRACE_SUPPORT),y)
+  ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8ec3871..ddc4c33 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -21,6 +21,7 @@ FILES=					\
 	test-libpython-version		\
 	test-libbfd			\
 	test-on-exit			\
+	test-backtrace			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -123,6 +124,9 @@ test-strlcpy:
 test-on-exit:
 	$(BUILD)
 
+test-backtrace:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
new file mode 100644
index 0000000..5b79468
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
1.7.11.7

