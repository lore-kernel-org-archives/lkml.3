Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBVSJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:09:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBVSAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:00:48 -0500
Date: Sat, 22 Feb 2014 09:58:28 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ea3da69df959dfa1c807586c061bfcc4ec7e5e17@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-11-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-11-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Rename unwind__arch_reg_id into libunwind__arch_reg_id
Git-Commit-ID: ea3da69df959dfa1c807586c061bfcc4ec7e5e17
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

Commit-ID:  ea3da69df959dfa1c807586c061bfcc4ec7e5e17
Gitweb:     http://git.kernel.org/tip/ea3da69df959dfa1c807586c061bfcc4ec7e5e17
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:27 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:48 -0300

perf callchain: Rename unwind__arch_reg_id into libunwind__arch_reg_id

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
index 720a4ca..79dbfbb 100644
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
