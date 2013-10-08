Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3JHKVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:21:03 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38227 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3JHKM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:28 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 25/52] tools/perf/build: Split out feature check: 'libpython-version'
Date: Tue,  8 Oct 2013 12:10:55 +0200
Message-Id: <1381227082-22039-26-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-raHmlqlnv0zexsrPau8hhane@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                |  3 ++-
 tools/perf/config/feature-checks/Makefile                 |  4 ++++
 tools/perf/config/feature-checks/test-libpython-version.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1b3ced4..9585bde 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -120,6 +120,7 @@ FEATURE_TESTS =				\
 	gtk2-infobar			\
 	libperl				\
 	libpython			\
+	libpython-version		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -362,7 +363,7 @@ else
         $(call disable-python,Python.h (for Python 2.x))
       else
 
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+        ifneq ($(feature-libpython-version), 1)
           $(warning Python 3 is not yet supported; please set)
           $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
           $(warning If you also have Python 2 installed, then)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index e7ed05a..d15074d 100644
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
index 0000000..facea12
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
1.8.3.1

