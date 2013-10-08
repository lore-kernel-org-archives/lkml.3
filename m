Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3JHKYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:24:30 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55914 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3JHKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:16 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/52] tools/perf/build: Split out feature check: 'glibc'
Date: Tue,  8 Oct 2013 12:10:42 +0200
Message-Id: <1381227082-22039-13-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-nqnnsptw7ivOzhzbNjiun7ds@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                    | 4 ++--
 tools/perf/config/feature-checks/Makefile     | 4 ++++
 tools/perf/config/feature-checks/test-glibc.c | 8 ++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6865428..8cd0fd8 100644
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
index 789a38d..c0569c7 100644
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
index 0000000..13c66a5
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
1.8.3.1

