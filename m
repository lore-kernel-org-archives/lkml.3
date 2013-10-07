Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3JGMJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:09:14 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45496 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3JGL5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:57:55 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/50] tools/perf/build: Split out feature check: 'fortify-source'
Date: Mon,  7 Oct 2013 13:56:01 +0200
Message-Id: <1381147003-2574-9-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-wicrcLCy2wkalka7iwsuzgpb@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                             | 3 ++-
 tools/perf/config/feature-checks/Makefile              | 4 ++++
 tools/perf/config/feature-checks/test-fortify-source.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 63e70c5..fc871ae 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -106,6 +106,7 @@ FEATURE_TESTS =				\
 	stackprotector-all		\
 	stackprotector			\
 	volatile-register-var		\
+	fortify-source			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -123,7 +124,7 @@ ifeq ($(feature-volatile-register-var), 1)
 endif
 
 ifndef PERF_DEBUG
-  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+  ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 5693299..529317e 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -4,6 +4,7 @@ FILES=					\
 	test-stackprotector-all		\
 	test-stackprotector		\
 	test-volatile-register-var	\
+	test-fortify-source		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -26,6 +27,9 @@ test-stackprotector:
 test-volatile-register-var:
 	$(BUILD) -Werror -Wvolatile-register-var
 
+test-fortify-source:
+	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-fortify-source.c b/tools/perf/config/feature-checks/test-fortify-source.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-fortify-source.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
-- 
1.7.11.7

