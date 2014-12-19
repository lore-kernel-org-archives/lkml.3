Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaLSMOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:14:00 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35656 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaLSMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:13:56 -0500
Date: Fri, 19 Dec 2014 13:13:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [GIT PULL] perf fixes and changes for v3.19, #2
Message-ID: <20141219121351.GA18811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: ac931f87a647ca156f65a4c00e7297165e4fa2d8 perf: Fix building warning on ARM 32

A kernel fix plus mostly tooling fixes, but also some tooling 
restructuring and cleanups.

 Thanks,

	Ingo

------------------>
Alexander Yarygin (1):
      perf kvm stat live: Mark events as (x86 only) in help output

Arjun Sreedharan (1):
      calloc/xcalloc: Fix argument order

Arnaldo Carvalho de Melo (22):
      tools lib fs: Adopt filename__read_int from tools/perf/
      tools lib fs: Add sysctl__read_int helper
      perf tools: Use sysctl__read_int instead of ad-hoc copies
      perf evlist: Introduce strerror_mmap method
      perf trace: Provide a better explanation when mmap fails
      perf evlist: Fixup brown paper bag on "hint" for --mmap-pages cmdline arg
      perf evlist: Clarify sterror_mmap variable names
      perf evlist: Improve the strerror_mmap method
      perf trace: Let the perf_evlist__mmap autosize the number of pages to use
      perf evlist: Do not use hard coded value for a mmap_pages default
      tools: Move __ffs implementation to tools/include/asm-generic/bitops/__ffs.h
      tools: Move code originally from linux/log2.h to tools/include/linux/
      tools: Move code originally from asm-generic/atomic.h into tools/include/asm-generic/
      tools: Whitespace prep patches for moving bitops.h
      tools lib: Move asm-generic/bitops/find.h code to tools/include and tools/lib
      tools: Introduce asm-generic/bitops.h
      tools: Move bitops.h from tools/perf/util to tools/
      tools: Adopt fls_long and deps
      tools: Adopt rounddown_pow_of_two and deps
      perf tools: Make the mmap length autotuning more robust
      tools: Adopt roundup_pow_of_two
      perf evlist: Use roundup_pow_of_two

Jiri Olsa (7):
      perf tools: Use single strcmp call instead of two
      perf buildid-cache: Remove extra debugdir variables
      perf buildid cache: Fix -a segfault related to kcore handling
      perf tools: Add --buildid-dir option to set cache directory
      perf tests: Fix attr tests size values to cope with machine state on interrupt ABI changes
      perf/x86/intel/uncore: Make sure only uncore events are collected
      perf: Fix events installation during moving group

Kan Liang (2):
      perf callchain: Fixup parameter handling error message
      perf callchain: Move cpumode resolve code to add_callchain_ip

Mitchell Krome (1):
      perf symbols: Fix use after free in filename__read_build_id

Rabin Vincent (3):
      perf bench: Prepare memcpy for merge
      perf bench: Merge memset into memcpy
      perf bench: Fix memcpy/memset output

Tom Huynh (1):
      perf hists browser: Change print format from %lu to %PRIu64

Wang Nan (1):
      perf: Fix building warning on ARM 32


 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  22 +-
 kernel/events/core.c                          |   4 +-
 scripts/kconfig/mconf.c                       |   4 +-
 tools/include/asm-generic/bitops.h            |  27 +++
 tools/include/asm-generic/bitops/__ffs.h      |  43 ++++
 tools/include/asm-generic/bitops/__fls.h      |   1 +
 tools/include/asm-generic/bitops/atomic.h     |  22 ++
 tools/include/asm-generic/bitops/find.h       |  33 +++
 tools/include/asm-generic/bitops/fls.h        |   1 +
 tools/include/asm-generic/bitops/fls64.h      |   1 +
 tools/include/linux/bitops.h                  |  53 +++++
 tools/include/linux/log2.h                    | 185 ++++++++++++++++
 tools/lib/api/fs/fs.c                         |  34 +++
 tools/lib/api/fs/fs.h                         |   3 +
 tools/lib/util/find_next_bit.c                |  89 ++++++++
 tools/perf/Documentation/perf.txt             |   4 +
 tools/perf/MANIFEST                           |  16 +-
 tools/perf/Makefile.perf                      |  15 +-
 tools/perf/bench/mem-memcpy.c                 | 286 +++++++++++++++++-------
 tools/perf/bench/mem-memset.c                 | 304 --------------------------
 tools/perf/builtin-buildid-cache.c            |  13 +-
 tools/perf/builtin-kvm.c                      |   3 +-
 tools/perf/builtin-trace.c                    |  14 +-
 tools/perf/perf.c                             |  14 +-
 tools/perf/tests/attr/base-record             |   2 +-
 tools/perf/tests/attr/base-stat               |   2 +-
 tools/perf/ui/browsers/hists.c                |   2 +-
 tools/perf/ui/hist.c                          |   4 +-
 tools/perf/util/build-id.c                    |   9 +-
 tools/perf/util/callchain.c                   |   2 +-
 tools/perf/util/config.c                      |  10 +-
 tools/perf/util/evlist.c                      |  57 ++++-
 tools/perf/util/evlist.h                      |   1 +
 tools/perf/util/include/linux/bitops.h        | 162 --------------
 tools/perf/util/machine.c                     |  72 +++---
 tools/perf/util/record.c                      |  11 +-
 tools/perf/util/srcline.c                     |  12 +-
 tools/perf/util/symbol-minimal.c              |   8 +-
 tools/perf/util/util.c                        |  26 +--
 tools/perf/util/util.h                        |  34 +--
 tools/thermal/tmon/sysfs.c                    |   6 +-
 41 files changed, 897 insertions(+), 714 deletions(-)
 create mode 100644 tools/include/asm-generic/bitops.h
 create mode 100644 tools/include/asm-generic/bitops/__ffs.h
 create mode 100644 tools/include/asm-generic/bitops/__fls.h
 create mode 100644 tools/include/asm-generic/bitops/atomic.h
 create mode 100644 tools/include/asm-generic/bitops/find.h
 create mode 100644 tools/include/asm-generic/bitops/fls.h
 create mode 100644 tools/include/asm-generic/bitops/fls64.h
 create mode 100644 tools/include/linux/bitops.h
 create mode 100644 tools/include/linux/log2.h
 create mode 100644 tools/lib/util/find_next_bit.c
 delete mode 100644 tools/perf/bench/mem-memset.c
 delete mode 100644 tools/perf/util/include/linux/bitops.h

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 9762dbd9f3f7..e98f68cfea02 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -276,6 +276,17 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	return box;
 }
 
+/*
+ * Using uncore_pmu_event_init pmu event_init callback
+ * as a detection point for uncore events.
+ */
+static int uncore_pmu_event_init(struct perf_event *event);
+
+static bool is_uncore_event(struct perf_event *event)
+{
+	return event->pmu->event_init == uncore_pmu_event_init;
+}
+
 static int
 uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, bool dogrp)
 {
@@ -290,13 +301,18 @@ uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, b
 		return -EINVAL;
 
 	n = box->n_events;
-	box->event_list[n] = leader;
-	n++;
+
+	if (is_uncore_event(leader)) {
+		box->event_list[n] = leader;
+		n++;
+	}
+
 	if (!dogrp)
 		return n;
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
-		if (event->state <= PERF_EVENT_STATE_OFF)
+		if (!is_uncore_event(event) ||
+		    event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		if (n >= max_count)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3e19d3ebc29c..af0a5ba4e21d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7477,11 +7477,11 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	if (move_group) {
 		synchronize_rcu();
-		perf_install_in_context(ctx, group_leader, event->cpu);
+		perf_install_in_context(ctx, group_leader, group_leader->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_install_in_context(ctx, sibling, event->cpu);
+			perf_install_in_context(ctx, sibling, sibling->cpu);
 			get_ctx(ctx);
 		}
 	}
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 14cea7463a62..4dd37552abc2 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -330,10 +330,10 @@ static void set_subtitle(void)
 	list_for_each_entry(sp, &trail, entries) {
 		if (sp->text) {
 			if (pos) {
-				pos->next = xcalloc(sizeof(*pos), 1);
+				pos->next = xcalloc(1, sizeof(*pos));
 				pos = pos->next;
 			} else {
-				subtitles = pos = xcalloc(sizeof(*pos), 1);
+				subtitles = pos = xcalloc(1, sizeof(*pos));
 			}
 			pos->text = sp->text;
 		}
diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
new file mode 100644
index 000000000000..6eedba1f7732
--- /dev/null
+++ b/tools/include/asm-generic/bitops.h
@@ -0,0 +1,27 @@
+#ifndef __TOOLS_ASM_GENERIC_BITOPS_H
+#define __TOOLS_ASM_GENERIC_BITOPS_H
+
+/*
+ * tools/ copied this from include/asm-generic/bitops.h, bit by bit as it needed
+ * some functions.
+ *
+ * For the benefit of those who are trying to port Linux to another
+ * architecture, here are some C-language equivalents.  You should
+ * recode these in the native assembly language, if at all possible.
+ *
+ * C language equivalents written by Theodore Ts'o, 9/26/92
+ */
+
+#include <asm-generic/bitops/__ffs.h>
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/find.h>
+
+#ifndef _TOOLS_LINUX_BITOPS_H_
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <asm-generic/bitops/atomic.h>
+
+#endif /* __TOOLS_ASM_GENERIC_BITOPS_H */
diff --git a/tools/include/asm-generic/bitops/__ffs.h b/tools/include/asm-generic/bitops/__ffs.h
new file mode 100644
index 000000000000..c94175015a82
--- /dev/null
+++ b/tools/include/asm-generic/bitops/__ffs.h
@@ -0,0 +1,43 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_
+
+#include <asm/types.h>
+
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static __always_inline unsigned long __ffs(unsigned long word)
+{
+	int num = 0;
+
+#if __BITS_PER_LONG == 64
+	if ((word & 0xffffffff) == 0) {
+		num += 32;
+		word >>= 32;
+	}
+#endif
+	if ((word & 0xffff) == 0) {
+		num += 16;
+		word >>= 16;
+	}
+	if ((word & 0xff) == 0) {
+		num += 8;
+		word >>= 8;
+	}
+	if ((word & 0xf) == 0) {
+		num += 4;
+		word >>= 4;
+	}
+	if ((word & 0x3) == 0) {
+		num += 2;
+		word >>= 2;
+	}
+	if ((word & 0x1) == 0)
+		num += 1;
+	return num;
+}
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_ */
diff --git a/tools/include/asm-generic/bitops/__fls.h b/tools/include/asm-generic/bitops/__fls.h
new file mode 100644
index 000000000000..2218b9add4c1
--- /dev/null
+++ b/tools/include/asm-generic/bitops/__fls.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/__fls.h>
diff --git a/tools/include/asm-generic/bitops/atomic.h b/tools/include/asm-generic/bitops/atomic.h
new file mode 100644
index 000000000000..4bccd7c3d5d6
--- /dev/null
+++ b/tools/include/asm-generic/bitops/atomic.h
@@ -0,0 +1,22 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_
+
+#include <asm/types.h>
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / __BITS_PER_LONG] |= 1UL << (nr % __BITS_PER_LONG);
+}
+
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / __BITS_PER_LONG] &= ~(1UL << (nr % __BITS_PER_LONG));
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % __BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / __BITS_PER_LONG])) != 0;
+}
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_ */
diff --git a/tools/include/asm-generic/bitops/find.h b/tools/include/asm-generic/bitops/find.h
new file mode 100644
index 000000000000..31f51547fcd4
--- /dev/null
+++ b/tools/include/asm-generic/bitops/find.h
@@ -0,0 +1,33 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
+
+#ifndef find_next_bit
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
+		size, unsigned long offset);
+#endif
+
+#ifndef find_first_bit
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum number of bits to search
+ *
+ * Returns the bit number of the first set bit.
+ * If no bits are set, returns @size.
+ */
+extern unsigned long find_first_bit(const unsigned long *addr,
+				    unsigned long size);
+
+#endif /* find_first_bit */
+
+#endif /*_TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_ */
diff --git a/tools/include/asm-generic/bitops/fls.h b/tools/include/asm-generic/bitops/fls.h
new file mode 100644
index 000000000000..dbf711a28f71
--- /dev/null
+++ b/tools/include/asm-generic/bitops/fls.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/fls.h>
diff --git a/tools/include/asm-generic/bitops/fls64.h b/tools/include/asm-generic/bitops/fls64.h
new file mode 100644
index 000000000000..980b1f63c047
--- /dev/null
+++ b/tools/include/asm-generic/bitops/fls64.h
@@ -0,0 +1 @@
+#include <../../../../include/asm-generic/bitops/fls64.h>
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
new file mode 100644
index 000000000000..26005a15e7e2
--- /dev/null
+++ b/tools/include/linux/bitops.h
@@ -0,0 +1,53 @@
+#ifndef _TOOLS_LINUX_BITOPS_H_
+#define _TOOLS_LINUX_BITOPS_H_
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <asm/hweight.h>
+
+#ifndef __WORDSIZE
+#define __WORDSIZE (__SIZEOF_LONG__ * 8)
+#endif
+
+#define BITS_PER_LONG __WORDSIZE
+
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
+
+/*
+ * Include this here because some architectures need generic_ffs/fls in
+ * scope
+ *
+ * XXX: this needs to be asm/bitops.h, when we get to per arch optimizations
+ */
+#include <asm-generic/bitops.h>
+
+#define for_each_set_bit(bit, addr, size) \
+	for ((bit) = find_first_bit((addr), (size));		\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_set_bit() but use bit as value to start with */
+#define for_each_set_bit_from(bit, addr, size) \
+	for ((bit) = find_next_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
+
+static inline unsigned fls_long(unsigned long l)
+{
+	if (sizeof(l) == 4)
+		return fls(l);
+	return fls64(l);
+}
+
+#endif
diff --git a/tools/include/linux/log2.h b/tools/include/linux/log2.h
new file mode 100644
index 000000000000..41446668ccce
--- /dev/null
+++ b/tools/include/linux/log2.h
@@ -0,0 +1,185 @@
+/* Integer base 2 logarithm calculation
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _TOOLS_LINUX_LOG2_H
+#define _TOOLS_LINUX_LOG2_H
+
+/*
+ * deal with unrepresentable constant logarithms
+ */
+extern __attribute__((const, noreturn))
+int ____ilog2_NaN(void);
+
+/*
+ * non-constant log of base 2 calculators
+ * - the arch may override these in asm/bitops.h if they can be implemented
+ *   more efficiently than using fls() and fls64()
+ * - the arch is not required to handle n==0 if implementing the fallback
+ */
+static inline __attribute__((const))
+int __ilog2_u32(u32 n)
+{
+	return fls(n) - 1;
+}
+
+static inline __attribute__((const))
+int __ilog2_u64(u64 n)
+{
+	return fls64(n) - 1;
+}
+
+/*
+ *  Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two.
+ */
+
+static inline __attribute__((const))
+bool is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
+/*
+ * round up to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __roundup_pow_of_two(unsigned long n)
+{
+	return 1UL << fls_long(n - 1);
+}
+
+/*
+ * round down to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __rounddown_pow_of_two(unsigned long n)
+{
+	return 1UL << (fls_long(n) - 1);
+}
+
+/**
+ * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
+ * @n - parameter
+ *
+ * constant-capable log of base 2 calculation
+ * - this can be used to initialise global variables from constant data, hence
+ *   the massive ternary operator construction
+ *
+ * selects the appropriately-sized optimised version depending on sizeof(n)
+ */
+#define ilog2(n)				\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n) < 1 ? ____ilog2_NaN() :	\
+		(n) & (1ULL << 63) ? 63 :	\
+		(n) & (1ULL << 62) ? 62 :	\
+		(n) & (1ULL << 61) ? 61 :	\
+		(n) & (1ULL << 60) ? 60 :	\
+		(n) & (1ULL << 59) ? 59 :	\
+		(n) & (1ULL << 58) ? 58 :	\
+		(n) & (1ULL << 57) ? 57 :	\
+		(n) & (1ULL << 56) ? 56 :	\
+		(n) & (1ULL << 55) ? 55 :	\
+		(n) & (1ULL << 54) ? 54 :	\
+		(n) & (1ULL << 53) ? 53 :	\
+		(n) & (1ULL << 52) ? 52 :	\
+		(n) & (1ULL << 51) ? 51 :	\
+		(n) & (1ULL << 50) ? 50 :	\
+		(n) & (1ULL << 49) ? 49 :	\
+		(n) & (1ULL << 48) ? 48 :	\
+		(n) & (1ULL << 47) ? 47 :	\
+		(n) & (1ULL << 46) ? 46 :	\
+		(n) & (1ULL << 45) ? 45 :	\
+		(n) & (1ULL << 44) ? 44 :	\
+		(n) & (1ULL << 43) ? 43 :	\
+		(n) & (1ULL << 42) ? 42 :	\
+		(n) & (1ULL << 41) ? 41 :	\
+		(n) & (1ULL << 40) ? 40 :	\
+		(n) & (1ULL << 39) ? 39 :	\
+		(n) & (1ULL << 38) ? 38 :	\
+		(n) & (1ULL << 37) ? 37 :	\
+		(n) & (1ULL << 36) ? 36 :	\
+		(n) & (1ULL << 35) ? 35 :	\
+		(n) & (1ULL << 34) ? 34 :	\
+		(n) & (1ULL << 33) ? 33 :	\
+		(n) & (1ULL << 32) ? 32 :	\
+		(n) & (1ULL << 31) ? 31 :	\
+		(n) & (1ULL << 30) ? 30 :	\
+		(n) & (1ULL << 29) ? 29 :	\
+		(n) & (1ULL << 28) ? 28 :	\
+		(n) & (1ULL << 27) ? 27 :	\
+		(n) & (1ULL << 26) ? 26 :	\
+		(n) & (1ULL << 25) ? 25 :	\
+		(n) & (1ULL << 24) ? 24 :	\
+		(n) & (1ULL << 23) ? 23 :	\
+		(n) & (1ULL << 22) ? 22 :	\
+		(n) & (1ULL << 21) ? 21 :	\
+		(n) & (1ULL << 20) ? 20 :	\
+		(n) & (1ULL << 19) ? 19 :	\
+		(n) & (1ULL << 18) ? 18 :	\
+		(n) & (1ULL << 17) ? 17 :	\
+		(n) & (1ULL << 16) ? 16 :	\
+		(n) & (1ULL << 15) ? 15 :	\
+		(n) & (1ULL << 14) ? 14 :	\
+		(n) & (1ULL << 13) ? 13 :	\
+		(n) & (1ULL << 12) ? 12 :	\
+		(n) & (1ULL << 11) ? 11 :	\
+		(n) & (1ULL << 10) ? 10 :	\
+		(n) & (1ULL <<  9) ?  9 :	\
+		(n) & (1ULL <<  8) ?  8 :	\
+		(n) & (1ULL <<  7) ?  7 :	\
+		(n) & (1ULL <<  6) ?  6 :	\
+		(n) & (1ULL <<  5) ?  5 :	\
+		(n) & (1ULL <<  4) ?  4 :	\
+		(n) & (1ULL <<  3) ?  3 :	\
+		(n) & (1ULL <<  2) ?  2 :	\
+		(n) & (1ULL <<  1) ?  1 :	\
+		(n) & (1ULL <<  0) ?  0 :	\
+		____ilog2_NaN()			\
+				   ) :		\
+	(sizeof(n) <= 4) ?			\
+	__ilog2_u32(n) :			\
+	__ilog2_u64(n)				\
+ )
+
+/**
+ * roundup_pow_of_two - round the given value up to nearest power of two
+ * @n - parameter
+ *
+ * round the given value up to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define roundup_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 1 :			\
+		(1UL << (ilog2((n) - 1) + 1))	\
+				   ) :		\
+	__roundup_pow_of_two(n)			\
+ )
+
+/**
+ * rounddown_pow_of_two - round the given value down to nearest power of two
+ * @n - parameter
+ *
+ * round the given value down to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define rounddown_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(1UL << ilog2(n))) :		\
+	__rounddown_pow_of_two(n)		\
+ )
+
+#endif /* _TOOLS_LINUX_LOG2_H */
diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index c1b49c36a951..65d9be3f9887 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -7,6 +7,10 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/vfs.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
 
 #include "debugfs.h"
 #include "fs.h"
@@ -163,3 +167,33 @@ const char *name##__mountpoint(void)	\
 
 FS__MOUNTPOINT(sysfs,  FS__SYSFS);
 FS__MOUNTPOINT(procfs, FS__PROCFS);
+
+int filename__read_int(const char *filename, int *value)
+{
+	char line[64];
+	int fd = open(filename, O_RDONLY), err = -1;
+
+	if (fd < 0)
+		return -1;
+
+	if (read(fd, line, sizeof(line)) > 0) {
+		*value = atoi(line);
+		err = 0;
+	}
+
+	close(fd);
+	return err;
+}
+
+int sysctl__read_int(const char *sysctl, int *value)
+{
+	char path[PATH_MAX];
+	const char *procfs = procfs__mountpoint();
+
+	if (!procfs)
+		return -1;
+
+	snprintf(path, sizeof(path), "%s/sys/%s", procfs, sysctl);
+
+	return filename__read_int(path, value);
+}
diff --git a/tools/lib/api/fs/fs.h b/tools/lib/api/fs/fs.h
index cb7049551f33..6caa2bbc6cec 100644
--- a/tools/lib/api/fs/fs.h
+++ b/tools/lib/api/fs/fs.h
@@ -11,4 +11,7 @@
 
 const char *sysfs__mountpoint(void);
 const char *procfs__mountpoint(void);
+
+int filename__read_int(const char *filename, int *value);
+int sysctl__read_int(const char *sysctl, int *value);
 #endif /* __API_FS__ */
diff --git a/tools/lib/util/find_next_bit.c b/tools/lib/util/find_next_bit.c
new file mode 100644
index 000000000000..41b44f65a79e
--- /dev/null
+++ b/tools/lib/util/find_next_bit.c
@@ -0,0 +1,89 @@
+/* find_next_bit.c: fallback find next bit implementation
+ *
+ * Copied from lib/find_next_bit.c to tools/lib/next_bit.c
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <asm/types.h>
+#include <asm/byteorder.h>
+
+#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+
+#ifndef find_next_bit
+/*
+ * Find the next set bit in a memory region.
+ */
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	const unsigned long *p = addr + BITOP_WORD(offset);
+	unsigned long result = offset & ~(BITS_PER_LONG-1);
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	size -= result;
+	offset %= BITS_PER_LONG;
+	if (offset) {
+		tmp = *(p++);
+		tmp &= (~0UL << offset);
+		if (size < BITS_PER_LONG)
+			goto found_first;
+		if (tmp)
+			goto found_middle;
+		size -= BITS_PER_LONG;
+		result += BITS_PER_LONG;
+	}
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found_middle;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+	tmp = *p;
+
+found_first:
+	tmp &= (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found_middle:
+	return result + __ffs(tmp);
+}
+#endif
+
+#ifndef find_first_bit
+/*
+ * Find the first set bit in a memory region.
+ */
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found:
+	return result + __ffs(tmp);
+}
+#endif
diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index d240bb2e5b22..1e8e400b4493 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -18,6 +18,10 @@ OPTIONS
 	  --debug verbose   # sets verbose = 1
 	  --debug verbose=2 # sets verbose = 2
 
+--buildid-dir::
+	Setup buildid cache directory. It has higher priority than
+	buildid.dir config file option.
+
 DESCRIPTION
 -----------
 Performance counters for Linux are a new kernel-based subsystem
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 344c4d3d0a4a..83e2887f91a3 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,17 +4,31 @@ tools/lib/traceevent
 tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/atomic.h
+tools/include/asm-generic/bitops/__ffs.h
+tools/include/asm-generic/bitops/__fls.h
+tools/include/asm-generic/bitops/find.h
+tools/include/asm-generic/bitops/fls64.h
+tools/include/asm-generic/bitops/fls.h
+tools/include/asm-generic/bitops.h
+tools/include/linux/bitops.h
 tools/include/linux/compiler.h
-tools/include/linux/hash.h
 tools/include/linux/export.h
+tools/include/linux/hash.h
+tools/include/linux/log2.h
 tools/include/linux/types.h
+include/asm-generic/bitops/fls64.h
+include/asm-generic/bitops/__fls.h
+include/asm-generic/bitops/fls.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
 include/linux/list.h
 include/linux/hash.h
 include/linux/stringify.h
+lib/find_next_bit.c
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 478efa9b2364..67a03a825b3c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -231,8 +231,16 @@ LIB_H += ../../include/uapi/linux/const.h
 LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
-LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/atomic.h
+LIB_H += ../include/asm-generic/bitops/find.h
+LIB_H += ../include/asm-generic/bitops/fls64.h
+LIB_H += ../include/asm-generic/bitops/fls.h
+LIB_H += ../include/asm-generic/bitops/__ffs.h
+LIB_H += ../include/asm-generic/bitops/__fls.h
+LIB_H += ../include/asm-generic/bitops.h
 LIB_H += ../include/linux/compiler.h
+LIB_H += ../include/linux/log2.h
 LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
@@ -335,6 +343,7 @@ LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
 LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
+LIB_OBJS += $(OUTPUT)util/find_next_bit.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/kallsyms.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
@@ -458,7 +467,6 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
@@ -735,6 +743,9 @@ $(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
 
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 2465141b554b..6c14afe8c1b1 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -13,6 +13,7 @@
 #include "../util/cloexec.h"
 #include "bench.h"
 #include "mem-memcpy-arch.h"
+#include "mem-memset-arch.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -48,20 +49,24 @@ static const struct option options[] = {
 };
 
 typedef void *(*memcpy_t)(void *, const void *, size_t);
+typedef void *(*memset_t)(void *, int, size_t);
 
 struct routine {
 	const char *name;
 	const char *desc;
-	memcpy_t fn;
+	union {
+		memcpy_t memcpy;
+		memset_t memset;
+	} fn;
 };
 
-struct routine routines[] = {
-	{ "default",
-	  "Default memcpy() provided by glibc",
-	  memcpy },
+struct routine memcpy_routines[] = {
+	{ .name = "default",
+	  .desc = "Default memcpy() provided by glibc",
+	  .fn.memcpy = memcpy },
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 
-#define MEMCPY_FN(fn, name, desc) { name, desc, fn },
+#define MEMCPY_FN(_fn, _name, _desc) {.name = _name, .desc = _desc, .fn.memcpy = _fn},
 #include "mem-memcpy-x86-64-asm-def.h"
 #undef MEMCPY_FN
 
@@ -69,7 +74,7 @@ struct routine routines[] = {
 
 	{ NULL,
 	  NULL,
-	  NULL   }
+	  {NULL}   }
 };
 
 static const char * const bench_mem_memcpy_usage[] = {
@@ -110,63 +115,6 @@ static double timeval2double(struct timeval *ts)
 		(double)ts->tv_usec / (double)1000000;
 }
 
-static void alloc_mem(void **dst, void **src, size_t length)
-{
-	*dst = zalloc(length);
-	if (!*dst)
-		die("memory allocation failed - maybe length is too large?\n");
-
-	*src = zalloc(length);
-	if (!*src)
-		die("memory allocation failed - maybe length is too large?\n");
-	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
-	memset(*src, 0, length);
-}
-
-static u64 do_memcpy_cycle(memcpy_t fn, size_t len, bool prefault)
-{
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
-	void *src = NULL, *dst = NULL;
-	int i;
-
-	alloc_mem(&src, &dst, len);
-
-	if (prefault)
-		fn(dst, src, len);
-
-	cycle_start = get_cycle();
-	for (i = 0; i < iterations; ++i)
-		fn(dst, src, len);
-	cycle_end = get_cycle();
-
-	free(src);
-	free(dst);
-	return cycle_end - cycle_start;
-}
-
-static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	void *src = NULL, *dst = NULL;
-	int i;
-
-	alloc_mem(&src, &dst, len);
-
-	if (prefault)
-		fn(dst, src, len);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < iterations; ++i)
-		fn(dst, src, len);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	free(src);
-	free(dst);
-	return (double)((double)len / timeval2double(&tv_diff));
-}
-
 #define pf (no_prefault ? 0 : 1)
 
 #define print_bps(x) do {					\
@@ -180,16 +128,25 @@ static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 			printf(" %14lf GB/Sec", x / K / K / K); \
 	} while (0)
 
-int bench_mem_memcpy(int argc, const char **argv,
-		     const char *prefix __maybe_unused)
+struct bench_mem_info {
+	const struct routine *routines;
+	u64 (*do_cycle)(const struct routine *r, size_t len, bool prefault);
+	double (*do_gettimeofday)(const struct routine *r, size_t len, bool prefault);
+	const char *const *usage;
+};
+
+static int bench_mem_common(int argc, const char **argv,
+		     const char *prefix __maybe_unused,
+		     struct bench_mem_info *info)
 {
 	int i;
 	size_t len;
+	double totallen;
 	double result_bps[2];
 	u64 result_cycle[2];
 
 	argc = parse_options(argc, argv, options,
-			     bench_mem_memcpy_usage, 0);
+			     info->usage, 0);
 
 	if (no_prefault && only_prefault) {
 		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
@@ -200,6 +157,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 		init_cycle();
 
 	len = (size_t)perf_atoll((char *)length_str);
+	totallen = (double)len * iterations;
 
 	result_cycle[0] = result_cycle[1] = 0ULL;
 	result_bps[0] = result_bps[1] = 0.0;
@@ -213,16 +171,16 @@ int bench_mem_memcpy(int argc, const char **argv,
 	if (only_prefault && no_prefault)
 		only_prefault = no_prefault = false;
 
-	for (i = 0; routines[i].name; i++) {
-		if (!strcmp(routines[i].name, routine))
+	for (i = 0; info->routines[i].name; i++) {
+		if (!strcmp(info->routines[i].name, routine))
 			break;
 	}
-	if (!routines[i].name) {
+	if (!info->routines[i].name) {
 		printf("Unknown routine:%s\n", routine);
 		printf("Available routines...\n");
-		for (i = 0; routines[i].name; i++) {
+		for (i = 0; info->routines[i].name; i++) {
 			printf("\t%s ... %s\n",
-			       routines[i].name, routines[i].desc);
+			       info->routines[i].name, info->routines[i].desc);
 		}
 		return 1;
 	}
@@ -234,25 +192,25 @@ int bench_mem_memcpy(int argc, const char **argv,
 		/* show both of results */
 		if (use_cycle) {
 			result_cycle[0] =
-				do_memcpy_cycle(routines[i].fn, len, false);
+				info->do_cycle(&info->routines[i], len, false);
 			result_cycle[1] =
-				do_memcpy_cycle(routines[i].fn, len, true);
+				info->do_cycle(&info->routines[i], len, true);
 		} else {
 			result_bps[0] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				info->do_gettimeofday(&info->routines[i],
 						len, false);
 			result_bps[1] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				info->do_gettimeofday(&info->routines[i],
 						len, true);
 		}
 	} else {
 		if (use_cycle) {
 			result_cycle[pf] =
-				do_memcpy_cycle(routines[i].fn,
+				info->do_cycle(&info->routines[i],
 						len, only_prefault);
 		} else {
 			result_bps[pf] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				info->do_gettimeofday(&info->routines[i],
 						len, only_prefault);
 		}
 	}
@@ -263,10 +221,10 @@ int bench_mem_memcpy(int argc, const char **argv,
 			if (use_cycle) {
 				printf(" %14lf Cycle/Byte\n",
 					(double)result_cycle[0]
-					/ (double)len);
+					/ totallen);
 				printf(" %14lf Cycle/Byte (with prefault)\n",
 					(double)result_cycle[1]
-					/ (double)len);
+					/ totallen);
 			} else {
 				print_bps(result_bps[0]);
 				printf("\n");
@@ -277,7 +235,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 			if (use_cycle) {
 				printf(" %14lf Cycle/Byte",
 					(double)result_cycle[pf]
-					/ (double)len);
+					/ totallen);
 			} else
 				print_bps(result_bps[pf]);
 
@@ -288,8 +246,8 @@ int bench_mem_memcpy(int argc, const char **argv,
 		if (!only_prefault && !no_prefault) {
 			if (use_cycle) {
 				printf("%lf %lf\n",
-					(double)result_cycle[0] / (double)len,
-					(double)result_cycle[1] / (double)len);
+					(double)result_cycle[0] / totallen,
+					(double)result_cycle[1] / totallen);
 			} else {
 				printf("%lf %lf\n",
 					result_bps[0], result_bps[1]);
@@ -297,7 +255,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 		} else {
 			if (use_cycle) {
 				printf("%lf\n", (double)result_cycle[pf]
-					/ (double)len);
+					/ totallen);
 			} else
 				printf("%lf\n", result_bps[pf]);
 		}
@@ -310,3 +268,163 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	return 0;
 }
+
+static void memcpy_alloc_mem(void **dst, void **src, size_t length)
+{
+	*dst = zalloc(length);
+	if (!*dst)
+		die("memory allocation failed - maybe length is too large?\n");
+
+	*src = zalloc(length);
+	if (!*src)
+		die("memory allocation failed - maybe length is too large?\n");
+	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
+	memset(*src, 0, length);
+}
+
+static u64 do_memcpy_cycle(const struct routine *r, size_t len, bool prefault)
+{
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	void *src = NULL, *dst = NULL;
+	memcpy_t fn = r->fn.memcpy;
+	int i;
+
+	memcpy_alloc_mem(&src, &dst, len);
+
+	if (prefault)
+		fn(dst, src, len);
+
+	cycle_start = get_cycle();
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
+	cycle_end = get_cycle();
+
+	free(src);
+	free(dst);
+	return cycle_end - cycle_start;
+}
+
+static double do_memcpy_gettimeofday(const struct routine *r, size_t len,
+				     bool prefault)
+{
+	struct timeval tv_start, tv_end, tv_diff;
+	memcpy_t fn = r->fn.memcpy;
+	void *src = NULL, *dst = NULL;
+	int i;
+
+	memcpy_alloc_mem(&src, &dst, len);
+
+	if (prefault)
+		fn(dst, src, len);
+
+	BUG_ON(gettimeofday(&tv_start, NULL));
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
+	BUG_ON(gettimeofday(&tv_end, NULL));
+
+	timersub(&tv_end, &tv_start, &tv_diff);
+
+	free(src);
+	free(dst);
+	return (double)(((double)len * iterations) / timeval2double(&tv_diff));
+}
+
+int bench_mem_memcpy(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	struct bench_mem_info info = {
+		.routines = memcpy_routines,
+		.do_cycle = do_memcpy_cycle,
+		.do_gettimeofday = do_memcpy_gettimeofday,
+		.usage = bench_mem_memcpy_usage,
+	};
+
+	return bench_mem_common(argc, argv, prefix, &info);
+}
+
+static void memset_alloc_mem(void **dst, size_t length)
+{
+	*dst = zalloc(length);
+	if (!*dst)
+		die("memory allocation failed - maybe length is too large?\n");
+}
+
+static u64 do_memset_cycle(const struct routine *r, size_t len, bool prefault)
+{
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	memset_t fn = r->fn.memset;
+	void *dst = NULL;
+	int i;
+
+	memset_alloc_mem(&dst, len);
+
+	if (prefault)
+		fn(dst, -1, len);
+
+	cycle_start = get_cycle();
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
+	cycle_end = get_cycle();
+
+	free(dst);
+	return cycle_end - cycle_start;
+}
+
+static double do_memset_gettimeofday(const struct routine *r, size_t len,
+				     bool prefault)
+{
+	struct timeval tv_start, tv_end, tv_diff;
+	memset_t fn = r->fn.memset;
+	void *dst = NULL;
+	int i;
+
+	memset_alloc_mem(&dst, len);
+
+	if (prefault)
+		fn(dst, -1, len);
+
+	BUG_ON(gettimeofday(&tv_start, NULL));
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
+	BUG_ON(gettimeofday(&tv_end, NULL));
+
+	timersub(&tv_end, &tv_start, &tv_diff);
+
+	free(dst);
+	return (double)(((double)len * iterations) / timeval2double(&tv_diff));
+}
+
+static const char * const bench_mem_memset_usage[] = {
+	"perf bench mem memset <options>",
+	NULL
+};
+
+static const struct routine memset_routines[] = {
+	{ .name ="default",
+	  .desc = "Default memset() provided by glibc",
+	  .fn.memset = memset },
+#ifdef HAVE_ARCH_X86_64_SUPPORT
+
+#define MEMSET_FN(_fn, _name, _desc) { .name = _name, .desc = _desc, .fn.memset = _fn },
+#include "mem-memset-x86-64-asm-def.h"
+#undef MEMSET_FN
+
+#endif
+
+	{ .name = NULL,
+	  .desc = NULL,
+	  .fn.memset = NULL   }
+};
+
+int bench_mem_memset(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	struct bench_mem_info info = {
+		.routines = memset_routines,
+		.do_cycle = do_memset_cycle,
+		.do_gettimeofday = do_memset_gettimeofday,
+		.usage = bench_mem_memset_usage,
+	};
+
+	return bench_mem_common(argc, argv, prefix, &info);
+}
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
deleted file mode 100644
index 75fc3e65fb2a..000000000000
--- a/tools/perf/bench/mem-memset.c
+++ /dev/null
@@ -1,304 +0,0 @@
-/*
- * mem-memset.c
- *
- * memset: Simple memory set in various ways
- *
- * Trivial clone of mem-memcpy.c.
- */
-
-#include "../perf.h"
-#include "../util/util.h"
-#include "../util/parse-options.h"
-#include "../util/header.h"
-#include "../util/cloexec.h"
-#include "bench.h"
-#include "mem-memset-arch.h"
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/time.h>
-#include <errno.h>
-
-#define K 1024
-
-static const char	*length_str	= "1MB";
-static const char	*routine	= "default";
-static int		iterations	= 1;
-static bool		use_cycle;
-static int		cycle_fd;
-static bool		only_prefault;
-static bool		no_prefault;
-
-static const struct option options[] = {
-	OPT_STRING('l', "length", &length_str, "1MB",
-		    "Specify length of memory to set. "
-		    "Available units: B, KB, MB, GB and TB (upper and lower)"),
-	OPT_STRING('r', "routine", &routine, "default",
-		    "Specify routine to set"),
-	OPT_INTEGER('i', "iterations", &iterations,
-		    "repeat memset() invocation this number of times"),
-	OPT_BOOLEAN('c', "cycle", &use_cycle,
-		    "Use cycles event instead of gettimeofday() for measuring"),
-	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
-		    "Show only the result with page faults before memset()"),
-	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
-		    "Show only the result without page faults before memset()"),
-	OPT_END()
-};
-
-typedef void *(*memset_t)(void *, int, size_t);
-
-struct routine {
-	const char *name;
-	const char *desc;
-	memset_t fn;
-};
-
-static const struct routine routines[] = {
-	{ "default",
-	  "Default memset() provided by glibc",
-	  memset },
-#ifdef HAVE_ARCH_X86_64_SUPPORT
-
-#define MEMSET_FN(fn, name, desc) { name, desc, fn },
-#include "mem-memset-x86-64-asm-def.h"
-#undef MEMSET_FN
-
-#endif
-
-	{ NULL,
-	  NULL,
-	  NULL   }
-};
-
-static const char * const bench_mem_memset_usage[] = {
-	"perf bench mem memset <options>",
-	NULL
-};
-
-static struct perf_event_attr cycle_attr = {
-	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES
-};
-
-static void init_cycle(void)
-{
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
-				       perf_event_open_cloexec_flag());
-
-	if (cycle_fd < 0 && errno == ENOSYS)
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-	else
-		BUG_ON(cycle_fd < 0);
-}
-
-static u64 get_cycle(void)
-{
-	int ret;
-	u64 clk;
-
-	ret = read(cycle_fd, &clk, sizeof(u64));
-	BUG_ON(ret != sizeof(u64));
-
-	return clk;
-}
-
-static double timeval2double(struct timeval *ts)
-{
-	return (double)ts->tv_sec +
-		(double)ts->tv_usec / (double)1000000;
-}
-
-static void alloc_mem(void **dst, size_t length)
-{
-	*dst = zalloc(length);
-	if (!*dst)
-		die("memory allocation failed - maybe length is too large?\n");
-}
-
-static u64 do_memset_cycle(memset_t fn, size_t len, bool prefault)
-{
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
-	void *dst = NULL;
-	int i;
-
-	alloc_mem(&dst, len);
-
-	if (prefault)
-		fn(dst, -1, len);
-
-	cycle_start = get_cycle();
-	for (i = 0; i < iterations; ++i)
-		fn(dst, i, len);
-	cycle_end = get_cycle();
-
-	free(dst);
-	return cycle_end - cycle_start;
-}
-
-static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	void *dst = NULL;
-	int i;
-
-	alloc_mem(&dst, len);
-
-	if (prefault)
-		fn(dst, -1, len);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < iterations; ++i)
-		fn(dst, i, len);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	free(dst);
-	return (double)((double)len / timeval2double(&tv_diff));
-}
-
-#define pf (no_prefault ? 0 : 1)
-
-#define print_bps(x) do {					\
-		if (x < K)					\
-			printf(" %14lf B/Sec", x);		\
-		else if (x < K * K)				\
-			printf(" %14lfd KB/Sec", x / K);	\
-		else if (x < K * K * K)				\
-			printf(" %14lf MB/Sec", x / K / K);	\
-		else						\
-			printf(" %14lf GB/Sec", x / K / K / K); \
-	} while (0)
-
-int bench_mem_memset(int argc, const char **argv,
-		     const char *prefix __maybe_unused)
-{
-	int i;
-	size_t len;
-	double result_bps[2];
-	u64 result_cycle[2];
-
-	argc = parse_options(argc, argv, options,
-			     bench_mem_memset_usage, 0);
-
-	if (no_prefault && only_prefault) {
-		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
-		return 1;
-	}
-
-	if (use_cycle)
-		init_cycle();
-
-	len = (size_t)perf_atoll((char *)length_str);
-
-	result_cycle[0] = result_cycle[1] = 0ULL;
-	result_bps[0] = result_bps[1] = 0.0;
-
-	if ((s64)len <= 0) {
-		fprintf(stderr, "Invalid length:%s\n", length_str);
-		return 1;
-	}
-
-	/* same to without specifying either of prefault and no-prefault */
-	if (only_prefault && no_prefault)
-		only_prefault = no_prefault = false;
-
-	for (i = 0; routines[i].name; i++) {
-		if (!strcmp(routines[i].name, routine))
-			break;
-	}
-	if (!routines[i].name) {
-		printf("Unknown routine:%s\n", routine);
-		printf("Available routines...\n");
-		for (i = 0; routines[i].name; i++) {
-			printf("\t%s ... %s\n",
-			       routines[i].name, routines[i].desc);
-		}
-		return 1;
-	}
-
-	if (bench_format == BENCH_FORMAT_DEFAULT)
-		printf("# Copying %s Bytes ...\n\n", length_str);
-
-	if (!only_prefault && !no_prefault) {
-		/* show both of results */
-		if (use_cycle) {
-			result_cycle[0] =
-				do_memset_cycle(routines[i].fn, len, false);
-			result_cycle[1] =
-				do_memset_cycle(routines[i].fn, len, true);
-		} else {
-			result_bps[0] =
-				do_memset_gettimeofday(routines[i].fn,
-						len, false);
-			result_bps[1] =
-				do_memset_gettimeofday(routines[i].fn,
-						len, true);
-		}
-	} else {
-		if (use_cycle) {
-			result_cycle[pf] =
-				do_memset_cycle(routines[i].fn,
-						len, only_prefault);
-		} else {
-			result_bps[pf] =
-				do_memset_gettimeofday(routines[i].fn,
-						len, only_prefault);
-		}
-	}
-
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
-		if (!only_prefault && !no_prefault) {
-			if (use_cycle) {
-				printf(" %14lf Cycle/Byte\n",
-					(double)result_cycle[0]
-					/ (double)len);
-				printf(" %14lf Cycle/Byte (with prefault)\n ",
-					(double)result_cycle[1]
-					/ (double)len);
-			} else {
-				print_bps(result_bps[0]);
-				printf("\n");
-				print_bps(result_bps[1]);
-				printf(" (with prefault)\n");
-			}
-		} else {
-			if (use_cycle) {
-				printf(" %14lf Cycle/Byte",
-					(double)result_cycle[pf]
-					/ (double)len);
-			} else
-				print_bps(result_bps[pf]);
-
-			printf("%s\n", only_prefault ? " (with prefault)" : "");
-		}
-		break;
-	case BENCH_FORMAT_SIMPLE:
-		if (!only_prefault && !no_prefault) {
-			if (use_cycle) {
-				printf("%lf %lf\n",
-					(double)result_cycle[0] / (double)len,
-					(double)result_cycle[1] / (double)len);
-			} else {
-				printf("%lf %lf\n",
-					result_bps[0], result_bps[1]);
-			}
-		} else {
-			if (use_cycle) {
-				printf("%lf\n", (double)result_cycle[pf]
-					/ (double)len);
-			} else
-				printf("%lf\n", result_bps[pf]);
-		}
-		break;
-	default:
-		/* reaching this means there's some disaster: */
-		die("unknown format: %d\n", bench_format);
-		break;
-	}
-
-	return 0;
-}
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 70385756da63..77d5cae54c6a 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -285,12 +285,11 @@ int cmd_buildid_cache(int argc, const char **argv,
 	struct str_node *pos;
 	int ret = 0;
 	bool force = false;
-	char debugdir[PATH_MAX];
 	char const *add_name_list_str = NULL,
 		   *remove_name_list_str = NULL,
 		   *missing_filename = NULL,
 		   *update_name_list_str = NULL,
-		   *kcore_filename;
+		   *kcore_filename = NULL;
 	char sbuf[STRERR_BUFSIZE];
 
 	struct perf_data_file file = {
@@ -335,13 +334,11 @@ int cmd_buildid_cache(int argc, const char **argv,
 
 	setup_pager();
 
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
 	if (add_name_list_str) {
 		list = strlist__new(true, add_name_list_str);
 		if (list) {
 			strlist__for_each(pos, list)
-				if (build_id_cache__add_file(pos->s, debugdir)) {
+				if (build_id_cache__add_file(pos->s, buildid_dir)) {
 					if (errno == EEXIST) {
 						pr_debug("%s already in the cache\n",
 							 pos->s);
@@ -359,7 +356,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		list = strlist__new(true, remove_name_list_str);
 		if (list) {
 			strlist__for_each(pos, list)
-				if (build_id_cache__remove_file(pos->s, debugdir)) {
+				if (build_id_cache__remove_file(pos->s, buildid_dir)) {
 					if (errno == ENOENT) {
 						pr_debug("%s wasn't in the cache\n",
 							 pos->s);
@@ -380,7 +377,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		list = strlist__new(true, update_name_list_str);
 		if (list) {
 			strlist__for_each(pos, list)
-				if (build_id_cache__update_file(pos->s, debugdir)) {
+				if (build_id_cache__update_file(pos->s, buildid_dir)) {
 					if (errno == ENOENT) {
 						pr_debug("%s wasn't in the cache\n",
 							 pos->s);
@@ -395,7 +392,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 	}
 
 	if (kcore_filename &&
-	    build_id_cache__add_kcore(kcore_filename, debugdir, force))
+	    build_id_cache__add_kcore(kcore_filename, buildid_dir, force))
 		pr_warning("Couldn't add %s\n", kcore_filename);
 
 out:
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 3c0f3d4fb021..0894a817f67e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1293,7 +1293,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		OPT_UINTEGER('d', "display", &kvm->display_time,
 			"time in seconds between display updates"),
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
-			"event for reporting: vmexit, mmio, ioport"),
+			"event for reporting: "
+			"vmexit, mmio (x86 only), ioport (x86 only)"),
 		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
 			"vcpu id to report"),
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 83a4835c8118..badfabc6a01f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2045,7 +2045,6 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	unsigned long before;
 	const bool forks = argc > 0;
 	bool draining = false;
-	char sbuf[STRERR_BUFSIZE];
 
 	trace->live = true;
 
@@ -2106,11 +2105,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_error_open;
 
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
-	if (err < 0) {
-		fprintf(trace->output, "Couldn't mmap the events: %s\n",
-			strerror_r(errno, sbuf, sizeof(sbuf)));
-		goto out_delete_evlist;
-	}
+	if (err < 0)
+		goto out_error_mmap;
 
 	perf_evlist__enable(evlist);
 
@@ -2210,6 +2206,10 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
 	goto out_error;
 
+out_error_mmap:
+	perf_evlist__strerror_mmap(evlist, errno, errbuf, sizeof(errbuf));
+	goto out_error;
+
 out_error_open:
 	perf_evlist__strerror_open(evlist, errno, errbuf, sizeof(errbuf));
 
@@ -2485,7 +2485,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.user_freq     = UINT_MAX,
 			.user_interval = ULLONG_MAX,
 			.no_buffering  = true,
-			.mmap_pages    = 1024,
+			.mmap_pages    = UINT_MAX,
 		},
 		.output = stdout,
 		.show_comm = true,
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 452a8474d29d..3700a7faca6c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -200,6 +200,16 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
+		} else if (!strcmp(cmd, "--buildid-dir")) {
+			if (*argc < 2) {
+				fprintf(stderr, "No directory given for --buildid-dir.\n");
+				usage(perf_usage_string);
+			}
+			set_buildid_dir((*argv)[1]);
+			if (envchanged)
+				*envchanged = 1;
+			(*argv)++;
+			(*argc)--;
 		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
 			perf_debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
 			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
@@ -499,7 +509,7 @@ int main(int argc, const char **argv)
 	}
 	if (!prefixcmp(cmd, "trace")) {
 #ifdef HAVE_LIBAUDIT_SUPPORT
-		set_buildid_dir();
+		set_buildid_dir(NULL);
 		setup_path();
 		argv[0] = "trace";
 		return cmd_trace(argc, argv, NULL);
@@ -514,7 +524,7 @@ int main(int argc, const char **argv)
 	argc--;
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
-	set_buildid_dir();
+	set_buildid_dir(NULL);
 
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index f710b92ccff6..d3095dafed36 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0|1
-size=96
+size=104
 config=0
 sample_period=4000
 sample_type=263
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index dc3ada2470c0..872ed7e24c7c 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0
-size=96
+size=104
 config=0
 sample_period=0
 sample_type=0
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 502daff76ceb..e6bb04b5b09b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1252,7 +1252,7 @@ static int hists__browser_title(struct hists *hists,
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
-			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
+			   "Samples: %lu%c of event '%s', Event count (approx.): %" PRIu64,
 			   nr_samples, unit, ev_name, nr_events);
 
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 2af18376b077..dc0d095f318c 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -162,8 +162,8 @@ static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
 		return ret;
 
 	nr_members = evsel->nr_members;
-	fields_a = calloc(sizeof(*fields_a), nr_members);
-	fields_b = calloc(sizeof(*fields_b), nr_members);
+	fields_a = calloc(nr_members, sizeof(*fields_a));
+	fields_b = calloc(nr_members, sizeof(*fields_b));
 
 	if (!fields_a || !fields_b)
 		goto out;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e8d79e5bfaf7..0c72680a977f 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -410,21 +410,18 @@ int perf_session__cache_build_ids(struct perf_session *session)
 {
 	struct rb_node *nd;
 	int ret;
-	char debugdir[PATH_MAX];
 
 	if (no_buildid_cache)
 		return 0;
 
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
-	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
+	if (mkdir(buildid_dir, 0755) != 0 && errno != EEXIST)
 		return -1;
 
-	ret = machine__cache_build_ids(&session->machines.host, debugdir);
+	ret = machine__cache_build_ids(&session->machines.host, buildid_dir);
 
 	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__cache_build_ids(pos, debugdir);
+		ret |= machine__cache_build_ids(pos, buildid_dir);
 	}
 	return ret ? -1 : 0;
 }
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index cf524a35cc84..64b377e591e4 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -77,7 +77,7 @@ int parse_callchain_record_opt(const char *arg)
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
-				       "needed for -g fp\n");
+				       "needed for --call-graph fp\n");
 			break;
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 57ff826f150b..e18f653cd7db 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -522,7 +522,7 @@ static int buildid_dir_command_config(const char *var, const char *value,
 	const char *v;
 
 	/* same dir for all commands */
-	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
+	if (!strcmp(var, "buildid.dir")) {
 		v = perf_config_dirname(var, value);
 		if (!v)
 			return -1;
@@ -539,12 +539,14 @@ static void check_buildid_dir_config(void)
 	perf_config(buildid_dir_command_config, &c);
 }
 
-void set_buildid_dir(void)
+void set_buildid_dir(const char *dir)
 {
-	buildid_dir[0] = '\0';
+	if (dir)
+		scnprintf(buildid_dir, MAXPATHLEN-1, "%s", dir);
 
 	/* try config file */
-	check_buildid_dir_config();
+	if (buildid_dir[0] == '\0')
+		check_buildid_dir_config();
 
 	/* default to $HOME/.debug */
 	if (buildid_dir[0] == '\0') {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cfbe2b99b9aa..cbab1fb77b1d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -8,6 +8,7 @@
  */
 #include "util.h"
 #include <api/fs/debugfs.h>
+#include <api/fs/fs.h>
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
@@ -24,6 +25,7 @@
 
 #include <linux/bitops.h>
 #include <linux/hash.h>
+#include <linux/log2.h>
 
 static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
@@ -892,10 +894,24 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
 
 static size_t perf_evlist__mmap_size(unsigned long pages)
 {
-	/* 512 kiB: default amount of unprivileged mlocked memory */
-	if (pages == UINT_MAX)
-		pages = (512 * 1024) / page_size;
-	else if (!is_power_of_2(pages))
+	if (pages == UINT_MAX) {
+		int max;
+
+		if (sysctl__read_int("kernel/perf_event_mlock_kb", &max) < 0) {
+			/*
+			 * Pick a once upon a time good value, i.e. things look
+			 * strange since we can't read a sysctl value, but lets not
+			 * die yet...
+			 */
+			max = 512;
+		} else {
+			max -= (page_size / 1024);
+		}
+
+		pages = (max * 1024) / page_size;
+		if (!is_power_of_2(pages))
+			pages = rounddown_pow_of_two(pages);
+	} else if (!is_power_of_2(pages))
 		return 0;
 
 	return (pages + 1) * page_size;
@@ -932,7 +948,7 @@ static long parse_pages_arg(const char *str, unsigned long min,
 		/* leave number of pages at 0 */
 	} else if (!is_power_of_2(pages)) {
 		/* round pages up to next power of 2 */
-		pages = next_pow2_l(pages);
+		pages = roundup_pow_of_two(pages);
 		if (!pages)
 			return -EINVAL;
 		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
@@ -1483,6 +1499,37 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 	return 0;
 }
 
+int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size)
+{
+	char sbuf[STRERR_BUFSIZE], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
+	int pages_attempted = evlist->mmap_len / 1024, pages_max_per_user, printed = 0;
+
+	switch (err) {
+	case EPERM:
+		sysctl__read_int("kernel/perf_event_mlock_kb", &pages_max_per_user);
+		printed += scnprintf(buf + printed, size - printed,
+				     "Error:\t%s.\n"
+				     "Hint:\tCheck /proc/sys/kernel/perf_event_mlock_kb (%d kB) setting.\n"
+				     "Hint:\tTried using %zd kB.\n",
+				     emsg, pages_max_per_user, pages_attempted);
+
+		if (pages_attempted >= pages_max_per_user) {
+			printed += scnprintf(buf + printed, size - printed,
+					     "Hint:\tTry 'sudo sh -c \"echo %d > /proc/sys/kernel/perf_event_mlock_kb\"', or\n",
+					     pages_max_per_user + pages_attempted);
+		}
+
+		printed += scnprintf(buf + printed, size - printed,
+				     "Hint:\tTry using a smaller -m/--mmap-pages value.");
+		break;
+	default:
+		scnprintf(buf, size, "%s", emsg);
+		break;
+	}
+
+	return 0;
+}
+
 void perf_evlist__to_front(struct perf_evlist *evlist,
 			   struct perf_evsel *move_evsel)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649b0c597283..0ba93f67ab94 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -185,6 +185,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
 int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
+int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size);
 
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
deleted file mode 100644
index c3294163de17..000000000000
--- a/tools/perf/util/include/linux/bitops.h
+++ /dev/null
@@ -1,162 +0,0 @@
-#ifndef _PERF_LINUX_BITOPS_H_
-#define _PERF_LINUX_BITOPS_H_
-
-#include <linux/kernel.h>
-#include <linux/compiler.h>
-#include <asm/hweight.h>
-
-#ifndef __WORDSIZE
-#define __WORDSIZE (__SIZEOF_LONG__ * 8)
-#endif
-
-#define BITS_PER_LONG __WORDSIZE
-#define BITS_PER_BYTE           8
-#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
-#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
-#define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
-#define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
-#define BIT_WORD(nr)            ((nr) / BITS_PER_LONG)
-#define BIT_MASK(nr)            (1UL << ((nr) % BITS_PER_LONG))
-
-#define for_each_set_bit(bit, addr, size) \
-	for ((bit) = find_first_bit((addr), (size));		\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-
-/* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_from(bit, addr, size) \
-	for ((bit) = find_next_bit((addr), (size), (bit));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-
-static inline void set_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
-}
-
-static inline void clear_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
-}
-
-static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
-{
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
-}
-
-static inline unsigned long hweight_long(unsigned long w)
-{
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
-}
-
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static __always_inline unsigned long __ffs(unsigned long word)
-{
-	int num = 0;
-
-#if BITS_PER_LONG == 64
-	if ((word & 0xffffffff) == 0) {
-		num += 32;
-		word >>= 32;
-	}
-#endif
-	if ((word & 0xffff) == 0) {
-		num += 16;
-		word >>= 16;
-	}
-	if ((word & 0xff) == 0) {
-		num += 8;
-		word >>= 8;
-	}
-	if ((word & 0xf) == 0) {
-		num += 4;
-		word >>= 4;
-	}
-	if ((word & 0x3) == 0) {
-		num += 2;
-		word >>= 2;
-	}
-	if ((word & 0x1) == 0)
-		num += 1;
-	return num;
-}
-
-typedef const unsigned long __attribute__((__may_alias__)) long_alias_t;
-
-/*
- * Find the first set bit in a memory region.
- */
-static inline unsigned long
-find_first_bit(const unsigned long *addr, unsigned long size)
-{
-	long_alias_t *p = (long_alias_t *) addr;
-	unsigned long result = 0;
-	unsigned long tmp;
-
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-
-	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found:
-	return result + __ffs(tmp);
-}
-
-/*
- * Find the next set bit in a memory region.
- */
-static inline unsigned long
-find_next_bit(const unsigned long *addr, unsigned long size, unsigned long offset)
-{
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + __ffs(tmp);
-}
-
-#endif
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 15dd0a9691ce..94de3e48b490 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1385,19 +1385,46 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 static int add_callchain_ip(struct thread *thread,
 			    struct symbol **parent,
 			    struct addr_location *root_al,
-			    int cpumode,
+			    bool branch_history,
 			    u64 ip)
 {
 	struct addr_location al;
 
 	al.filtered = 0;
 	al.sym = NULL;
-	if (cpumode == -1)
+	if (branch_history)
 		thread__find_cpumode_addr_location(thread, MAP__FUNCTION,
 						   ip, &al);
-	else
+	else {
+		u8 cpumode = PERF_RECORD_MISC_USER;
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			switch (ip) {
+			case PERF_CONTEXT_HV:
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;
+				break;
+			case PERF_CONTEXT_KERNEL:
+				cpumode = PERF_RECORD_MISC_KERNEL;
+				break;
+			case PERF_CONTEXT_USER:
+				cpumode = PERF_RECORD_MISC_USER;
+				break;
+			default:
+				pr_debug("invalid callchain context: "
+					 "%"PRId64"\n", (s64) ip);
+				/*
+				 * It seems the callchain is corrupted.
+				 * Discard all.
+				 */
+				callchain_cursor_reset(&callchain_cursor);
+				return 1;
+			}
+			return 0;
+		}
 		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
 				   ip, &al);
+	}
+
 	if (al.sym != NULL) {
 		if (sort__has_parent && !*parent &&
 		    symbol__match_regex(al.sym, &parent_regex))
@@ -1480,11 +1507,8 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct addr_location *root_al,
 					     int max_stack)
 {
-	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
-	int i;
-	int j;
-	int err;
+	int i, j, err;
 	int skip_idx = -1;
 	int first_call = 0;
 
@@ -1542,10 +1566,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 		for (i = 0; i < nr; i++) {
 			err = add_callchain_ip(thread, parent, root_al,
-					       -1, be[i].to);
+					       true, be[i].to);
 			if (!err)
 				err = add_callchain_ip(thread, parent, root_al,
-						       -1, be[i].from);
+						       true, be[i].from);
 			if (err == -EINVAL)
 				break;
 			if (err)
@@ -1574,36 +1598,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 #endif
 		ip = chain->ips[j];
 
-		if (ip >= PERF_CONTEXT_MAX) {
-			switch (ip) {
-			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;
-				break;
-			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;
-				break;
-			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;
-				break;
-			default:
-				pr_debug("invalid callchain context: "
-					 "%"PRId64"\n", (s64) ip);
-				/*
-				 * It seems the callchain is corrupted.
-				 * Discard all.
-				 */
-				callchain_cursor_reset(&callchain_cursor);
-				return 0;
-			}
-			continue;
-		}
+		err = add_callchain_ip(thread, parent, root_al, false, ip);
 
-		err = add_callchain_ip(thread, parent, root_al,
-				       cpumode, ip);
-		if (err == -EINVAL)
-			break;
 		if (err)
-			return err;
+			return (err < 0) ? err : 0;
 	}
 
 	return 0;
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index cf69325b985f..8acd0df88b5c 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -137,16 +137,7 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 
 static int get_max_rate(unsigned int *rate)
 {
-	char path[PATH_MAX];
-	const char *procfs = procfs__mountpoint();
-
-	if (!procfs)
-		return -1;
-
-	snprintf(path, PATH_MAX,
-		 "%s/sys/kernel/perf_event_max_sample_rate", procfs);
-
-	return filename__read_int(path, (int *) rate);
+	return sysctl__read_int("kernel/perf_event_max_sample_rate", (int *)rate);
 }
 
 static int record_opts__config_freq(struct record_opts *opts)
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index e73b6a5c9e0f..c93fb0c5bd0b 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -20,7 +20,7 @@
 
 struct a2l_data {
 	const char 	*input;
-	unsigned long 	addr;
+	u64	 	addr;
 
 	bool 		found;
 	const char 	*filename;
@@ -147,7 +147,7 @@ static void addr2line_cleanup(struct a2l_data *a2l)
 	free(a2l);
 }
 
-static int addr2line(const char *dso_name, unsigned long addr,
+static int addr2line(const char *dso_name, u64 addr,
 		     char **file, unsigned int *line, struct dso *dso)
 {
 	int ret = 0;
@@ -193,7 +193,7 @@ void dso__free_a2l(struct dso *dso)
 
 #else /* HAVE_LIBBFD_SUPPORT */
 
-static int addr2line(const char *dso_name, unsigned long addr,
+static int addr2line(const char *dso_name, u64 addr,
 		     char **file, unsigned int *line_nr,
 		     struct dso *dso __maybe_unused)
 {
@@ -252,7 +252,7 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
  */
 #define A2L_FAIL_LIMIT 123
 
-char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+char *get_srcline(struct dso *dso, u64 addr, struct symbol *sym,
 		  bool show_sym)
 {
 	char *file = NULL;
@@ -293,10 +293,10 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
 		dso__free_a2l(dso);
 	}
 	if (sym) {
-		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
+		if (asprintf(&srcline, "%s+%" PRIu64, show_sym ? sym->name : "",
 					addr - sym->start) < 0)
 			return SRCLINE_UNKNOWN;
-	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+	} else if (asprintf(&srcline, "%s[%" PRIx64 "]", dso->short_name, addr) < 0)
 		return SRCLINE_UNKNOWN;
 	return srcline;
 }
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index fa585c63f56a..d7efb03b3f9a 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -129,6 +129,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			long offset;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -140,12 +141,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			offset = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, offset, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
@@ -178,6 +180,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			long offset;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -189,12 +192,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			offset = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, offset, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index d5eab3f3323f..b86744f29eef 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -442,23 +442,6 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags)
 	return (unsigned long) -1;
 }
 
-int filename__read_int(const char *filename, int *value)
-{
-	char line[64];
-	int fd = open(filename, O_RDONLY), err = -1;
-
-	if (fd < 0)
-		return -1;
-
-	if (read(fd, line, sizeof(line)) > 0) {
-		*value = atoi(line);
-		err = 0;
-	}
-
-	close(fd);
-	return err;
-}
-
 int filename__read_str(const char *filename, char **buf, size_t *sizep)
 {
 	size_t size = 0, alloc_size = 0;
@@ -523,16 +506,9 @@ const char *get_filename_for_perf_kvm(void)
 
 int perf_event_paranoid(void)
 {
-	char path[PATH_MAX];
-	const char *procfs = procfs__mountpoint();
 	int value;
 
-	if (!procfs)
-		return INT_MAX;
-
-	scnprintf(path, PATH_MAX, "%s/sys/kernel/perf_event_paranoid", procfs);
-
-	if (filename__read_int(path, &value))
+	if (sysctl__read_int("kernel/perf_event_paranoid", &value))
 		return INT_MAX;
 
 	return value;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 419bee030f83..027a5153495c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -153,7 +153,7 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);
-extern void set_buildid_dir(void);
+extern void set_buildid_dir(const char *dir);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
@@ -269,35 +269,6 @@ void event_attr_init(struct perf_event_attr *attr);
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-/*
- *  Determine whether some value is a power of two, where zero is
- * *not* considered a power of two.
- */
-
-static inline __attribute__((const))
-bool is_power_of_2(unsigned long n)
-{
-	return (n != 0 && ((n & (n - 1)) == 0));
-}
-
-static inline unsigned next_pow2(unsigned x)
-{
-	if (!x)
-		return 1;
-	return 1ULL << (32 - __builtin_clz(x - 1));
-}
-
-static inline unsigned long next_pow2_l(unsigned long x)
-{
-#if BITS_PER_LONG == 64
-	if (x <= (1UL << 31))
-		return next_pow2(x);
-	return (unsigned long)next_pow2(x >> 32) << 32;
-#else
-	return next_pow2(x);
-#endif
-}
-
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
@@ -339,11 +310,10 @@ static inline int path__join3(char *bf, size_t size,
 struct dso;
 struct symbol;
 
-char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+char *get_srcline(struct dso *dso, u64 addr, struct symbol *sym,
 		  bool show_sym);
 void free_srcline(char *srcline);
 
-int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
 int perf_event_paranoid(void);
 
diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
index dfe454855cd2..1c12536f2081 100644
--- a/tools/thermal/tmon/sysfs.c
+++ b/tools/thermal/tmon/sysfs.c
@@ -446,7 +446,7 @@ int probe_thermal_sysfs(void)
 		return -1;
 	}
 
-	ptdata.tzi = calloc(sizeof(struct tz_info), ptdata.max_tz_instance+1);
+	ptdata.tzi = calloc(ptdata.max_tz_instance+1, sizeof(struct tz_info));
 	if (!ptdata.tzi) {
 		fprintf(stderr, "Err: allocate tz_info\n");
 		return -1;
@@ -454,8 +454,8 @@ int probe_thermal_sysfs(void)
 
 	/* we still show thermal zone information if there is no cdev */
 	if (ptdata.nr_cooling_dev) {
-		ptdata.cdi = calloc(sizeof(struct cdev_info),
-				ptdata.max_cdev_instance + 1);
+		ptdata.cdi = calloc(ptdata.max_cdev_instance + 1,
+				sizeof(struct cdev_info));
 		if (!ptdata.cdi) {
 			free(ptdata.tzi);
 			fprintf(stderr, "Err: allocate cdev_info\n");
