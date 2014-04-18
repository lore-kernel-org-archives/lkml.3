Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaDRNEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:04:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaDRNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:04:46 -0400
Date: Fri, 18 Apr 2014 06:03:57 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c7vlkshl3tblim0o8z2p70kt@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        rkuo@codeaurora.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arc,hexagon: Delete asm/barrier.h
Git-Commit-ID: 2ab08ee9f0a4eba27c7c4ce0b6d5118e8a18554b
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

Commit-ID:  2ab08ee9f0a4eba27c7c4ce0b6d5118e8a18554b
Gitweb:     http://git.kernel.org/tip/2ab08ee9f0a4eba27c7c4ce0b6d5118e8a18554b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 6 Feb 2014 14:26:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:30 +0200

arc,hexagon: Delete asm/barrier.h

Both already use asm-generic/barrier.h as per their
include/asm/Kbuild. Remove the stale files.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-c7vlkshl3tblim0o8z2p70kt@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arc/include/asm/barrier.h     | 37 -------------------------------------
 arch/hexagon/include/asm/barrier.h | 37 -------------------------------------
 2 files changed, 74 deletions(-)

diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
deleted file mode 100644
index c32245c..0000000
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
diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
deleted file mode 100644
index 4e863da..0000000
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
