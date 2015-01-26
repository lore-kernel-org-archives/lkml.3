Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbbAZKOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:14:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbbAZKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:22 -0500
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
Subject: [PATCH 23/36] perf build: Add arch powerpc objects building
Date: Mon, 26 Jan 2015 11:12:23 +0100
Message-Id: <1422267156-13873-24-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the powerpc arch objects building under build framework
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
 tools/perf/arch/powerpc/Build      | 1 +
 tools/perf/arch/powerpc/Makefile   | 3 ---
 tools/perf/arch/powerpc/util/Build | 4 ++++
 3 files changed, 5 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/Build

diff --git a/tools/perf/arch/powerpc/Build b/tools/perf/arch/powerpc/Build
index e69de29bb2d1..54afe4a467e7 100644
--- a/tools/perf/arch/powerpc/Build
+++ b/tools/perf/arch/powerpc/Build
@@ -0,0 +1 @@
+libperf-y += util/
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 6f7782bea5dd..7fbca175099e 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -1,6 +1,3 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
 endif
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/powerpc/util/Build b/tools/perf/arch/powerpc/util/Build
new file mode 100644
index 000000000000..0af6e9b3f728
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/Build
@@ -0,0 +1,4 @@
+libperf-y += header.o
+
+libperf-$(CONFIG_DWARF) += dwarf-regs.o
+libperf-$(CONFIG_DWARF) += skip-callchain-idx.o
-- 
1.9.3

