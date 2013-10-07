Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3JGMF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:05:27 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41788 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3JGL6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:13 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 27/50] tools/perf/build: Split out feature check: 'on-exit'
Date: Mon,  7 Oct 2013 13:56:20 +0200
Message-Id: <1381147003-2574-28-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-gmywXandzfxnlcbzlX6bkpw1@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 3 ++-
 tools/perf/config/feature-checks/Makefile       | 4 ++++
 tools/perf/config/feature-checks/test-on-exit.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4f60ecc..55ce63c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -122,6 +122,7 @@ FEATURE_TESTS =				\
 	libpython			\
 	libpython-version		\
 	libbfd				\
+	on-exit				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -429,7 +430,7 @@ ifndef NO_STRLCPY
 endif
 
 ifndef NO_ON_EXIT
-  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT_SUPPORT),y)
+  ifeq ($(feature-on-exit), 1)
     CFLAGS += -DHAVE_ON_EXIT_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2a3473e..8ec3871 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -20,6 +20,7 @@ FILES=					\
 	test-libpython			\
 	test-libpython-version		\
 	test-libbfd			\
+	test-on-exit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -119,6 +120,9 @@ test-libbfd:
 test-strlcpy:
 	$(BUILD)
 
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
1.7.11.7

