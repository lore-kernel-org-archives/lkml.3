Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbbA1B5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:57:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbbA1BiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 40/77] ARC: Delete stale barrier.h
Date: Tue, 27 Jan 2015 17:27:18 -0800
Message-Id: <20150128012747.163667477@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

commit 64ee9f32c33cbd53545284742e73c17fedf9d429 upstream.

Commit 93ea02bb8435 ("arch: Clean up asm/barrier.h implementations")
wired generic barrier.h for ARC, but failed to delete the existing file.

In 3.15, due to rcupdate.h updates, this causes a build breakage on ARC:

      CC      arch/arc/kernel/asm-offsets.s
    In file included from include/linux/sched.h:45:0,
                     from arch/arc/kernel/asm-offsets.c:9:
    include/linux/rculist.h: In function __list_add_rcu:
    include/linux/rculist.h:54:2: error: implicit declaration of function smp_store_release [-Werror=implicit-function-declaration]
      rcu_assign_pointer(list_next_rcu(prev), new);
      ^

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/barrier.h |   37 -------------------------------------
 1 file changed, 37 deletions(-)

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


