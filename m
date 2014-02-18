Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaBRVJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:09:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35698 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaBRVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/32] perf callchain: Rename unwind__arch_reg_id into libunwind__arch_reg_id
Date: Tue, 18 Feb 2014 18:08:34 -0300
Message-Id: <1392757731-32619-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Renaming unwind__arch_reg_id into libunwind__arch_reg_id, so it's clear
it's specific to libunwind.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-11-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/arm/util/unwind-libunwind.c | 2 +-
 tools/perf/arch/x86/util/unwind-libunwind.c | 4 ++--
 tools/perf/util/unwind-libunwind.c          | 2 +-
 tools/perf/util/unwind.h                    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/arch/arm/util/unwind-libunwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
index da3dc950550c..729ed69a6664 100644
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
index 456a88cf5b37..3261f68c6a7c 100644
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
index 720a4cae6004..79dbfbbeb5ed 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -469,7 +469,7 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	id = unwind__arch_reg_id(regnum);
+	id = libunwind__arch_reg_id(regnum);
 	if (id < 0)
 		return -EINVAL;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index 356e1d642f9d..18f33b475c46 100644
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
1.8.1.4

