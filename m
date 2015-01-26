Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbbAZKPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:15:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbbAZKPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:15:05 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/36] perf build: Add arch arm objects building
Date: Mon, 26 Jan 2015 11:12:21 +0100
Message-Id: <1422267156-13873-22-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the arm arch objects building under build framework
to be included in the libperf build object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/arch/arm/Build       |  2 ++
 tools/perf/arch/arm/Makefile    | 11 -----------
 tools/perf/arch/arm/tests/Build |  2 ++
 tools/perf/arch/arm/util/Build  |  4 ++++
 4 files changed, 8 insertions(+), 11 deletions(-)
 create mode 100644 tools/perf/arch/arm/tests/Build
 create mode 100644 tools/perf/arch/arm/util/Build

diff --git a/tools/perf/arch/arm/Build b/tools/perf/arch/arm/Build
index e69de29bb2d1..41bf61da476a 100644
--- a/tools/perf/arch/arm/Build
+++ b/tools/perf/arch/arm/Build
@@ -0,0 +1,2 @@
+libperf-y += util/
+libperf-$(CONFIG_DWARF_UNWIND) += tests/
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 09d62153d384..7fbca175099e 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -1,14 +1,3 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
-endif
-ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
-endif
-ifndef NO_LIBDW_DWARF_UNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
-endif
-ifndef NO_DWARF_UNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/arm/tests/Build b/tools/perf/arch/arm/tests/Build
new file mode 100644
index 000000000000..b30eff9bcc83
--- /dev/null
+++ b/tools/perf/arch/arm/tests/Build
@@ -0,0 +1,2 @@
+libperf-y += regs_load.o
+libperf-y += dwarf-unwind.o
diff --git a/tools/perf/arch/arm/util/Build b/tools/perf/arch/arm/util/Build
new file mode 100644
index 000000000000..d22e3d07de3d
--- /dev/null
+++ b/tools/perf/arch/arm/util/Build
@@ -0,0 +1,4 @@
+libperf-$(CONFIG_DWARF) += dwarf-regs.o
+
+libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
+libperf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
-- 
1.9.3

