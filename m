Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaIWCOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:14:31 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39517 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaIWCOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:14:30 -0400
From: Fathi Boudra <fathi.boudra@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Fathi Boudra <fathi.boudra@linaro.org>
Subject: [PATCH 1/1] tools/perf: add missing include debug.h for arm/arm64
Date: Tue, 23 Sep 2014 05:14:23 +0300
Message-Id: <1411438463-14159-1-git-send-email-fathi.boudra@linaro.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perf build failure on arm/arm64 architectures introduced by 
commit 84f5d36f4 (move pr_* debug macros into debug object):

 arch/arm/util/unwind-libunwind.c: In function 'libunwind__arch_reg_id':
 arch/arm/util/unwind-libunwind.c:43:3: error: implicit declaration
 of function 'pr_err' [-Werror=implicit-function-declaration]
   pr_err("unwind: invalid reg id %d\n", regnum);
   ^
 arch/arm/util/unwind-libunwind.c:43:3: error: nested extern declaration
 of 'pr_err' [-Werror=nested-externs]
 cc1: all warnings being treated as errors
 make[2]: *** [arch/arm/util/unwind-libunwind.o] Error 1
 arch/arm/tests/dwarf-unwind.c: In function 'sample_ustack':
 arch/arm/tests/dwarf-unwind.c:20:3: error: implicit declaration
 of function 'pr_debug' [-Werror=implicit-function-declaration]
   pr_debug("failed to allocate sample uregs data\n");
   ^
 arch/arm/tests/dwarf-unwind.c:20:3: error: nested extern declaration
 of 'pr_debug' [-Werror=nested-externs]
 cc1: all warnings being treated as errors
 make[2]: *** [arch/arm/tests/dwarf-unwind.o] Error 1

Signed-off-by: Fathi Boudra <fathi.boudra@linaro.org>
---
 tools/perf/arch/arm/tests/dwarf-unwind.c      | 1 +
 tools/perf/arch/arm/util/unwind-libunwind.c   | 1 +
 tools/perf/arch/arm64/util/unwind-libunwind.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
index 9f870d2..62eff84 100644
--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -3,6 +3,7 @@
 #include "thread.h"
 #include "map.h"
 #include "event.h"
+#include "debug.h"
 #include "tests/tests.h"
 
 #define STACK_SIZE 8192
diff --git a/tools/perf/arch/arm/util/unwind-libunwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
index 729ed69..62c397e 100644
--- a/tools/perf/arch/arm/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
diff --git a/tools/perf/arch/arm64/util/unwind-libunwind.c b/tools/perf/arch/arm64/util/unwind-libunwind.c
index 436ee43..a87afa9 100644
--- a/tools/perf/arch/arm64/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
-- 
2.1.0

