Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3JOFPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:15:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3JOFPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:15:37 -0400
Date: Mon, 14 Oct 2013 22:15:20 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b9498b508a0d601029f1040a51e9a5a4aecbb926@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libslang'
Git-Commit-ID: b9498b508a0d601029f1040a51e9a5a4aecbb926
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:15:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9498b508a0d601029f1040a51e9a5a4aecbb926
Gitweb:     http://git.kernel.org/tip/b9498b508a0d601029f1040a51e9a5a4aecbb926
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:57:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:41 +0200

tools/perf/build: Split out feature check: 'libslang'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-FGmpkydfwqlkaw7yy8ewjpza@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 4 ++--
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libslang.c | 6 ++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d4f18f4..43713c6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -115,6 +115,7 @@ FEATURE_TESTS =				\
 	libelf-getphdrnum		\
 	libunwind			\
 	libaudit			\
+	libslang			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -280,8 +281,7 @@ ifdef NO_NEWT
 endif
 
 ifndef NO_SLANG
-  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+  ifneq ($(feature-libslang), 1)
     msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
     NO_SLANG := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8e49fa0..c9b15b0 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -13,6 +13,7 @@ FILES=					\
 	test-libelf-getphdrnum		\
 	test-libunwind			\
 	test-libaudit			\
+	test-libslang			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -65,6 +66,9 @@ test-libunwind:
 test-libaudit:
 	$(BUILD) -laudit
 
+test-libslang:
+	$(BUILD) -I/usr/include/slang -lslang
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libslang.c b/tools/perf/config/feature-checks/test-libslang.c
new file mode 100644
index 0000000..22ff22e
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libslang.c
@@ -0,0 +1,6 @@
+#include <slang.h>
+
+int main(void)
+{
+	return SLsmg_init_smg();
+}
