Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab3JNUtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:49:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab3JNUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 019/161] tools/perf/build: Split out feature check: 'libaudit'
Date: Mon, 14 Oct 2013 17:00:08 -0300
Message-Id: <1381780950-25642-20-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-orhejqtjao3vf4wxwBUdzhaz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 4 ++--
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libaudit.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libaudit.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d684a292536e..d4f18f4c8d51 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -114,6 +114,7 @@ FEATURE_TESTS =				\
 	libelf-mmap			\
 	libelf-getphdrnum		\
 	libunwind			\
+	libaudit			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -265,8 +266,7 @@ ifndef NO_LIBUNWIND
 endif
 
 ifndef NO_LIBAUDIT
-  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
-  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+  ifneq ($(feature-libaudit), 1)
     msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
     NO_LIBAUDIT := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d6d9570a038f..8e49fa0c922b 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -12,6 +12,7 @@ FILES=					\
 	test-libelf-mmap		\
 	test-libelf-getphdrnum		\
 	test-libunwind			\
+	test-libaudit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -61,6 +62,9 @@ test-libnuma:
 test-libunwind:
 	$(BUILD) -lunwind -lunwind-x86_64 -lelf
 
+test-libaudit:
+	$(BUILD) -laudit
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
new file mode 100644
index 000000000000..854a65d3cc78
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -0,0 +1,7 @@
+#include <libaudit.h>
+
+int main(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+	return audit_open();
+}
-- 
1.8.1.4

