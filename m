Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3JNUrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:47:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38471 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab3JNUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 025/161] tools/perf/build: Split out feature check: 'libpython-version'
Date: Mon, 14 Oct 2013 17:00:14 -0300
Message-Id: <1381780950-25642-26-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-raHmlqlnv0zexsrPau8hhane@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                |  3 ++-
 tools/perf/config/feature-checks/Makefile                 |  4 ++++
 tools/perf/config/feature-checks/test-libpython-version.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-libpython-version.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 595c0e0dd139..63ba069868c9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -120,6 +120,7 @@ FEATURE_TESTS =				\
 	gtk2-infobar			\
 	libperl				\
 	libpython			\
+	libpython-version		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -372,7 +373,7 @@ else
         $(call disable-python,Python.h (for Python 2.x))
       else
 
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+        ifneq ($(feature-libpython-version), 1)
           $(warning Python 3 is not yet supported; please set)
           $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
           $(warning If you also have Python 2 installed, then)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index e7ed05aa5710..d15074d77243 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -18,6 +18,7 @@ FILES=					\
 	test-gtk2-infobar		\
 	test-libperl			\
 	test-libpython			\
+	test-libpython-version		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -108,6 +109,9 @@ FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 test-libpython:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
+test-libpython-version:
+	$(BUILD) $(FLAGS_PYTHON_EMBED)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libpython-version.c b/tools/perf/config/feature-checks/test-libpython-version.c
new file mode 100644
index 000000000000..facea122d812
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libpython-version.c
@@ -0,0 +1,10 @@
+#include <Python.h>
+
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+
+int main(void)
+{
+	return 0;
+}
-- 
1.8.1.4

