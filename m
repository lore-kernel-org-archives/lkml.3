Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbbATQqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:46:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbbATQmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:42:18 -0500
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
Subject: [PATCH 28/36] perf build: Remove directory dependency rules
Date: Tue, 20 Jan 2015 17:39:25 +0100
Message-Id: <1421771973-6022-29-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing subdirectories creation support from Makefile.perf
as it's no longer needed, since it's properly handled by new
build system.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
 tools/perf/Makefile.perf | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index a5f0a63f020d..e0351da7cfde 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -465,21 +465,6 @@ endif
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
-# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
-# we depend the various files onto their directories.
-DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS)
-DIRECTORY_DEPS += $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
-# no need to add flex objects, because they depend on bison ones
-DIRECTORY_DEPS += $(OUTPUT)util/parse-events-bison.c
-DIRECTORY_DEPS += $(OUTPUT)util/pmu-bison.c
-
-OUTPUT_DIRECTORIES := $(sort $(dir $(DIRECTORY_DEPS)))
-
-$(DIRECTORY_DEPS): | $(OUTPUT_DIRECTORIES)
-# In the second step, we make a rule to actually create these directories
-$(OUTPUT_DIRECTORIES):
-	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
-
 LIBPERF_IN := $(OUTPUT)libperf-in.o
 
 $(LIBPERF_IN): FORCE
-- 
1.9.3

