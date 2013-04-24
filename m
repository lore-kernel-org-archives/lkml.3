Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab3DXJjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758421Ab3DXJjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:07 -0400
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
Subject: [PATCH 14/26] perf tools: Move libbfd check config into config/Makefile
Date: Wed, 24 Apr 2013 11:37:41 +0200
Message-Id: <1366796273-4780-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libbfd check config into config/Makefile.

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
 tools/perf/Makefile        | 37 -------------------------------------
 tools/perf/config/Makefile | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 899ef12..c116417 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -540,43 +540,6 @@ ifndef NO_LIBPYTHON
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
index d5e0386..68c6a2b 100644
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
1.7.11.7

