Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3EaMMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:12:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3EaML7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:11:59 -0400
Date: Fri, 31 May 2013 05:11:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a1c7c9e7e989c3cf881f72f5d19010fd9890b115@git.kernel.org>
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
In-Reply-To: <1369398928-9809-15-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-15-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move stdlib check config into config/
 Makefile
Git-Commit-ID: a1c7c9e7e989c3cf881f72f5d19010fd9890b115
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

Commit-ID:  a1c7c9e7e989c3cf881f72f5d19010fd9890b115
Gitweb:     http://git.kernel.org/tip/a1c7c9e7e989c3cf881f72f5d19010fd9890b115
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 18 Mar 2013 00:41:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 14:57:41 +0300

perf tools: Move stdlib check config into config/Makefile

Moving stdlib check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-15-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 18 ------------------
 tools/perf/config/Makefile | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e4d99c4..9276576 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -544,24 +544,6 @@ ifeq ($(NO_PERF_REGS),0)
 	endif
 endif
 
-ifndef NO_STRLCPY
-	ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
-		BASIC_CFLAGS += -DHAVE_STRLCPY
-	endif
-endif
-
-ifndef NO_ON_EXIT
-	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
-		BASIC_CFLAGS += -DHAVE_ON_EXIT
-	endif
-endif
-
-ifndef NO_BACKTRACE
-       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
-               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
-       endif
-endif
-
 ifndef NO_LIBNUMA
 	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
 	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 317dafe..8c0e43f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -361,3 +361,21 @@ else
 		endif
 	endif
 endif
+
+ifndef NO_STRLCPY
+	ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
+		BASIC_CFLAGS += -DHAVE_STRLCPY
+	endif
+endif
+
+ifndef NO_ON_EXIT
+	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
+		BASIC_CFLAGS += -DHAVE_ON_EXIT
+	endif
+endif
+
+ifndef NO_BACKTRACE
+       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
+		BASIC_CFLAGS += -DBACKTRACE_SUPPORT
+       endif
+endif
