Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbbAZKO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:14:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbbAZKOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:53 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/36] perf build: Add perf regs objects building
Date: Mon, 26 Jan 2015 11:12:17 +0100
Message-Id: <1422267156-13873-18-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the regs objects building under build framework
to be included in the libperf build object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile.perf   | 7 -------
 tools/perf/config/Makefile | 4 ++++
 tools/perf/util/Build      | 2 ++
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ddf814aba60d..0584e99b713d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -349,13 +349,6 @@ install-gtk: $(OUTPUT)libperf-gtk.so
 		$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
 endif
 
-ifeq ($(NO_PERF_REGS),0)
-  ifeq ($(ARCH),x86)
-    LIB_H += arch/x86/include/perf_regs.h
-  endif
-  LIB_OBJS += $(OUTPUT)util/perf_regs.o
-endif
-
 ifndef NO_ZLIB
   LIB_OBJS += $(OUTPUT)util/zlib.o
 endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index fe5d09cc75c2..ed42f41111ba 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,6 +48,10 @@ ifeq ($(ARCH),arm64)
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
 endif
 
+ifeq ($(NO_PERF_REGS),0)
+  $(call detected,CONFIG_PERF_REGS)
+endif
+
 # So far there's only x86 and arm libdw unwind support merged in perf.
 # Disable it on all other architectures in case libdw unwind
 # support is detected in system. Add supported architectures
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index b0a65429da6c..f69843218228 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -90,6 +90,8 @@ libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
 
 libperf-y += scripting-engines/
 
+libperf-$(CONFIG_PERF_REGS) += perf_regs.o
+
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
 
-- 
1.9.3

