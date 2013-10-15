Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3JOFNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:13:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3JOFNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:22 -0400
Date: Mon, 14 Oct 2013 22:13:08 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-90ac5422b617fcab0c6f02249502ffc17dfbf6e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 stackprotector-all'
Git-Commit-ID: 90ac5422b617fcab0c6f02249502ffc17dfbf6e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:13:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90ac5422b617fcab0c6f02249502ffc17dfbf6e3
Gitweb:     http://git.kernel.org/tip/90ac5422b617fcab0c6f02249502ffc17dfbf6e3
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 13:48:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:30 +0200

tools/perf/build: Split out feature check: 'stackprotector-all'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-gupddm9clctVYws3lyexfdhg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                            | 3 ++-
 tools/perf/config/feature-checks/Makefile                             | 4 ++++
 .../config/feature-checks/{test-hello.c => test-stackprotector-all.c} | 0
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f39fc22..1a67371 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -103,11 +103,12 @@ $(info done)
 
 FEATURE_TESTS =				\
 	hello				\
+	stackprotector-all		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
+ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 6a42ad2..7538c14 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,6 +1,7 @@
 
 FILES=					\
 	test-hello			\
+	test-stackprotector-all		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -14,6 +15,9 @@ BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 test-hello:
 	$(BUILD)
 
+test-stackprotector-all:
+	$(BUILD) -Werror -fstack-protector-all
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-hello.c b/tools/perf/config/feature-checks/test-stackprotector-all.c
similarity index 100%
copy from tools/perf/config/feature-checks/test-hello.c
copy to tools/perf/config/feature-checks/test-stackprotector-all.c
