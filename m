Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3JNUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:02:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38405 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3JNUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 007/161] tools/perf/build: Split out feature check: 'volatile-register-var'
Date: Mon, 14 Oct 2013 16:59:56 -0300
Message-Id: <1381780950-25642-8-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-5dOevlybbwvbk3zTbcxrrqet@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                    | 3 ++-
 tools/perf/config/feature-checks/Makefile                     | 4 ++++
 tools/perf/config/feature-checks/test-volatile-register-var.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9f94912ccf63..a3de2f8bd61a 100644
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
index 46b7650983cb..5693299b4806 100644
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
index 000000000000..c9f398d87868
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
1.8.1.4

