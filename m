Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3KIV7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 16:59:01 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53102 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab3KIV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 16:59:00 -0500
Date: Sun, 10 Nov 2013 06:58:56 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] percpu changes for v3.13-rc1
Message-ID: <20131109215856.GA24275@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two smallish changes for percpu.  Two patches to remove unused
this_cpu_xor() and one to fix a bug in percpu init failure path so
that it can reach the proper BUG() instead of oopsing earlier.

The patches are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.13

for you to fetch changes up to 90f2492cf9c84fd414ecfd2f40685fb5291a484e:

  x86: remove this_cpu_xor() implementation (2013-10-27 09:03:46 -0400)

Thanks.

----------------------------------------------------------------
Heiko Carstens (2):
      percpu: remove this_cpu_xor() implementation
      x86: remove this_cpu_xor() implementation

Michael Holzheu (1):
      percpu: fix bootmem error handling in pcpu_page_first_chunk()

 arch/x86/include/asm/percpu.h |  8 --------
 include/linux/percpu.h        | 32 --------------------------------
 mm/percpu.c                   |  5 +++--
 3 files changed, 3 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0da5200..604e13d 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -377,9 +377,6 @@ do {									\
 #define __this_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
 #define __this_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
 #define __this_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
@@ -399,9 +396,6 @@ do {									\
 #define this_cpu_or_1(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_or_2(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_or_4(pcp, val)		percpu_to_op("or", (pcp), val)
-#define this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
@@ -446,7 +440,6 @@ do {									\
 #define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
@@ -456,7 +449,6 @@ do {									\
 #define this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
-#define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index cc88172..fd6ffe4 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -375,22 +375,6 @@ do {									\
 # define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
 #endif
 
-#ifndef this_cpu_xor
-# ifndef this_cpu_xor_1
-#  define this_cpu_xor_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef this_cpu_xor_2
-#  define this_cpu_xor_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef this_cpu_xor_4
-#  define this_cpu_xor_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef this_cpu_xor_8
-#  define this_cpu_xor_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# define this_cpu_xor(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
-#endif
-
 #define _this_cpu_generic_add_return(pcp, val)				\
 ({									\
 	typeof(pcp) ret__;						\
@@ -629,22 +613,6 @@ do {									\
 # define __this_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
 #endif
 
-#ifndef __this_cpu_xor
-# ifndef __this_cpu_xor_1
-#  define __this_cpu_xor_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef __this_cpu_xor_2
-#  define __this_cpu_xor_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef __this_cpu_xor_4
-#  define __this_cpu_xor_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef __this_cpu_xor_8
-#  define __this_cpu_xor_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
-#endif
-
 #define __this_cpu_generic_add_return(pcp, val)				\
 ({									\
 	__this_cpu_add(pcp, val);					\
diff --git a/mm/percpu.c b/mm/percpu.c
index 8c8e08f..0d10def 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1706,8 +1706,9 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 
 out_free_areas:
 	for (group = 0; group < ai->nr_groups; group++)
-		free_fn(areas[group],
-			ai->groups[group].nr_units * ai->unit_size);
+		if (areas[group])
+			free_fn(areas[group],
+				ai->groups[group].nr_units * ai->unit_size);
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)

-- 
tejun
