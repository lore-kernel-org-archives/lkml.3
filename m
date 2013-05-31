Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3EaMeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:34:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3EaMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:33:57 -0400
Date: Fri, 31 May 2013 05:33:14 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4e22db46495f951d3b652277047639ea60c89d3c@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        bp@alien8.de, namhyung@kernel.org, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, namhyung@kernel.org,
        mingo@elte.hu
In-Reply-To: <1369398928-9809-22-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-22-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add NO_BIONIC variable to confiure bionic setup
Git-Commit-ID: 4e22db46495f951d3b652277047639ea60c89d3c
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

Commit-ID:  4e22db46495f951d3b652277047639ea60c89d3c
Gitweb:     http://git.kernel.org/tip/4e22db46495f951d3b652277047639ea60c89d3c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 May 2013 14:35:24 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 30 May 2013 16:45:02 +0300

perf tools: Add NO_BIONIC variable to confiure bionic setup

Adding NO_BIONIC variable to confiure bionic setup

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-22-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 4 ++++
 tools/perf/config/Makefile | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4275ddc..8f50afe 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -51,6 +51,10 @@ include config/utilities.mak
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
 #
 # Define NO_LIBNUMA if you do not want numa perf benchmark
+#
+# Define NO_LIBAUDIT if you do not want libaudit support
+#
+# Define NO_LIBBIONIC if you do not want bionic support
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8762209..cc464f1 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -131,11 +131,13 @@ CFLAGS += \
 CFLAGS += \
 	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
+ifndef NO_BIONIC
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	BIONIC := 1
 	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 endif
+endif # NO_BIONIC
 
 ifdef NO_LIBELF
 	NO_DWARF := 1
