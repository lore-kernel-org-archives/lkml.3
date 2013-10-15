Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3JOFUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:20:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3JOFU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:20:29 -0400
Date: Mon, 14 Oct 2013 22:20:16 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-165108a92fc554d51e73b143b69b77e7c278da78@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20131008155110.GA15558@krava.redhat.com>
References: <20131008155110.GA15558@krava.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Clean up feature_print_code()
Git-Commit-ID: 165108a92fc554d51e73b143b69b77e7c278da78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:20:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  165108a92fc554d51e73b143b69b77e7c278da78
Gitweb:     http://git.kernel.org/tip/165108a92fc554d51e73b143b69b77e7c278da78
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 8 Oct 2013 17:51:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:04 +0200

tools/perf/build: Clean up feature_print_code()

Remove DUMMY by making sure 'feature_print' is evaluated and thus
all messages are printed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/20131008155110.GA15558@krava.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 78f3b3e..f5d661f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -180,21 +180,21 @@ endif
 #
 # Print the result of the feature test:
 #
-feature_print = $(eval $(feature_print_code))
+feature_print = $(eval $(feature_print_code)) $(info $(MSG))
+
 define feature_print_code
   ifeq ($(feature-$(1)), 1)
     MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
   else
     MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
   endif
-  $(info $(MSG))
 endef
 
 #
 # Only print out our features if we rebuilt the testcases or if a test failed:
 #
 ifeq ($(test-all-failed), 1)
-  $(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
   $(info )
 endif
 
