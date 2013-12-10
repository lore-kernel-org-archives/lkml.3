Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3LJJfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:35:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJJQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:16:53 -0500
Date: Tue, 10 Dec 2013 01:16:16 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e6d7cee1ecac099786d3ba7a71b1e69cf0ae9a7b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-2-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove stackprotector feature check
Git-Commit-ID: e6d7cee1ecac099786d3ba7a71b1e69cf0ae9a7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:16:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6d7cee1ecac099786d3ba7a71b1e69cf0ae9a7b
Gitweb:     http://git.kernel.org/tip/e6d7cee1ecac099786d3ba7a71b1e69cf0ae9a7b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:15 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 13:46:36 -0300

perf tools: Remove stackprotector feature check

We use -fstack-protector-all option to enable stack protecting for all
available functions. There's no reason for enabling -Wstack-protector to
get warning for unprotected functions.

Removing stackprotector feature check which was used to enable the
-Wstack-protector option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                             | 5 -----
 tools/perf/config/feature-checks/Makefile              | 6 +-----
 tools/perf/config/feature-checks/test-stackprotector.c | 6 ------
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 36e66ac..0761d57 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -141,7 +141,6 @@ CORE_FEATURE_TESTS =			\
 	libslang			\
 	libunwind			\
 	on-exit				\
-	stackprotector			\
 	stackprotector-all		\
 	timerfd
 
@@ -209,10 +208,6 @@ ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
-ifeq ($(feature-stackprotector), 1)
-  CFLAGS += -Wstack-protector
-endif
-
 ifeq ($(DEBUG),0)
   ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 87e7900..b8bb749 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -26,7 +26,6 @@ FILES=					\
 	test-libunwind-debug-frame	\
 	test-on-exit			\
 	test-stackprotector-all		\
-	test-stackprotector		\
 	test-timerfd
 
 CC := $(CC) -MD
@@ -38,7 +37,7 @@ BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 ###############################
 
 test-all:
-	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello:
 	$(BUILD)
@@ -46,9 +45,6 @@ test-hello:
 test-stackprotector-all:
 	$(BUILD) -Werror -fstack-protector-all
 
-test-stackprotector:
-	$(BUILD) -Werror -fstack-protector -Wstack-protector
-
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
diff --git a/tools/perf/config/feature-checks/test-stackprotector.c b/tools/perf/config/feature-checks/test-stackprotector.c
deleted file mode 100644
index c9f398d..0000000
--- a/tools/perf/config/feature-checks/test-stackprotector.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <stdio.h>
-
-int main(void)
-{
-	return puts("hi");
-}
