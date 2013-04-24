Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab3DXJnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:43:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758475Ab3DXJjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 18/26] perf tools: Final touches for CHK config move
Date: Wed, 24 Apr 2013 11:37:45 +0200
Message-Id: <1366796273-4780-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74e3cf6..cd19007 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -424,14 +424,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
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
@@ -521,9 +513,6 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
-endif # MAKECMDGOALS != tags
-endif # MAKECMDGOALS != clean
-
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
-- 
1.7.11.7

