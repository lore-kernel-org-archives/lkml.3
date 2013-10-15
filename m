Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3JOFQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:16:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab3JOFQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:16:55 -0400
Date: Mon, 14 Oct 2013 22:16:41 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-4cc9117a35b2810fb84454514a9136e5f2945751@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 backtrace'
Git-Commit-ID: 4cc9117a35b2810fb84454514a9136e5f2945751
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:16:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cc9117a35b2810fb84454514a9136e5f2945751
Gitweb:     http://git.kernel.org/tip/4cc9117a35b2810fb84454514a9136e5f2945751
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 16:49:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:47 +0200

tools/perf/build: Split out feature check: 'backtrace'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-ihnwe6cvglVkudyvcavP1wql@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                        |  3 ++-
 tools/perf/config/feature-checks/Makefile         |  4 ++++
 tools/perf/config/feature-checks/test-backtrace.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 44affb5..c0c8344 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -124,6 +124,7 @@ FEATURE_TESTS =				\
 	strlcpy				\
 	libbfd				\
 	on-exit				\
+	backtrace			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -448,7 +449,7 @@ ifndef NO_ON_EXIT
 endif
 
 ifndef NO_BACKTRACE
-  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DHAVE_BACKTRACE_SUPPORT),y)
+  ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 20f1b8c..0e4dbc2 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -22,6 +22,7 @@ FILES=					\
 	test-strlcpy			\
 	test-libbfd			\
 	test-on-exit			\
+	test-backtrace			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -124,6 +125,9 @@ test-libbfd:
 test-on-exit:
 	$(BUILD)
 
+test-backtrace:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
new file mode 100644
index 0000000..5b79468
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -0,0 +1,10 @@
+#include <execinfo.h>
+#include <stdio.h>
+
+int main(void)
+{
+	backtrace(NULL, 0);
+	backtrace_symbols(NULL, 0);
+
+	return 0;
+}
