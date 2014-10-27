Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaJ0Qrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:47:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16359 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaJ0Qri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:38 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-c0-544e7727ce93
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 00/12] Kernel address sanitizer - runtime memory debugger.
Date: Mon, 27 Oct 2014 19:46:47 +0300
Message-id: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAy2Ra0iTYRiGe7/zhoOvafk1RGrVSkE7UPRSoUYUb4VRMUiKyKnzEE5lXzMP
	P7Isy5ljKDY1ydWSdAjqFHWislRc4BEPEy1Ny0OSh9TKSFw57d/13PcN14+HwcW5hISJibur
	VMcpYqWUkOhw2h1+B+5dlh/uaKBh7Z/PFFxrKiBhUUU5BdscqzQc+jUH4KTtCYDLs+MA1gw9
	xODMxAQN9RMZNHxe5QnLstIpWDc9j8GyzHES9jcUUXCs/C8J+2xGDD5q7sVgxoqThPZsGwbn
	PxoImPGmCoOmtg84XJjOxWG1JQ+Hg+Z3NOxZt5Pwd+UXMsgLFVuXALIWjtLIaNGg6lJfZGqc
	xZDFnEkhy3IOjbTzAxha6O6m0fv8NQJNDhgwZNLlkmhpaoRAi82DFNLVmAHqNLbRV9xvCE9H
	KGNjEpXqQwGhwuj8ZQue8EmetGhXpoGiQC0QMBx7jCtufUVs8U6ud6yC0gIhI2ZLAFddV/f/
	0GFco7YKc60o1p9zFroKAePB+nHmmQbcNcJZB8197xkiXYU7G8zlpOmAiwl2P/fSmLXJIvY8
	p8+z41s6b87QNLqpFrhyg2MjZzZs5zh9qUwPREawzQx2KDXhCXxYlOqoP69Q8Zq4KP/weJUF
	bD3yZz0oaT/ZAlgGSN1Eej5YLiYViXyyqgVwDC71ENkiL8vFoghFcopSHX9brYlV8i0AYwSS
	NJA1fMF7NSR0JHBfeoUv1p2ye3LulmxquFjS2VV5ak0x+uNmQSTWd/W429N0GXYCs94J36MP
	6fAJ61c/kJRctHs58bHUgJXevdnPcr5mv0gwpV63NHZtf3y2uX291Uc347PrrbW+R1cmA0kH
	tQOmxJJaz2/XUutRzeuoS0Fn+nT3pQQfrTjii6t5xT/s4VgLpgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KASan is a runtime memory debugger designed to find use-after-free
and out-of-bounds bugs.

Currently KASAN supported only for x86_64 architecture and requires kernel
to be build with SLUB allocator.
KASAN uses compile-time instrumentation for checking every memory access, therefore you
will need a fresh GCC >= v4.9.2

Patches are based on mmotm-2014-10-23-16-26 tree and also avaliable in git:

	git://github.com/aryabinin/linux --branch=kasan/kasan_v5

Changes since v4:
    - rebased on top of mmotm-2014-10-23-16-26

    - merge patch 'efi: libstub: disable KASAN for efistub in' into the first patch.
        No reason to keep it separate.

    - Added support for upcoming asan ABI changes in GCC 5.0 (second patch).
        GCC patch has not been published/upstreamed yet, but to will be soon. I'm adding this in advance
        in order to avoid breaking kasan with future GCC update.
        Details about gcc ABI changes in this thread: https://gcc.gnu.org/ml/gcc-patches/2014-10/msg02510.html

    - Updated GCC verison requirements in doc (GCC kasan patches were backported into 4.9 branch)

    - Dropped last patch with inline instrumentation support. At first let's wait for merging GCC patches.

Changes since v3:

    - rebased on last mm
    - Added comment about rcu slabs.
    - Removed useless kasan_free_slab_pages().
    - Removed __asan_init_v*() stub. GCC doesn't generate this call anymore:
       https://gcc.gnu.org/ml/gcc-patches/2014-10/msg00269.html
    - Replaced CALL_KASAN_REPORT define with inline function

Changes since v2:

    - Shadow moved to vmalloc area.
    - Added posion page. This page mapped to shadow correspondig to
      shadow region itself:
       [kasan_mem_to_shadow(KASAN_SHADOW_START) - kasan_mem_to_shadow(KASAN_SHADOW_END)]
      It used to catch memory access to shadow outside mm/kasan/.

    - Fixed boot with CONFIG_DEBUG_VIRTUAL=y
    - Fixed boot with KASan and stack protector enabled
         (patch "x86_64: load_percpu_segment: read irq_stack_union.gs_base before load_segment")

    - Fixed build with CONFIG_EFI_STUB=y
    - Some slub specific stuf moved from mm/slab.h to include/linux/slub_def.h
    - Fixed Kconfig dependency. CONFIG_KASAN depends on CONFIG_SLUB_DEBUG.
    - Optimizations of __asan_load/__asan_store.
    - Spelling fixes from Randy.
    - Misc minor cleanups in different places.


    - Added inline instrumentation in last patch. This will require two not
         yet-in-trunk-patches for GCC:
             https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00452.html
             https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00605.html

Changes since v1:

    - The main change is in shadow memory laoyut.
      Now for shadow memory we reserve 1/8 of all virtual addresses available for kernel.
      16TB on x86_64 to cover all 128TB of kernel's address space.
      At early stage we map whole shadow region with zero page.
      Latter, after physical memory mapped to direct mapping address range
      we unmap zero pages from corresponding shadow and allocate and map a real
      memory.

     - Since per-arch work is much bigger now, support for arm/x86_32 platforms was dropped.

     - CFLAGS was change from -fsanitize=address with different --params to -fsanitize=kernel-address

     - If compiler doesn't support -fsanitize=kernel-address warning printed and build continues without -fsanitize

     - Removed kasan_memset/kasan_memcpy/kasan_memmove hooks. It turned out that this hooks are not needed. Compiler
       already instrument memset/memcpy/memmove (inserts __asan_load/__asan_store call before mem*() calls).

     - branch profiling disabled for mm/kasan/kasan.c to avoid recursion (__asan_load -> ftrace_likely_update -> __asan_load -> ...)

     - kasan hooks for buddy allocator moved to right places


Comparison with other debuggin features:
=======================================

KMEMCHECK:
	- KASan can do almost everything that kmemcheck can. KASan uses compile-time
	  instrumentation, which makes it significantly faster than kmemcheck.
	  The only advantage of kmemcheck over KASan is detection of unitialized
	  memory reads.

DEBUG_PAGEALLOC:
	- KASan is slower than DEBUG_PAGEALLOC, but KASan works on sub-page
	  granularity level, so it able to find more bugs.

SLUB_DEBUG (poisoning, redzones):
	- SLUB_DEBUG has lower overhead than KASan.

	- SLUB_DEBUG in most cases are not able to detect bad reads,
	  KASan able to detect both reads and writes.

	- In some cases (e.g. redzone overwritten) SLUB_DEBUG detect
	  bugs only on allocation/freeing of object. KASan catch
	  bugs right before it will happen, so we always know exact
	  place of first bad read/write.


Basic idea:
===========

    The main idea of KASAN is to use shadow memory to record whether each byte of memory
    is safe to access or not, and use compiler's instrumentation to check the shadow memory
    on each memory access.

    Address sanitizer uses 1/8 of the memory addressable in kernel for shadow memory
    (on x86_64 16TB of virtual address space reserved for shadow to cover all 128TB)
    and uses direct mapping with a scale and offset to translate a memory
    address to its corresponding shadow address.

    Here is function to translate address to corresponding shadow address:

         unsigned long kasan_mem_to_shadow(unsigned long addr)
         {
                    return (addr >> KASAN_SHADOW_SCALE_SHIFT) + KASAN_SHADOW_OFFSET;
         }
    where KASAN_SHADOW_SCALE_SHIFT = 3.

    So for every 8 bytes there is one corresponding byte of shadow memory.
    The following encoding used for each shadow byte: 0 means that all 8 bytes of the
    corresponding memory region are valid for access; k (1 <= k <= 7) means that
    the first k bytes are valid for access, and other (8 - k) bytes are not;
    Any negative value indicates that the entire 8-bytes are inaccessible.
    Different negative values used to distinguish between different kinds of
    inaccessible memory (redzones, freed memory) (see mm/kasan/kasan.h).

    To be able to detect accesses to bad memory we need a special compiler.
    Such compiler inserts a specific function calls (__asan_load*(addr), __asan_store*(addr))
    before each memory access of size 1, 2, 4, 8 or 16.

    These functions check whether memory region is valid to access or not by checking
    corresponding shadow memory. If access is not valid an error printed.

Andrey Ryabinin (12):
  Add kernel address sanitizer infrastructure.
  kasan: Add support for upcoming GCC 5.0 asan ABI changes
  x86_64: load_percpu_segment: read irq_stack_union.gs_base before
    load_segment
  x86_64: add KASan support
  mm: page_alloc: add kasan hooks on alloc and free paths
  mm: slub: introduce virt_to_obj function.
  mm: slub: share slab_err and object_err functions
  mm: slub: introduce metadata_access_enable()/metadata_access_disable()
  mm: slub: add kernel address sanitizer support for slub allocator
  fs: dcache: manually unpoison dname after allocation to shut up
    kasan's reports
  kmemleak: disable kasan instrumentation for kmemleak
  lib: add kasan test module

 Documentation/kasan.txt               | 174 ++++++++++++
 Makefile                              |  11 +-
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/Makefile                |   2 +
 arch/x86/boot/compressed/Makefile     |   2 +
 arch/x86/include/asm/kasan.h          |  27 ++
 arch/x86/kernel/Makefile              |   2 +
 arch/x86/kernel/cpu/common.c          |   4 +-
 arch/x86/kernel/dumpstack.c           |   5 +-
 arch/x86/kernel/head64.c              |   9 +-
 arch/x86/kernel/head_64.S             |  28 ++
 arch/x86/mm/Makefile                  |   3 +
 arch/x86/mm/init.c                    |   3 +
 arch/x86/mm/kasan_init_64.c           |  87 ++++++
 arch/x86/realmode/Makefile            |   2 +-
 arch/x86/realmode/rm/Makefile         |   1 +
 arch/x86/vdso/Makefile                |   1 +
 drivers/firmware/efi/libstub/Makefile |   1 +
 fs/dcache.c                           |   6 +
 include/linux/kasan.h                 |  69 +++++
 include/linux/sched.h                 |   3 +
 include/linux/slab.h                  |  11 +-
 include/linux/slub_def.h              |   9 +
 lib/Kconfig.debug                     |   2 +
 lib/Kconfig.kasan                     |  30 +++
 lib/Makefile                          |   1 +
 lib/test_kasan.c                      | 254 ++++++++++++++++++
 mm/Makefile                           |   4 +
 mm/compaction.c                       |   2 +
 mm/kasan/Makefile                     |   3 +
 mm/kasan/kasan.c                      | 480 ++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h                      |  32 +++
 mm/kasan/report.c                     | 201 ++++++++++++++
 mm/kmemleak.c                         |   6 +
 mm/page_alloc.c                       |   3 +
 mm/slab_common.c                      |   5 +-
 mm/slub.c                             |  55 +++-
 scripts/Makefile.lib                  |  10 +
 38 files changed, 1534 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/kasan.txt
 create mode 100644 arch/x86/include/asm/kasan.h
 create mode 100644 arch/x86/mm/kasan_init_64.c
 create mode 100644 include/linux/kasan.h
 create mode 100644 lib/Kconfig.kasan
 create mode 100644 lib/test_kasan.c
 create mode 100644 mm/kasan/Makefile
 create mode 100644 mm/kasan/kasan.c
 create mode 100644 mm/kasan/kasan.h
 create mode 100644 mm/kasan/report.c

-- 
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: <linux-mm@kvack.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
-- 
2.1.2

