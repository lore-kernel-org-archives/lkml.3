Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab3DATVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab3DATUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/27] perf tools: Final touches for CHK config move
Date: Mon,  1 Apr 2013 21:18:41 +0200
Message-Id: <1364843930-17974-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing no longer needed ifdefs.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e9c9258..c25997f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -410,14 +410,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
 PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 
-#
-# Platform specific tweaks
-#
-ifneq ($(MAKECMDGOALS),clean)
-ifneq ($(MAKECMDGOALS),tags)
-
--include config/feature-tests.mak
-
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
@@ -507,9 +499,6 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
-endif # MAKECMDGOALS != tags
-endif # MAKECMDGOALS != clean
-
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
-- 
1.7.11.7

