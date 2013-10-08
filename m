Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab3JHKMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32978 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3JHKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:12 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/52] tools/perf/build: Split out feature check: 'volatile-register-var'
Date: Tue,  8 Oct 2013 12:10:37 +0200
Message-Id: <1381227082-22039-8-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-5dOevlybbwvbk3zTbcxrrqet@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                    | 3 ++-
 tools/perf/config/feature-checks/Makefile                     | 4 ++++
 tools/perf/config/feature-checks/test-volatile-register-var.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9f94912..a3de2f8 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -105,6 +105,7 @@ FEATURE_TESTS =				\
 	hello				\
 	stackprotector-all		\
 	stackprotector			\
+	volatile-register-var		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -117,7 +118,7 @@ ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
+ifeq ($(feature-volatile-register-var), 1)
   CFLAGS += -Wvolatile-register-var
 endif
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 46b7650..5693299 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -3,6 +3,7 @@ FILES=					\
 	test-hello			\
 	test-stackprotector-all		\
 	test-stackprotector		\
+	test-volatile-register-var	\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -22,6 +23,9 @@ test-stackprotector-all:
 test-stackprotector:
 	$(BUILD) -Werror -fstack-protector
 
+test-volatile-register-var:
+	$(BUILD) -Werror -Wvolatile-register-var
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-volatile-register-var.c b/tools/perf/config/feature-checks/test-volatile-register-var.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-volatile-register-var.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
-- 
1.8.3.1

