Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3EaMIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:08:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab3EaMIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:08:09 -0400
Date: Fri, 31 May 2013 05:07:32 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-3082cb339fb51b156db66516a80599b958dabbf4@git.kernel.org>
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
In-Reply-To: <1369398928-9809-12-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-12-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move libperl check config into config
 /Makefile
Git-Commit-ID: 3082cb339fb51b156db66516a80599b958dabbf4
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

Commit-ID:  3082cb339fb51b156db66516a80599b958dabbf4
Gitweb:     http://git.kernel.org/tip/3082cb339fb51b156db66516a80599b958dabbf4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 18 Mar 2013 00:19:44 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 14:44:03 +0300

perf tools: Move libperl check config into config/Makefile

Moving libperl check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-12-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 20 +++-----------------
 tools/perf/config/Makefile | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8e59a4d..f856bb5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -530,23 +530,9 @@ ifndef NO_GTK2
 	LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
 endif
 
-ifdef NO_LIBPERL
-	BASIC_CFLAGS += -DNO_LIBPERL
-else
-       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
-       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
-       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
-	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
-
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
-		BASIC_CFLAGS += -DNO_LIBPERL
-	else
-               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
-               EXTLIBS += $(PERL_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-	endif
+ifndef NO_LIBPERL
+	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+	LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
 disable-python = $(eval $(disable-python_code))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8cf0958..a42c7b8 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -240,3 +240,24 @@ ifndef NO_GTK2
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 	endif
 endif
+
+grep-libs  = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+ifdef NO_LIBPERL
+	BASIC_CFLAGS += -DNO_LIBPERL
+else
+	PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+	PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+	PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+		BASIC_CFLAGS += -DNO_LIBPERL
+		NO_LIBPERL := 1
+	else
+		ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+		EXTLIBS += $(PERL_EMBED_LIBADD)
+	endif
+endif
