Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbbAQKNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:13:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbAQKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:13:06 -0500
Date: Sat, 17 Jan 2015 02:12:30 -0800
From: tip-bot for Vineet Gupta <tipbot@zytor.com>
Message-ID: <tip-ea1fe3a88763d4dfef7e2529ba606f96e8e6b271@git.kernel.org>
Cc: namhyung@kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Vineet.Gupta1@synopsys.com, Alexey.Brodkin@synopsys.com,
        jolsa@kernel.org, hpa@zytor.com, acme@redhat.com, vgupta@synopsys.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Reply-To: Alexey.Brodkin@synopsys.com, Vineet.Gupta1@synopsys.com,
        tglx@linutronix.de, mingo@kernel.org, namhyung@kernel.org,
        jolsa@kernel.org, peterz@infradead.org, vgupta@synopsys.com,
        acme@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <1421156604-30603-4-git-send-email-vgupta@synopsys.com>
References: <1421156604-30603-4-git-send-email-vgupta@synopsys.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Avoid build splat for syscall numbers with uclibc
Git-Commit-ID: ea1fe3a88763d4dfef7e2529ba606f96e8e6b271
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

Commit-ID:  ea1fe3a88763d4dfef7e2529ba606f96e8e6b271
Gitweb:     http://git.kernel.org/tip/ea1fe3a88763d4dfef7e2529ba606f96e8e6b271
Author:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
AuthorDate: Tue, 13 Jan 2015 19:13:22 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:29 -0300

perf tools: Avoid build splat for syscall numbers with uclibc

This is due to duplicated unistd inclusion (via uClibc headers + kernel headers)
Also seen on ARM uClibc based tools

   ------- ARC build ---------->8-------------

  CC       util/evlist.o
In file included from
~/arc/k.org/arch/arc/include/uapi/asm/unistd.h:25:0,
                 from util/../perf-sys.h:10,
                 from util/../perf.h:15,
                 from util/event.h:7,
                 from util/event.c:3:
~/arc/k.org/include/uapi/asm-generic/unistd.h:906:0:
warning: "__NR_fcntl64" redefined [enabled by default]
 #define __NR_fcntl64 __NR3264_fcntl
 ^
In file included from
~/arc/gnu/INSTALL_1412-arc-2014.12-rc1/arc-snps-linux-uclibc/sysroot/usr/include/sys/syscall.h:24:0,
                 from util/../perf-sys.h:6,
   ----------------->8-------------------

   ------- ARM build ---------->8-------------

  CC FPIC  plugin_scsi.o
In file included from util/../perf-sys.h:9:0,
                 from util/../perf.h:15,
                 from util/cache.h:7,
                 from perf.c:12:
~/arc/k.org/arch/arm/include/uapi/asm/unistd.h:28:0:
warning: "__NR_restart_syscall" redefined [enabled by default]
In file included from
~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/sys/syscall.h:25:0,
                 from util/../perf-sys.h:6,
                 from util/../perf.h:15,
                 from util/cache.h:7,
                 from perf.c:12:
~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/bits/sysnum.h:17:0:
note: this is the location of the previous definition
   ----------------->8-------------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1421156604-30603-4-git-send-email-vgupta@synopsys.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-pipe.c | 2 +-
 tools/perf/builtin-top.c      | 1 -
 tools/perf/perf-sys.h         | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 07a8d76..005cc28 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -19,12 +19,12 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <sys/wait.h>
-#include <linux/unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <assert.h>
 #include <sys/time.h>
 #include <sys/types.h>
+#include <sys/syscall.h>
 
 #include <pthread.h>
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 961cea1..616f0fc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -66,7 +66,6 @@
 #include <sys/utsname.h>
 #include <sys/mman.h>
 
-#include <linux/unistd.h>
 #include <linux/types.h>
 
 static volatile int done;
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index a3b13d7..6ef6816 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -6,7 +6,6 @@
 #include <sys/syscall.h>
 #include <linux/types.h>
 #include <linux/perf_event.h>
-#include <asm/unistd.h>
 
 #if defined(__i386__)
 #define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
