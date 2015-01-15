Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbbAOM5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:57:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbbAOM5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:57:14 -0500
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
Subject: [PATCH 22/36] perf build: Add arch arm64 objects building
Date: Thu, 15 Jan 2015 13:55:18 +0100
Message-Id: <1421326532-25660-23-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the arm64 arch objects building under build framework
to be included in the libperf build object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
 tools/perf/arch/arm64/Build      | 3 +++
 tools/perf/arch/arm64/Makefile   | 4 ----
 tools/perf/arch/arm64/util/Build | 2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/arch/arm64/util/Build

diff --git a/tools/perf/arch/arm64/Build b/tools/perf/arch/arm64/Build
index e69de29bb2d1..3bfe380bbf4e 100644
--- a/tools/perf/arch/arm64/Build
+++ b/tools/perf/arch/arm64/Build
@@ -0,0 +1,3 @@
+ifneq ($(CONFIG_DWARF)$(CONFIG_LIBUNWIND),)
+libperf-y += util/
+endif
diff --git a/tools/perf/arch/arm64/Makefile b/tools/perf/arch/arm64/Makefile
index 67e9b3d38e89..7fbca175099e 100644
--- a/tools/perf/arch/arm64/Makefile
+++ b/tools/perf/arch/arm64/Makefile
@@ -1,7 +1,3 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
-endif
-ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
diff --git a/tools/perf/arch/arm64/util/Build b/tools/perf/arch/arm64/util/Build
new file mode 100644
index 000000000000..e58123a8912b
--- /dev/null
+++ b/tools/perf/arch/arm64/util/Build
@@ -0,0 +1,2 @@
+libperf-$(CONFIG_DWARF)     += dwarf-regs.o
+libperf-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
-- 
1.9.3

