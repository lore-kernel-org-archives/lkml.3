Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3JMVWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 17:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3JMVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 17:22:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf make: Move DEBUG initialization into Makefile.perf
Date: Sun, 13 Oct 2013 23:22:09 +0200
Message-Id: <1381699329-6418-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new top level Makefile invalidated the
DEBUG variable check for "command line" origin.

Moving this check into Makefile.perf.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 6 +++++-
 tools/perf/config/Makefile | 3 ---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5aa3d04..db21dad 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -37,12 +37,16 @@ ifneq ($(O),)
   FULL_O := $(shell readlink -f $(O))
 endif
 
+ifeq ("$(origin DEBUG)", "command line")
+  D = $(DEBUG)
+endif
+
 define print_msg
   @printf '  BUILD:   Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
-  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $@
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) PERF_DEBUG=$(D) $@
 endef
 
 #
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9680424..912026a 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -66,9 +66,6 @@ ifneq ($(WERROR),0)
   CFLAGS += -Werror
 endif
 
-ifeq ("$(origin DEBUG)", "command line")
-  PERF_DEBUG = $(DEBUG)
-endif
 ifndef PERF_DEBUG
   CFLAGS += -O6
 endif
-- 
1.7.11.7

