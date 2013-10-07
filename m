Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3JGMFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:05:53 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44231 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3JGL6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:10 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 25/50] tools/perf/build: Split out feature check: 'libpython-version'
Date: Mon,  7 Oct 2013 13:56:18 +0200
Message-Id: <1381147003-2574-26-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-raHmlqlnv0zexsrPau8hhane@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                |  3 ++-
 tools/perf/config/feature-checks/Makefile                 |  4 ++++
 tools/perf/config/feature-checks/test-libpython-version.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index dfb4c84..77a2e6b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -120,6 +120,7 @@ FEATURE_TESTS =				\
 	gtk2-infobar			\
 	libperl				\
 	libpython			\
+	libpython-version		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -361,7 +362,7 @@ else
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
1.7.11.7

