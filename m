Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3JOFQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:16:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3JOFQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:16:38 -0400
Date: Mon, 14 Oct 2013 22:16:24 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-d0707c9172e5d286fc119dcef5ea1621ef3bfade@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 strlcpy'
Git-Commit-ID: d0707c9172e5d286fc119dcef5ea1621ef3bfade
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:16:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0707c9172e5d286fc119dcef5ea1621ef3bfade
Gitweb:     http://git.kernel.org/tip/d0707c9172e5d286fc119dcef5ea1621ef3bfade
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 8 Oct 2013 10:10:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:46 +0200

tools/perf/build: Split out feature check: 'strlcpy'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-ektO8cgvupthhyqqczSok2sr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 3 ++-
 tools/perf/config/feature-checks/Makefile       | 4 ++++
 tools/perf/config/feature-checks/test-strlcpy.c | 8 ++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7e13969..c8ac4df 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,6 +121,7 @@ FEATURE_TESTS =				\
 	libperl				\
 	libpython			\
 	libpython-version		\
+	strlcpy				\
 	libbfd				\
 	libnuma
 
@@ -434,7 +435,7 @@ else
 endif
 
 ifndef NO_STRLCPY
-  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY_SUPPORT),y)
+  ifeq ($(feature-strlcpy), 1)
     CFLAGS += -DHAVE_STRLCPY_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index af65aaa..d348aa0 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -19,6 +19,7 @@ FILES=					\
 	test-libperl			\
 	test-libpython			\
 	test-libpython-version		\
+	test-strlcpy			\
 	test-libbfd			\
 	test-libnuma
 
@@ -113,6 +114,9 @@ test-libpython:
 test-libpython-version:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
+test-strlcpy:
+	$(BUILD)
+
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
diff --git a/tools/perf/config/feature-checks/test-strlcpy.c b/tools/perf/config/feature-checks/test-strlcpy.c
new file mode 100644
index 0000000..4a6b6ff
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-strlcpy.c
@@ -0,0 +1,8 @@
+#include <stdlib.h>
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
