Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3EaMAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:00:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3EaMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:00:37 -0400
Date: Fri, 31 May 2013 04:59:47 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-cf4cca10f6905229b9269e8f0a300016010320de@git.kernel.org>
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
In-Reply-To: <1369398928-9809-6-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move libelf check config into config/
 Makefile
Git-Commit-ID: cf4cca10f6905229b9269e8f0a300016010320de
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

Commit-ID:  cf4cca10f6905229b9269e8f0a300016010320de
Gitweb:     http://git.kernel.org/tip/cf4cca10f6905229b9269e8f0a300016010320de
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Mar 2013 00:45:08 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:07 +0300

perf tools: Move libelf check config into config/Makefile

Moving libelf check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 46 ---------------------------------------------
 tools/perf/config/Makefile | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index aa6f933..a174c68 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -473,45 +473,6 @@ ifneq ($(MAKECMDGOALS),tags)
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
-ifdef NO_LIBELF
-	NO_DWARF := 1
-	NO_DEMANGLE := 1
-	NO_LIBUNWIND := 1
-else
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
-	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
-	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
-		LIBC_SUPPORT := 1
-	endif
-	ifeq ($(BIONIC),1)
-		LIBC_SUPPORT := 1
-	endif
-	ifeq ($(LIBC_SUPPORT),1)
-		msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
-
-		NO_LIBELF := 1
-		NO_DWARF := 1
-		NO_DEMANGLE := 1
-	else
-		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-	endif
-else
-	# for linking with debug library, run like:
-	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
-	ifdef LIBDW_DIR
-		LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-	endif
-
-	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-		NO_DWARF := 1
-	endif # Dwarf support
-endif # SOURCE_LIBELF
-endif # NO_LIBELF
-
 # There's only x86 (both 32 and 64) support for CFI unwind so far
 ifneq ($(ARCH),x86)
 	NO_LIBUNWIND := 1
@@ -553,13 +514,6 @@ BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
 LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
 else # NO_LIBELF
-BASIC_CFLAGS += -DLIBELF_SUPPORT
-
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-	BASIC_CFLAGS += -DLIBELF_MMAP
-endif
-
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8acbcfe..17614b1 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -108,3 +108,50 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+
+ifdef NO_LIBELF
+	NO_DWARF := 1
+	NO_DEMANGLE := 1
+	NO_LIBUNWIND := 1
+else
+FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
+	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+		LIBC_SUPPORT := 1
+	endif
+	ifeq ($(BIONIC),1)
+		LIBC_SUPPORT := 1
+	endif
+	ifeq ($(LIBC_SUPPORT),1)
+		msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+
+		NO_LIBELF := 1
+		NO_DWARF := 1
+		NO_DEMANGLE := 1
+	else
+		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+	endif
+else
+	# for linking with debug library, run like:
+	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
+	ifdef LIBDW_DIR
+		LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+	endif
+
+	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
+		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+		NO_DWARF := 1
+	endif # Dwarf support
+endif # SOURCE_LIBELF
+endif # NO_LIBELF
+
+ifndef NO_LIBELF
+BASIC_CFLAGS += -DLIBELF_SUPPORT
+FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
+	BASIC_CFLAGS += -DLIBELF_MMAP
+endif
+endif # NO_LIBELF
