Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3EaMQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:16:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57451 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3EaMQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:16:09 -0400
Date: Fri, 31 May 2013 05:15:13 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4ddc929c29d5c07c0b463cdf2300774e20dbdbfd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, bp@alien8.de,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, bp@alien8.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1369398928-9809-18-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-18-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Final touches for CHK config move
Git-Commit-ID: 4ddc929c29d5c07c0b463cdf2300774e20dbdbfd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ddc929c29d5c07c0b463cdf2300774e20dbdbfd
Gitweb:     http://git.kernel.org/tip/4ddc929c29d5c07c0b463cdf2300774e20dbdbfd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 18 Mar 2013 22:04:35 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 15:00:55 +0300

perf tools: Final touches for CHK config move

Removing no longer needed ifdefs.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-18-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 240bf88..74fdd2b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -422,14 +422,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
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
@@ -519,9 +511,6 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
-endif # MAKECMDGOALS != tags
-endif # MAKECMDGOALS != clean
-
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
