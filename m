Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3JGL6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:03 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:51154 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3JGL5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:57:53 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/50] tools/perf/build: Split out feature check: 'stackprotector'
Date: Mon,  7 Oct 2013 13:55:59 +0200
Message-Id: <1381147003-2574-7-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-eyLYjhskzn6qxkoyjtjic4ap@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                             | 3 ++-
 tools/perf/config/feature-checks/Makefile              | 4 ++++
 tools/perf/config/feature-checks/test-stackprotector.c | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 21e4f83..82daa23 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -104,6 +104,7 @@ $(info done)
 FEATURE_TESTS =				\
 	hello				\
 	stackprotector-all		\
+	stackprotector			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -112,7 +113,7 @@ ifeq ($(stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
+ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 7538c14..46b7650 100644
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
index 0000000..c9f398d
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
1.7.11.7

