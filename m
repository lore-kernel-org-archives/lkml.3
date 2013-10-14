Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3JNUqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:46:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3JNUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 020/161] tools/perf/build: Split out feature check: 'libslang'
Date: Mon, 14 Oct 2013 17:00:09 -0300
Message-Id: <1381780950-25642-21-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-FGmpkydfwqlkaw7yy8ewjpza@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 4 ++--
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libslang.c | 6 ++++++
 3 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libslang.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d4f18f4c8d51..43713c641600 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -115,6 +115,7 @@ FEATURE_TESTS =				\
 	libelf-getphdrnum		\
 	libunwind			\
 	libaudit			\
+	libslang			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -280,8 +281,7 @@ ifdef NO_NEWT
 endif
 
 ifndef NO_SLANG
-  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+  ifneq ($(feature-libslang), 1)
     msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
     NO_SLANG := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8e49fa0c922b..c9b15b0a819b 100644
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
index 000000000000..22ff22ed94d1
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
1.8.1.4

