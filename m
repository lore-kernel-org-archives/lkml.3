Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBVR6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:58:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaBVR6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:58:37 -0500
Date: Sat, 22 Feb 2014 09:58:17 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-436aa749bb193385f6a3b741ddc6bfba61770a6e@git.kernel.org>
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
In-Reply-To: <1389098853-14466-10-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-10-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Separate libunwind code to special object
Git-Commit-ID: 436aa749bb193385f6a3b741ddc6bfba61770a6e
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

Commit-ID:  436aa749bb193385f6a3b741ddc6bfba61770a6e
Gitweb:     http://git.kernel.org/tip/436aa749bb193385f6a3b741ddc6bfba61770a6e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:26 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:48 -0300

perf callchain: Separate libunwind code to special object

We are going to add libdw library support to do dwarf post unwind.

Making the code ready by moving libunwind dwarf post unwind stuff into
separate object.

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
Link: http://lkml.kernel.org/r/1389098853-14466-10-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf                                  | 2 +-
 tools/perf/arch/arm/Makefile                              | 2 +-
 tools/perf/arch/arm/util/{unwind.c => unwind-libunwind.c} | 0
 tools/perf/arch/x86/Makefile                              | 2 +-
 tools/perf/arch/x86/util/{unwind.c => unwind-libunwind.c} | 0
 tools/perf/util/{unwind.c => unwind-libunwind.c}          | 0
 6 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 10fcf33..9ef6b33 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -481,7 +481,7 @@ endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
-  LIB_OBJS += $(OUTPUT)util/unwind.o
+  LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
 endif
 LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
 
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index fe9b61e..67e9b3d 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -3,5 +3,5 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
diff --git a/tools/perf/arch/arm/util/unwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
similarity index 100%
rename from tools/perf/arch/arm/util/unwind.c
rename to tools/perf/arch/arm/util/unwind-libunwind.c
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 948ea6c..4fa9be9 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -3,7 +3,7 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/x86/util/unwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
similarity index 100%
rename from tools/perf/arch/x86/util/unwind.c
rename to tools/perf/arch/x86/util/unwind-libunwind.c
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind-libunwind.c
similarity index 100%
rename from tools/perf/util/unwind.c
rename to tools/perf/util/unwind-libunwind.c
