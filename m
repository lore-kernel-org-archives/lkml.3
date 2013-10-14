Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3JNUqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:46:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38490 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab3JNUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 028/161] tools/perf/build: Split out feature check: 'on-exit'
Date: Mon, 14 Oct 2013 17:00:17 -0300
Message-Id: <1381780950-25642-29-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-gmywXandzfxnlcbzlX6bkpw1@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 3 ++-
 tools/perf/config/feature-checks/Makefile       | 4 ++++
 tools/perf/config/feature-checks/test-on-exit.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-on-exit.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c8ac4df05db1..44affb5477c5 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -123,6 +123,7 @@ FEATURE_TESTS =				\
 	libpython-version		\
 	strlcpy				\
 	libbfd				\
+	on-exit				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -441,7 +442,7 @@ ifndef NO_STRLCPY
 endif
 
 ifndef NO_ON_EXIT
-  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT_SUPPORT),y)
+  ifeq ($(feature-on-exit), 1)
     CFLAGS += -DHAVE_ON_EXIT_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d348aa0ec181..20f1b8c0f865 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -21,6 +21,7 @@ FILES=					\
 	test-libpython-version		\
 	test-strlcpy			\
 	test-libbfd			\
+	test-on-exit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -120,6 +121,9 @@ test-strlcpy:
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
+test-on-exit:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
new file mode 100644
index 000000000000..473f1dea5316
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return on_exit(NULL, NULL);
+}
-- 
1.8.1.4

