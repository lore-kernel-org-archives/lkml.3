Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaAGMtC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:49:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaAGMsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:24 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 10/16] perf tools: Rename unwind__arch_reg_id into libunwind__arch_reg_id
Date: Tue,  7 Jan 2014 13:47:27 +0100
Message-Id: <1389098853-14466-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming unwind__arch_reg_id into libunwind__arch_reg_id,
so it's clear it's specific to libunwind.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/arch/arm/util/unwind-libunwind.c | 2 +-
 tools/perf/arch/x86/util/unwind-libunwind.c | 4 ++--
 tools/perf/util/unwind-libunwind.c          | 2 +-
 tools/perf/util/unwind.h                    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/arch/arm/util/unwind-libunwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
index da3dc95..729ed69 100644
--- a/tools/perf/arch/arm/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm/util/unwind-libunwind.c
@@ -4,7 +4,7 @@
 #include "perf_regs.h"
 #include "../../util/unwind.h"
 
-int unwind__arch_reg_id(int regnum)
+int libunwind__arch_reg_id(int regnum)
 {
 	switch (regnum) {
 	case UNW_ARM_R0:
diff --git a/tools/perf/arch/x86/util/unwind-libunwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
index 456a88c..3261f68 100644
--- a/tools/perf/arch/x86/util/unwind-libunwind.c
+++ b/tools/perf/arch/x86/util/unwind-libunwind.c
@@ -5,7 +5,7 @@
 #include "../../util/unwind.h"
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-int unwind__arch_reg_id(int regnum)
+int libunwind__arch_reg_id(int regnum)
 {
 	int id;
 
@@ -69,7 +69,7 @@ int unwind__arch_reg_id(int regnum)
 	return id;
 }
 #else
-int unwind__arch_reg_id(int regnum)
+int libunwind__arch_reg_id(int regnum)
 {
 	int id;
 
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 226586e..95cfb54 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -485,7 +485,7 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	id = unwind__arch_reg_id(regnum);
+	id = libunwind__arch_reg_id(regnum);
 	if (id < 0)
 		return -EINVAL;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index 356e1d6..18f33b4 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -18,7 +18,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
 			struct perf_sample *data, int max_stack);
-int unwind__arch_reg_id(int regnum);
+int libunwind__arch_reg_id(int regnum);
 #else
 static inline int
 unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
-- 
1.8.3.1

