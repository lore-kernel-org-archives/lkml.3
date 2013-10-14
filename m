Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3JNUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:16:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39081 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 151/161] tools/perf/build: Remove the volatile-register-var feature check
Date: Mon, 14 Oct 2013 17:02:20 -0300
Message-Id: <1381780950-25642-152-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Namhyung Kim noticed that the volatile-register-var feature check
is superfluous:

 > The gcc manpage says this warning is enabled by -Wall, and we add -Wall
 > to CFLAGS before doing feature checks.  So all gcc versions that support
 > -Wvolatile-register-var enables it by default without this check and
 > older gcc versions will always fail the feature check.

Remove it - this will further speed up feature checks.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                | 7 +------
 tools/perf/config/feature-checks/Makefile | 8 ++------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d2079220ff87..c516d6ba6716 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -132,8 +132,7 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	on-exit				\
 	stackprotector			\
-	stackprotector-all		\
-	volatile-register-var
+	stackprotector-all
 
 #
 # So here we detect whether test-all was rebuilt, to be able
@@ -203,10 +202,6 @@ ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
-ifeq ($(feature-volatile-register-var), 1)
-  CFLAGS += -Wvolatile-register-var
-endif
-
 ifeq ($(DEBUG),0)
   ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index cf33596c7300..2eb83467cca2 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -25,8 +25,7 @@ FILES=					\
 	test-libunwind			\
 	test-on-exit			\
 	test-stackprotector-all		\
-	test-stackprotector		\
-	test-volatile-register-var
+	test-stackprotector
 
 CC := $(CC) -MD
 
@@ -37,7 +36,7 @@ BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 ###############################
 
 test-all:
-	$(BUILD) -Werror -fstack-protector -fstack-protector-all -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello:
 	$(BUILD)
@@ -48,9 +47,6 @@ test-stackprotector-all:
 test-stackprotector:
 	$(BUILD) -Werror -fstack-protector
 
-test-volatile-register-var:
-	$(BUILD) -Werror -Wvolatile-register-var
-
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
-- 
1.8.1.4

