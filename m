Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935118Ab3E3QHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:07:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934822Ab3E3QCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 45/66] perf tools: Move libbfd check config into config/Makefile
Date: Thu, 30 May 2013 19:01:18 +0300
Message-Id: <1369929699-8724-46-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving libbfd check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-14-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 37 -------------------------------------
 tools/perf/config/Makefile | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 061de65..e4d99c4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -538,43 +538,6 @@ ifndef NO_LIBPYTHON
 	LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 endif
 
-ifdef NO_DEMANGLE
-	BASIC_CFLAGS += -DNO_DEMANGLE
-else
-	ifdef HAVE_CPLUS_DEMANGLE
-		EXTLIBS += -liberty
-		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-	else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-		ifeq ($(has_bfd),y)
-			EXTLIBS += -lbfd
-		else
-			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
-			ifeq ($(has_bfd_iberty),y)
-				EXTLIBS += -lbfd -liberty
-			else
-				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
-				ifeq ($(has_bfd_iberty_z),y)
-					EXTLIBS += -lbfd -liberty -lz
-				else
-					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
-					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
-					ifeq ($(has_cplus_demangle),y)
-						EXTLIBS += -liberty
-						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-					else
-						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-						BASIC_CFLAGS += -DNO_DEMANGLE
-					endif
-				endif
-			endif
-		endif
-	endif
-endif
-
 ifeq ($(NO_PERF_REGS),0)
 	ifeq ($(ARCH),x86)
 		LIB_H += arch/x86/include/perf_regs.h
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b9b1465..317dafe 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -324,3 +324,40 @@ else
     endif
   endif
 endif
+
+ifdef NO_DEMANGLE
+	BASIC_CFLAGS += -DNO_DEMANGLE
+else
+	ifdef HAVE_CPLUS_DEMANGLE
+		EXTLIBS += -liberty
+		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+	else
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
+		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
+		ifeq ($(has_bfd),y)
+			EXTLIBS += -lbfd
+		else
+			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
+			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
+			ifeq ($(has_bfd_iberty),y)
+				EXTLIBS += -lbfd -liberty
+			else
+				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
+				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
+				ifeq ($(has_bfd_iberty_z),y)
+					EXTLIBS += -lbfd -liberty -lz
+				else
+					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
+					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
+					ifeq ($(has_cplus_demangle),y)
+						EXTLIBS += -liberty
+						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+					else
+						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+						BASIC_CFLAGS += -DNO_DEMANGLE
+					endif
+				endif
+			endif
+		endif
+	endif
+endif
-- 
1.8.1.4

