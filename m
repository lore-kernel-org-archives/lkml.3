Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3JHKUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:20:34 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49963 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3JHKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:29 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 26/52] tools/perf/build: Split out feature check: 'libbfd'
Date: Tue,  8 Oct 2013 12:10:56 +0200
Message-Id: <1381227082-22039-27-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-cdxdfv7Corpfvjg9Skezhvjn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 4 ++--
 tools/perf/config/feature-checks/Makefile      | 4 ++++
 tools/perf/config/feature-checks/test-libbfd.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9585bde..15a3bce 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,6 +121,7 @@ FEATURE_TESTS =				\
 	libperl				\
 	libpython			\
 	libpython-version		\
+	libbfd				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -394,8 +395,7 @@ else
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
index d15074d..af65aaa 100644
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
index 0000000..d03339c
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
1.8.3.1

