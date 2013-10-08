Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3JHKMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:30 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52048 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JHKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:23 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 19/52] tools/perf/build: Split out feature check: 'libaudit'
Date: Tue,  8 Oct 2013 12:10:49 +0200
Message-Id: <1381227082-22039-20-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-orhejqtjao3vf4wxwBUdzhaz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 4 ++--
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libaudit.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c3f73be..7fda3a6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -114,6 +114,7 @@ FEATURE_TESTS =				\
 	libelf-mmap			\
 	libelf-getphdrnum		\
 	libunwind			\
+	libaudit			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -255,8 +256,7 @@ ifndef NO_LIBUNWIND
 endif
 
 ifndef NO_LIBAUDIT
-  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
-  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+  ifneq ($(feature-libaudit), 1)
     msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
     NO_LIBAUDIT := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d6d9570..8e49fa0 100644
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
index 0000000..854a65d
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
1.8.3.1

