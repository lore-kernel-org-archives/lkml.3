Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3JHK0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:26:16 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58101 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3JHKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:09 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/52] tools/perf/build: Split out feature check: 'stackprotector-all'
Date: Tue,  8 Oct 2013 12:10:35 +0200
Message-Id: <1381227082-22039-6-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-gupddm9clctVYws3lyexfdhg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                 | 3 ++-
 tools/perf/config/feature-checks/Makefile                  | 4 ++++
 tools/perf/config/feature-checks/test-stackprotector-all.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f39fc22..1a67371 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -103,11 +103,12 @@ $(info done)
 
 FEATURE_TESTS =				\
 	hello				\
+	stackprotector-all		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
+ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 6a42ad2..7538c14 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,6 +1,7 @@
 
 FILES=					\
 	test-hello			\
+	test-stackprotector-all		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -14,6 +15,9 @@ BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 test-hello:
 	$(BUILD)
 
+test-stackprotector-all:
+	$(BUILD) -Werror -fstack-protector-all
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-stackprotector-all.c b/tools/perf/config/feature-checks/test-stackprotector-all.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-stackprotector-all.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
-- 
1.8.3.1

