Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3JNUxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:53:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38409 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab3JNUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 006/161] tools/perf/build: Split out feature check: 'stackprotector'
Date: Mon, 14 Oct 2013 16:59:55 -0300
Message-Id: <1381780950-25642-7-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-eyLYjhskzn6qxkoyjtjic4ap@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                             | 3 ++-
 tools/perf/config/feature-checks/Makefile              | 4 ++++
 tools/perf/config/feature-checks/test-stackprotector.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1a6737144149..9f94912ccf63 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -104,6 +104,7 @@ $(info done)
 FEATURE_TESTS =				\
 	hello				\
 	stackprotector-all		\
+	stackprotector			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -112,7 +113,7 @@ ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
+ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 7538c148b40c..46b7650983cb 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -2,6 +2,7 @@
 FILES=					\
 	test-hello			\
 	test-stackprotector-all		\
+	test-stackprotector		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -18,6 +19,9 @@ test-hello:
 test-stackprotector-all:
 	$(BUILD) -Werror -fstack-protector-all
 
+test-stackprotector:
+	$(BUILD) -Werror -fstack-protector
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-stackprotector.c b/tools/perf/config/feature-checks/test-stackprotector.c
new file mode 100644
index 000000000000..c9f398d87868
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-stackprotector.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
-- 
1.8.1.4

