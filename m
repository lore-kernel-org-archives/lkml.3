Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbbAZKZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:25:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbbAZKOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:11 -0500
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
Subject: [PATCH 20/36] perf build: Add arch x86 objects building
Date: Mon, 26 Jan 2015 11:12:20 +0100
Message-Id: <1422267156-13873-21-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the x86 arch objects building under build framework
to be included in the libperf build object.

Adding also arch/$(ARCH)/Build files for the rest of the
archs. The reason for this is that in arch/Build we now do:

  +libperf-y += $(ARCH)/

which would make the build to fail on other architectures,
because the build framework requires 'Build' file in nested
directories and this patch adds it only for x86.

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
 tools/perf/arch/Build           |  1 +
 tools/perf/arch/arm/Build       |  0
 tools/perf/arch/arm64/Build     |  0
 tools/perf/arch/powerpc/Build   |  0
 tools/perf/arch/s390/Build      |  0
 tools/perf/arch/sh/Build        |  0
 tools/perf/arch/sparc/Build     |  0
 tools/perf/arch/x86/Build       |  2 ++
 tools/perf/arch/x86/Makefile    | 15 ---------------
 tools/perf/arch/x86/tests/Build |  2 ++
 tools/perf/arch/x86/util/Build  |  8 ++++++++
 11 files changed, 13 insertions(+), 15 deletions(-)
 create mode 100644 tools/perf/arch/arm/Build
 create mode 100644 tools/perf/arch/arm64/Build
 create mode 100644 tools/perf/arch/powerpc/Build
 create mode 100644 tools/perf/arch/s390/Build
 create mode 100644 tools/perf/arch/sh/Build
 create mode 100644 tools/perf/arch/sparc/Build
 create mode 100644 tools/perf/arch/x86/Build
 create mode 100644 tools/perf/arch/x86/tests/Build
 create mode 100644 tools/perf/arch/x86/util/Build

diff --git a/tools/perf/arch/Build b/tools/perf/arch/Build
index 304f5e76c613..109eb75cf7de 100644
--- a/tools/perf/arch/Build
+++ b/tools/perf/arch/Build
@@ -1 +1,2 @@
 libperf-y += common.o
+libperf-y += $(ARCH)/
diff --git a/tools/perf/arch/arm/Build b/tools/perf/arch/arm/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/arch/arm64/Build b/tools/perf/arch/arm64/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/arch/powerpc/Build b/tools/perf/arch/powerpc/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/arch/s390/Build b/tools/perf/arch/s390/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/arch/sh/Build b/tools/perf/arch/sh/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/arch/sparc/Build b/tools/perf/arch/sparc/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/arch/x86/Build b/tools/perf/arch/x86/Build
new file mode 100644
index 000000000000..41bf61da476a
--- /dev/null
+++ b/tools/perf/arch/x86/Build
@@ -0,0 +1,2 @@
+libperf-y += util/
+libperf-$(CONFIG_DWARF_UNWIND) += tests/
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 9b21881db52f..21322e0385b8 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -1,19 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
-endif
-ifndef NO_LIBDW_DWARF_UNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
-endif
-ifndef NO_DWARF_UNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
-endif
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
-LIB_H += arch/$(ARCH)/util/tsc.h
 HAVE_KVM_STAT_SUPPORT := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/kvm-stat.o
diff --git a/tools/perf/arch/x86/tests/Build b/tools/perf/arch/x86/tests/Build
new file mode 100644
index 000000000000..b30eff9bcc83
--- /dev/null
+++ b/tools/perf/arch/x86/tests/Build
@@ -0,0 +1,2 @@
+libperf-y += regs_load.o
+libperf-y += dwarf-unwind.o
diff --git a/tools/perf/arch/x86/util/Build b/tools/perf/arch/x86/util/Build
new file mode 100644
index 000000000000..cfbccc4e3187
--- /dev/null
+++ b/tools/perf/arch/x86/util/Build
@@ -0,0 +1,8 @@
+libperf-y += header.o
+libperf-y += tsc.o
+libperf-y += kvm-stat.o
+
+libperf-$(CONFIG_DWARF) += dwarf-regs.o
+
+libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
+libperf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
-- 
1.9.3

