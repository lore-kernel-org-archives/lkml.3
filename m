Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbbAZKUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:20:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbbAZKPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:15:01 -0500
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
Subject: [PATCH 18/36] perf build: Add zlib objects building
Date: Mon, 26 Jan 2015 11:12:18 +0100
Message-Id: <1422267156-13873-19-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the zlib objects building under build framework
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
 tools/perf/Makefile.perf   | 4 ----
 tools/perf/config/Makefile | 1 +
 tools/perf/util/Build      | 1 +
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 0584e99b713d..2a109fdb4a1f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -349,10 +349,6 @@ install-gtk: $(OUTPUT)libperf-gtk.so
 		$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
 endif
 
-ifndef NO_ZLIB
-  LIB_OBJS += $(OUTPUT)util/zlib.o
-endif
-
 ifdef ASCIIDOC8
   export ASCIIDOC8
 endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ed42f41111ba..a3bdaff9ee81 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -634,6 +634,7 @@ ifndef NO_ZLIB
   ifeq ($(feature-zlib), 1)
     CFLAGS += -DHAVE_ZLIB_SUPPORT
     EXTLIBS += -lz
+    $(call detected,CONFIG_ZLIB)
   else
     NO_ZLIB := 1
   endif
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index f69843218228..459918872f07 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -91,6 +91,7 @@ libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
 libperf-y += scripting-engines/
 
 libperf-$(CONFIG_PERF_REGS) += perf_regs.o
+libperf-$(CONFIG_ZLIB) += zlib.o
 
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
-- 
1.9.3

