Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3JNUCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:02:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3JNUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 012/161] tools/perf/build: Split out feature check: 'glibc'
Date: Mon, 14 Oct 2013 17:00:01 -0300
Message-Id: <1381780950-25642-13-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-nqnnsptw7ivOzhzbNjiun7ds@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                    | 4 ++--
 tools/perf/config/feature-checks/Makefile     | 4 ++++
 tools/perf/config/feature-checks/test-glibc.c | 8 ++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-glibc.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 68654281b973..8cd0fd82967c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -109,6 +109,7 @@ FEATURE_TESTS =				\
 	fortify-source			\
 	bionic				\
 	libelf				\
+	glibc				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -166,8 +167,7 @@ ifdef NO_LIBELF
   NO_LIBUNWIND := 1
 else
   ifeq ($(feature-libelf), 0)
-    FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
-    ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+    ifeq ($(feature-glibc), 1)
       LIBC_SUPPORT := 1
     endif
     ifeq ($(BIONIC),1)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 789a38d21a34..c0569c7edb89 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -7,6 +7,7 @@ FILES=					\
 	test-fortify-source		\
 	test-bionic			\
 	test-libelf			\
+	test-glibc			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -38,6 +39,9 @@ test-bionic:
 test-libelf:
 	$(BUILD) -lelf
 
+test-glibc:
+	$(BUILD)
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-glibc.c b/tools/perf/config/feature-checks/test-glibc.c
new file mode 100644
index 000000000000..13c66a58f2ec
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-glibc.c
@@ -0,0 +1,8 @@
+#include <gnu/libc-version.h>
+
+int main(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+
-- 
1.8.1.4

