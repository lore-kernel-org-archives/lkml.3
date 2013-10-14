Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3JNUDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:03:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38537 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3JNUCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 041/161] tools/perf/build: Standardize the various messages output by parallel make
Date: Mon, 14 Oct 2013 17:00:30 -0300
Message-Id: <1381780950-25642-42-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-mky0rtpwxi3ivxsvdjoOEmhr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile        | 23 ++++++++++++++++++++---
 tools/perf/config/Makefile |  4 ++--
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ce7874b73dd9..3b925ad0d5f5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -13,13 +13,30 @@ endif
 
 export JOBS
 
-$(info $(shell printf '# [ perf build: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build. ]\n'))
+define print_msg
+  @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
+endef
+
+define make
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+endef
 
 #
 # Needed if no target specified:
 #
 all:
-	@$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+	$(print_msg)
+	$(make)
+
+#
+# The clean target is not really parallel, don't print the jobs info:
+#
+clean:
+	$(make)
 
+#
+# All other targets get passed through:
+#
 %:
-	@$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+	$(print_msg)
+	$(make)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index fb6ec069f541..62d02cd03f29 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -179,9 +179,9 @@ endif
 feature_print = $(eval $(feature_print_code))
 define feature_print_code
   ifeq ($(feature-$(1)), 1)
-    MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
   else
-    MSG := $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
   endif
   $(info $(MSG))
 endef
-- 
1.8.1.4

