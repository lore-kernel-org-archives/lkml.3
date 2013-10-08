Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3JHKTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:19:24 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45114 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3JHKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:31 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 28/52] tools/perf/build: Split out feature check: 'on-exit'
Date: Tue,  8 Oct 2013 12:10:58 +0200
Message-Id: <1381227082-22039-29-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-gmywXandzfxnlcbzlX6bkpw1@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 3 ++-
 tools/perf/config/feature-checks/Makefile       | 4 ++++
 tools/perf/config/feature-checks/test-on-exit.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 079d8aa..2d6fcf4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -123,6 +123,7 @@ FEATURE_TESTS =				\
 	libpython-version		\
 	strlcpy				\
 	libbfd				\
+	on-exit				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -431,7 +432,7 @@ ifndef NO_STRLCPY
 endif
 
 ifndef NO_ON_EXIT
-  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT_SUPPORT),y)
+  ifeq ($(feature-on-exit), 1)
     CFLAGS += -DHAVE_ON_EXIT_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d348aa0..20f1b8c 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -21,6 +21,7 @@ FILES=					\
 	test-libpython-version		\
 	test-strlcpy			\
 	test-libbfd			\
+	test-on-exit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -120,6 +121,9 @@ test-strlcpy:
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
+test-on-exit:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
new file mode 100644
index 0000000..473f1de
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return on_exit(NULL, NULL);
+}
-- 
1.8.3.1

