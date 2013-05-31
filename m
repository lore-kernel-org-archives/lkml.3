Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3EaMDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:03:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3EaMDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:03:02 -0400
Date: Fri, 31 May 2013 05:02:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0e433feb109da0a174d838f0a5fb1af144848761@git.kernel.org>
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
In-Reply-To: <1369398928-9809-8-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move libunwind check config into config/Makefile
Git-Commit-ID: 0e433feb109da0a174d838f0a5fb1af144848761
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

Commit-ID:  0e433feb109da0a174d838f0a5fb1af144848761
Gitweb:     http://git.kernel.org/tip/0e433feb109da0a174d838f0a5fb1af144848761
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Mar 2013 00:53:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 14:37:17 +0300

perf tools: Move libunwind check config into config/Makefile

Moving libunwind check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 24 ------------------------
 tools/perf/config/Makefile | 27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 51fac31..7dc6615 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -473,26 +473,6 @@ ifneq ($(MAKECMDGOALS),tags)
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
-# There's only x86 (both 32 and 64) support for CFI unwind so far
-ifneq ($(ARCH),x86)
-	NO_LIBUNWIND := 1
-endif
-
-ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
-
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-	NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
-
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -521,10 +501,6 @@ endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
-	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
-	EXTLIBS += $(LIBUNWIND_LIBS)
-	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 71e737c..438574b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -170,3 +170,30 @@ endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
 endif # NO_LIBELF
+
+# There's only x86 (both 32 and 64) support for CFI unwind so far
+ifneq ($(ARCH),x86)
+	NO_LIBUNWIND := 1
+endif
+
+ifndef NO_LIBUNWIND
+# for linking with debug library, run like:
+# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+ifdef LIBUNWIND_DIR
+	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+endif
+
+FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+	NO_LIBUNWIND := 1
+endif # Libunwind support
+endif # NO_LIBUNWIND
+
+ifndef NO_LIBUNWIND
+	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
+	EXTLIBS += $(LIBUNWIND_LIBS)
+	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
+endif # NO_LIBUNWIND
