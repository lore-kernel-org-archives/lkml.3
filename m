Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3JHKWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:22:41 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:33791 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3JHKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:24 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 20/52] tools/perf/build: Split out feature check: 'libslang'
Date: Tue,  8 Oct 2013 12:10:50 +0200
Message-Id: <1381227082-22039-21-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-FGmpkydfwqlkaw7yy8ewjpza@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 4 ++--
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libslang.c | 6 ++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7fda3a6..a8f2d67 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -115,6 +115,7 @@ FEATURE_TESTS =				\
 	libelf-getphdrnum		\
 	libunwind			\
 	libaudit			\
+	libslang			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -270,8 +271,7 @@ ifdef NO_NEWT
 endif
 
 ifndef NO_SLANG
-  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+  ifneq ($(feature-libslang), 1)
     msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
     NO_SLANG := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8e49fa0..c9b15b0 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -13,6 +13,7 @@ FILES=					\
 	test-libelf-getphdrnum		\
 	test-libunwind			\
 	test-libaudit			\
+	test-libslang			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -65,6 +66,9 @@ test-libunwind:
 test-libaudit:
 	$(BUILD) -laudit
 
+test-libslang:
+	$(BUILD) -I/usr/include/slang -lslang
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libslang.c b/tools/perf/config/feature-checks/test-libslang.c
new file mode 100644
index 0000000..22ff22e
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libslang.c
@@ -0,0 +1,6 @@
+#include <slang.h>
+
+int main(void)
+{
+	return SLsmg_init_smg();
+}
-- 
1.8.3.1

