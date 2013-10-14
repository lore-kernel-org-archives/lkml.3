Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3JNUqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:46:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab3JNUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 026/161] tools/perf/build: Split out feature check: 'libbfd'
Date: Mon, 14 Oct 2013 17:00:15 -0300
Message-Id: <1381780950-25642-27-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-cdxdfv7Corpfvjg9Skezhvjn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 4 ++--
 tools/perf/config/feature-checks/Makefile      | 4 ++++
 tools/perf/config/feature-checks/test-libbfd.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libbfd.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 63ba069868c9..7e139694afc2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,6 +121,7 @@ FEATURE_TESTS =				\
 	libperl				\
 	libpython			\
 	libpython-version		\
+	libbfd				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -404,8 +405,7 @@ else
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-    ifeq ($(has_bfd),y)
+    ifeq ($(feature-libbfd), 1)
       EXTLIBS += -lbfd
     else
       FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d15074d77243..af65aaa93e16 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -19,6 +19,7 @@ FILES=					\
 	test-libperl			\
 	test-libpython			\
 	test-libpython-version		\
+	test-libbfd			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -112,6 +113,9 @@ test-libpython:
 test-libpython-version:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
+test-libbfd:
+	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
new file mode 100644
index 000000000000..d03339c995d7
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -0,0 +1,7 @@
+#include <bfd.h>
+
+int main(void)
+{
+	bfd_demangle(0, 0, 0);
+	return 0;
+}
-- 
1.8.1.4

