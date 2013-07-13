Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3GMLJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:09:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:44341 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3GMLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:09:12 -0400
Date: Sat, 13 Jul 2013 13:09:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] perf updates for 3.11
Message-ID: <alpine.DEB.2.02.1307131305160.11918@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   * Fix for do_div() abuse on x86
   * Locking fix in perf core
   * A pile of (build) fixes and cleanups in perf tools

Thanks,

	tglx

------------------>
Adrian Hunter (4):
      perf tools: Fix parse_events_terms() segfault on error path
      perf tools: Fix new_term() missing free on error path
      perf tools: Update symbol_conf.nr_events when processing attribute events
      perf evsel: Fix missing increment in sample parsing

Dave Hansen (1):
      perf/x86: Fix incorrect use of do_div() in NMI warning

David Ahern (1):
      perf evsel: Fix count parameter to read call in event_format__new

Jiri Olsa (5):
      perf record: Remove -A/--append option
      perf record: Remove -f/--force option
      perf tools: Fix -x/--exclude-other option for report command
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario

Joonsoo Kim (2):
      perf tools: Include termios.h explicitly
      tools lib lk: Fix for cross build

Kirill A. Shutemov (1):
      perf bench: Fix memory allocation fail check in mem{set,cpy} workloads

Michael Witten (1):
      perf tools: Revert regression in configuration of Python support

Mike Frysinger (1):
      perf tools: Fix -ldw/-lelf link test when static linking

Namhyung Kim (1):
      perf evlist: Enhance perf_evlist__start_workload()

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Ramkumar Ramachandra (1):
      perf script: Fix broken include in Context.xs

Robert Richter (4):
      tools: Get only verbose output with V=1
      perf tools: Fix output directory of Documentation/
      perf tools: Fix build errors with O and DESTDIR make vars set
      perf tools: Fix perf version generation

Runzhen Wang (1):
      perf tools: fix a typo of a Power7 event name

Stephane Eranian (2):
      perf stat: Avoid sending SIGTERM to random processes
      perf stat: Fix per-socket output bug for uncore events

Waiman Long (1):
      perf symbols: Fix vdso list searching


 .../testing/sysfs-bus-event_source-devices-events  |    2 +-
 arch/powerpc/perf/power7-pmu.c                     |   12 +--
 arch/x86/kernel/nmi.c                              |    7 +-
 kernel/events/core.c                               |   28 ++++++-
 tools/lib/lk/Makefile                              |   17 +++-
 tools/perf/Documentation/Makefile                  |   12 +--
 tools/perf/Documentation/examples.txt              |    4 +-
 tools/perf/Documentation/perf-record.txt           |    8 +-
 tools/perf/Makefile                                |    5 +-
 tools/perf/bench/mem-memcpy.c                      |    4 +-
 tools/perf/bench/mem-memset.c                      |    2 +-
 tools/perf/builtin-diff.c                          |    1 -
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-record.c                        |   85 +++-----------------
 tools/perf/builtin-report.c                        |    3 +-
 tools/perf/builtin-sched.c                         |    1 -
 tools/perf/builtin-stat.c                          |   30 ++++++-
 tools/perf/builtin-timechart.c                     |    4 +-
 tools/perf/builtin-top.c                           |    2 -
 tools/perf/config/Makefile                         |    6 +-
 tools/perf/config/utilities.mak                    |    4 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    2 +-
 tools/perf/util/PERF-VERSION-GEN                   |   21 +++--
 tools/perf/util/dso.c                              |   10 ++-
 tools/perf/util/dso.h                              |    3 +-
 tools/perf/util/evlist.c                           |   10 ++-
 tools/perf/util/evsel.c                            |    4 +-
 tools/perf/util/header.c                           |   15 +---
 tools/perf/util/parse-events.c                     |    4 +-
 tools/perf/util/symbol.c                           |    1 -
 tools/perf/util/util.h                             |    2 +-
 tools/perf/util/vdso.c                             |    2 +-
 tools/scripts/Makefile.include                     |    2 +-
 34 files changed, 154 insertions(+), 163 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 8b25ffb..3c1cc24 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -29,7 +29,7 @@ Description:	Generic performance monitoring events
 
 What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
 		/sys/devices/cpu/events/PM_BRU_FIN
-		/sys/devices/cpu/events/PM_BRU_MPRED
+		/sys/devices/cpu/events/PM_BR_MPRED
 		/sys/devices/cpu/events/PM_CMPLU_STALL
 		/sys/devices/cpu/events/PM_CMPLU_STALL_BRU
 		/sys/devices/cpu/events/PM_CMPLU_STALL_DCACHE_MISS
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 13c3f0e..d1821b8 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -60,7 +60,7 @@
 #define	PME_PM_LD_REF_L1		0xc880
 #define	PME_PM_LD_MISS_L1		0x400f0
 #define	PME_PM_BRU_FIN			0x10068
-#define	PME_PM_BRU_MPRED		0x400f6
+#define	PME_PM_BR_MPRED			0x400f6
 
 #define PME_PM_CMPLU_STALL_FXU			0x20014
 #define PME_PM_CMPLU_STALL_DIV			0x40014
@@ -349,7 +349,7 @@ static int power7_generic_events[] = {
 	[PERF_COUNT_HW_CACHE_REFERENCES] =		PME_PM_LD_REF_L1,
 	[PERF_COUNT_HW_CACHE_MISSES] =			PME_PM_LD_MISS_L1,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PME_PM_BRU_FIN,
-	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BRU_MPRED,
+	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BR_MPRED,
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
@@ -405,7 +405,7 @@ GENERIC_EVENT_ATTR(instructions,		INST_CMPL);
 GENERIC_EVENT_ATTR(cache-references,		LD_REF_L1);
 GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
 GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
-GENERIC_EVENT_ATTR(branch-misses,		BRU_MPRED);
+GENERIC_EVENT_ATTR(branch-misses,		BR_MPRED);
 
 POWER_EVENT_ATTR(CYC,				CYC);
 POWER_EVENT_ATTR(GCT_NOSLOT_CYC,		GCT_NOSLOT_CYC);
@@ -414,7 +414,7 @@ POWER_EVENT_ATTR(INST_CMPL,			INST_CMPL);
 POWER_EVENT_ATTR(LD_REF_L1,			LD_REF_L1);
 POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
 POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
-POWER_EVENT_ATTR(BRU_MPRED,			BRU_MPRED);
+POWER_EVENT_ATTR(BR_MPRED,			BR_MPRED);
 
 POWER_EVENT_ATTR(CMPLU_STALL_FXU,		CMPLU_STALL_FXU);
 POWER_EVENT_ATTR(CMPLU_STALL_DIV,		CMPLU_STALL_DIV);
@@ -449,7 +449,7 @@ static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(LD_REF_L1),
 	GENERIC_EVENT_PTR(LD_MISS_L1),
 	GENERIC_EVENT_PTR(BRU_FIN),
-	GENERIC_EVENT_PTR(BRU_MPRED),
+	GENERIC_EVENT_PTR(BR_MPRED),
 
 	POWER_EVENT_PTR(CYC),
 	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
@@ -458,7 +458,7 @@ static struct attribute *power7_events_attr[] = {
 	POWER_EVENT_PTR(LD_REF_L1),
 	POWER_EVENT_PTR(LD_MISS_L1),
 	POWER_EVENT_PTR(BRU_FIN),
-	POWER_EVENT_PTR(BRU_MPRED),
+	POWER_EVENT_PTR(BR_MPRED),
 
 	POWER_EVENT_PTR(CMPLU_STALL_FXU),
 	POWER_EVENT_PTR(CMPLU_STALL_DIV),
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 0920212..ba77ebc 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -111,7 +111,7 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
 		u64 before, delta, whole_msecs;
-		int decimal_msecs, thishandled;
+		int remainder_ns, decimal_msecs, thishandled;
 
 		before = local_clock();
 		thishandled = a->handler(type, regs);
@@ -123,8 +123,9 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 			continue;
 
 		nmi_longest_ns = delta;
-		whole_msecs = do_div(delta, (1000 * 1000));
-		decimal_msecs = do_div(delta, 1000) % 1000;
+		whole_msecs = delta;
+		remainder_ns = do_div(whole_msecs, (1000 * 1000));
+		decimal_msecs = remainder_ns / 1000;
 		printk_ratelimited(KERN_INFO
 			"INFO: NMI handler (%ps) took too long to run: "
 			"%lld.%03d msecs\n", a->handler, whole_msecs,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1833bc5..eba8fb5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -947,8 +947,18 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
 {
 	struct perf_event_context *ctx;
 
-	rcu_read_lock();
 retry:
+	/*
+	 * One of the few rules of preemptible RCU is that one cannot do
+	 * rcu_read_unlock() while holding a scheduler (or nested) lock when
+	 * part of the read side critical section was preemptible -- see
+	 * rcu_read_unlock_special().
+	 *
+	 * Since ctx->lock nests under rq->lock we must ensure the entire read
+	 * side critical section is non-preemptible.
+	 */
+	preempt_disable();
+	rcu_read_lock();
 	ctx = rcu_dereference(task->perf_event_ctxp[ctxn]);
 	if (ctx) {
 		/*
@@ -964,6 +974,8 @@ retry:
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
+			rcu_read_unlock();
+			preempt_enable();
 			goto retry;
 		}
 
@@ -973,6 +985,7 @@ retry:
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 	return ctx;
 }
 
@@ -1950,7 +1963,16 @@ static int __perf_event_enable(void *info)
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
-	if (WARN_ON_ONCE(!ctx->is_active))
+	/*
+	 * There's a time window between 'ctx->is_active' check
+	 * in perf_event_enable function and this place having:
+	 *   - IRQs on
+	 *   - ctx->lock unlocked
+	 *
+	 * where the task could be killed and 'ctx' deactivated
+	 * by perf_event_exit_task.
+	 */
+	if (!ctx->is_active)
 		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
@@ -7465,7 +7487,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 2c5a197..280dd82 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -3,6 +3,21 @@ include ../../scripts/Makefile.include
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
@@ -14,7 +29,7 @@ LIB_OBJS += $(OUTPUT)debugfs.o
 LIBFILE = liblk.a
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lelf -lpthread -lrt -lm
 ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
 
diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index eb30044..5a37a7c 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -1,12 +1,6 @@
+include ../../scripts/Makefile.include
 include ../config/utilities.mak
 
-OUTPUT := ./
-ifeq ("$(origin O)", "command line")
-  ifneq ($(O),)
-	OUTPUT := $(O)/
-  endif
-endif
-
 MAN1_TXT= \
 	$(filter-out $(addsuffix .txt, $(ARTICLES) $(SP_ARTICLES)), \
 		$(wildcard perf-*.txt)) \
@@ -150,7 +144,7 @@ NO_SUBDIR = :
 endif
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifneq ($(V),1)
 	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
 	QUIET_XMLTO	= @echo '   ' XMLTO $@;
 	QUIET_DB2TEXI	= @echo '   ' DB2TEXI $@;
@@ -277,7 +271,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
diff --git a/tools/perf/Documentation/examples.txt b/tools/perf/Documentation/examples.txt
index 77f9527..a4e3921 100644
--- a/tools/perf/Documentation/examples.txt
+++ b/tools/perf/Documentation/examples.txt
@@ -66,7 +66,7 @@ Furthermore, these tracepoints can be used to sample the workload as
 well. For example the page allocations done by a 'git gc' can be
 captured the following way:
 
- titan:~/git> perf record -f -e kmem:mm_page_alloc -c 1 ./git gc
+ titan:~/git> perf record -e kmem:mm_page_alloc -c 1 ./git gc
  Counting objects: 1148, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (450/450), done.
@@ -120,7 +120,7 @@ Furthermore, call-graph sampling can be done too, of page
 allocations - to see precisely what kind of page allocations there
 are:
 
- titan:~/git> perf record -f -g -e kmem:mm_page_alloc -c 1 ./git gc
+ titan:~/git> perf record -g -e kmem:mm_page_alloc -c 1 ./git gc
  Counting objects: 1148, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (450/450), done.
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d4da111..e297b74 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -65,16 +65,10 @@ OPTIONS
 -r::
 --realtime=::
 	Collect data with this RT SCHED_FIFO priority.
+
 -D::
 --no-delay::
 	Collect data without buffering.
--A::
---append::
-	Append to the output file to do incremental profiling.
-
--f::
---force::
-	Overwrite existing data file. (deprecated)
 
 -c::
 --count=::
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 203cb0e..641fccd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -121,17 +121,16 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-LK_PATH=$(LK_DIR)
-
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(OUTPUT)$(LK_DIR)
+  LK_PATH=$(objtree)/lib/lk/
 else
   LK_PATH=$(OUTPUT)
 endif
 else
   TE_PATH=$(TRACE_EVENT_DIR)
+  LK_PATH=$(LK_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 93c83e3..25fd3f1 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -111,11 +111,11 @@ static double timeval2double(struct timeval *ts)
 static void alloc_mem(void **dst, void **src, size_t length)
 {
 	*dst = zalloc(length);
-	if (!dst)
+	if (!*dst)
 		die("memory allocation failed - maybe length is too large?\n");
 
 	*src = zalloc(length);
-	if (!src)
+	if (!*src)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index c6e4bc5..4a2f120 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -111,7 +111,7 @@ static double timeval2double(struct timeval *ts)
 static void alloc_mem(void **dst, size_t length)
 {
 	*dst = zalloc(length);
-	if (!dst)
+	if (!*dst)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index da8f8eb..0aac5f3 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -607,7 +607,6 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 		input_new = "perf.data.guest";
 	}
 
-	symbol_conf.exclude_other = false;
 	if (symbol__init() < 0)
 		return -1;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 46878da..0259502 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -708,7 +708,7 @@ static int parse_line_opt(const struct option *opt __maybe_unused,
 static int __cmd_record(int argc, const char **argv)
 {
 	const char * const record_args[] = {
-	"record", "-a", "-R", "-f", "-c", "1",
+	"record", "-a", "-R", "-c", "1",
 	"-e", "kmem:kmalloc",
 	"-e", "kmem:kmalloc_node",
 	"-e", "kmem:kfree",
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 4258300..76543a4 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -878,7 +878,7 @@ static int __cmd_report(void)
 static int __cmd_record(int argc, const char **argv)
 {
 	const char *record_args[] = {
-		"record", "-R", "-f", "-m", "1024", "-c", "1",
+		"record", "-R", "-m", "1024", "-c", "1",
 	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fff985c..ecca62e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -61,11 +61,6 @@ static void __handle_on_exit_funcs(void)
 }
 #endif
 
-enum write_mode_t {
-	WRITE_FORCE,
-	WRITE_APPEND
-};
-
 struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
@@ -77,12 +72,8 @@ struct perf_record {
 	int			output;
 	unsigned int		page_size;
 	int			realtime_prio;
-	enum write_mode_t	write_mode;
 	bool			no_buildid;
 	bool			no_buildid_cache;
-	bool			force;
-	bool			file_new;
-	bool			append_file;
 	long			samples;
 	off_t			post_processing_offset;
 };
@@ -200,25 +191,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 	signal(signr, SIG_DFL);
 }
 
-static bool perf_evlist__equal(struct perf_evlist *evlist,
-			       struct perf_evlist *other)
-{
-	struct perf_evsel *pos, *pair;
-
-	if (evlist->nr_entries != other->nr_entries)
-		return false;
-
-	pair = perf_evlist__first(other);
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr) != 0))
-			return false;
-		pair = perf_evsel__next(pair);
-	}
-
-	return true;
-}
-
 static int perf_record__open(struct perf_record *rec)
 {
 	char msg[512];
@@ -273,16 +245,7 @@ try_again:
 		goto out;
 	}
 
-	if (rec->file_new)
-		session->evlist = evlist;
-	else {
-		if (!perf_evlist__equal(session->evlist, evlist)) {
-			fprintf(stderr, "incompatible append\n");
-			rc = -1;
-			goto out;
-		}
- 	}
-
+	session->evlist = evlist;
 	perf_session__set_id_hdr_size(session);
 out:
 	return rc;
@@ -415,23 +378,15 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		if (!strcmp(output_name, "-"))
 			opts->pipe_output = true;
 		else if (!stat(output_name, &st) && st.st_size) {
-			if (rec->write_mode == WRITE_FORCE) {
-				char oldname[PATH_MAX];
-				snprintf(oldname, sizeof(oldname), "%s.old",
-					 output_name);
-				unlink(oldname);
-				rename(output_name, oldname);
-			}
-		} else if (rec->write_mode == WRITE_APPEND) {
-			rec->write_mode = WRITE_FORCE;
+			char oldname[PATH_MAX];
+			snprintf(oldname, sizeof(oldname), "%s.old",
+				 output_name);
+			unlink(oldname);
+			rename(output_name, oldname);
 		}
 	}
 
-	flags = O_CREAT|O_RDWR;
-	if (rec->write_mode == WRITE_APPEND)
-		rec->file_new = 0;
-	else
-		flags |= O_TRUNC;
+	flags = O_CREAT|O_RDWR|O_TRUNC;
 
 	if (opts->pipe_output)
 		output = STDOUT_FILENO;
@@ -445,7 +400,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	rec->output = output;
 
 	session = perf_session__new(output_name, O_WRONLY,
-				    rec->write_mode == WRITE_FORCE, false, NULL);
+				    true, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
@@ -465,12 +420,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
-	if (!rec->file_new) {
-		err = perf_session__read_header(session, output);
-		if (err < 0)
-			goto out_delete_session;
-	}
-
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
 						    argv, opts->pipe_output,
@@ -498,7 +447,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		err = perf_header__write_pipe(output);
 		if (err < 0)
 			goto out_delete_session;
-	} else if (rec->file_new) {
+	} else {
 		err = perf_session__write_header(session, evsel_list,
 						 output, false);
 		if (err < 0)
@@ -869,8 +818,6 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
-	.write_mode = WRITE_FORCE,
-	.file_new   = true,
 };
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
@@ -906,12 +853,8 @@ const struct option record_options[] = {
 		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &record.opts.target.system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('A', "append", &record.append_file,
-			    "append to the output file to do incremental profiling"),
 	OPT_STRING('C', "cpu", &record.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
-	OPT_BOOLEAN('f', "force", &record.force,
-			"overwrite existing data file (deprecated)"),
 	OPT_U64('c', "count", &record.opts.user_interval, "event period to sample"),
 	OPT_STRING('o', "output", &record.output_name, "file",
 		    "output file name"),
@@ -977,16 +920,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc && perf_target__none(&rec->opts.target))
 		usage_with_options(record_usage, record_options);
 
-	if (rec->force && rec->append_file) {
-		ui__error("Can't overwrite and append at the same time."
-			  " You need to choose between -f and -A");
-		usage_with_options(record_usage, record_options);
-	} else if (rec->append_file) {
-		rec->write_mode = WRITE_APPEND;
-	} else {
-		rec->write_mode = WRITE_FORCE;
-	}
-
 	if (nr_cgroups && !rec->opts.target.system_wide) {
 		ui__error("cgroup monitoring only available in"
 			  " system-wide mode\n");
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca98d34..3662047 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -939,8 +939,7 @@ repeat:
 		 */
 		if (!strstr(sort_order, "parent"))
 			sort_parent.elide = 1;
-	} else
-		symbol_conf.exclude_other = false;
+	}
 
 	if (argc) {
 		/*
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6c..fed9ae4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1632,7 +1632,6 @@ static int __cmd_record(int argc, const char **argv)
 		"record",
 		"-a",
 		"-R",
-		"-f",
 		"-m", "1024",
 		"-c", "1",
 		"-e", "sched:sched_switch",
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7e910ba..352fbd7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -87,7 +87,7 @@ static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
 static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
-static pid_t			child_pid			= -1;
+static volatile pid_t		child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
 static bool			big_num				=  true;
@@ -924,7 +924,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 static void print_aggr(char *prefix)
 {
 	struct perf_evsel *counter;
-	int cpu, s, s2, id, nr;
+	int cpu, cpu2, s, s2, id, nr;
 	u64 ena, run, val;
 
 	if (!(aggr_map || aggr_get_id))
@@ -936,7 +936,8 @@ static void print_aggr(char *prefix)
 			val = ena = run = 0;
 			nr = 0;
 			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-				s2 = aggr_get_id(evsel_list->cpus, cpu);
+				cpu2 = perf_evsel__cpus(counter)->map[cpu];
+				s2 = aggr_get_id(evsel_list->cpus, cpu2);
 				if (s2 != id)
 					continue;
 				val += counter->counts->cpu[cpu].val;
@@ -948,7 +949,7 @@ static void print_aggr(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				aggr_printout(counter, cpu, nr);
+				aggr_printout(counter, id, nr);
 
 				fprintf(output, "%*s%s%*s",
 					csv_output ? 0 : 18,
@@ -1148,13 +1149,34 @@ static void skip_signal(int signo)
 		done = 1;
 
 	signr = signo;
+	/*
+	 * render child_pid harmless
+	 * won't send SIGTERM to a random
+	 * process in case of race condition
+	 * and fast PID recycling
+	 */
+	child_pid = -1;
 }
 
 static void sig_atexit(void)
 {
+	sigset_t set, oset;
+
+	/*
+	 * avoid race condition with SIGCHLD handler
+	 * in skip_signal() which is modifying child_pid
+	 * goal is to avoid send SIGTERM to a random
+	 * process
+	 */
+	sigemptyset(&set);
+	sigaddset(&set, SIGCHLD);
+	sigprocmask(SIG_BLOCK, &set, &oset);
+
 	if (child_pid != -1)
 		kill(child_pid, SIGTERM);
 
+	sigprocmask(SIG_SETMASK, &oset, NULL);
+
 	if (signr == -1)
 		return;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index ab4cf232..4536a92 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1005,7 +1005,7 @@ static int __cmd_record(int argc, const char **argv)
 {
 #ifdef SUPPORT_OLD_POWER_EVENTS
 	const char * const record_old_args[] = {
-		"record", "-a", "-R", "-f", "-c", "1",
+		"record", "-a", "-R", "-c", "1",
 		"-e", "power:power_start",
 		"-e", "power:power_end",
 		"-e", "power:power_frequency",
@@ -1014,7 +1014,7 @@ static int __cmd_record(int argc, const char **argv)
 	};
 #endif
 	const char * const record_new_args[] = {
-		"record", "-a", "-R", "-f", "-c", "1",
+		"record", "-a", "-R", "-c", "1",
 		"-e", "power:cpu_frequency",
 		"-e", "power:cpu_idle",
 		"-e", "sched:sched_wakeup",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f036af9..e06c4f8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1130,8 +1130,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
-	symbol_conf.exclude_other = false;
-
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f139dcd..b5d9238 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -39,7 +39,7 @@ src-perf := $(srctree)/tools/perf
 endif
 
 ifeq ($(obj-perf),)
-obj-perf := $(objtree)
+obj-perf := $(OUTPUT)
 endif
 
 ifneq ($(obj-perf),)
@@ -85,7 +85,7 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lelf -lpthread -lrt -lm
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
@@ -165,7 +165,7 @@ else
     LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
   endif
 
-  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
+  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
   ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
     msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
     NO_DWARF := 1
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 8ef3bd3..94d2d4f 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -173,7 +173,7 @@ _ge-abspath = $(if $(is-executable),$(1))
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
 #
 define get-executable-or-default
-$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
 endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
@@ -181,7 +181,7 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options, msg)
-ifndef V
+ifneq ($(V),1)
 TRY_CC_OUTPUT= > /dev/null 2>&1
 endif
 TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index c1e2ed1..8c7ea42 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -23,7 +23,7 @@
 #include "perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
-#include "../../../util/script-event.h"
+#include "../../../util/trace-event.h"
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 055fef3..15a77b7 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -13,13 +13,22 @@ LF='
 # First check if there is a .git to get the version from git describe
 # otherwise try to get the version from the kernel Makefile
 #
-if test -d ../../.git -o -f ../../.git &&
-	VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
+CID=
+TAG=
+if test -d ../../.git -o -f ../../.git
 then
-	VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
-	VN=$(echo "$VN" | sed -e 's/-/./g');
-else
-	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
+	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
+	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
+fi
+if test -z "$TAG"
+then
+	TAG=$(MAKEFLAGS= make -sC ../.. kernelversion)
+fi
+VN="$TAG$CID"
+if test -n "$CID"
+then
+	# format version string, strip trailing zero of sublevel:
+	VN=$(echo "$VN" | sed -e 's/-/./g;s/\([0-9]*[.][0-9]*\)[.]0/\1/')
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6f7d5a9..c4374f0 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -513,10 +513,16 @@ void dsos__add(struct list_head *head, struct dso *dso)
 	list_add_tail(&dso->node, head);
 }
 
-struct dso *dsos__find(struct list_head *head, const char *name)
+struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
 {
 	struct dso *pos;
 
+	if (cmp_short) {
+		list_for_each_entry(pos, head, node)
+			if (strcmp(pos->short_name, name) == 0)
+				return pos;
+		return NULL;
+	}
 	list_for_each_entry(pos, head, node)
 		if (strcmp(pos->long_name, name) == 0)
 			return pos;
@@ -525,7 +531,7 @@ struct dso *dsos__find(struct list_head *head, const char *name)
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
 {
-	struct dso *dso = dsos__find(head, name);
+	struct dso *dso = dsos__find(head, name, false);
 
 	if (!dso) {
 		dso = dso__new(name);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 450199a..d51aaf2 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -133,7 +133,8 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 				const char *short_name, int dso_type);
 
 void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(struct list_head *head, const char *name);
+struct dso *dsos__find(struct list_head *head, const char *name,
+		       bool cmp_short);
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 99b43dd..8065ce8 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -821,6 +821,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		goto out_close_pipes;
 	}
 
+	fcntl(go_pipe[1], F_SETFD, FD_CLOEXEC);
 	evlist->workload.cork_fd = go_pipe[1];
 	close(child_ready_pipe[0]);
 	return 0;
@@ -837,10 +838,17 @@ out_close_ready_pipe:
 int perf_evlist__start_workload(struct perf_evlist *evlist)
 {
 	if (evlist->workload.cork_fd > 0) {
+		char bf;
+		int ret;
 		/*
 		 * Remove the cork, let it rip!
 		 */
-		return close(evlist->workload.cork_fd);
+		ret = write(evlist->workload.cork_fd, &bf, 1);
+		if (ret < 0)
+			perror("enable to write to pipe");
+
+		close(evlist->workload.cork_fd);
+		return ret;
 	}
 
 	return 0;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 63b6f8c..c9c7494 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -124,7 +124,7 @@ struct event_format *event_format__new(const char *sys, const char *name)
 			bf = nbf;
 		}
 
-		n = read(fd, bf + size, BUFSIZ);
+		n = read(fd, bf + size, alloc_size - size);
 		if (n < 0)
 			goto out_free_bf;
 		size += n;
@@ -1170,7 +1170,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		} else {
 			data->user_stack.data = (char *)array;
 			array += size / sizeof(*array);
-			data->user_stack.size = *array;
+			data->user_stack.size = *array++;
 		}
 	}
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 738d3b8..a4dafbe 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2303,29 +2303,18 @@ int perf_session__write_header(struct perf_session *session,
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
-	struct perf_evsel *evsel, *pair = NULL;
+	struct perf_evsel *evsel;
 	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
-	if (session->evlist != evlist)
-		pair = perf_evlist__first(session->evlist);
-
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		evsel->id_offset = lseek(fd, 0, SEEK_CUR);
 		err = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
 		if (err < 0) {
-out_err_write:
 			pr_debug("failed to write perf header\n");
 			return err;
 		}
-		if (session->evlist != evlist) {
-			err = do_write(fd, pair->id, pair->ids * sizeof(u64));
-			if (err < 0)
-				goto out_err_write;
-			evsel->ids += pair->ids;
-			pair = perf_evsel__next(pair);
-		}
 	}
 
 	header->attr_offset = lseek(fd, 0, SEEK_CUR);
@@ -2967,6 +2956,8 @@ int perf_event__process_attr(union perf_event *event,
 		perf_evlist__id_add(evlist, evsel, 0, i, event->attr.id[i]);
 	}
 
+	symbol_conf.nr_events = evlist->nr_entries;
+
 	return 0;
 }
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0f..995fc25 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -860,7 +860,8 @@ int parse_events_terms(struct list_head *terms, const char *str)
 		return 0;
 	}
 
-	parse_events__free_terms(data.terms);
+	if (data.terms)
+		parse_events__free_terms(data.terms);
 	return ret;
 }
 
@@ -1183,6 +1184,7 @@ static int new_term(struct parse_events_term **_term, int type_val,
 		term->val.str = str;
 		break;
 	default:
+		free(term);
 		return -EINVAL;
 	}
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8cf3b54..d5528e1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -32,7 +32,6 @@ int vmlinux_path__nr_entries;
 char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
-	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7a484c9..2732fad 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -72,6 +72,7 @@
 #include "types.h"
 #include <sys/ttydefaults.h>
 #include <lk/debugfs.h>
+#include <termios.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
@@ -274,6 +275,5 @@ void dump_stack(void);
 
 extern unsigned int page_size;
 
-struct winsize;
 void get_term_dimensions(struct winsize *ws);
 #endif /* GIT_COMPAT_UTIL_H */
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index e60951f..3915982 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -91,7 +91,7 @@ void vdso__exit(void)
 
 struct dso *vdso__dso_findnew(struct list_head *head)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME);
+	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
 
 	if (!dso) {
 		char *file;
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index f03e681..0d0506d 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -59,7 +59,7 @@ QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifneq ($(V),1)
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
