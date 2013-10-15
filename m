Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3JOFTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:19:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3JOFSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:18:49 -0400
Date: Mon, 14 Oct 2013 22:18:31 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-73a725f0008702600f7d987e262f963c0fa64bc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Standardize the various messages output by parallel make
Git-Commit-ID: 73a725f0008702600f7d987e262f963c0fa64bc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:18:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73a725f0008702600f7d987e262f963c0fa64bc6
Gitweb:     http://git.kernel.org/tip/73a725f0008702600f7d987e262f963c0fa64bc6
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 11:58:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:56 +0200

tools/perf/build: Standardize the various messages output by parallel make

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
index ce7874b..3b925ad 100644
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
index fb6ec06..62d02cd 100644
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
