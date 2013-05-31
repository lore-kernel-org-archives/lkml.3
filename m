Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3EaMN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:13:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3EaMNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:13:19 -0400
Date: Fri, 31 May 2013 05:12:40 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-58a0abd7375fb41223a96f632f1450ec04ce6ff9@git.kernel.org>
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
In-Reply-To: <1369398928-9809-16-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-16-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move libnuma check config into config
 /Makefile
Git-Commit-ID: 58a0abd7375fb41223a96f632f1450ec04ce6ff9
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

Commit-ID:  58a0abd7375fb41223a96f632f1450ec04ce6ff9
Gitweb:     http://git.kernel.org/tip/58a0abd7375fb41223a96f632f1450ec04ce6ff9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 18 Mar 2013 00:45:27 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 14:58:01 +0300

perf tools: Move libnuma check config into config/Makefile

Moving libnuma check config into config/Makefile

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
Link: http://lkml.kernel.org/r/1369398928-9809-16-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |  9 +--------
 tools/perf/config/Makefile | 11 +++++++++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9276576..11525ac 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -545,14 +545,7 @@ ifeq ($(NO_PERF_REGS),0)
 endif
 
 ifndef NO_LIBNUMA
-	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
-	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
-		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
-	else
-		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-		EXTLIBS += -lnuma
-	endif
+	BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 endif
 
 ifdef ASCIIDOC8
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8c0e43f..124c344 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -379,3 +379,14 @@ ifndef NO_BACKTRACE
 		BASIC_CFLAGS += -DBACKTRACE_SUPPORT
        endif
 endif
+
+ifndef NO_LIBNUMA
+	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
+	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
+		NO_LIBNUMA := 1
+	else
+		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
+		EXTLIBS += -lnuma
+	endif
+endif
