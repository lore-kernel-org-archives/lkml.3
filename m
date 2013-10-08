Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3JHKTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:19:22 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43993 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3JHKMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:32 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 29/52] tools/perf/build: Split out feature check: 'backtrace'
Date: Tue,  8 Oct 2013 12:10:59 +0200
Message-Id: <1381227082-22039-30-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
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
index 2d6fcf4..57ec8b6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -124,6 +124,7 @@ FEATURE_TESTS =				\
 	strlcpy				\
 	libbfd				\
 	on-exit				\
+	backtrace			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -438,7 +439,7 @@ ifndef NO_ON_EXIT
 endif
 
 ifndef NO_BACKTRACE
-  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DHAVE_BACKTRACE_SUPPORT),y)
+  ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 20f1b8c..0e4dbc2 100644
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
1.8.3.1

