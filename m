Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3JOFQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:16:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3JOFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:16:46 -0400
Date: Mon, 14 Oct 2013 22:16:32 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-34ef21622f9028efafe7950504a9ce90d9cc15a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 on-exit'
Git-Commit-ID: 34ef21622f9028efafe7950504a9ce90d9cc15a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:16:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34ef21622f9028efafe7950504a9ce90d9cc15a0
Gitweb:     http://git.kernel.org/tip/34ef21622f9028efafe7950504a9ce90d9cc15a0
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 16:46:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:46 +0200

tools/perf/build: Split out feature check: 'on-exit'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-gmywXandzfxnlcbzlX6bkpw1@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                        | 3 ++-
 tools/perf/config/feature-checks/Makefile                         | 4 ++++
 tools/perf/config/feature-checks/{test-hello.c => test-on-exit.c} | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c8ac4df..44affb5 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -123,6 +123,7 @@ FEATURE_TESTS =				\
 	libpython-version		\
 	strlcpy				\
 	libbfd				\
+	on-exit				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -441,7 +442,7 @@ ifndef NO_STRLCPY
 endif
 
 ifndef NO_ON_EXIT
-  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT_SUPPORT),y)
+  ifeq ($(feature-on-exit), 1)
     CFLAGS += -DHAVE_ON_EXIT_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d348aa0..20f1b8c 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -21,6 +21,7 @@ FILES=					\
 	test-libpython-version		\
 	test-strlcpy			\
 	test-libbfd			\
+	test-on-exit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -120,6 +121,9 @@ test-strlcpy:
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
+test-on-exit:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-hello.c b/tools/perf/config/feature-checks/test-on-exit.c
similarity index 57%
copy from tools/perf/config/feature-checks/test-hello.c
copy to tools/perf/config/feature-checks/test-on-exit.c
index c9f398d..473f1de 100644
--- a/tools/perf/config/feature-checks/test-hello.c
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -2,5 +2,5 @@
 
 int main(void)
 {
-	return puts("hi");
+	return on_exit(NULL, NULL);
 }
