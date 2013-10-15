Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3JOFNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:13:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3JOFNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:30 -0400
Date: Mon, 14 Oct 2013 22:13:16 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-430be5ab0a50a9116c689b2b2ea7acd7a635aabe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 stackprotector'
Git-Commit-ID: 430be5ab0a50a9116c689b2b2ea7acd7a635aabe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:13:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  430be5ab0a50a9116c689b2b2ea7acd7a635aabe
Gitweb:     http://git.kernel.org/tip/430be5ab0a50a9116c689b2b2ea7acd7a635aabe
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 09:47:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:31 +0200

tools/perf/build: Split out feature check: 'stackprotector'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-eyLYjhskzn6qxkoyjtjic4ap@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                            | 3 ++-
 tools/perf/config/feature-checks/Makefile                             | 4 ++++
 .../config/feature-checks/{test-hello.c => test-stackprotector.c}     | 0
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1a67371..9f94912 100644
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
 
diff --git a/tools/perf/config/feature-checks/test-hello.c b/tools/perf/config/feature-checks/test-stackprotector.c
similarity index 100%
copy from tools/perf/config/feature-checks/test-hello.c
copy to tools/perf/config/feature-checks/test-stackprotector.c
