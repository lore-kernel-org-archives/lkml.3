Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3JNUs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:48:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab3JNUCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 027/161] tools/perf/build: Split out feature check: 'strlcpy'
Date: Mon, 14 Oct 2013 17:00:16 -0300
Message-Id: <1381780950-25642-28-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-ektO8cgvupthhyqqczSok2sr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 3 ++-
 tools/perf/config/feature-checks/Makefile       | 4 ++++
 tools/perf/config/feature-checks/test-strlcpy.c | 8 ++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-strlcpy.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7e139694afc2..c8ac4df05db1 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,6 +121,7 @@ FEATURE_TESTS =				\
 	libperl				\
 	libpython			\
 	libpython-version		\
+	strlcpy				\
 	libbfd				\
 	libnuma
 
@@ -434,7 +435,7 @@ else
 endif
 
 ifndef NO_STRLCPY
-  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY_SUPPORT),y)
+  ifeq ($(feature-strlcpy), 1)
     CFLAGS += -DHAVE_STRLCPY_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index af65aaa93e16..d348aa0ec181 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -19,6 +19,7 @@ FILES=					\
 	test-libperl			\
 	test-libpython			\
 	test-libpython-version		\
+	test-strlcpy			\
 	test-libbfd			\
 	test-libnuma
 
@@ -113,6 +114,9 @@ test-libpython:
 test-libpython-version:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
+test-strlcpy:
+	$(BUILD)
+
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
diff --git a/tools/perf/config/feature-checks/test-strlcpy.c b/tools/perf/config/feature-checks/test-strlcpy.c
new file mode 100644
index 000000000000..4a6b6ff06f74
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-strlcpy.c
@@ -0,0 +1,8 @@
+#include <stdlib.h>
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
-- 
1.8.1.4

