Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3JNUJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:09:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3JNUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:07:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 053/161] tools/perf/build: Clean up feature_print_code()
Date: Mon, 14 Oct 2013 17:00:42 -0300
Message-Id: <1381780950-25642-54-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index 78f3b3eff12a..f5d661f5637d 100644
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
 
-- 
1.8.1.4

