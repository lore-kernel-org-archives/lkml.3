Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbaCSHGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:06:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaCSG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:28 -0400
Message-Id: <20140319065203.890725970@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 02/31] arc,hexagon: Delete asm/barrier.h
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-kill-arc-hexagon-barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both already use asm-generic/barrier.h as per their
include/asm/Kbuild. Remove the stale files.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arc/include/asm/barrier.h     |   37 -------------------------------------
 arch/hexagon/include/asm/barrier.h |   37 -------------------------------------
 2 files changed, 74 deletions(-)

--- a/arch/arc/include/asm/barrier.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_BARRIER_H
-#define __ASM_BARRIER_H
-
-#ifndef __ASSEMBLY__
-
-/* TODO-vineetg: Need to see what this does, don't we need sync anywhere */
-#define mb() __asm__ __volatile__ ("" : : : "memory")
-#define rmb() mb()
-#define wmb() mb()
-#define set_mb(var, value)  do { var = value; mb(); } while (0)
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-#define read_barrier_depends()  mb()
-
-/* TODO-vineetg verify the correctness of macros here */
-#ifdef CONFIG_SMP
-#define smp_mb()        mb()
-#define smp_rmb()       rmb()
-#define smp_wmb()       wmb()
-#else
-#define smp_mb()        barrier()
-#define smp_rmb()       barrier()
-#define smp_wmb()       barrier()
-#endif
-
-#define smp_read_barrier_depends()      do { } while (0)
-
-#endif
-
-#endif
--- a/arch/hexagon/include/asm/barrier.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Memory barrier definitions for the Hexagon architecture
- *
- * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#ifndef _ASM_BARRIER_H
-#define _ASM_BARRIER_H
-
-#define rmb()				barrier()
-#define read_barrier_depends()		barrier()
-#define wmb()				barrier()
-#define mb()				barrier()
-#define smp_rmb()			barrier()
-#define smp_read_barrier_depends()	barrier()
-#define smp_wmb()			barrier()
-#define smp_mb()			barrier()
-
-/*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
-
-#endif /* _ASM_BARRIER_H */


