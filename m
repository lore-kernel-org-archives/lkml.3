Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3JNUCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:02:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38404 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3JNUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 008/161] tools/perf/build: Split out feature check: 'fortify-source'
Date: Mon, 14 Oct 2013 16:59:57 -0300
Message-Id: <1381780950-25642-9-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-wicrcLCy2wkalka7iwsuzgpb@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                             | 3 ++-
 tools/perf/config/feature-checks/Makefile              | 4 ++++
 tools/perf/config/feature-checks/test-fortify-source.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-fortify-source.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a3de2f8bd61a..7a614f92ce8c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -106,6 +106,7 @@ FEATURE_TESTS =				\
 	stackprotector-all		\
 	stackprotector			\
 	volatile-register-var		\
+	fortify-source			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -123,7 +124,7 @@ ifeq ($(feature-volatile-register-var), 1)
 endif
 
 ifndef PERF_DEBUG
-  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+  ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 5693299b4806..529317e6009b 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -4,6 +4,7 @@ FILES=					\
 	test-stackprotector-all		\
 	test-stackprotector		\
 	test-volatile-register-var	\
+	test-fortify-source		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -26,6 +27,9 @@ test-stackprotector:
 test-volatile-register-var:
 	$(BUILD) -Werror -Wvolatile-register-var
 
+test-fortify-source:
+	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-fortify-source.c b/tools/perf/config/feature-checks/test-fortify-source.c
new file mode 100644
index 000000000000..c9f398d87868
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-fortify-source.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
-- 
1.8.1.4

