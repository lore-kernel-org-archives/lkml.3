Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3JOFNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:13:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60449 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3JOFNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:48 -0400
Date: Mon, 14 Oct 2013 22:13:33 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-1ea6f99efd8ae61fce68c97a9cf9f722cfbca3ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 fortify-source'
Git-Commit-ID: 1ea6f99efd8ae61fce68c97a9cf9f722cfbca3ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:13:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ea6f99efd8ae61fce68c97a9cf9f722cfbca3ad
Gitweb:     http://git.kernel.org/tip/1ea6f99efd8ae61fce68c97a9cf9f722cfbca3ad
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 09:38:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:32 +0200

tools/perf/build: Split out feature check: 'fortify-source'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-wicrcLCy2wkalka7iwsuzgpb@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                            | 3 ++-
 tools/perf/config/feature-checks/Makefile                             | 4 ++++
 .../config/feature-checks/{test-hello.c => test-fortify-source.c}     | 0
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a3de2f8..7a614f9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -106,6 +106,7 @@ FEATURE_TESTS =				\
 	stackprotector-all		\
 	stackprotector			\
 	volatile-register-var		\
+	fortify-source			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -123,7 +124,7 @@ ifeq ($(feature-volatile-register-var), 1)
 endif
 
 ifndef PERF_DEBUG
-  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+  ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 5693299..529317e 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -4,6 +4,7 @@ FILES=					\
 	test-stackprotector-all		\
 	test-stackprotector		\
 	test-volatile-register-var	\
+	test-fortify-source		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -26,6 +27,9 @@ test-stackprotector:
 test-volatile-register-var:
 	$(BUILD) -Werror -Wvolatile-register-var
 
+test-fortify-source:
+	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-hello.c b/tools/perf/config/feature-checks/test-fortify-source.c
similarity index 100%
copy from tools/perf/config/feature-checks/test-hello.c
copy to tools/perf/config/feature-checks/test-fortify-source.c
